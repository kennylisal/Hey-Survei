// ignore_for_file: public_member_api_docs, sort_constructors_first
class DSurveiInput {
  int hargaPerPartisipan;
  int insentifPerPartisipan;
  int demografiUsia;
  List<String> demografiLokasi;
  List<String> DemografiInterest;
  int batasPartisipan;
  bool diJual;
  int hargaJual;
  DSurveiInput({
    required this.hargaPerPartisipan,
    required this.insentifPerPartisipan,
    required this.demografiUsia,
    required this.demografiLokasi,
    required this.DemografiInterest,
    required this.batasPartisipan,
    required this.diJual,
    required this.hargaJual,
  });

  @override
  String toString() {
    return 'DSurveiInput(hargaPerPartisipan: $hargaPerPartisipan, insentifPerPartisipan: $insentifPerPartisipan, demografiUsia: $demografiUsia, demografiLokasi: $demografiLokasi, DemografiInterest: $DemografiInterest, batasPartisipan: $batasPartisipan, diJual: $diJual, hargaJual: $hargaJual)';
  }
}
