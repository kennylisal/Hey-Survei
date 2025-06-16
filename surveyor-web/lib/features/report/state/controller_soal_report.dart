import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hei_survei/features/report/model/data_soal_survei.dart';
import 'package:hei_survei/features/report/state/soal_report.dart';

class ControllerSoalReport extends StateNotifier<SoalReportState> {
  ControllerSoalReport({required DataPertanyaanForm dataPertanyaan})
      : super(SoalReportState(
          soalPertanyaan: dataPertanyaan.soalPertanyaan,
          urlGambar: dataPertanyaan.urlGambar,
          idSoal: dataPertanyaan.idSoal,
          dataSoalReport: dataPertanyaan.dataSoalReport,
        )) {
    setUpReport();
  }
  Delta getDocumentPertanyaan() => state.soalPertanyaan;
  setUpReport() {}
}
