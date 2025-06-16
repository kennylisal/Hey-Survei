![logo hey survei](https://github.com/kennylisal/Hey-Survei/blob/master/images/today.png)

# Hey Survei

Selamat datang di repository Hey-Survei. Projek ini adalah usaha untuk membuat sebuah aplikasi yang mirip dengan google form menggunakan flutter sebagai backend serta express sebagai backend. Projek ini juga memanfaatkan beberapa library luar seperti GraphQL dan Firebse.

## Memulai
Ikuti langkah-langkah berikut untuk mengunduh dan menginstal proyek di komputer Anda.

### Prasyarat
Pastikan Anda telah menginstal perangkat lunak berikut:
- Git: Untuk mengunduh repositori.
- Flutter: Versi 3.1.16 atau lebih baru (periksa dengan `flutter --version`).
- Node.js: Versi 16.x atau lebih baru (periksa dengan `node --version`).
- npm: Sudah termasuk dalam Node.js (periksa dengan `npm --version`).
- Editor kode seperti VS Code atau Android Studio.


### Instalasi
1. Kloning Repositori
   git clone https://github.com/kennylisal/Hey-Survei.git
   cd Hey-Survei

2. Mengatur Backend
   - Masuk ke folder backend:
     cd backend
   - Instal dependensi:
     npm install
   - Buat file `.env` di folder `backend` dan tambahkan variabel lingkungan yang diperlukan (misalnya, URL database, kunci API). Contoh:
     DATABASE_URL=string_koneksi_database_anda
     PORT=3000
   - Jalankan server backend, tersedia 3 jalur untuk menjalankan backend yang seduai dengan frontend yg tersedia (web untuk surveyor, admin untuk admin, app untuk aplikasi)
     npm start <web|app|admin>
   - Port akan menyesuaikan dengan yang diberikan di .env

3. Mengatur Frontend Flutter
   Setiap frontend (`admin-web`, `surveyor-web`, `user-app`) adalah proyek Flutter terpisah. Ulangi langkah-langkah berikut untuk masing-masing:
   - Masuk ke folder frontend (misalnya, `admin-web`):
     cd admin-web
   - Instal dependensi Flutter:
     flutter pub get
   - Konfigurasikan frontend untuk terhubung ke backend dengan memperbarui endpoint API di kode Dart Anda (misalnya, atur klien GraphQL ke `http://localhost:3000/graphql`).
   - Jalankan frontend:
     flutter run
     - Untuk web: Pilih browser saat diminta.
     - Untuk mobile: Hubungkan perangkat atau emulator dan pilih.
   - Ulangi untuk `surveyor-web` dan `user-app`.

### Menjalankan Proyek
- Pastikan backend berjalan sebelum memulai frontend.
- Akses frontend:
  - `frontend1`: Biasanya di `http://localhost:port` (port tergantung pada server web Flutter).
  - `frontend2`: Sama seperti di atas, di terminal berbeda.
  - `frontend3`: Sama seperti di atas.
- Uji API GraphQL menggunakan alat seperti Postman atau Apollo GraphQL Playground di `http://localhost:3000/graphql`.

## Arsitektur Sistem
![arsitektur sitem](https://github.com/kennylisal/Hey-Survei/blob/master/images/arsitektur.png)

## ScreenShot-Web pengguna surveyor
![ss web](https://github.com/kennylisal/Hey-Survei/blob/master/images/ss%20web.png)

## ScreenShot Aplikasi user
![ss app](https://github.com/kennylisal/Hey-Survei/blob/master/images/ss%20app.png)

Ini berhubung dengan penggunaan firebase
-Tambahakn firebase_options didalam /lib
