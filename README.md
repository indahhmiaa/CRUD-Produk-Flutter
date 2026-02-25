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
<img width="1366" height="636" alt="image" src="https://github.com/user-attachments/assets/08856900-38b3-4bc2-8c96-7110f1a1b37a" />
<img width="1366" height="638" alt="image" src="https://github.com/user-attachments/assets/e5c37e08-3da5-4e56-a38e-7478bd34876b" />
<img width="1366" height="638" alt="image" src="https://github.com/user-attachments/assets/59c97502-64bf-4f20-a062-69b24c6112ce" />
<img width="1366" height="637" alt="image" src="https://github.com/user-attachments/assets/645158a2-fd28-4d52-9288-3169065292e6" />
<img width="1366" height="636" alt="image" src="https://github.com/user-attachments/assets/1509112e-83c9-4192-8fa1-5c4fe239197d" />
