# Argumento Mobile — Migration Documentation

> Web → Flutter + Express.js + MongoDB rewrite

---

## Daftar Isi

1. [Struktur Project](#struktur-project)
2. [Panduan Setup & Menjalankan](#panduan-setup--menjalankan)
   - [Prasyarat](#prasyarat)
   - [Step 1 — Setup MongoDB](#step-1--setup-mongodb)
   - [Step 2 — Setup Backend](#step-2--setup-backend)
   - [Step 3 — Verifikasi Koneksi MongoDB](#step-3--verifikasi-koneksi-mongodb)
   - [Step 4 — Test Registrasi & Login](#step-4--test-registrasi--login-via-postman)
   - [Step 5 — Setup Flutter](#step-5--setup-flutter)
   - [Step 6 — Test di Flutter](#step-6--test-di-flutter)
3. [Troubleshooting](#troubleshooting)
4. [API Endpoints](#api-endpoints)
5. [MongoDB Schemas](#mongodb-schemas)
6. [Feature Mapping](#feature--screen-mapping)
7. [State Management](#state-management)
8. [Key Behavior Preserved](#key-behavior-preserved)

---

## Struktur Project

```
argumento-mobile/
├── backend/                  # Express.js REST API
│   ├── src/
│   │   ├── config/           # DB connection
│   │   ├── controllers/      # Business logic
│   │   ├── middleware/        # JWT auth middleware
│   │   ├── models/           # Mongoose schemas
│   │   ├── routes/           # API route definitions
│   │   └── utils/            # Game config, shop, mailer
│   ├── .env.example
│   └── package.json
│
└── flutter_app/              # Flutter mobile frontend
    └── lib/
        ├── main.dart
        ├── core/
        │   ├── network/       # Dio API client + token storage
        │   ├── theme/         # AppTheme (5 color themes)
        │   └── utils/         # Models, ApiService, AppState, Router, Widgets
        └── features/
            ├── auth/          # Sign In, Sign Up, Verify, Reset Password
            ├── dashboard/     # Home (landing) + Dashboard
            ├── play/          # Daily Shift + Practice Mode
            ├── campaign/      # Campaign list + Level play
            ├── leaderboard/   # Leaderboard dengan sort tabs
            ├── shop/          # Theme shop buy/equip
            ├── history/       # Post log + detail
            ├── skills_radar/  # Radar chart breakdown
            ├── settings/      # Account settings
            ├── feedback/      # Feedback form
            ├── profile/       # Public profile
            └── shared/        # Bottom nav + drawer
```

---

## Panduan Setup & Menjalankan

### Prasyarat

Pastikan sudah terinstall:

| Tool | Versi Minimum | Cek dengan |
|------|--------------|------------|
| Node.js | 18+ | `node -v` |
| npm | 9+ | `npm -v` |
| Flutter | 3.10+ | `flutter --version` |
| Git | any | `git --version` |

---

### Step 1 — Setup MongoDB

Pilih salah satu opsi berikut:

#### Opsi A: MongoDB Atlas (Direkomendasikan — Gratis, Tanpa Install)

1. Buka [https://cloud.mongodb.com](https://cloud.mongodb.com) → daftar akun gratis
2. Klik **"Build a Database"** → pilih **M0 Free**
3. Pilih region terdekat (misal: Singapore) → klik **Create**
4. Di bagian **Security**:
   - Buat username & password database (catat, akan dipakai di `.env`)
   - Klik **"Add My Current IP Address"** agar bisa akses dari komputer kamu
5. Klik **"Connect"** → **"Compass"** atau **"Drivers"**
6. Copy connection string, bentuknya:
   ```
   mongodb+srv://USERNAME:PASSWORD@cluster0.xxxxx.mongodb.net/argumento
   ```
   > Ganti `USERNAME` dan `PASSWORD` dengan yang kamu buat di step 4

#### Opsi B: MongoDB Lokal (Perlu Install MongoDB)

1. Download MongoDB Community dari [https://www.mongodb.com/try/download/community](https://www.mongodb.com/try/download/community)
2. Install dan jalankan:
   ```bash
   # Windows — jalankan sebagai service (otomatis saat install)
   # Atau manual:
   mongod --dbpath "C:\data\db"
   ```
3. Connection string yang dipakai:
   ```
   mongodb://localhost:27017/argumento
   ```

---

### Step 2 — Setup Backend

```bash
# 1. Masuk ke folder backend
cd backend

# 2. Install semua dependencies
npm install
# Tunggu hingga selesai, akan muncul folder node_modules/

# 3. Buat file .env dari template
# Windows (Command Prompt):
copy .env.example .env

# Windows (PowerShell):
Copy-Item .env.example .env

# Mac/Linux:
cp .env.example .env
```

#### Isi File `.env`

Buka file `.env` dengan text editor, lalu isi:

```env
PORT=3000

# Ganti dengan connection string MongoDB kamu (Atlas atau lokal)
MONGODB_URI=mongodb+srv://USERNAME:PASSWORD@cluster0.xxxxx.mongodb.net/argumento

# Bisa diisi string acak apa saja — dipakai untuk sign JWT token
JWT_SECRET=argumento_secret_rahasia_2024

# Bisa dikosongkan dulu saat testing awal (untuk fitur AI)
GEMINI_AI_API=

# Bisa dikosongkan dulu saat testing awal (untuk kirim email)
GMAIL_USER=
GMAIL_APP_PASS=

CORS_ORIGIN=*
```

> **Catatan:** `GEMINI_AI_API` dan `GMAIL_*` **tidak dibutuhkan** untuk fitur register dan login. Kamu bisa kosongkan dulu dan isi nanti ketika ingin mencoba fitur game (Daily Shift) dan verifikasi email.

#### Jalankan Backend

```bash
npm run dev
```

Jika berhasil, terminal akan menampilkan:

```
[nodemon] starting `ts-node -r tsconfig-paths/register src/index.ts`
✅ MongoDB connected successfully
🚀 Argumento API running on port 3000
📖 Health check: http://localhost:3000/api
```

> Jika muncul error koneksi MongoDB, lihat bagian [Troubleshooting](#troubleshooting).

---

### Step 3 — Verifikasi Koneksi MongoDB

#### Cara 1: Health Check via Browser

Buka browser, akses:
```
http://localhost:3000/api
```

Jika berhasil, akan tampil:
```json
{
  "status": "OK",
  "message": "Server is healthy"
}
```

Jika koneksi MongoDB gagal, server tidak akan bisa start sama sekali dan terminal akan menampilkan pesan error.

#### Cara 2: Cek via MongoDB Compass (GUI)

1. Download **MongoDB Compass** dari [https://www.mongodb.com/products/compass](https://www.mongodb.com/products/compass)
2. Buka Compass → paste connection string yang sama dengan di `.env`
3. Klik **Connect**
4. Jika berhasil terhubung, kamu akan melihat list database
5. Setelah register akun pertama, database `argumento` dan collection `users` akan otomatis muncul

#### Cara 3: Cek Log Terminal

Perhatikan output saat `npm run dev`:
- ✅ Koneksi berhasil: `✅ MongoDB connected successfully`
- ❌ Koneksi gagal: `❌ MongoDB connection error: MongoServerError: ...`

---

### Step 4 — Test Registrasi & Login via Postman

Download **Postman** dari [https://www.postman.com/downloads](https://www.postman.com/downloads) atau gunakan ekstensi **Thunder Client** di VS Code.

#### Test 1: Register Akun Baru

```
Method : POST
URL    : http://localhost:3000/api/auth/register
Headers: Content-Type: application/json
Body   :
{
  "username": "testuser",
  "email": "test@example.com",
  "password": "password123"
}
```

**Response sukses (200):**
```json
{
  "success": true,
  "message": "Success",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.xxxx"
}
```

**Response gagal — username sudah ada (400):**
```json
{
  "success": false,
  "message": "Username already exists"
}
```

> Token yang dikembalikan adalah **JWT token** — simpan token ini untuk dipakai di request yang butuh autentikasi.

#### Test 2: Login

```
Method : POST
URL    : http://localhost:3000/api/auth/login
Headers: Content-Type: application/json
Body   :
{
  "username": "testuser",
  "password": "password123"
}
```

**Response sukses (200):**
```json
{
  "success": true,
  "message": "Success",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.xxxx"
}
```

**Response gagal — password salah (400):**
```json
{
  "success": false,
  "message": "Invalid username or password"
}
```

#### Test 3: Get Data User (Butuh Token)

```
Method : GET
URL    : http://localhost:3000/api/auth
Headers:
  Content-Type : application/json
  Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.xxxx
```

**Response sukses (200):**
```json
{
  "success": true,
  "user": {
    "_id": "...",
    "username": "testuser",
    "email": "test@example.com",
    "isVerified": false,
    "totalExp": 0,
    "totalCoins": 0,
    "currentStreak": 0,
    "bestStreak": 0,
    "activeTheme": "theme_green",
    ...
  }
}
```

#### Test 4: Verifikasi Data di MongoDB

Setelah register berhasil, buka MongoDB Compass dan cek:
- Database: `argumento`
- Collection: `users`
- Kamu akan melihat dokumen user baru dengan semua field yang sudah terisi default

---

### Step 5 — Setup Flutter

#### Konfigurasi URL API

Buka file:
```
flutter_app/lib/core/network/api_client.dart
```

Ubah `kBaseUrl` sesuai situasimu:

```dart
// Jika pakai Android Emulator (AVD)
const String kBaseUrl = 'http://10.0.2.2:3000/api';

// Jika pakai iOS Simulator
const String kBaseUrl = 'http://localhost:3000/api';

// Jika pakai device fisik (HP Android/iPhone)
// Ganti dengan IP komputer kamu di jaringan yang sama
const String kBaseUrl = 'http://192.168.1.xxx:3000/api';
```

**Cara cek IP komputer:**
```bash
# Windows (Command Prompt / PowerShell)
ipconfig
# Lihat bagian "IPv4 Address" pada adapter WiFi/Ethernet yang aktif

# Mac/Linux
ifconfig | grep "inet "
```

> Pastikan HP dan komputer terhubung ke **WiFi yang sama** jika pakai device fisik.

#### Install Dependencies & Jalankan

```bash
cd flutter_app

# Install dependencies
flutter pub get

# Cek device yang tersedia
flutter devices

# Jalankan app
flutter run

# Atau pilih device spesifik
flutter run -d emulator-5554        # Android emulator
flutter run -d "iPhone 15"          # iOS simulator
```

---

### Step 6 — Test di Flutter

1. Jalankan backend terlebih dahulu (`npm run dev`)
2. Jalankan Flutter app (`flutter run`)
3. Di halaman **Home**, klik **"Get Started"**
4. Isi form registrasi:
   - Username (min. 3 karakter)
   - Email valid
   - Password (min. 8 karakter)
   - Konfirmasi password
5. Klik **"Sign Up"**
6. Jika berhasil → otomatis masuk ke halaman **Dashboard**
7. Cek terminal backend — akan muncul log request masuk

**Untuk login akun yang sudah ada:**
1. Klik **"Sign In"** di halaman Home
2. Isi username dan password
3. Klik **"Sign In"**

---

## Troubleshooting

### ❌ `Cannot find module 'express'` atau module lainnya

**Penyebab:** `node_modules` belum terinstall.

**Solusi:**
```bash
cd backend
npm install
```

---

### ❌ `MongoDB connection error: MongoServerError: Authentication failed`

**Penyebab:** Username/password di connection string salah.

**Solusi:**
1. Buka MongoDB Atlas → Database Access
2. Pastikan username dan password sudah benar
3. Cek apakah ada karakter spesial di password (encode dulu jika ada, misal `@` → `%40`)
4. Update `MONGODB_URI` di `.env`

---

### ❌ `MongoNetworkError: connection timed out`

**Penyebab:** IP komputer belum di-whitelist di MongoDB Atlas.

**Solusi:**
1. Buka MongoDB Atlas → **Network Access**
2. Klik **"Add IP Address"**
3. Klik **"Add Current IP Address"** atau masukkan `0.0.0.0/0` (izinkan semua IP — hanya untuk development)
4. Klik **Confirm**

---

### ❌ Flutter: `SocketException: Connection refused`

**Penyebab:** Flutter tidak bisa menjangkau backend.

**Solusi:**
1. Pastikan backend sudah jalan (`npm run dev`)
2. Pastikan `kBaseUrl` di `api_client.dart` sudah benar:
   - Emulator Android → `http://10.0.2.2:3000/api`
   - Device fisik → IP komputer kamu (bukan `localhost`)
3. Pastikan firewall Windows tidak memblokir port 3000:
   - Windows Defender Firewall → Allow an app → tambahkan Node.js

---

### ❌ Flutter: `DioException: 401 Not Authorized`

**Penyebab:** Token JWT tidak valid atau sudah expired.

**Solusi:**
1. Logout dari app lalu login ulang
2. Token tersimpan di secure storage — uninstall app dan install ulang jika perlu

---

### ❌ `npm run dev` langsung crash tanpa pesan error jelas

**Solusi:**
1. Pastikan file `.env` sudah ada (bukan hanya `.env.example`)
2. Pastikan `MONGODB_URI` sudah diisi dengan benar
3. Coba jalankan:
   ```bash
   npm run build
   npm start
   ```
4. Perhatikan pesan error yang muncul

---

## API Endpoints

### Auth
| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| POST | `/api/auth/register` | Register akun baru | ❌ |
| POST | `/api/auth/login` | Login, returns JWT | ❌ |
| GET | `/api/auth` | Get data user saat ini | ✅ |
| POST | `/api/auth/verify` | Kirim ulang email verifikasi | ❌ |
| PUT | `/api/auth/verify/:id` | Verifikasi email dengan token | ❌ |
| POST | `/api/auth/reset` | Request reset password | ❌ |
| PUT | `/api/auth/reset/:id` | Reset password dengan token | ❌ |
| DELETE | `/api/auth` | Hapus akun | ✅ |

### Shifts (Game)
| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| POST | `/api/shifts/generate` | Generate daily shift dengan AI | ✅ |
| POST | `/api/shifts/practice` | Generate practice mode | ✅ |
| PUT | `/api/shifts/complete` | Submit hasil game, update stats | ✅ |

### Judge
| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| POST | `/api/judge` | AI evaluasi jawaban user | ✅ |

### Campaign
| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| GET | `/api/campaign` | Get semua campaign | ✅ |
| GET | `/api/campaign/:level/:id` | Get level tertentu | ❌ |
| POST | `/api/campaign/complete/:level/:id` | Tandai level selesai | ✅ |

### Leaderboard
| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| GET | `/api/leaderboard/:type` | Top 100 diurutkan by field | ❌ |

Sort types: `totalExp`, `bestStreak`, `currentStreak`, `postsProcessed`, `postsCorrect`

### Shop
| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| GET | `/api/shops` | Get semua item shop | ❌ |
| PUT | `/api/shops` | Beli item | ✅ |

### Users
| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| GET | `/api/users/:userId` | Get profil user | ❌ |
| PUT | `/api/users/theme` | Equip tema | ✅ |
| PUT | `/api/users/streak` | Refresh streak | ✅ |

### Posts
| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| GET | `/api/posts/:postId` | Get post by ID | ❌ |

### Feedback
| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| POST | `/api/feedback` | Submit feedback | ✅ |
| GET | `/api/feedback/analytics` | Lihat analytics feedback | ✅ |

> **✅ Auth** = butuh header `Authorization: Bearer <token>`

---

## MongoDB Schemas

### Users
```
username        String  (unique)
email           String  (unique)
password        String  (bcrypt hashed)
isVerified      Boolean (default: false)
totalExp        Number  (default: 0)
totalCoins      Number  (default: 0)
currentStreak   Number  (default: 0)
bestStreak      Number  (default: 0)
lastPlayedDate  Date
postsProcessed  Number
postsCorrect    Number
postsHistory    [{ post_id, is_correct }]
stats           [{ stat_id, name, correct, total }]
campaign_progress [{ campaign_id, isCompleted, levelsCompleted[] }]
activeTheme     String  (default: 'theme_green')
inventory       { themes: String[], consumables: [{ itemId, amount }] }
verifyToken     String
resetToken      String
```

### Posts
```
headline  String
content   String
type      'slop' | 'safe'
category  'logical_fallacies' | 'cognitive_biases' | 'media_manipulation' | 'ai_hallucinations' | 'safe'
reasons   String[]
origin    'human' | 'ai'
```

### Feedback
```
userId            String
description       String
expectation       'better' | 'same' | 'worse'
favoritePart      String
frustrated        String
clarity           Number (1-4)
playAgainTomorrow Number (1-5)
improvements      String
learnedSomething  'yes_lot' | 'yes_little' | 'not_really' | 'already_knew'
changesSocialMedia 'yes' | 'maybe' | 'probably_not' | 'no'
anythingElse      String
```

---

## Feature → Screen Mapping

| Web Route | Flutter Page |
|-----------|-------------|
| `/` | `HomePage` (landing) |
| `/sign-in` | `SignInPage` |
| `/sign-up` | `SignUpPage` |
| `/reset-password` | `ResetPasswordPage` |
| `/reset-password/:id` | `ResetPasswordConfirmPage` |
| `/verify/:id` | `VerifyPage` |
| `/dashboard` | `DashboardPage` |
| `/play/daily` | `DailyPlayPage` (Setup → Game → Done) |
| `/play/practice` | `PracticePlayPage` (no stats) |
| `/campaign` | `CampaignPage` |
| `/campaign/:level/:id` | `CampaignLevelPage` (Briefing → Game → Done) |
| `/leaderboard` | `LeaderboardPage` |
| `/shop` | `ShopPage` |
| `/history` | `HistoryPage` |
| `/history/:id` | `HistoryDetailPage` |
| `/skills-radar` | `SkillsRadarPage` |
| `/settings` | `SettingsPage` |
| `/feedbacks` | `FeedbackPage` |
| `/profile/:id` | `ProfilePage` |

---

## State Management

- **UserCubit** — Menyimpan object user yang sedang login. Di-load saat app start, di-refresh setelah aksi game.
- **ThemeCubit** — Menyimpan string tema aktif (`theme_green`, dll). Disync dari UserCubit dan di-update langsung saat equip tema.

Keduanya di-provide di root `MaterialApp.router` via `MultiBlocProvider`.

---

## Key Behavior Preserved

| Behavior | Implementasi |
|----------|-------------|
| Daily shift sekali/hari | `user.hasPlayedToday` di dashboard; `completeShift` set `lastPlayedDate` |
| Streak logic | Kalkulasi selisih hari di controller `completeShift` (identik dengan web) |
| Practice mode — tidak simpan stats | `generatePracticeShifts` tidak simpan ke DB |
| AI Judge evaluasi | Prompt Gemini identik dengan controller `judge` asli |
| Tema langsung berubah saat equip | ThemeCubit di-update langsung + disimpan ke backend |
| Progress shift tersimpan lokal | `SharedPreferences` simpan shift yang sedang berjalan |
| Campaign lock/unlock | Field `requirement` di-cek terhadap `campaign_progress` |
| Kalkulasi XP & koin | `game_config.ts`: benar=100XP+100koin, salah=50koin |
