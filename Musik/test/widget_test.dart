import 'package:flutter_test/flutter_test.dart';

import 'package:praktikum3/song.dart';

void main() {
  test('formatWaktu mengubah detik menjadi m:ss', () {
    expect(formatWaktu(245), '4:05');
    expect(formatWaktu(60), '1:00');
  });

  test('Pemutar bisa putar, jeda, dan pindah lagu', () {
    final pemutar = Pemutar();

    pemutar.putar(daftarLagu[0]);
    expect(pemutar.sedangMain.value, true);

    pemutar.playPause();
    expect(pemutar.sedangMain.value, false);

    pemutar.berikutnya();
    expect(pemutar.laguAktif.value, daftarLagu[1]);

    pemutar.sebelumnya();
    expect(pemutar.laguAktif.value, daftarLagu[0]);

    pemutar.dispose();
  });
}
