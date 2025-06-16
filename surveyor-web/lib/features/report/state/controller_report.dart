import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hei_survei/features/report/model/data_soal.dart';
import 'package:hei_survei/features/report/model/data_soal_survei.dart';
import 'package:hei_survei/features/report/state/controller_soal_report.dart';
import 'package:hei_survei/features/report/state/report.dart';

final _reportProvider =
    StateNotifierProvider.family<ControllerReport, ReportState, String>(
  (ref, arg) => ControllerReport(idForm: arg),
);

class ControllerReport extends StateNotifier<ReportState> {
  ControllerReport({required String idForm})
      : super(ReportState(idForm: idForm)) {
    setUpReport();
  }

  List<ControllerSoalReport>? getListController() => state.listController;

  static StateNotifierProviderFamily<ControllerReport, ReportState, String>
      get provider => _reportProvider;

  setUpReport() {
    Map<String, dynamic> mapAwal = {
      "content": [
        {
          "insert":
              "Negara manakah yang kamu rasa adalah negara paling bagus di dunia ini kalau saya rasa mungkin indonesia tapi tidak tahu kamu rasanya gimana oleh sebab itu pertanyaan ini ada nutuk memeprtanyakana pertanyaan misterius ini\n"
        }
      ]
    };
    Delta dTemp = Delta.fromJson(mapAwal["content"]);

    DataPilganReport dpilgan = DataPilganReport(
        chartPilihan: SizedBox(),
        listJawaban: ["USA", "Indonesia", "Jepang", "India"],
        jumlahPartisipan: 57);

    List<DataPertanyaanForm> listData = [
      DataPertanyaanForm(
        soalPertanyaan: dTemp,
        urlGambar: 'aa.jpg',
        idSoal: "soalx",
        dataSoalReport: dpilgan,
      ),
      DataPertanyaanForm(
        soalPertanyaan: dTemp,
        urlGambar: 'aa.jpg',
        idSoal: "soalx",
        dataSoalReport: dpilgan,
      ),
    ];

    state = state.copyWith(
        judul: "judul survei",
        deskripsi: "deskripsi",
        listController: [
          for (final data in listData)
            ControllerSoalReport(dataPertanyaan: data)
        ]);
  }
}
