import 'dart:async';

import 'package:flutter/material.dart';

class Song {
  String name;
  String creator;
  String lyric;
  String genre;
  String cover;
  int durasi; // dalam detik

  Song({
    required this.name,
    required this.creator,
    required this.genre,
    required this.lyric,
    required this.cover,
    this.durasi = 210,
  });
}

final List<Song> daftarLagu = [
  Song(
    name: 'Sesi Potret',
    creator: 'Ari Lesmana',
    genre: 'Indie',
    durasi: 245,
    cover: 'https://i.scdn.co/image/ab67616d0000b273172768978c7f929803ad7e8b',
    lyric: '''Tahun lalu berjuta alasanku
Maaf tak bisa pulang penghasilanku pas-pasan
Kali ini sudah lumayan
Berkat doamu di ijabah sang maha kaya
Dan tahun ini kubisa pulang
Oleh-oleh sudah ditangan
Tapi anehnya bukan kau yang menyambutku
Oh ternyata kau yang lebih dulu pulang

Ku bertamu ke rumah barumu
Tak ada kamu
Hanya papan dan namamu
Mana ocehan wewangian khasmu
Jarak ini terlalu jauh
Kalau rindu aku tak mampu

Soal ikhlas ternyata aku masih amatir
Gengsi menyelimutiku
Manusia ini kehilanganmu
Ha-ha-ha-ha

Sesi potret yang selalu ku benci
Aneh rasanya kau tak di sini
Susunan barisannya tak sama lagi
Oh ho ho satu dua tiga
Ini nyata kau telah pergi

Ku bertamu kerumah barumu
Tak ada kamu
Hanya papan dan namamu
Mana ocehan wewangian khasmu
Jarak ini terlalu jauh
Kalau rindu aku tak mampu

Sesal hatiku tak sempat temani kamu
Harusnya kubisikan kata ajaib ke telingamu
Soal ikhlas ternyata aku masih amatir
Masih sangat amatir
Gengsi menyelimutiku
Manusia ini kehilanganmu
Kehilanganmu''',
  ),
  Song(
    name: 'Evaluasi',
    creator: 'Hindia',
    genre: 'Indie',
    durasi: 262,
    cover: 'https://picsum.photos/seed/evaluasi/400',
    lyric: 'Lirik belum tersedia untuk lagu ini.',
  ),
  Song(
    name: 'Hati-Hati di Jalan',
    creator: 'Tulus',
    genre: 'Pop',
    durasi: 242,
    cover: 'https://picsum.photos/seed/tulus/400',
    lyric: 'Lirik belum tersedia untuk lagu ini.',
  ),
  Song(
    name: 'Rehat',
    creator: 'Kunto Aji',
    genre: 'Pop',
    durasi: 276,
    cover: 'https://picsum.photos/seed/rehat/400',
    lyric: 'Lirik belum tersedia untuk lagu ini.',
  ),
  Song(
    name: 'Bertaut',
    creator: 'Nadin Amizah',
    genre: 'Folk',
    durasi: 283,
    cover: 'https://picsum.photos/seed/bertaut/400',
    lyric: 'Lirik belum tersedia untuk lagu ini.',
  ),
  Song(
    name: 'Kita ke Sana',
    creator: 'Hindia',
    genre: 'Rock',
    durasi: 231,
    cover: 'https://picsum.photos/seed/kitakesana/400',
    lyric: 'Lirik belum tersedia untuk lagu ini.',
  ),
];

/// Menyimpan status pemutar musik: lagu aktif, sedang main/jeda, dan posisi (detik).
/// Tiap nilai memakai ValueNotifier supaya bisa didengarkan oleh ValueListenableBuilder.
class Pemutar {
  final laguAktif = ValueNotifier<Song>(daftarLagu.first);
  final sedangMain = ValueNotifier<bool>(false);
  final posisi = ValueNotifier<int>(0);
  late final Timer _timer;

  Pemutar() {
    // Simulasi lagu berjalan: posisi bertambah 1 detik setiap detik
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!sedangMain.value) return;
      if (posisi.value < laguAktif.value.durasi) {
        posisi.value++;
      } else {
        berikutnya();
      }
    });
  }

  void putar(Song lagu) {
    laguAktif.value = lagu;
    posisi.value = 0;
    sedangMain.value = true;
  }

  void playPause() => sedangMain.value = !sedangMain.value;

  void berikutnya() {
    final i = daftarLagu.indexOf(laguAktif.value);
    putar(daftarLagu[(i + 1) % daftarLagu.length]);
  }

  void sebelumnya() {
    final i = daftarLagu.indexOf(laguAktif.value);
    putar(daftarLagu[(i - 1 + daftarLagu.length) % daftarLagu.length]);
  }

  void geser(double detik) => posisi.value = detik.toInt();

  void dispose() {
    _timer.cancel();
    laguAktif.dispose();
    sedangMain.dispose();
    posisi.dispose();
  }
}

/// InheritedWidget: membagikan objek Pemutar ke semua widget di bawahnya.
/// Cara pakai: `final pemutar = MusicScope.of(context);`
class MusicScope extends InheritedWidget {
  const MusicScope({super.key, required this.pemutar, required super.child});

  final Pemutar pemutar;

  static Pemutar of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MusicScope>()!.pemutar;
  }

  @override
  bool updateShouldNotify(MusicScope oldWidget) => pemutar != oldWidget.pemutar;
}

/// Mengubah detik menjadi format m:ss, contoh 245 -> 4:05
String formatWaktu(int detik) {
  final menit = detik ~/ 60;
  final sisa = (detik % 60).toString().padLeft(2, '0');
  return '$menit:$sisa';
}
