console.log("✅ recording.js loaded");

document.addEventListener("DOMContentLoaded", () => {
  console.log("✅ DOM ready");

  const recordTab = document.getElementById("record-tab");
  const uploadTab = document.getElementById("upload-tab");
  const recordSection = document.getElementById("record-section");
  const uploadSection = document.getElementById("upload-section");
  const startBtn = document.getElementById("start-recording");
  const stopBtn = document.getElementById("stop-recording");
  const fileInput = document.getElementById("audio_file");
  const audioPlayback = document.getElementById("audio-playback");

  let mediaRecorder;
  let chunks = [];

  // Toggle buttons
  recordTab?.addEventListener("click", () => {
    recordSection.classList.remove("hidden");
    uploadSection.classList.add("hidden");
  });

  uploadTab?.addEventListener("click", () => {
    uploadSection.classList.remove("hidden");
    recordSection.classList.add("hidden");
  });

  // Recording logic
  startBtn?.addEventListener("click", async () => {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
      mediaRecorder = new MediaRecorder(stream);
      chunks = [];

      mediaRecorder.ondataavailable = e => chunks.push(e.data);
      mediaRecorder.onstop = () => {
        const blob = new Blob(chunks, { type: 'audio/webm' });
        const file = new File([blob], "recording.webm", { type: "audio/webm" });
        audioPlayback.src = URL.createObjectURL(blob);

        const dataTransfer = new DataTransfer();
        dataTransfer.items.add(file);
        fileInput.files = dataTransfer.files;
      };

      mediaRecorder.start();
      startBtn.disabled = true;
      stopBtn.disabled = false;
    } catch (err) {
      console.error("🎤 Microphone access denied or failed:", err);
    }
  });

  stopBtn?.addEventListener("click", () => {
    mediaRecorder.stop();
    startBtn.disabled = false;
    stopBtn.disabled = true;
  });
});
