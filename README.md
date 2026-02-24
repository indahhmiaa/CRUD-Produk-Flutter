# Aplikasi Produk Indah

Aplikasi manajemen inventaris produk sederhana berbasis Flutter dan PHP.

### Struktur Proyek
Aplikasi ini dipecah menjadi dua basis utama: Backend (API) dan Frontend (Mobile).

**Frontend (`lib/`)**
Kumpulan kode Dart untuk aplikasi. Selain `main.dart`, terdapat `hello_world.dart`, widget tata letak seperti `column_widget.dart` dan `row_widget.dart`, serta folder khusus `ui/`, `model/`, dan `service/` untuk mengkonsumsi API.

**Backend (`crudproduk/`)**
Folder ini menyediakan sistem API dengan bahasa PHP.
- `database.sql`: Tabel konfigurasi MySQL.
- `config/`: Tempat mengatur koneksi DB.
- `produk/`: Berisi logika CRUD produk.

### Persiapan & Instalasi
- **Database:** Import `crudproduk/database.sql` lewat PhpMyAdmin.
- **API:** Pastikan folder `crudproduk` berada pada server lokal (seperti XAMPP `htdocs`).
- **Flutter App:** 
  1. Jalankan `flutter pub get`
  2. Pastikan file konfigurasi di `lib/service/` sudah mengarah ke `http://localhost/crudproduk/...` (sesuaikan IP jika pakai device asli).
  3. Tekan F5 atau ketik `flutter run` di terminal.
