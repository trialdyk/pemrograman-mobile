import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import 'pengaturan_page.dart';
import 'player_page.dart';
import 'song.dart';

// ===== Warna tema aplikasi =====
const warnaLatar = Color(0xFF0F0C18);
const warnaKartu = Color(0xFF1C1729);
const warnaUngu = Color(0xFF8E5CFF);
const warnaPink = Color(0xFFFF5C9A);
const gradienUtama = LinearGradient(
  colors: [warnaUngu, warnaPink],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// Gambar transparan 1x1 piksel, dipakai sebagai placeholder FadeInImage
final gambarKosong = base64Decode(
  'R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7',
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final pemutar = Pemutar();

  @override
  void dispose() {
    pemutar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // MusicScope diletakkan paling atas supaya semua halaman bisa mengakses pemutar
    return MusicScope(
      pemutar: pemutar,
      child: MaterialApp(
        title: 'Musikku',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            seedColor: warnaUngu,
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: warnaLatar,
          appBarTheme: const AppBarTheme(backgroundColor: warnaLatar),
        ),
        home: const HomePage(),
      ),
    );
  }
}

// ============================================================
// HALAMAN 1: BERANDA
// ============================================================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _menu = 0; // 0 = Beranda, 1 = Pengaturan

  late final Future<List<Song>> _muatLagu;
  late final Stream<int> _pendengar;
  final _pageController = PageController(viewportFraction: 0.9);
  final _cariController = TextEditingController();
  String _genre = 'Semua';

  @override
  void initState() {
    super.initState();
    // Simulasi mengambil data lagu dari server (2 detik)
    _muatLagu = Future.delayed(const Duration(seconds: 2), () => daftarLagu);
    // Simulasi jumlah pendengar yang berubah setiap 2 detik
    _pendengar = Stream.periodic(
      const Duration(seconds: 2),
      (_) => 1000 + Random().nextInt(500),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _cariController.dispose();
    super.dispose();
  }

  void _gantiMenu(int i) => setState(() => _menu = i);

  @override
  Widget build(BuildContext context) {
    // Layar lebar (tablet) pakai NavigationRail, layar HP pakai BottomNavigationBar
    final layarLebar = MediaQuery.of(context).size.width > 600;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _menu == 0 ? 'Musikku' : 'Pengaturan',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              tooltip: 'Notifikasi',
              icon: const Icon(Icons.notifications_none_rounded),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Belum ada notifikasi baru'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
          bottom: _menu == 0
              ? const TabBar(
                  indicatorColor: warnaUngu,
                  labelColor: Colors.white,
                  tabs: [
                    Tab(text: 'Untukmu'),
                    Tab(text: 'Cari'),
                  ],
                )
              : null,
        ),
        drawer: _buildDrawer(context),
        body: SafeArea(
          child: Row(
            children: [
              if (layarLebar)
                NavigationRail(
                  selectedIndex: _menu,
                  onDestinationSelected: _gantiMenu,
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_rounded),
                      label: Text('Beranda'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings_rounded),
                      label: Text('Pengaturan'),
                    ),
                  ],
                ),
              Expanded(
                child: _menu == 0 ? _buildBeranda() : const PengaturanPage(),
              ),
            ],
          ),
        ),
        floatingActionButton: _menu == 0
            ? FloatingActionButton(
                tooltip: 'Putar acak',
                backgroundColor: warnaPink,
                foregroundColor: Colors.white,
                onPressed: () {
                  final pemutar = MusicScope.of(context);
                  pemutar.putar(daftarLagu[Random().nextInt(daftarLagu.length)]);
                },
                child: const Icon(Icons.shuffle_rounded),
              )
            : null,
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const MiniPlayer(),
            if (!layarLebar)
              BottomNavigationBar(
                currentIndex: _menu,
                onTap: _gantiMenu,
                backgroundColor: warnaLatar,
                selectedItemColor: warnaUngu,
                unselectedItemColor: Colors.white54,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_rounded),
                    label: 'Beranda',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings_rounded),
                    label: 'Pengaturan',
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: warnaLatar,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(gradient: gradienUtama),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ImageIcon(
                  NetworkImage(
                    'https://cdn-icons-png.flaticon.com/512/25/25231.png',
                  ),
                  size: 40,
                  color: Colors.white,
                ),
                SizedBox(height: 12),
                Text(
                  'Musikku',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text('Dengarkan tanpa batas'),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_rounded),
            title: const Text('Beranda'),
            onTap: () {
              Navigator.pop(context); // tutup drawer
              _gantiMenu(0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_rounded),
            title: const Text('Pengaturan'),
            onTap: () {
              Navigator.pop(context);
              _gantiMenu(1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: const Text('Tentang Aplikasi'),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Musikku'),
                  content: const Text(
                    'Aplikasi pemutar musik sederhana untuk Praktikum 3.1 '
                    'Pemrograman Mobile.\n\nVersi 1.0.0',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Tutup'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBeranda() {
    // FutureBuilder: tampilkan loading sampai data lagu selesai dimuat
    return FutureBuilder<List<Song>>(
      future: _muatLagu,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: warnaUngu),
                SizedBox(height: 16),
                Text('Memuat lagu...'),
              ],
            ),
          );
        }
        final semuaLagu = snapshot.data!;
        return TabBarView(
          children: [
            _buildTabUntukmu(semuaLagu),
            _buildTabCari(semuaLagu),
          ],
        );
      },
    );
  }

  Widget _buildTabUntukmu(List<Song> semuaLagu) {
    final genreList = ['Semua', ...{for (final lagu in semuaLagu) lagu.genre}];
    final laguTampil = _genre == 'Semua'
        ? semuaLagu
        : semuaLagu.where((lagu) => lagu.genre == _genre).toList();

    return Scrollbar(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildSapaan()),
          SliverToBoxAdapter(child: _judulBagian('Pilihan Minggu Ini')),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 190,
              child: PageView(
                controller: _pageController,
                children: [
                  for (final lagu in semuaLagu.take(3)) BannerLagu(lagu: lagu),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: _judulBagian('Album Populer')),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 205,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: semuaLagu.length,
                itemBuilder: (context, i) => KartuAlbum(lagu: semuaLagu[i]),
              ),
            ),
          ),
          SliverToBoxAdapter(child: _judulBagian('Playlist Kamu')),
          SliverToBoxAdapter(child: _buildGridPlaylist()),
          SliverToBoxAdapter(child: _judulBagian('Lagu Untukmu')),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final genre in genreList)
                    ChoiceChip(
                      label: Text(genre),
                      selected: _genre == genre,
                      onSelected: (_) => setState(() => _genre = genre),
                    ),
                ],
              ),
            ),
          ),
          SliverList.builder(
            itemCount: laguTampil.length,
            itemBuilder: (context, i) => SongTile(lagu: laguTampil[i]),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  Widget _buildSapaan() {
    final jam = DateTime.now().hour;
    final salam = jam < 11
        ? 'Selamat pagi'
        : jam < 15
            ? 'Selamat siang'
            : jam < 18
                ? 'Selamat sore'
                : 'Selamat malam';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 26, color: Colors.white),
              children: [
                TextSpan(text: '$salam,\n'),
                const TextSpan(
                  text: 'Aldy 🎧',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: warnaUngu,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // StreamBuilder: teks ikut berubah setiap ada data baru dari stream
          StreamBuilder<int>(
            stream: _pendengar,
            builder: (context, snapshot) {
              return Row(
                children: [
                  const Icon(Icons.circle, size: 10, color: Colors.greenAccent),
                  const SizedBox(width: 6),
                  Text(
                    '${snapshot.data ?? 1250} orang sedang mendengarkan',
                    style: const TextStyle(color: Colors.white60),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _judulBagian(String teks) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Text(
        teks,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildGridPlaylist() {
    const playlist = [
      ('Favorit', Icons.favorite_rounded),
      ('Santai', Icons.spa_rounded),
      ('Galau', Icons.water_drop_rounded),
      ('Semangat', Icons.bolt_rounded),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 3,
      children: [
        for (final (nama, ikon) in playlist)
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Membuka playlist $nama'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: warnaKartu,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 50,
                    decoration: const BoxDecoration(gradient: gradienUtama),
                    child: Icon(ikon, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        nama,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTabCari(List<Song> semuaLagu) {
    final kata = _cariController.text.toLowerCase();
    final hasil = semuaLagu
        .where((lagu) =>
            lagu.name.toLowerCase().contains(kata) ||
            lagu.creator.toLowerCase().contains(kata))
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _cariController,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              hintText: 'Cari judul lagu atau artis...',
              prefixIcon: Icon(Icons.search_rounded),
              filled: true,
              fillColor: warnaKartu,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: hasil.isEmpty
              ? const Center(child: Text('Lagu tidak ditemukan 😢'))
              : ListView.builder(
                  itemCount: hasil.length,
                  itemBuilder: (context, i) => SongTile(lagu: hasil[i]),
                ),
        ),
      ],
    );
  }
}

// ============================================================
// WIDGET-WIDGET KECIL YANG DIPAKAI DI BERANDA
// ============================================================

/// Kartu besar di PageView "Pilihan Minggu Ini"
class BannerLagu extends StatelessWidget {
  const BannerLagu({super.key, required this.lagu});

  final Song lagu;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: GestureDetector(
        onTap: () {
          MusicScope.of(context).putar(lagu);
          bukaPlayer(context);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Banner(
            message: 'HOT',
            location: BannerLocation.topEnd,
            color: warnaPink,
            // Stack: menumpuk gambar, gradien gelap, teks, dan tombol play
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(lagu.cover, fit: BoxFit.cover),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black87],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lagu.genre.toUpperCase(),
                          style: const TextStyle(
                            color: warnaPink,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        Text(
                          lagu.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          lagu.creator,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
                const Positioned(
                  right: 16,
                  bottom: 16,
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: warnaUngu,
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Kartu album kecil di daftar horizontal "Album Populer"
class KartuAlbum extends StatelessWidget {
  const KartuAlbum({super.key, required this.lagu});

  final Song lagu;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Card(
        color: warnaKartu,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: InkWell(
          onTap: () {
            MusicScope.of(context).putar(lagu);
            bukaPlayer(context);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // FadeInImage: gambar muncul perlahan setelah selesai diunduh
              FadeInImage(
                placeholder: MemoryImage(gambarKosong),
                image: NetworkImage(lagu.cover),
                width: 150,
                height: 130,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lagu.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      lagu.creator,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 12, color: Colors.white60),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Satu baris lagu (dipakai di tab Untukmu dan tab Cari)
class SongTile extends StatelessWidget {
  const SongTile({super.key, required this.lagu});

  final Song lagu;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(lagu.cover, width: 50, height: 50, fit: BoxFit.cover),
      ),
      title: Text(lagu.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('${lagu.creator} • ${lagu.genre}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Tooltip(
            message: 'Durasi lagu',
            child: Text(
              formatWaktu(lagu.durasi),
              style: const TextStyle(color: Colors.white54),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (pilihan) {
              if (pilihan == 'info') {
                _tampilkanInfo(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('"${lagu.name}" ditambahkan ke favorit'),
                    behavior: SnackBarBehavior.floating,
                    action: SnackBarAction(label: 'Batal', onPressed: () {}),
                  ),
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'favorit', child: Text('Tambah ke Favorit')),
              PopupMenuItem(value: 'info', child: Text('Info Lagu')),
            ],
          ),
        ],
      ),
      onTap: () {
        MusicScope.of(context).putar(lagu);
        bukaPlayer(context);
      },
    );
  }

  void _tampilkanInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(lagu.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Artis   : ${lagu.creator}'),
            Text('Genre  : ${lagu.genre}'),
            Text('Durasi : ${formatWaktu(lagu.durasi)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}

/// Pemutar kecil di atas BottomNavigationBar. Tekan untuk membuka halaman Player.
class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final pemutar = MusicScope.of(context);

    // ValueListenableBuilder: otomatis build ulang saat lagu aktif berubah
    return ValueListenableBuilder<Song>(
      valueListenable: pemutar.laguAktif,
      builder: (context, lagu, _) {
        return GestureDetector(
          onTap: () => bukaPlayer(context),
          child: Container(
            margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: warnaKartu,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      // Hero: cover ini akan "terbang" ke halaman Player
                      Hero(
                        tag: 'cover-aktif',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            lagu.cover,
                            width: 44,
                            height: 44,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lagu.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              lagu.creator,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white60,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: pemutar.sedangMain,
                        builder: (context, diputar, _) => IconButton(
                          tooltip: diputar ? 'Jeda' : 'Putar',
                          onPressed: pemutar.playPause,
                          icon: Icon(
                            diputar
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            size: 32,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Berikutnya',
                        onPressed: pemutar.berikutnya,
                        icon: const Icon(Icons.skip_next_rounded),
                      ),
                    ],
                  ),
                ),
                ValueListenableBuilder<int>(
                  valueListenable: pemutar.posisi,
                  builder: (context, detik, _) => LinearProgressIndicator(
                    value: detik / lagu.durasi,
                    minHeight: 3,
                    color: warnaUngu,
                    backgroundColor: Colors.white12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
