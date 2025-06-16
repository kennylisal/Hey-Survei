import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class DemografiSurvei {
  int usiaMinimal;
  List<String> demografiKota;
  List<String> demografiInterest;
  DemografiSurvei({
    required this.usiaMinimal,
    required this.demografiKota,
    required this.demografiInterest,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'usiaMinimal': usiaMinimal,
      'demografiKota': demografiKota,
      'demografiInterest': demografiInterest,
    };
  }

  factory DemografiSurvei.fromMap(Map<String, dynamic> map) {
    print(map);
    List<Object?> tempInter = map['demografiInterest'];
    List<Object?> tempKota = map['demografiLokasi'];
    int usia = -1;
    if (map['demografiUsia'] != null) {
      usia = map['demografiUsia'] as int;
    }
    return DemografiSurvei(
      usiaMinimal: usia,
      demografiKota:
          List.generate(tempKota.length, (index) => tempKota[index] as String),
      demografiInterest: List.generate(
          tempInter.length, (index) => tempInter[index] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory DemografiSurvei.fromJson(String source) =>
      DemografiSurvei.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'DemografiSurvei(usiaMinimal: $usiaMinimal, demografiKota: $demografiKota, demografiInterest: $demografiInterest)';
}
