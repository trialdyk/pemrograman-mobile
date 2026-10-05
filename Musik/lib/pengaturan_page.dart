import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

// ============================================================
// HALAMAN 3: PENGATURAN
// ============================================================
class PengaturanPage extends StatefulWidget {
  const PengaturanPage({super.key});

  @override
  State<PengaturanPage> createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _tanggalLahir;
  TimeOfDay? _timerTidur;
  bool _wifiSaja = true;
  bool _modeHemat = false;
  double _volume = 70;
  String _kualitas = 'Tinggi';
  String _equalizer = 'Normal';

  Future<void> _pilihTanggal() async {
    final hasil = await showDatePicker(
      context: context,
      initialDate: DateTime(2004, 1, 1),
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    );
    if (hasil != null) setState(() => _tanggalLahir = hasil);
  }

  Future<void> _pilihJam() async {
    final hasil = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 22, minute: 0),
    );
    if (hasil != null) setState(() => _timerTidur = hasil);
  }

  void _simpan() {
    // validate() menjalankan semua validator TextFormField di dalam Form
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil berhasil disimpan ✅'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _keluar() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar Akun?'),
        content: const Text('Kamu harus login lagi untuk mendengarkan musik.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfil(),
            _judul('Profil'),
            TextFormField(
              initialValue: 'Tri Aldy Kurniawan',
              decoration: const InputDecoration(
                labelText: 'Nama',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
              validator: (nilai) =>
                  (nilai == null || nilai.isEmpty) ? 'Nama tidak boleh kosong' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (nilai) =>
                  (nilai == null || !nilai.contains('@')) ? 'Email tidak valid' : null,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.cake_outlined),
              title: const Text('Tanggal Lahir'),
              subtitle: Text(
                _tanggalLahir == null
                    ? 'Belum dipilih'
                    : '${_tanggalLahir!.day}/${_tanggalLahir!.month}/${_tanggalLahir!.year}',
              ),
              trailing: const Icon(Icons.calendar_month_rounded),
              onTap: _pilihTanggal,
            ),

            _judul('Pemutaran'),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.volume_up_rounded),
              title: Text('Volume: ${_volume.round()}%'),
              subtitle: Slider(
                value: _volume,
                max: 100,
                divisions: 20,
                label: '${_volume.round()}',
                onChanged: (nilai) => setState(() => _volume = nilai),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.equalizer_rounded),
              title: const Text('Equalizer'),
              trailing: DropdownButton<String>(
                value: _equalizer,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: 'Normal', child: Text('Normal')),
                  DropdownMenuItem(value: 'Bass Boost', child: Text('Bass Boost')),
                  DropdownMenuItem(value: 'Vokal', child: Text('Vokal')),
                  DropdownMenuItem(value: 'Akustik', child: Text('Akustik')),
                ],
                onChanged: (nilai) => setState(() => _equalizer = nilai!),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.bedtime_outlined),
              title: const Text('Timer Tidur'),
              subtitle: Text(
                _timerTidur == null ? 'Nonaktif' : 'Berhenti pukul ${_timerTidur!.format(context)}',
              ),
              trailing: const Icon(Icons.access_time_rounded),
              onTap: _pilihJam,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: const Icon(Icons.battery_saver_rounded),
              title: const Text('Mode Hemat Data'),
              value: _modeHemat,
              onChanged: (nilai) => setState(() => _modeHemat = nilai),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              secondary: const Icon(Icons.wifi_rounded),
              title: const Text('Unduh hanya lewat Wi-Fi'),
              value: _wifiSaja,
              onChanged: (nilai) => setState(() => _wifiSaja = nilai!),
            ),

            _judul('Kualitas Audio'),
            // RadioGroup: mengatur nilai terpilih untuk semua Radio di dalamnya
            RadioGroup<String>(
              groupValue: _kualitas,
              onChanged: (nilai) => setState(() => _kualitas = nilai!),
              child: const Column(
                children: [
                  RadioListTile<String>(contentPadding: EdgeInsets.zero, title: Text('Normal (96 kbps)'), value: 'Normal'),
                  RadioListTile<String>(contentPadding: EdgeInsets.zero, title: Text('Tinggi (160 kbps)'), value: 'Tinggi'),
                  RadioListTile<String>(contentPadding: EdgeInsets.zero, title: Text('Sangat Tinggi (320 kbps)'), value: 'Sangat Tinggi'),
                ],
              ),
            ),

            const SizedBox(height: 8),
            // OverflowBar: pengganti ButtonBar (ButtonBar sudah deprecated di Flutter terbaru)
            OverflowBar(
              alignment: MainAxisAlignment.end,
              spacing: 8,
              children: [
                TextButton(onPressed: _keluar, child: const Text('Keluar')),
                OutlinedButton(
                  onPressed: () => _formKey.currentState!.reset(),
                  child: const Text('Reset'),
                ),
                ElevatedButton(onPressed: _simpan, child: const Text('Simpan')),
              ],
            ),

            _judul('Tampilan iOS (Cupertino)'),
            // CupertinoApp kecil di dalam kotak, untuk contoh widget gaya iOS
            SizedBox(
              height: 330,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: const CupertinoApp(
                  debugShowCheckedModeBanner: false,
                  theme: CupertinoThemeData(
                    brightness: Brightness.dark,
                    primaryColor: warnaUngu,
                  ),
                  home: ContohIos(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfil() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradienUtama,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white,
            child: Text(
              'TA',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: warnaUngu,
              ),
            ),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tri Aldy Kurniawan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text('Akun Premium ⭐'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _judul(String teks) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(
        teks,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: warnaUngu,
        ),
      ),
    );
  }
}

