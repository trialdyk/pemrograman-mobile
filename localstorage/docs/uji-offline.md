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

Pengujian dilakukan di emulator Android dengan mode pesawat diaktifkan lewat pengaturan perangkat.

1. **Catatan tetap bisa dibuat saat offline.** Dengan mode pesawat aktif (ikon pesawat muncul di status bar), saya menambah tiga catatan dan semuanya langsung tersimpan tanpa error. Hal ini wajar karena seluruh operasi catatan hanya menulis ke SQLite lokal dan tidak memerlukan jaringan sama sekali. Tidak ada kode khusus untuk menangani mode offline.

2. **Dirty flag bekerja sebagai antrean.** Setiap catatan baru langsung ditandai belum tersinkron: ikon awan oranye, chip "belum tersinkron", dan badge di AppBar bertambah dari 1 menjadi 3 sesuai jumlah catatan yang ditambahkan.

3. **Sinkronisasi ditolak saat offline dan antrean tidak hilang.** Setelah saklar "Paksa mode offline" saya aktifkan, tombol Sinkronkan menampilkan snackbar "Perangkat offline, sinkronisasi ditunda." dan badge tetap 3. Artinya flag dirty tidak diubah ketika sinkronisasi gagal, sehingga data masih bisa dikirim nanti.

4. **Sinkronisasi berhasil setelah saklar dimatikan.** Setelah jeda sekitar satu detik (delay simulasi server), muncul snackbar "3 catatan berhasil disinkronkan", badge menghilang, dan ikon ketiga catatan berubah menjadi awan hijau. Terlihat bahwa penanda dirty dibersihkan hanya setelah proses sinkronisasi selesai.

5. **Cache posts tampil tanpa internet.** Saat online, halaman Posts mengambil data dari API dan menyimpannya ke tabel `cached_posts`. Setelah aplikasi dimatikan total dan mode pesawat diaktifkan, halaman Posts tetap menampilkan daftar yang sama dari cache. Jika cache belum pernah terisi dan perangkat offline, aplikasi akan menampilkan pesan error yang jelas dan bukan layar kosong.

6. **Data dan preferensi bertahan setelah aplikasi ditutup.** Catatan masih ada setelah aplikasi dimatikan paksa lalu dibuka lagi, dan tema gelap tetap aktif karena disimpan di SharedPreferences.

**Kesimpulan observasi:** pola offline-first berjalan sesuai tujuan. Perangkat menjadi sumber data utama sehingga membaca dan menulis tetap lancar tanpa internet, sementara jaringan hanya diperlukan untuk menyinkronkan. Kelemahan yang saya sadari: `markAllSynced()` menandai semua catatan menjadi bersih, jadi catatan yang diedit selama proses upload bisa ikut ditandai sudah tersinkron padahal versi barunya belum terkirim.

