# UTS Pemrogramman Mobile Lanjutan

# Pengembang
 * Afnan Dani Alaudin
 * 1123150074
 * TI SE P1 23
 * Teknik Informatika
 * Software Engineering 
 * [Link-Youtube-presentation](https://www.youtube.com/watch?v=EJeToa_EQYE)

# Aplikasi Paket Alat Pancing

## Tech Stack
Aplikasi ini di rancang dengan :

- [Flutter](https://docs.flutter.dev/get-started/learn-flutter) - Sebagai Front-End yg menerima respon dari beckend & Response User ke beckend
- [Firebase](https://firebase.google.com/?hl=id) - Sebagai Authentikasi Verifikasi email-validation dan log-in Google
- [Golang-beckend](https://github.com/afnan923/MobileApp2_week5_1123150074) - sebagai backend API untuk menghubungkan Mysql ke Front-End
- [Mysql](https://www.mysql.com/) - sebagai database local

# Tampilan UI untuk Aplikasi ini
 * Tampilan halaman Login register,forgot password & email Verified
 <p align="center">
<img width="200" src="https://github.com/user-attachments/assets/ccc3efc3-4159-4643-a3ba-93ea8e906774" />
<img width="200" src="https://github.com/user-attachments/assets/2b077e00-5565-4625-90fd-426939ca54ae" />
<img width="200" alt="WhatsApp Image 2026-04-22 at 23 08 35 (1)" src="https://github.com/user-attachments/assets/f7ec0e19-6238-4d83-977c-5c9c1ca82cbe" />
<img width="200" src="https://github.com/user-attachments/assets/f0b436c2-20a9-400f-aa70-c8945bd57638" />


</p>

 * Setelah aplikasi mengirimkan aplikasi cek email & klik email untuk verified
  <p align="center">
<img width="200" alt="Screenshot 2026-04-22 231853" src="https://github.com/user-attachments/assets/0f4365ff-4af7-43f9-8722-1929cb645774" />
<img width="200" alt="Screenshot 2026-04-22 231913" src="https://github.com/user-attachments/assets/8d3be005-c6a9-4649-a62a-0fc3682d795c" />
<img width="200" alt="Screenshot 2026-04-22 231929" src="https://github.com/user-attachments/assets/fb9caede-b2b1-4c24-8c56-2f47a5ef4bb0" />


</p>

 * Setelah email terverifikasi maka aplikasi langsung mengarahkan ke halaman dashboard dan mendapatkan notif
 <p align="center">
   
<img width="200" src="https://github.com/user-attachments/assets/b3240b08-ebc5-41af-85cf-03c004ddf745" />
<img width="200" src="https://github.com/user-attachments/assets/f1dcc974-d550-4418-af8b-240d4419824c" />

</p>

 * Fitur di dalam aplikasi ketika user memasuki aplikasi
  <p align="center">
<img width="200" alt="WhatsApp Image 2026-04-22 at 23 08 34 (2)" src="https://github.com/user-attachments/assets/a8fc3c5d-2a82-4277-ae95-9b2a29716be4" />
<img width="200" alt="WhatsApp Image 2026-04-22 at 23 08 34" src="https://github.com/user-attachments/assets/c5d9a1fa-25ba-4998-a6da-44e517fb66d1" />

</p>

 * Ketika user melakukan klik keranjang pada product maka mendapatkan notif
 <p align="center">
<img width="200" alt="WhatsApp Image 2026-04-22 at 23 08 34" src="https://github.com/user-attachments/assets/c5d9a1fa-25ba-4998-a6da-44e517fb66d1" />
<img width="200" alt="WhatsApp Image 2026-04-22 at 23 08 33 (3)" src="https://github.com/user-attachments/assets/4106b452-30dd-4bdd-88f2-638a798f744a" />

</p>

 * keranjang yang awalnya kosong sekarang sudah ada detail produk dan harga produk di dalam nya
  <p align="center">
  <img width="200" src="https://github.com/user-attachments/assets/818a85c4-e8c4-47d8-9aba-2d1f1327b107" />

</p>

* User dapat menghapus semua produk di dalam keranjang dan mendapatkan notif
  <p align="center">
  <img width="200" src="https://github.com/user-attachments/assets/697bc760-fee6-48a6-9a06-03a0cb423bff" />

</p>

* User dapat menghapus satu produk di dalam keranjang 
<p align="center">
 <img width="200" src="https://github.com/user-attachments/assets/e66ecd72-c0b3-45a3-baea-dcc2ec93f1ea" />
 <img width="200" src="https://github.com/user-attachments/assets/7bc9d53c-7915-48e5-a795-c4ac7c625c3d" />
</p>

* Ketika user logout akan mendapatkan notif
  <p align="center">
  <img width="200" src="https://github.com/user-attachments/assets/fc2b3c6d-161d-468d-b6b6-084848c64fda" />
</p>

## 📁 Project Structure

```
lib/
├── core/                        # Pondasi global aplikasi (Reusable)
│   ├── constants/               # Variabel statis (api_constants, colors, strings)
│   ├── guard/                   # Middleware navigasi (auth_guard untuk proteksi rute)
│   ├── routes/                  # Pusat pengaturan navigasi (app_router)
│   ├── services/                # Infrastruktur sistem (dio_client, storage, biometric)
│   ├── theme/                   # Konfigurasi visual global (app_theme)
│   └── utils/                   # Fungsi bantuan umum (currency_helper/format uang)
│
├── features/                    # Pemisahan kode berdasarkan Fitur (Feature-First)
│   ├── auth/                    # --- MODUL AUTENTIKASI ---
│   │   ├── data/                # Model data API (auth_response_model)
│   │   ├── domain/              # Kontrak & Logika bisnis (auth_repository)
│   │   └── presentation/        # UI (login_page, register_page) & Provider (auth_provider)
│   │
│   ├── dashboard/               # --- MODUL UTAMA/PRODUK ---
│   │   ├── data/                # Model data produk (product_model)
│   │   ├── domain/              # Repositori untuk manajemen produk
│   │   └── presentation/        # Dashboard_page, splash_screen & product_provider
│   │
│   └── cart/                    # --- MODUL KERANJANG BELANJA ---
│       ├── data/                # Remote datasource (API) & Implementation (cart_repository_impl)
│       ├── domain/              # Entity (data murni) & Abstract Repository (kontrak)
│       └── presentation/        # Cart_page & cart_provider (state management keranjang)
│
├── firebase_options.dart        # Konfigurasi otomatis koneksi Firebase
└── main.dart                    # Titik masuk utama aplikasi (Root)
```
## App Structure

<div >
<img width="600"  src="https://github.com/user-attachments/assets/4a7d9464-ec09-42a0-91f3-bbda516c28ba" />
</div>

| Layer | Nama Layer | Komponen | Fungsi Utama |
| :--- | :--- | :--- | :--- |
| **Layer 1** | **Presentation** | Flutter App | Interaksi User & Tampilan Reaktif |
| **Layer 2** | **Security** | Firebase Auth | Verifikasi Identitas (Login/Email) |
| **Layer 3** | **Application** | Backend API (Go) | Logika Bisnis & Aturan Aplikasi |
| **Layer 4** | **Data** | Database (MySQL) | Penyimpanan Data Fisik & Permanen |

---

> [!NOTE]
> Aplikasi ini hanya sampai dengan fitur cart saja dan belum sampai ke fitur checkout