/// Isi kotak Cupertino: semua widget di sini bergaya iOS
class ContohIos extends StatefulWidget {
  const ContohIos({super.key});

  @override
  State<ContohIos> createState() => _ContohIosState();
}

class _ContohIosState extends State<ContohIos> {
  final _genreList = ['Pop', 'Indie', 'Rock', 'Jazz', 'Folk'];
  int _genreDipilih = 0;
  bool _putarOtomatis = true;

  void _pilihGenre() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 220,
        color: CupertinoColors.darkBackgroundGray,
        child: CupertinoPicker(
          itemExtent: 36,
          scrollController: FixedExtentScrollController(initialItem: _genreDipilih),
          onSelectedItemChanged: (i) => setState(() => _genreDipilih = i),
          children: [for (final g in _genreList) Center(child: Text(g))],
        ),
      ),
    );
  }

  void _hapusRiwayat() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Hapus Riwayat?'),
        content: const Text('Semua riwayat lagu yang pernah diputar akan dihapus.'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // removePadding: supaya NavigationBar tidak ikut memberi jarak status bar HP
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      child: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          automaticallyImplyLeading: false,
          middle: Text('Pengaturan iOS'),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const CupertinoTextField(
                placeholder: 'Cari di pustaka...',
                prefix: Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(CupertinoIcons.search, size: 18),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Expanded(child: Text('Putar otomatis')),
                  CupertinoSwitch(
                    value: _putarOtomatis,
                    activeTrackColor: warnaUngu,
                    onChanged: (nilai) => setState(() => _putarOtomatis = nilai),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(child: Text('Genre favorit: ${_genreList[_genreDipilih]}')),
                  CupertinoButton(onPressed: _pilihGenre, child: const Text('Ubah')),
                ],
              ),
              const Row(
                children: [
                  CupertinoActivityIndicator(),
                  SizedBox(width: 10),
                  Text('Menyinkronkan pustaka...'),
                ],
              ),
              const SizedBox(height: 16),
              CupertinoButton.filled(
                onPressed: _hapusRiwayat,
                child: const Text('Hapus Riwayat'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
