// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hei_survei/features/report/state/controller_soal_report.dart';

class ReportState {
  String idForm;
  String? judul;
  String? deskripsi;
  List<ControllerSoalReport>? listController;
  ReportState({
    required this.idForm,
    this.judul,
    this.deskripsi,
    this.listController,
  });

  ReportState copyWith({
    String? idForm,
    String? judul,
    String? deskripsi,
    List<ControllerSoalReport>? listController,
  }) {
    return ReportState(
      idForm: idForm ?? this.idForm,
      judul: judul ?? this.judul,
      deskripsi: deskripsi ?? this.deskripsi,
      listController: listController ?? this.listController,
    );
  }
}
