# Argumento

Aplikasi mobile game edukasi *critical thinking* — latih kemampuan mendeteksi logical fallacy, media manipulation, dan AI hallucination melalui skenario post media sosial berbasis AI.

---

## Tech Stack

| Layer | Teknologi |
|---|---|
| Frontend | Flutter (Dart) |
| Backend | Express.js + TypeScript |
| Database | MongoDB + Mongoose |
| Auth | JWT |
| AI | Google Gemini API |
| State | flutter_bloc (Cubit) |
| Navigation | go_router |

---

## Requirements

- Node.js `>= 18`
- Flutter `>= 3.10`
- MongoDB (Atlas atau lokal)
- Google Gemini API key *(untuk fitur Daily Shift)*

---

## Struktur Folder

```
argumento/
├── backend/          # Express.js REST API
│   ├── src/
│   │   ├── controllers/
│   │   ├── models/
│   │   ├── routes/
│   │   ├── middleware/
│   │   └── utils/
│   └── .env.example
└── frontend/         # Flutter app
    └── lib/
        ├── core/         # theme, network, utils, widgets
        └── features/     # auth, dashboard, play, campaign, ...
```

---

## Setup Backend

```bash
cd backend
npm install
cp .env.example .env   # Windows: copy .env.example .env
```

Isi file `.env`:

```env
PORT=3000
MONGODB_URI=mongodb+srv://user:pass@cluster.mongodb.net/argumento
JWT_SECRET=your_secret_key

# Opsional — kosongkan jika belum dibutuhkan
GEMINI_AI_API=
GMAIL_USER=
GMAIL_APP_PASS=
CORS_ORIGIN=*
```

> `GEMINI_AI_API` hanya dibutuhkan untuk fitur Daily Shift. Register dan login tetap bisa tanpa ini.

Jalankan backend:

```bash
npm run dev
```

Cek koneksi: buka `http://localhost:3000/api` → harus muncul `{"status":"OK"}`.

---

## Setup Frontend

```bash
cd frontend
flutter pub get
```

Buka `lib/core/network/api_client.dart`, sesuaikan `kBaseUrl`:

```dart
// Android Emulator
const String kBaseUrl = 'http://10.0.2.2:3000/api';

// iOS Simulator
const String kBaseUrl = 'http://localhost:3000/api';

// Device fisik — ganti dengan IP komputer di jaringan yang sama
const String kBaseUrl = 'http://192.168.x.x:3000/api';
```

Jalankan app:

```bash
flutter run
```

---

## Commands

### Backend

| Command | Keterangan |
|---|---|
| `npm run dev` | Jalankan dev server (hot reload) |
| `npm run build` | Build TypeScript ke JavaScript |
| `npm start` | Jalankan build hasil produksi |

### Frontend

| Command | Keterangan |
|---|---|
| `flutter pub get` | Install dependencies |
| `flutter run` | Jalankan app |
| `flutter build apk` | Build APK Android |
| `flutter build ipa` | Build IPA iOS |
| `flutter devices` | Lihat daftar device tersedia |

---

## Troubleshooting

**`Cannot find module 'express'`**
→ Jalankan `npm install` di folder `backend/`

**`MongoDB connection error: Authentication failed`**
→ Cek username/password di `MONGODB_URI`. Karakter spesial di password harus di-encode (misal `@` → `%40`).

**`MongoNetworkError: connection timed out`**
→ Whitelist IP kamu di MongoDB Atlas → *Network Access* → *Add IP Address*.

**Flutter: `SocketException: Connection refused`**
→ Pastikan backend sudah jalan dan `kBaseUrl` sudah benar. Emulator Android wajib pakai `10.0.2.2`, bukan `localhost`.

**Flutter: `DioException: 401`**
→ Logout lalu login ulang. Jika masih gagal, uninstall app untuk menghapus token lama.
