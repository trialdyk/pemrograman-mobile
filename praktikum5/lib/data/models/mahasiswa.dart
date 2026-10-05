class Mahasiswa {
  const Mahasiswa({
    this.id, // null jika data baru
    required this.nim,
    required this.nama,
    required this.prodi,
    required this.email,
  });

  final int? id;
  final String nim;
  final String nama;
  final String prodi;
  final String email;


  factory Mahasiswa.fromJson(Map<String, dynamic> json) {
    return Mahasiswa(
      id: (json['id'] as num?)?.toInt(),
      nim: json['nim'] as String? ?? '',
      nama: json['nama'] as String? ?? '',
      prodi: json['prodi'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'nim': nim,
        'nama': nama,
        'prodi': prodi,
        'email': email,
      };
}
