import 'dart:convert';

class TemplateForm {
  String judul;
  String idForm;
  String petunjuk;
  bool isKlasik;
  String kategori;
  TemplateForm({
    required this.judul,
    required this.idForm,
    required this.petunjuk,
    required this.isKlasik,
    required this.kategori,
  });

  TemplateForm copyWith({
    String? judul,
    String? idForm,
    String? petunjuk,
    bool? isKlasik,
    String? kategori,
  }) {
    return TemplateForm(
      judul: judul ?? this.judul,
      idForm: idForm ?? this.idForm,
      petunjuk: petunjuk ?? this.petunjuk,
      isKlasik: isKlasik ?? this.isKlasik,
      kategori: kategori ?? this.kategori,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'judul': judul,
      'idForm': idForm,
      'petunjuk': petunjuk,
      'isKlasik': isKlasik,
      'kategori': kategori,
    };
  }

  factory TemplateForm.fromMap(Map<String, dynamic> map, bool isKlasik) {
    return TemplateForm(
      judul: map['judul'] as String,
      idForm: map['idForm'] as String,
      petunjuk: map['petunjuk'] as String,
      isKlasik: isKlasik,
      kategori: map['kategori'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TemplateForm.fromJson(String source, bool isKlasik) =>
      TemplateForm.fromMap(
          json.decode(source) as Map<String, dynamic>, isKlasik);
}
