### Developer's Identity
Name : Zhillan Baniaksa

NPM : 2506637174

Class : PBP KKI

### Individual Assignment 08: Experience Form

Formulir baru ada di `lib/screens/experience_form.dart` dan mengikuti model `Experience` pada web portofolio (Django).

| Field | Widget | Validasi |
|---|---|---|
| Judul Pengalaman | `TextFormField` | Wajib, tidak boleh hanya spasi, maksimal 255 karakter |
| Organisasi | `TextFormField` | Opsional, maksimal 160 karakter |
| Deskripsi | `TextFormField` multiline | Wajib, tidak boleh hanya spasi |
| Kategori | `DropdownButtonFormField` | Harus salah satu pilihan model (Internship, Research, Volunteer, Part-Time, Full-Time, Freelance) |
| URL Thumbnail | `TextFormField` (keyboard URL) | Opsional; jika diisi harus URL `http://`/`https://` yang valid, maksimal 200 karakter |
| Tanggal Mulai | `showDatePicker()` | Wajib |
| Tanggal Selesai | `showDatePicker()` | Opsional (kosong berarti masih berlangsung); tidak boleh sebelum tanggal mulai |

Formulir dapat dibuka dari kartu **Tambah Pengalaman** di halaman utama (`Navigator.push()`) dan dari opsi **Add Experience** di drawer. Drawer yang sama (Home, Add Project, Add Experience) dipakai di halaman utama dan kedua halaman formulir. Tombol **Simpan** memanggil `validate()`, lalu menampilkan seluruh isian dalam `AlertDialog` dengan tombol **Tutup**.

Pengujian ada di `test/experience_form_test.dart`: akses dari kartu dan drawer, kembali dengan tombol kembali perangkat dan opsi Home, input tidak valid dan valid, urutan tanggal, layar sempit 320×568, serta validator URL. `flutter analyze` dan `flutter test` lolos tanpa temuan.

### Reflective Questions
1. Navigator

Navigator.push() membuka halaman baru di atas halaman saat ini, Navigator.pushReplacement() mengganti halaman saat ini dengan halaman baru sehingga tidak bisa kembali dengan tombol back, sedangkan Navigator.pop() menutup halaman teratas dan kembali ke halaman sebelumnya.
Kartu aksi "Tambah Proyek" dan "Tambah Pengalaman" menggunakan Navigator.push() sehingga pengguna tetap bisa kembali ke halaman utama dengan tombol kembali bawaan perangkat setelah membuka formulir.
Opsi Home di drawer menggunakan Navigator.pushReplacement() ke MyHomePage, sehingga halaman saat ini diganti dengan halaman utama tanpa menumpuk halaman baru di riwayat navigasi.

2. Scaffold, AppBar, dan Drawer

Scaffold menyediakan kerangka halaman yang sama (AppBar di atas, Drawer di samping, body di tengah), dan karena LeftDrawer dibuat sebagai satu widget terpisah yang dipakai ulang di menu.dart, project_form.dart, dan experience_form.dart, setiap halaman memiliki struktur dan navigasi yang konsisten.
Warna indigo digunakan sebagai warna tema di beberapa halaman, yaitu sebagai seedColor tema di main.dart yang dipakai lewat colorScheme.primary pada AppBar halaman utama serta AppBar dan tombol Simpan halaman formulir pengalaman, juga sebagai latar DrawerHeader.

3. Tata letak formulir

Formulir disusun dengan Column dan crossAxisAlignment: CrossAxisAlignment.start agar setiap field tersusun vertikal dan rata kiri sehingga mudah dibaca dan diisi satu per satu.
Padding dengan EdgeInsets.all(8.0) memberi jarak antar-field agar tidak berdempetan, sedangkan SingleChildScrollView membuat formulir bisa digulir ketika layar sempit atau keyboard muncul sehingga semua field dan tombol Simpan tetap dapat dijangkau tanpa overflow.

4. Validasi formulir

GlobalKey<FormState> memberi akses ke state Form, validator pada tiap field berisi aturan yang mengembalikan pesan error atau null, dan _formKey.currentState!.validate() menjalankan semua validator saat tombol Simpan ditekan sehingga dialog hanya muncul jika semua input valid.
Contoh nilai yang ditolak adalah URL Thumbnail berisi "example.com", karena tidak diawali http:// atau https:// sehingga muncul pesan "Masukkan URL yang valid (diawali http:// atau https://)!"; Judul berisi spasi saja ("   ") juga ditolak karena value.trim().isEmpty bernilai true.
Memilih jenis input atau keyboard saja belum cukup karena keyboard (misalnya TextInputType.url) hanya membantu cara mengetik, tidak memastikan isi input benar: pengguna tetap bisa mengosongkan field, mengetik spasi saja, menempelkan (paste) teks yang bukan URL, atau memilih tanggal selesai yang lebih awal dari tanggal mulai.

### Penggunaan AI
