//ini versi baru
class DataKumpulanJawaban {
  Map<String, dynamic> dataJawaban;
  String idSoal;
  String tipeJawaban;
  DataKumpulanJawaban({
    required this.dataJawaban,
    required this.idSoal,
    required this.tipeJawaban,
  });

  @override
  String toString() =>
      '(dataJawaban: $dataJawaban, idSoal: $idSoal, tipeJawaban: $tipeJawaban)';
}
