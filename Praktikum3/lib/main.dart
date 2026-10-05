import 'package:flutter/material.dart';
import 'package:praktikum3/song.dart';
import 'package:camera/camera.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

Song sesiPotret = Song(
  name: 'Sesi Potret',
  creator: 'Ari Lesmana',
  genre: 'Indie',
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
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isChecked = false;
  bool isSwitchOn = false;
  double sliderValue = 20;
  int radioGroup = 1;
  String dropdownValue = 'Indie';
  final TextEditingController namaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          mini: true,
          child: const Icon(Icons.add),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage(
                          'https://i.scdn.co/image/ab67616d0000b273172768978c7f929803ad7e8b',
                        ),
                      ),
                      DropdownButton<String>(
                        value: dropdownValue,
                        items: const [
                          DropdownMenuItem(value: 'Indie', child: Text('Indie')),
                          DropdownMenuItem(value: 'Pop', child: Text('Pop')),
                          DropdownMenuItem(value: 'Rock', child: Text('Rock')),
                        ],
                        onChanged: (val) {
                          setState(() {
                            dropdownValue = val!;
                          });
                        },
                      ),
                      PopupMenuButton<String>(
                        onSelected: (val) {},
                        itemBuilder: (context) => const [
                          PopupMenuItem(value: 'share', child: Text('Share')),
                          PopupMenuItem(value: 'like', child: Text('Like')),
                        ],
                        child: const Icon(Icons.more_vert),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Album Art / Cover Slide
                SizedBox(
                  height: 140,
                  child: PageView(
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            'https://i.scdn.co/image/ab67616d0000b273172768978c7f929803ad7e8b',
                            width: 130,
                            height: 130,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Center(
                        child: Image.network(
                          'https://i.scdn.co/image/ab67616d0000b273172768978c7f929803ad7e8b',
                          width: 100,
                          height: 100,
                        ),
                      ),
                      const Center(
                        child: ImageIcon(
                          NetworkImage('https://cdn-icons-png.flaticon.com/512/25/25231.png'),
                          size: 60,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Judul & Artist
                Text(
                  sesiPotret.name,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  sesiPotret.creator,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 8),

                // Tag Chips
                const Wrap(
                  spacing: 6,
                  children: [
                    Chip(label: Text('Indie')),
                    Chip(label: Text('Sedih')),
                    Chip(label: Text('Baper')),
                    Chip(label: Text('2024')),
                  ],
                ),

                Slider(
                  value: sliderValue,
                  min: 0,
                  max: 100,
                  divisions: 10,
                  label: sliderValue.round().toString(),
                  onChanged: (val) {
                    setState(() {
                      sliderValue = val;
                    });
                  },
                ),

                // Tombol Kontrol Musik Utama
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.skip_previous, color: Colors.black),
                    ),
                    IconButton(
                      onPressed: (){},
                      icon: const Icon(
                        Icons.play_arrow,
                        color: Colors.black,
                        size: 40,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.skip_next, color: Colors.black),
                    ),
                  ],
                ),

                // Tombol Aksi Tambahan
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Play All'),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('Shuffle'),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Repeat'),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Area Lirik & Teks Khusus
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        RichText(
                          text: const TextSpan(
                            text: 'Status: ',
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Sedang Memutar',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              TextSpan(text: ' (Lirik)'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const SelectableText(
                          'Ketuk & tahan untuk salin lirik pilihan:',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          sesiPotret.lyric,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                const Divider(thickness: 2),

                // Antrean Musik / Mini Playlist Horizontal
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Antrean Lagu',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    children: const [
                      Padding(padding: EdgeInsets.all(8), child: Text('Track 1')),
                      Padding(padding: EdgeInsets.all(8), child: Text('Track 2')),
                      Padding(padding: EdgeInsets.all(8), child: Text('Track 3')),
                      Padding(padding: EdgeInsets.all(8), child: Text('Track 4')),
                    ],
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Album Terkait',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 120,
                  child: GridView.count(
                    crossAxisCount: 3,
                    padding: const EdgeInsets.all(8),
                    children: List.generate(
                      6,
                          (i) => Container(
                        margin: const EdgeInsets.all(4),
                        color: Colors.blue[100],
                        child: Center(child: Text('Album $i')),
                      ),
                    ),
                  ),
                ),

                const Divider(thickness: 1),

                // Pengaturan & Form Tambahan
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: namaController,
                    decoration: const InputDecoration(
                      labelText: 'Cari atau beri catatan lagu...',
                    ),
                  ),
                ),
                CheckboxListTile(
                  title: const Text('Simpan ke Favorit'),
                  value: isChecked,
                  onChanged: (val) {
                    setState(() {
                      isChecked = val!;
                    });
                  },
                ),
                RadioListTile<int>(
                  title: const Text('Kualitas Normal'),
                  value: 1,
                  groupValue: radioGroup,
                  onChanged: (val) {
                    setState(() {
                      radioGroup = val!;
                    });
                  },
                ),
                RadioListTile<int>(
                  title: const Text('Kualitas High'),
                  value: 2,
                  groupValue: radioGroup,
                  onChanged: (val) {
                    setState(() {
                      radioGroup = val!;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('Aktifkan Equalizer'),
                  value: isSwitchOn,
                  onChanged: (val) {
                    setState(() {
                      isSwitchOn = val;
                    });
                  },
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}