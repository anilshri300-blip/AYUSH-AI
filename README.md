# NYTOX AI — Android Voice Assistant
**Developer:** Ayush  
**Tagline:** Your Personal AI Assistant  
**Min SDK:** Android 8.0 (API 26) · **Target SDK:** 34

---

## ⚡ Quick Start: Build on Your Phone (Free, No PC)

### Method 1 — Replit (Recommended, fully free)

1. Go to **replit.com** → Create account (free)  
2. Click **+ Create Repl** → Choose **Android / Kotlin** template  
   *(or upload this ZIP and choose "run")*  
3. Paste all files from this project into the Repl  
4. Click **Run** — Replit builds the APK  
5. Download the `.apk` from the `app/build/outputs/apk/debug/` folder  
6. Transfer to your phone via Google Drive / WhatsApp → enable "Install unknown apps" → install

### Method 2 — GitHub Actions (Free CI/CD)

1. Push this project to a **GitHub repo** (github.com)  
2. Create `.github/workflows/build.yml`:

```yaml
name: Build APK
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-java@v3
        with: { java-version: '17', distribution: 'temurin' }
      - run: chmod +x gradlew
      - run: ./gradlew assembleDebug
      - uses: actions/upload-artifact@v3
        with:
          name: NytoxAI-debug
          path: app/build/outputs/apk/debug/app-debug.apk
```

3. Go to **Actions** tab → download the APK artifact → install on phone

### Method 3 — Android Studio on PC (Standard)

```bash
# 1. Open Android Studio → File → Open → select NytoxAI folder
# 2. Wait for Gradle sync
# 3. Build → Build APK(s)
# 4. APK at: app/build/outputs/apk/debug/app-debug.apk
```

---

## 🔧 Backend Setup (REQUIRED for AI responses)

The APK never contains an AI API key. You need a small proxy server.

### Minimal Node.js Backend (deploy free on Railway / Render / Vercel)

```js
// server.js
const express = require('express');
const app = express();
app.use(express.json());

const OPENAI_KEY = process.env.OPENAI_API_KEY; // set in host env vars

app.post('/chat', async (req, res) => {
  const { message, history, language } = req.body;

  const systemPrompt = language === 'hi'
    ? 'आप NYTOX AI हैं, Ayush द्वारा बनाया गया एक AI सहायक। हिंदी में जवाब दें।'
    : 'You are NYTOX AI, a helpful personal AI assistant made by Ayush. Be concise and friendly.';

  const messages = [
    { role: 'system', content: systemPrompt },
    ...history,
    { role: 'user', content: message }
  ];

  try {
    const response = await fetch('https://api.openai.com/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${OPENAI_KEY}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ model: 'gpt-3.5-turbo', messages, max_tokens: 300 })
    });
    const data = await response.json();
    res.json({ reply: data.choices[0].message.content, error: null });
  } catch (e) {
    res.status(500).json({ reply: '', error: e.message });
  }
});

app.listen(3000);
```

Deploy to **Railway.app** (free tier):
1. Push server.js to GitHub  
2. Connect Railway → New Project → Deploy from GitHub  
3. Add env var `OPENAI_API_KEY = sk-...`  
4. Copy the Railway URL (e.g. `https://nytox-backend.railway.app/api/`)  
5. Paste it into `app/build.gradle.kts` → `BACKEND_BASE_URL`

---

## 🎤 Voice Commands (Work Offline)

| Say                        | Action                     |
|---------------------------|----------------------------|
| "What time is it"         | Reads current time         |
| "What is today's date"    | Reads today's date         |
| "Open WhatsApp"           | Opens WhatsApp             |
| "Open YouTube"            | Opens YouTube              |
| "Open camera"             | Opens camera               |
| "Open settings"           | Opens phone settings       |
| "Open Play Store"         | Opens Play Store           |
| "Call" / "Dial"           | Opens dialer               |
| "Open Chrome"             | Opens browser              |
| All Hindi equivalents     | Fully supported            |

---

## 📁 Project Structure

```
NytoxAI/
├── app/src/main/
│   ├── AndroidManifest.xml
│   ├── java/com/ayush/nytoxai/
│   │   ├── model/Message.kt          # Data models
│   │   ├── network/AiRepository.kt   # Backend HTTP calls
│   │   ├── service/VoiceListenerService.kt
│   │   ├── receiver/BootReceiver.kt
│   │   ├── util/
│   │   │   ├── PrefManager.kt        # SharedPreferences
│   │   │   ├── NetworkUtil.kt        # Internet check
│   │   │   ├── PermissionUtil.kt     # Mic permission
│   │   │   ├── ToastUtil.kt
│   │   │   └── VoiceCommandProcessor.kt  # Local commands + TTS
│   │   ├── viewmodel/ChatViewModel.kt
│   │   └── ui/
│   │       ├── SplashActivity.kt
│   │       ├── MainActivity.kt
│   │       ├── SettingsActivity.kt
│   │       ├── WaveformView.kt       # Custom animated waveform
│   │       └── adapter/ChatAdapter.kt
│   └── res/
│       ├── layout/  (5 XML layouts)
│       ├── drawable/ (orbs, bubbles, buttons, icons)
│       ├── anim/    (pulse, breathe, slide animations)
│       ├── values/  (strings, colors, themes)
│       ├── menu/    (toolbar menu)
│       └── xml/     (backup rules)
└── README.md
```

---

## ⚠️ Known Limitations

- **Speech recognition** requires Google app + internet on most Android devices  
- **TTS in Hindi** requires downloading the Hindi voice pack in phone Settings → Accessibility → TTS  
- **AI responses** require the backend server to be running  
- Local voice commands (time, date, open apps) work fully offline  
- This project has been code-reviewed but **not compiled on a live machine** — see build notes above
