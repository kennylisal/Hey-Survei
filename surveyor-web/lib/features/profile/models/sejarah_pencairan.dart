import 'dart:convert';

class SejarahPencairan {
  int jumlahPoin;
  String aktif;
  DateTime waktu_pengajuan;
  SejarahPencairan({
    required this.jumlahPoin,
    required this.aktif,
    required this.waktu_pengajuan,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'jumlahPoin': jumlahPoin,
      'aktif': aktif,
      'waktu_pengajuan': waktu_pengajuan,
    };
  }

  factory SejarahPencairan.fromMap(Map<String, dynamic> map) {
    return SejarahPencairan(
        jumlahPoin: map['jumlahPoin'] as int,
        aktif: map['aktif'] as String,
        waktu_pengajuan: DateTime.fromMillisecondsSinceEpoch(
            (map['waktu_pengajuan'] as int) * 1000)
        // waktu_pengajuan: map['waktu_pengajuan'] as int,
        );
  }

  String toJson() => json.encode(toMap());

  factory SejarahPencairan.fromJson(String source) =>
      SejarahPencairan.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SejarahPencairan(jumlahPoin: $jumlahPoin, aktif: $aktif, waktu_pengajuan: $waktu_pengajuan)';
}
