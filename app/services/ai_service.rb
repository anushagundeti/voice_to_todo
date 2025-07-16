require 'httparty'

class AiService
  API_URL = "https://openrouter.ai/api/v1/chat/completions"

  def self.extract_todos(text)
    body = {
      model: "openai/gpt-3.5-turbo-0613", # or any available model
      messages: [
        { role: "system", content: "You extract action items from text as a bullet list." },
        { role: "user", content: "Extract TODOs from: #{text}" }
      ]
    }

    headers = {
      "Authorization" => "Bearer #{ENV['OPENROUTER_API_KEY']}",
      "Content-Type" => "application/json"
    }

    begin
      res = HTTParty.post(API_URL, headers: headers, body: body.to_json)

      if res.code != 200
        Rails.logger.error "❌ OpenRouter API error #{res.code}: #{res.body}"
        return ["[ERROR] AI service failed."]
      end

      choices = res.parsed_response["choices"]
      if choices && choices.first && choices.first["message"]
        content = choices.first["message"]["content"]
        return content.split("\n").map(&:strip).reject(&:empty?)
      else
        Rails.logger.error "❌ Invalid response from OpenRouter: #{res.parsed_response.inspect}"
        return ["[ERROR] AI response was malformed."]
      end
    rescue => e
      Rails.logger.error "❌ Exception in AIService: #{e.message}"
      return ["[ERROR] Exception during AI call."]
    end
  end
end
