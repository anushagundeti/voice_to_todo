# 🎙️ Voice TODO AI App

A Ruby on Rails application that lets users **record or upload audio**, transcribe it using **Whisper**, and extract actionable TODOs using **OpenRouter AI**.

---

## ✨ Features

- 🎤 **Record audio** via microphone (MediaRecorder API)
- 📁 **Upload audio files** (MP3, WebM, etc.)
- 🧠 **Transcribe** audio to text using local Whisper
- 🤖 **Extract TODOs** using OpenRouter LLM API
- ✅ Store and view TODOs per user
- 💡 Built with minimal JavaScript using Importmaps

---

## 🔧 Tech Stack

| Layer        | Tech Used                     |
| ------------ | ----------------------------- |
| Backend      | Ruby on Rails                 |
| Frontend     | Tailwind CSS, Hotwire         |
| Audio        | MediaRecorder API             |
| Transcription| OpenAI Whisper CLI (local)    |
| AI API       | OpenRouter (chat-based API)   |
| Database     | PostgreSQL or SQLite (dev)    |
| Storage      | ActiveStorage (audio blobs)   |
| Secrets      | dotenv-rails                  |

---

## 📦 Installation

```bash
# Clone repo
git clone https://github.com/your-username/voice_to_todo_ai.git
cd voice_to_todo_ai

# Install dependencies
bundle install

# Setup DB
rails db:create db:migrate

# Add Tailwind (if not already)
rails tailwindcss:install

# Start the app
bin/dev
