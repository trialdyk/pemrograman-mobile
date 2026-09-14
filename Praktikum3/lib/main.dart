import 'package:flutter/material.dart';
import 'package:praktikum3/song.dart';

void main() {
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
  // === variabel buat widget coba-coba di bawah, numpuk aja disini ===
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
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  sesiPotret.name,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.network(
                    'https://i.scdn.co/image/ab67616d0000b273172768978c7f929803ad7e8b',
                    width : 100,
                    height: 100
                ),
                Text(
                  sesiPotret.creator,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    sesiPotret.lyric,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.skip_previous, color: Colors.black),
                    ),
                    IconButton(
                      onPressed: (){},
                      icon: Icon(
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
                const SizedBox(height: 20),

                const Divider(thickness: 2),
                const Text(
                  'Test',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                RichText(
                  text: const TextSpan(
                    text: 'ini ',
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                          text: 'RichText',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                      TextSpan(text: ' coba coba doang'),
                    ],
                  ),
                ),
                const SelectableText('teks ini bisa di-copy paste (SelectableText)'),
                const ImageIcon(
                  NetworkImage('https://cdn-icons-png.flaticon.com/512/25/25231.png'),
                  size: 30,
                ),
                const SizedBox(height: 20),

                const Text('Kelompok 4 - Tombol'),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('ElevatedButton'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('TextButton'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('OutlinedButton'),
                ),
                FloatingActionButton(
                  onPressed: () {},
                  child: const Icon(Icons.add),
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
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('PopupMenuButton (klik)'),
                  ),
                ),
                const SizedBox(height: 20),

                const Text('Kelompok 5 - Input & Form'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: namaController,
                    decoration: const InputDecoration(labelText: 'coba ketik disini (TextField)'),
                  ),
                ),
                CheckboxListTile(
                  title: const Text('udah nonton tutorial? (Checkbox)'),
                  value: isChecked,
                  onChanged: (val) {
                    setState(() {
                      isChecked = val!;
                    });
                  },
                ),
                RadioListTile<int>(
                  title: const Text('Pilihan A (Radio)'),
                  value: 1,
                  groupValue: radioGroup,
                  onChanged: (val) {
                    setState(() {
                      radioGroup = val!;
                    });
                  },
                ),
                RadioListTile<int>(
                  title: const Text('Pilihan B (Radio)'),
                  value: 2,
                  groupValue: radioGroup,
                  onChanged: (val) {
                    setState(() {
                      radioGroup = val!;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('mode gelap? (Switch, bohongan doang)'),
                  value: isSwitchOn,
                  onChanged: (val) {
                    setState(() {
                      isSwitchOn = val;
                    });
                  },
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
                const SizedBox(height: 20),

                const Text('Kelompok 6 - Gambar & Media'),
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                      'https://i.scdn.co/image/ab67616d0000b273172768978c7f929803ad7e8b'),
                ),
                const SizedBox(height: 10),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text('ini isi Card, iseng doang'),
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    'https://i.scdn.co/image/ab67616d0000b273172768978c7f929803ad7e8b',
                    width: 80,
                    height: 80,
                  ),
                ),
                const SizedBox(height: 20),

                const Text('Kelompok 7 - List & Scrolling'),
                SizedBox(
                  height: 60,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      Padding(padding: EdgeInsets.all(8), child: Text('Item 1')),
                      Padding(padding: EdgeInsets.all(8), child: Text('Item 2')),
                      Padding(padding: EdgeInsets.all(8), child: Text('Item 3')),
                      Padding(padding: EdgeInsets.all(8), child: Text('Item 4')),
                    ],
                  ),
                ),
                SizedBox(
                  height: 150,
                  child: GridView.count(
                    crossAxisCount: 3,
                    children: List.generate(
                      6,
                          (i) => Container(
                        margin: const EdgeInsets.all(4),
                        color: Colors.blue[100],
                        child: Center(child: Text('Grid $i')),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8,
                    children: const [
                      Chip(label: Text('Indie')),
                      Chip(label: Text('Sedih')),
                      Chip(label: Text('Baper')),
                      Chip(label: Text('2024')),
                    ],
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: PageView(
                    children: const [
                      Center(child: Text('Halaman 1 (geser2 disini)')),
                      Center(child: Text('Halaman 2')),
                      Center(child: Text('Halaman 3')),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
