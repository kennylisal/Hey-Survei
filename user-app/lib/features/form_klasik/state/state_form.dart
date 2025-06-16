// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:survei_aplikasi/features/form_klasik/state/controller_pertanyaan.dart';

class FormStateX {
  //data utama -> yg didapat dari DB
  String idForm;
  String judul;
  List<PertanyaanController> listDataPertanyaan;
  List<PertanyaanController> listDataPertanyaanCabang;
  FormStateX({
    required this.judul,
    required this.listDataPertanyaan,
    required this.listDataPertanyaanCabang,
    required this.idForm,
  });
  //data tampilan
  //nanti ditaruh di controller form

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

  FormStateX copyWith({
    String? idForm,
    String? judul,
    List<PertanyaanController>? listDataPertanyaan,
    List<PertanyaanController>? listDataPertanyaanCabang,
  }) {
    return FormStateX(
      idForm: idForm ?? this.idForm,
      judul: judul ?? this.judul,
      listDataPertanyaan: listDataPertanyaan ?? this.listDataPertanyaan,
      listDataPertanyaanCabang:
          listDataPertanyaanCabang ?? this.listDataPertanyaanCabang,
    );
  }
}
