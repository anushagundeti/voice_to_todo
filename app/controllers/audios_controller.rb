class AudiosController < ApplicationController
  def index
    @audios = Audio.all
  end

  def new
    @audio = Audio.new
  end

  def create
    @audio = Audio.new
    @audio.file.attach(params[:audio][:file])

    if @audio.save
      # Step 1: Download uploaded file from ActiveStorage
      uploaded = @audio.file
      original_path = Rails.root.join("tmp", uploaded.filename.to_s)
      File.open(original_path, "wb") { |f| f.write(uploaded.download) }

      # Step 2: Convert to .wav using ffmpeg
      converted_path = original_path.to_s.gsub(File.extname(original_path), ".wav")
      ffmpeg_cmd = "ffmpeg -i #{original_path} -ar 16000 -ac 1 -c:a pcm_s16le #{converted_path}"
      system(ffmpeg_cmd)

      # Step 3: Transcribe with Whisper
      transcript = transcribe_with_whisper(converted_path)
      @audio.update(transcript: transcript)

      # Step 4: Extract TODOs using OpenRouter
      todos = AiService.extract_todos(transcript)
      todos.each { |item| @audio.todos.create(content: item) }

      # Cleanup temp files
      File.delete(original_path) if File.exist?(original_path)
      File.delete(converted_path) if File.exist?(converted_path)

      redirect_to @audio
    else
      render :new
    end
  end


  def show
    @audio = Audio.find(params[:id])
  end

  private

  private

  def transcribe_with_whisper(wav_path)
    system("whisper \"#{wav_path}\" --language en --model tiny --output_format txt --output_dir tmp")
    txt_file = wav_path.gsub(".wav", ".txt")
    File.read(txt_file).strip
  rescue => e
    Rails.logger.error("Whisper failed: #{e.message}")
    "[Transcription failed]"
  end

end
