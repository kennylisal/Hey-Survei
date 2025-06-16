import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Kategori {
  String id;
  String nama;
  Kategori({
    required this.id,
    required this.nama,
  });

  Kategori copyWith({
    String? id,
    String? nama,
  }) {
    return Kategori(
      id: id ?? this.id,
      nama: nama ?? this.nama,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nama': nama,
    };
  }

  factory Kategori.fromMap(Map<String, dynamic> map) {
    return Kategori(
      id: map['id'] as String,
      nama: map['nama'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Kategori.fromJson(String source) =>
      Kategori.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Kategori(id: $id, nama: $nama)';
}
