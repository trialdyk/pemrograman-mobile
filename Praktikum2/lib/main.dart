import 'package:flutter/material.dart';
import 'package:iseng/song.dart';

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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
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

              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
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
            ],
          ),
        ),
      ),
    );
  }
}
