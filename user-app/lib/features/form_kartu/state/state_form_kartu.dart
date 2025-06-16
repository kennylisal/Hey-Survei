// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:survei_aplikasi/features/form_klasik/state/controller_pertanyaan.dart';

class FormKartuState {
  String idForm;
  String judul;
  String deskripsi;
  List<PertanyaanController> listDataPertanyaan;
  List<PertanyaanController> listDataPertanyaanCabang;
  FormKartuState({
    required this.idForm,
    required this.judul,
    required this.deskripsi,
    required this.listDataPertanyaan,
    required this.listDataPertanyaanCabang,
  });

  FormKartuState copyWith({
    String? idForm,
    String? judul,
    String? deskripsi,
    List<PertanyaanController>? listDataPertanyaan,
    List<PertanyaanController>? listDataPertanyaanCabang,
  }) {
    return FormKartuState(
      idForm: idForm ?? this.idForm,
      judul: judul ?? this.judul,
      deskripsi: deskripsi ?? this.deskripsi,
      listDataPertanyaan: listDataPertanyaan ?? this.listDataPertanyaan,
      listDataPertanyaanCabang:
          listDataPertanyaanCabang ?? this.listDataPertanyaanCabang,
    );
  }

  Map<String, dynamic> formToMap() {
    return <String, dynamic>{
      'daftarJawaban': [
        for (final pertanyaan in listDataPertanyaan) pertanyaan.getJawabanData()
      ],
      'daftarJawabanCabang': [
        for (final pertanyaan in listDataPertanyaanCabang)
          pertanyaan.getJawabanData()
      ],
    };
  }
}
