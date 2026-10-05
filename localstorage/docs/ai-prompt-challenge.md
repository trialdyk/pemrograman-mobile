# AI Prompt Challenge

## Prompt yang digunakan

```
Aplikasi Flutter Offline Notes: CRUD catatan + preferensi tema.
Bandingkan SharedPreferences, Hive, sqflite (SQLite), dan Drift
untuk dua kebutuhan ini. Requirements:
- Kriteria: kompleksitas query, kebutuhan relasi, reaktivitas (stream),
  type-safety, ukuran boilerplate, dan kemudahan testing.
- Beri rekomendasi final: mana untuk preferensi, mana untuk catatan,
  beserta alasannya dalam 1 tabel.
- Tunjukkan skema tabel/kotak untuk 1000+ catatan.
Jelaskan trade-off setiap pilihan.
```

Tool AI: Claude Code (Claude Sonnet 5.5).

## Ringkasan output awal AI

- Preferensi → SharedPreferences.
- Catatan → sqflite untuk skala sederhana; Drift bila butuh stream dan query kompleks; Hive untuk cache objek.
- Skema SQLite `notes(id, title, body, updated_at, dirty)` dengan indeks pada `updated_at` dan `dirty`.
- Tabel perbandingan 6 kriteria (lihat `perbandingan-storage.md`).

## AI Verification Checklist

| Pertanyaan verifikasi | Temuan |
|---|---|
| Apakah AI menempatkan daftar catatan di SharedPreferences? | Tidak. AI menolaknya untuk koleksi. Keputusan ini juga saya pertahankan: satu blob JSON membuat tiap perubahan menulis ulang seluruh daftar. |
| Apakah skema mendukung antrean sync (dirty / updated_at)? | Ya, skema memuat `updated_at` dan `dirty`. Sudah diimplementasikan di `NoteRepository` dan terbukti oleh test (`syncNotes`, `countDirty`). |
| Apakah klaim "real-time" didukung stream? | Hanya Drift (`watch()`) dan Hive (`box.watch()`) yang punya stream bawaan. sqflite tidak; di proyek ini reaktivitas dicapai dengan `ref.invalidate` di Riverpod setelah mutasi. |
| Apakah estimasi boilerplate masuk akal? | Perlu dicoba sendiri: `flutter pub add drift drift_flutter` + `dev: drift_dev build_runner`, lalu definisi tabel dan `dart run build_runner build`. Terbukti lebih banyak langkah daripada sqflite. **(Isi dengan pengalaman Anda.)** |
| Keputusan final | SharedPreferences (preferensi) + sqflite (catatan, cache posts). Sama dengan rekomendasi AI untuk skala tugas ini, dengan alasan di `perbandingan-storage.md`. |

## Bagian rekomendasi AI yang ditolak / dikoreksi

- saran awal memakai Drift untuk reaktivitas ditolak karena Riverpod `invalidate`
  sudah cukup dan code generation menambah kompleksitas.
