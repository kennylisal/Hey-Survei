import 'package:aplikasi_admin/features/survei/models/survei_data.dart';

class SurveikuData {
  List<SurveiData> listSurvei;
  List<SurveiData> listBeli;
  SurveikuData({
    required this.listSurvei,
    required this.listBeli,
  });

  @override
  String toString() =>
      'SurveikuData(listSurvei: $listSurvei, listBeli: $listBeli)';
}
