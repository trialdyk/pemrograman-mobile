import 'package:Praktikum1/Praktikum1.dart' as Praktikum1;

void main(List<String> arguments) {
  print('Hello world: ${Praktikum1.calculate()}!');
  var nama = "Aldy";
  var usia = 20;
  var tinggi = "170";
  var iseng = usia + int.parse(tinggi);
  var alamat = "malang";
  print("nama: $nama");
  print("usia: $usia");
  print("alamat: $alamat");
  print("hasil iseng: $iseng");
}
