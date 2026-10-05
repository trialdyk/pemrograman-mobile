# Perbandingan Storage: SharedPreferences vs Hive vs sqflite vs Drift

Kebutuhan aplikasi: (1) preferensi kecil (tema, waktu terakhir dibuka), (2) koleksi catatan 1000+ baris
dengan antrean sinkronisasi (`dirty`, `updated_at`).

| Kriteria | SharedPreferences | Hive | sqflite | Drift |
|---|---|---|---|---|
| Kompleksitas query | Tidak ada query; hanya `get/set` per key | Ambil per key / iterasi box; filter dilakukan manual di Dart | SQL penuh: `WHERE`, `ORDER BY`, `COUNT`, transaksi, update parsial | SQL penuh via DSL Dart yang type-safe |
| Dukungan relasi | Tidak ada | Terbatas (simpan referensi key manual) | Ada (foreign key, JOIN) | Ada (JOIN, foreign key, view) |
| Reaktivitas (stream) | Tidak ada | `box.watch()` / `ValueListenable` | Tidak bawaan; harus `invalidate` provider manual | `watch()` bawaan, stream otomatis saat tabel berubah |
| Type-safety | Hanya primitif; key berupa string | Type adapter (butuh code generation untuk objek) | Rendah: hasil query `Map<String, Object?>`, mapping manual (`fromMap`) | Tinggi: kelas hasil di-generate |
| Ukuran boilerplate | Sangat kecil | Sedang (adapter + generator) | Sedang (SQL + mapping manual) | Besar (build_runner, definisi tabel, migrasi ter-generate) |
| Kemudahan testing | Mudah (`setMockInitialValues`) | Sedang (butuh init path) | Perlu fake repository atau `sqflite_common_ffi` in-memory | Mudah: `NativeDatabase.memory()` |
| Cocok untuk preferensi? | **Ya** (tepat guna) | Bisa, tapi berlebihan | Berlebihan | Berlebihan |
| Cocok untuk 1000+ catatan? | **Tidak** (satu blob JSON, baca-tulis ulang seluruh daftar) | Cukup, tapi query/sinkronisasi parsial sulit | **Ya** | **Ya** (terbaik jika butuh stream) |
| Keputusan & alasan | Dipakai untuk tema + waktu terakhir dibuka | Tidak dipilih: tidak ada query/urutan/hitung dirty yang efisien | Dipakai untuk `notes` dan `cached_posts` | Tidak dipilih: boilerplate/code-gen terlalu besar untuk skala tugas ini |

## Skema untuk 1000+ catatan (SQLite)

```sql
CREATE TABLE notes(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  body TEXT NOT NULL DEFAULT '',
  updated_at TEXT NOT NULL,      -- ISO-8601, bisa diurutkan sebagai teks
  dirty INTEGER NOT NULL DEFAULT 0
);
-- Opsional bila daftar sangat besar:
CREATE INDEX idx_notes_updated_at ON notes(updated_at DESC);
CREATE INDEX idx_notes_dirty ON notes(dirty) WHERE dirty = 1;
```

Pada 1000+ baris, `ORDER BY updated_at DESC` dan `COUNT(*) WHERE dirty = 1` tetap cepat (milidetik).
Dengan SharedPreferences, setiap perubahan satu catatan memaksa membaca, mengurai, mengubah, dan menulis ulang
seluruh JSON.

## Tanggung jawab teknis

Kombinasi **SharedPreferences + SQLite (sqflite)** dipilih karena:

1. Preferensi hanyalah dua nilai primitif kecil, sehingga SharedPreferences paling sederhana.
2. Catatan adalah koleksi yang butuh urutan, hitung `dirty`, update parsial, dan transaksi; itu pekerjaan SQL.
3. Reaktivitas tidak dibutuhkan dari storage karena Riverpod (`invalidate`) sudah memuat ulang data setelah
   setiap mutasi; inilah satu-satunya keunggulan nyata Drift yang tidak diperlukan di skala ini.
4. Boilerplate Drift (build_runner, code generation) tidak sebanding dengan manfaatnya untuk satu tabel catatan.

> **Catatan untuk mahasiswa:** isi kolom di atas adalah hasil verifikasi saya terhadap klaim umum
> (dokumentasi pub.dev tiap paket). Sebelum dikumpulkan, sesuaikan dengan temuan Anda sendiri
> saat mencoba `flutter pub add hive drift` dan lihat sendiri jumlah boilerplate-nya.
