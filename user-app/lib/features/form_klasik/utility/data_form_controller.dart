import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:survei_aplikasi/features/form_kartu/state/controller_form_kartu.dart';
import 'package:survei_aplikasi/features/form_kartu/state/state_form_kartu.dart';
import 'package:survei_aplikasi/features/form_klasik/constant.dart';
import 'package:survei_aplikasi/features/form_klasik/state/controller_form.dart';
import 'package:survei_aplikasi/features/form_klasik/state/controller_pertanyaan.dart';
import 'package:survei_aplikasi/features/form_klasik/state/state_form.dart';
import 'package:survei_aplikasi/features/form_klasik/state/state_pertanyaan.dart';

class DataFormController {
  Future<FormKartuController?> setUpFormKartu(String idForm) async {
    try {
      Map<String, dynamic> dataFormJson = {};
      final surveiKartuRef =
          FirebaseFirestore.instance.collection('form-kartu').doc(idForm);
      await surveiKartuRef.get().then((value) {
        dataFormJson = value.data()!;
      }).onError((error, stackTrace) {
        print(error);
      });

      List<PertanyaanStateKartu> listSoalUtama =
          dbDataProcessKartu(dataFormJson);
      List<PertanyaanStateKartuCabang> listSoalCabang =
          dbDataProcessKartuCabang(dataFormJson);
      int totalSoal = listSoalUtama.length;
      FormKartuState form = FormKartuState(
        idForm: idForm,
        judul: dataFormJson['judul'] as String,
        deskripsi: dataFormJson['petunjuk'] as String,
        listDataPertanyaan: List.generate(
            listSoalUtama.length,
            (index) => PertanyaanController(
                pertanyaanState:
                    (listSoalUtama[index] as PertanyaanStateKartu))),
        listDataPertanyaanCabang: List.generate(
          listSoalCabang.length,
          (index) => PertanyaanController(
            pertanyaanState:
                (listSoalCabang[index] as PertanyaanStateKartuCabang),
          ),
        ),
      );
      FormKartuController tempKiriman = FormKartuController(formKartu: form);
      tempKiriman.totalSoalUtama = totalSoal;
      return tempKiriman;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<FormController?> setUpFormKlasik(String idForm) async {
    try {
      Map<String, dynamic> dataFormJson = {};
      final surveiRef =
          FirebaseFirestore.instance.collection('form-klasik').doc(idForm);
      await surveiRef.get().then((value) {
        dataFormJson = value.data()!;
      }).onError((error, stackTrace) {
        print(error);
      });
      List<PertanyaanState> listSoalUtama = dbDataProcessKlasik(dataFormJson);
      List<PertanyaanStateKlasikCabang> listSoalCabang =
          dbDataProcessingCabangKlasik(dataFormJson);

      int jumlahBagian = -1;
      print("Sudah sampai sini");
      Map<int, List<int>> pembagianSoal = {};
      //bagian proses soal
      FormStateX state = FormStateX(
        idForm: idForm,
        judul: dataFormJson['judul'] as String,
        listDataPertanyaan: List.generate(listSoalUtama.length, (index) {
          if (listSoalUtama[index].tipePertanyaan ==
              TipePertanyaan.pembatasPertanyaan) {
            //
            jumlahBagian++;
            pembagianSoal[jumlahBagian] = [index];
            //
            return PertanyaanController(
                pertanyaanState: listSoalUtama[index] as PembatasState);
          } else {
            //
            pembagianSoal[jumlahBagian]!.add(index);
            //
            return PertanyaanController(
                pertanyaanState:
                    (listSoalUtama[index] as PertanyaanStateKlasik));
          }
        }),
        listDataPertanyaanCabang: List.generate(
            listSoalCabang.length,
            (index) => PertanyaanController(
                pertanyaanState:
                    (listSoalCabang[index] as PertanyaanStateKlasikCabang))),
      );
      FormController temp = FormController(formStateX: state);
      temp.jumlahBagian = (jumlahBagian + 1);
      temp.pembagianSoal = pembagianSoal;

      temp.jumlahPertanyaan =
          state.listDataPertanyaan.length - (jumlahBagian + 1);
      return temp;
    } catch (e) {
      print(e);
      return null;
    }
  }
}

List<PertanyaanState> dbDataProcessKlasik(Map<String, dynamic> dataForm) {
  String indexKey = 'daftarSoal';
  print(dataForm);
  List<PertanyaanState> list = [];
  for (Map<String, dynamic> map in dataForm[indexKey]) {
    print(map['idSoal'] as String);
    if (map['isPembatas'] == null) {
      list.add(PertanyaanStateKlasik.fromMap(map));
    } else {
      list.add(PembatasState.fromMap(map));
    }
  }
  return list;
}

List<PertanyaanStateKlasikCabang> dbDataProcessingCabangKlasik(
    Map<String, dynamic> dataForm) {
  String indexKey = 'daftarSoalCabang';
  List<PertanyaanStateKlasikCabang> list = [];
  for (Map<String, dynamic> map in dataForm[indexKey]) {
    list.add(PertanyaanStateKlasikCabang.fromMap(map));
  }
  return list;
}

List<PertanyaanStateKartu> dbDataProcessKartu(Map<String, dynamic> dataForm) {
  String indexKey = 'daftarSoal';
  List<PertanyaanStateKartu> list = [];
  for (Map<String, dynamic> map in dataForm[indexKey]) {
    list.add(PertanyaanStateKartu.fromMap(map));
  }
  return list;
}

List<PertanyaanStateKartuCabang> dbDataProcessKartuCabang(
    Map<String, dynamic> dataForm) {
  String indexKey = 'daftarSoalCabang';
  List<PertanyaanStateKartuCabang> list = [];
  for (Map<String, dynamic> map in dataForm[indexKey]) {
    list.add(PertanyaanStateKartuCabang.fromMap(map));
  }
  return list;
}
