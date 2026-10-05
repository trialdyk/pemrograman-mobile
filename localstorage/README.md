# week5_offline_notes

Aplikasi catatan **offline-first** untuk Praktikum Pemrograman Mobile Minggu 5 (Local Storage & Offline First),
Jurusan Teknologi Informasi, Politeknik Negeri Malang.

**Identitas:** Tri Aldy Kurniawan · NIM: 244107020098 · Kelas: 3C

## Tujuan

Menerapkan penyimpanan lokal (SharedPreferences + SQLite) dan pola offline-first: cache-first read, dirty flag,
antrean sinkronisasi, dan aturan konflik eksplisit, dengan arsitektur UI → Provider (Riverpod) → Repository.

## Fitur utama

- Preferensi: tema gelap/terang dan waktu terakhir dibuka (SharedPreferences), persisten setelah aplikasi ditutup.
- CRUD catatan di SQLite (urut `updated_at` terbaru) dengan empat state UI: loading, error, empty, success.
- Dirty flag + badge jumlah catatan belum tersinkron; tombol Sinkronkan (server disimulasikan dengan delay).
- Saklar "Paksa mode offline" agar demo dan test deterministik.
- Cache-first untuk data Posts (JSONPlaceholder) di tabel `cached_posts`, refresh di background.
- Halaman detail catatan `/note/:id` dengan GoRouter, membaca langsung dari repository lokal.

## Stack

Flutter 3.47 / Dart 3.13 · flutter_riverpod 3 · shared_preferences · sqflite · path · dio · go_router
(dev: sqflite_common_ffi untuk test SQLite in-memory).

## Struktur

```
lib/
  main.dart, router.dart
  data/  prefs.dart, sync.dart, local/{db,note}.dart, remote/post.dart,
         repositories/{note,post}_repository.dart
  providers/  prefs_, note_, offline_, post_providers.dart
  pages/  notes_page, settings_page, posts_page, note_detail_page
  widgets/  note_form_dialog, note_tile
test/  note_test.dart (repository palsu), note_repository_test.dart (SQLite in-memory)
docs/  perbandingan-storage.md, ai-prompt-challenge.md, uji-offline.md, jawaban-pertanyaan.md
screenshots/
```

## Cara menjalankan

```bash
flutter pub get
flutter run          # emulator Android / perangkat fisik (sqflite tidak mendukung web)
flutter analyze
flutter test
```

> Catatan Windows: `android/gradle.properties` memuat `kotlin.incremental=false` karena project (drive D:) dan
> pub-cache (drive C:) berbeda drive; tanpa itu build Gradle gagal ("Could not close incremental caches").

## Aturan konflik yang dipilih: last-write-wins

Fungsi `resolveConflict` (`lib/data/sync.dart`) mempertahankan versi dengan `updated_at` paling baru.
Kelebihan: sederhana dan deterministik. Kekurangan: perubahan yang lebih lama hilang dan bergantung pada jam
perangkat. Alternatif (server-wins, merge per field, tanya pengguna) dibahas di modul.

Keterbatasan yang diketahui: `markAllSynced()` menandai semua dirty menjadi bersih sehingga edit selama upload bisa
tertimpa flag; penghapusan baris langsung tidak diketahui server (perlu tombstone/outbox).

## Hasil yang dicapai

- `flutter analyze`: tanpa issue. `flutter test`: 14 test lulus (7 dengan repository palsu, 7 dengan SQLite
  in-memory).
- Praktikum 1–5 dan Refactoring Challenge (NoteTile, pemisahan tanggung jawab file, detail GoRouter) selesai.
- Bukti: lihat `screenshots/` dan `docs/uji-offline.md`.

## Temuan verifikasi AI

Ringkasan di `docs/ai-prompt-challenge.md`; perbandingan lengkap di `docs/perbandingan-storage.md`.
Keputusan final: SharedPreferences untuk preferensi, sqflite untuk catatan dan cache.
