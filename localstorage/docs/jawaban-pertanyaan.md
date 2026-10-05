# Jawaban Pertanyaan Praktikum & Refleksi

## Praktikum 1

1. **Mengapa `SharedPreferences.getInstance()` tidak boleh dipanggil di `build()`?**
   `build()` bisa dipanggil berkali-kali (setiap rebuild) dan harus sinkron. Memanggil operasi async di sana
   menyebabkan pembacaan berulang, UI berkedip, dan sulit diuji. Dengan repository + provider, hasilnya
   tercache oleh Riverpod dan providernya bisa di-override saat test.
2. **Alur data dari switch sampai tema berubah.**
   Switch ditekan → `onChanged` memanggil `darkModeProvider.notifier.toggle()` → `state = AsyncData(next)`
   (optimistic) → `OfflineNotesApp` yang me-`watch` provider rebuild sehingga `themeMode` berubah seketika →
   `PrefsRepository.setDarkMode` menulis bool ke SharedPreferences → platform (XML di Android) menyimpannya ke
   disk. Saat aplikasi dibuka lagi, `build()` notifier membaca nilai itu dari disk.
3. **Optimistic update.**
   Kelebihan: UI responsif dan tidak berkedip. Risiko: UI sempat menampilkan nilai yang ternyata gagal
   disimpan, karena itu `catch` harus melakukan rollback ke nilai sebelumnya.

## Praktikum 2

1. **Kolom `dirty` bertipe INTEGER.** SQLite tidak punya tipe BOOLEAN asli; benar/salah disimpan sebagai 1/0 dan
   dikonversi di `toMap`/`fromMap`.
2. **Parameter `openDb`.** Dependency injection: test dapat menyuntikkan database palsu/in-memory atau fungsi yang
   melempar error, sehingga repository bisa diuji tanpa SQLite sungguhan.
3. **`where: 'id = ?'` + `whereArgs`.** Mencegah SQL injection dan kesalahan escaping karakter khusus (misalnya
   tanda kutip); nilai dikirim terpisah dari string SQL.
4. **Menambah kolom di `onCreate` tanpa menaikkan `version`.** `onCreate` hanya jalan saat berkas database belum ada.
   Pada perangkat yang sudah punya database, kolom baru tidak pernah dibuat sehingga muncul `no such column`.

## Praktikum 3

1. **Invalidate dua provider.** Keduanya membaca tabel yang sama dari sudut berbeda. Jika hanya `notesProvider`,
   daftar berubah tetapi badge dirty basi; jika hanya `dirtyCountProvider`, badge benar tetapi daftar tidak berubah.
2. **Memicu state error.** Override `noteRepositoryProvider` dengan repository yang melempar exception, atau
   sementara melempar exception manual di `fetchNotes()`, atau mengubah nama tabel di query.
3. **Berfungsi di mode pesawat.** Seluruh baca/tulis catatan menuju SQLite lokal; tidak ada operasi catatan yang
   membutuhkan jaringan.

## Praktikum 4

1. **Cache-first vs network-first.** Cache-first menampilkan data lokal dulu lalu memperbarui di background
   (cocok untuk artikel/katalog). Network-first mencoba jaringan dulu dan cache hanya cadangan (cocok untuk
   harga saham, saldo, stok real-time yang tidak boleh basi).
2. **Kehilangan data pada `markAllSynced()`.** Jika pengguna mengedit catatan selama upload (jeda 1 detik),
   catatan itu ikut ditandai bersih padahal versi barunya belum terkirim, sehingga perubahan tidak pernah
   tersinkron. Perbaikan: tandai bersih hanya untuk `id` + `updated_at` yang benar-benar dikirim
   (`WHERE id = ? AND updated_at = ?`), atau gunakan tabel outbox.
3. **Saklar `forceOffline`.** Membuat demo dan test deterministik, tidak bergantung pada Wi-Fi kelas, bisa
   diotomatisasi, dan tidak perlu mengubah pengaturan perangkat.
4. **Transaksi di `fetchAndCache()`.** Hapus + insert menjadi atomik; bila gagal di tengah jalan, cache lama tetap
   utuh dan tidak tersisa cache setengah jadi.

## Praktikum 5

1. **`ProviderContainer` + `overrideWithValue`.** Cepat, deterministik, berjalan tanpa emulator/plugin, dan fokus
   menguji logika provider, bukan SQLite.
2. **Parameter `latency`.** Test memakai `Duration.zero` sehingga cepat, sementara aplikasi tetap memakai jeda
   simulasi 1 detik.
3. **Test tambahan.** `updateNote` harus menandai `dirty = true` dan memperbarui `updated_at` (sudah saya tulis di
   `test/note_repository_test.dart` memakai SQLite in-memory), karena inilah yang membuat catatan masuk antrean sync.

## Refleksi

1. **Mengapa daftar catatan tidak boleh di SharedPreferences?** Ia hanya untuk nilai primitif kecil. Satu blob
   JSON membuat query, urutan, update parsial, dan sync rapuh dan lambat: setiap perubahan satu catatan berarti
   membaca, mengurai, mengubah, dan menulis ulang seluruh daftar. Tidak ada transaksi, sehingga crash di tengah
   penulisan bisa merusak seluruh data.
2. **Kapan cache-first cukup?** Untuk data yang jarang berubah dan toleran terhadap sedikit ketertinggalan
   (posts, katalog). Untuk data real-time (harga, saldo) dibutuhkan network-first, dengan cache hanya sebagai
   cadangan dan penanda bahwa data mungkin basi.
3. **Dirty flag menjadi antrean sync tanpa memblokir UI.** Penulisan lokal selesai seketika dan hanya menandai
   `dirty = 1`; sinkronisasi berjalan terpisah secara async (tombol Sinkronkan atau background) dan UI hanya
   menampilkan badge. Tabel outbox diperlukan saat harus mengirim operasi berurutan yang tidak cukup
   direpresentasikan oleh satu flag, misalnya delete (tombstone), banyak edit pada catatan yang sama, atau retry
   dengan urutan yang harus dijaga.
4. **Bagian rekomendasi AI yang ditolak.** (Isi dengan pengalaman Anda sendiri; lihat `ai-prompt-challenge.md`.)

## Kesimpulan

Hal terpenting: aplikasi offline-first menjadikan penyimpanan lokal sebagai sumber data utama, sehingga baca dan
tulis selalu cepat dan tetap berfungsi tanpa internet; jaringan hanya dipakai untuk menyinkronkan lewat dirty flag
dan aturan konflik yang eksplisit. Pemisahan UI → provider → repository membuat logika ini mudah diuji dengan
repository palsu.
