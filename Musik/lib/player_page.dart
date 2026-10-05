import 'dart:math';

import 'package:flutter/material.dart';

import 'main.dart';
import 'song.dart';

/// Membuka halaman Player dengan transisi custom (geser dari bawah + fade)
void bukaPlayer(BuildContext context) {
  Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => const PlayerPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final geser = Tween(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
        return SlideTransition(
          position: geser,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    ),
  );
}

// ============================================================
// HALAMAN 2: PLAYER (sedang diputar)
// ============================================================
class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  bool _suka = false;
  bool _acak = false;
  bool _ulang = false;

  void _pesan(String teks) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(teks),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pemutar = MusicScope.of(context);

    // ListenableBuilder: build ulang saat lagu, status main, atau posisi berubah
    return ListenableBuilder(
      listenable: Listenable.merge([
        pemutar.laguAktif,
        pemutar.sedangMain,
        pemutar.posisi,
      ]),
      builder: (context, _) {
        final lagu = pemutar.laguAktif.value;
        final diputar = pemutar.sedangMain.value;
        final posisi = pemutar.posisi.value;
        final lebarLayar = MediaQuery.of(context).size.width;
        final ukuranCover = min(lebarLayar * (diputar ? 0.8 : 0.65), 340.0);

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF4A2B7A), warnaLatar],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _buildHeader(lagu),
                    const Spacer(),
                    // AnimatedContainer: cover membesar saat lagu diputar
                    Hero(
                      tag: 'cover-aktif',
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOut,
                        width: ukuranCover,
                        height: ukuranCover,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: warnaUngu.withValues(alpha: diputar ? 0.6 : 0.2),
                              blurRadius: diputar ? 40 : 10,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.network(lagu.cover, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    const Spacer(),
                    _buildJudul(lagu),
                    const SizedBox(height: 8),
                    Slider(
                      value: posisi.toDouble(),
                      max: lagu.durasi.toDouble(),
                      activeColor: Colors.white,
                      inactiveColor: Colors.white24,
                      onChanged: pemutar.geser,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(formatWaktu(posisi)),
                          Text(formatWaktu(lagu.durasi)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildKontrol(pemutar, diputar),
                    const SizedBox(height: 16),
                    // AnimatedOpacity: tombol lirik agak redup saat lagu dijeda
                    AnimatedOpacity(
                      opacity: diputar ? 1 : 0.5,
                      duration: const Duration(milliseconds: 300),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            onPressed: () => _tampilkanLirik(lagu),
                            icon: const Icon(Icons.lyrics_outlined),
                            label: const Text('Lirik'),
                          ),
                          OutlinedButton.icon(
                            onPressed: _tampilkanAntrean,
                            icon: const Icon(Icons.queue_music_rounded),
                            label: const Text('Antrean'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(Song lagu) {
    return Row(
      children: [
        IconButton(
          tooltip: 'Tutup',
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        Expanded(
          child: Column(
            children: [
              const Text(
                'SEDANG DIPUTAR',
                style: TextStyle(fontSize: 11, letterSpacing: 2, color: Colors.white60),
              ),
              Text(
                'Playlist ${lagu.genre}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          onSelected: (pilihan) => _pesan('$pilihan: ${lagu.name}'),
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'Ditambahkan ke playlist', child: Text('Tambah ke Playlist')),
            PopupMenuItem(value: 'Dibagikan', child: Text('Bagikan')),
          ],
        ),
      ],
    );
  }

  Widget _buildJudul(Song lagu) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lagu.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                lagu.creator,
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Suka',
          onPressed: () {
            setState(() => _suka = !_suka);
            _pesan(_suka ? 'Ditambahkan ke Favorit ❤️' : 'Dihapus dari Favorit');
          },
          icon: Icon(
            _suka ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            color: _suka ? warnaPink : Colors.white,
            size: 30,
          ),
        ),
      ],
    );
  }

  Widget _buildKontrol(Pemutar pemutar, bool diputar) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          tooltip: 'Acak',
          onPressed: () => setState(() => _acak = !_acak),
          icon: Icon(Icons.shuffle_rounded, color: _acak ? warnaPink : Colors.white54),
        ),
        IconButton(
          tooltip: 'Sebelumnya',
          onPressed: pemutar.sebelumnya,
          icon: const Icon(Icons.skip_previous_rounded, size: 40),
        ),
        Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: gradienUtama,
          ),
          child: IconButton(
            tooltip: diputar ? 'Jeda' : 'Putar',
            onPressed: pemutar.playPause,
            // AnimatedSwitcher + ScaleTransition: ikon play/pause berganti dengan efek membesar
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: Icon(
                diputar ? Icons.pause_rounded : Icons.play_arrow_rounded,
                key: ValueKey(diputar),
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
        ),
        IconButton(
          tooltip: 'Berikutnya',
          onPressed: pemutar.berikutnya,
          icon: const Icon(Icons.skip_next_rounded, size: 40),
        ),
        IconButton(
          tooltip: 'Ulangi',
          onPressed: () => setState(() => _ulang = !_ulang),
          icon: Icon(Icons.repeat_rounded, color: _ulang ? warnaPink : Colors.white54),
        ),
      ],
    );
  }

  /// BottomSheet berisi lirik yang bisa dipilih & disalin (SelectableText)
  void _tampilkanLirik(Song lagu) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: warnaKartu,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              'Lirik • ${lagu.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 24),
            Expanded(
              child: Scrollbar(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: SelectableText(
                    lagu.lyric,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, height: 1.8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// BottomSheet berisi antrean lagu yang urutannya bisa diubah (drag & drop)
  void _tampilkanAntrean() {
    showModalBottomSheet(
      context: context,
      backgroundColor: warnaKartu,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Antrean • tekan lama lalu geser untuk mengubah urutan',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            Expanded(
              child: ReorderableListView.builder(
                itemCount: daftarLagu.length,
                onReorderItem: (lama, baru) {
                  setSheetState(() {
                    final lagu = daftarLagu.removeAt(lama);
                    daftarLagu.insert(baru, lagu);
                  });
                },
                itemBuilder: (context, i) {
                  final lagu = daftarLagu[i];
                  return ListTile(
                    key: ValueKey(lagu.name),
                    leading: CircleAvatar(backgroundImage: NetworkImage(lagu.cover)),
                    title: Text(lagu.name),
                    subtitle: Text(lagu.creator),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
