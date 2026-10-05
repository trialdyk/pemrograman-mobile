# Uji Offline-First (Praktikum 3 & 4)

Perangkat uji: Android emulator `sdk gphone16k x86 64` (Android 17, API 37).

## Praktikum 3 — CRUD & mode pesawat

| No | Skenario | Langkah | Hasil yang diharapkan | Hasil aktual | Status |
|---|---|---|---|---|---|
| 1 | Empty state | Jalankan aplikasi pertama kali | Ikon + teks "Belum ada catatan" | Tampil ikon + teks (diuji di emulator) | Lulus |
| 2 | Create | Tekan + Catatan, isi judul, Simpan | Muncul paling atas, awan oranye, badge = 1 | Sesuai; badge 1, awan oranye, chip "belum tersinkron" | Lulus |
| 3 | Validasi | Simpan dengan judul kosong | "Judul wajib diisi", dialog tidak tertutup | _(belum diuji, uji manual)_ | |
| 4 | Update | Ketuk catatan, ubah isi, Simpan | Isi berubah, naik ke teratas | _(belum diuji, uji manual)_ | |
| 5 | Delete | Tekan ikon tempat sampah | Catatan hilang, badge berkurang bila dirty | _(belum diuji, uji manual)_ | |
| 6 | Persistensi | Tutup lalu buka kembali aplikasi | Semua catatan masih ada | Catatan tetap ada setelah force-stop dan buka ulang | Lulus |
| 7 | Mode pesawat | Aktifkan mode pesawat, ulangi 2, 4, 5 | Semua berfungsi tanpa error | Create (3 catatan) berhasil, ikon pesawat tampil (screenshots/p3-mode-pesawat.png). Update/delete belum diuji | Lulus (create) |

## Praktikum 4 — Offline-first

| No | Skenario | Langkah | Hasil yang diharapkan | Hasil aktual | Status |
|---|---|---|---|---|---|
| 1 | Isi cache | Online, buka Posts | 100 posts tampil, tersimpan di `cached_posts` | Daftar posts tampil saat online (jumlah 100 tidak dihitung manual) | Lulus |
| 2 | Cache saat offline | Mode pesawat, tutup-buka app, buka Posts | Posts tampil dari cache | Tampil setelah force-stop + mode pesawat (screenshots/p4-posts-offline.png) | Lulus |
| 3 | Antrean dirty | Masih offline, tambah 3 catatan | Badge = 3 | Badge 3 (screenshots/p4-dirty-sebelum.png) | Lulus |
| 4 | Sync ditolak | Aktifkan Paksa mode offline, Sinkronkan | Snackbar "Perangkat offline…", badge tetap 3 | Snackbar "Perangkat offline, sinkronisasi ditunda.", badge tetap 3 | Lulus |
| 5 | Sync berhasil | Matikan saklar, Sinkronkan | ±1 detik: "3 catatan…", badge hilang, awan hijau | Snackbar "3 catatan berhasil disinkronkan", badge hilang, awan hijau (screenshots/p4-dirty-sesudah.png) | Lulus |
| 6 | Refresh background | Online, buka Posts | Tampil seketika dari cache lalu diperbarui | _(belum diuji, uji manual)_ | |

## Observasi

_(Tuliskan dengan kata-kata sendiri apa yang Anda amati.)_

