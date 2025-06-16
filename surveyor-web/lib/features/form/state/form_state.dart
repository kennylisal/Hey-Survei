import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hei_survei/features/form/state/pertanyaan_controller.dart';
import 'package:hei_survei/features/form/state/pertanyaan_state.dart';

class FormStateX {
  String idForm;
  TextEditingController controllerJudul;
  TextEditingController controllerPetunjuk;
  List<PertanyaanController> listSoalController;
  List<PertanyaanController> listSoalCabang;
  int indexUtama;
  int indexCabang;
  bool isCabangShown;
  FormStateX({
    required this.idForm,
    required this.controllerJudul,
    required this.controllerPetunjuk,
    required this.listSoalController,
    required this.listSoalCabang,
    required this.isCabangShown,
    this.indexCabang = 0,
    this.indexUtama = 0,
  });

  FormStateX copyWith({
    String? idForm,
    TextEditingController? controllerJudul,
    TextEditingController? controllerPetunjuk,
    List<PertanyaanController>? listSoalController,
    List<PertanyaanController>? listSoalCabang,
    bool? isCabangShown,
    int? indexUtama,
    int? indexCabang,
  }) {
    return FormStateX(
      idForm: idForm ?? this.idForm,
      controllerJudul: controllerJudul ?? this.controllerJudul,
      controllerPetunjuk: controllerPetunjuk ?? this.controllerPetunjuk,
      listSoalController: listSoalController ?? this.listSoalController,
      listSoalCabang: listSoalCabang ?? this.listSoalCabang,
      isCabangShown: isCabangShown ?? this.isCabangShown,
      indexUtama: indexUtama ?? this.indexUtama,
      indexCabang: indexCabang ?? this.indexCabang,
    );
  }

  List<Map<String, dynamic>> getDataForm(TipePertanyaan tipePertanyaan) {
    if (TipePertanyaan.pertanyaanKlasik == tipePertanyaan) {
      return List.generate(listSoalController.length, (index) {
        return (listSoalController[index].getState() as PertanyaanKlasikState)
            .getSoalData();
      });
    } else if (TipePertanyaan.pertanyaanKlasikCabang == tipePertanyaan) {
      return List.generate(listSoalCabang.length, (index) {
        return (listSoalCabang[index].getState() as PertanyaanCabangKlasikState)
            .getSoalData();
      });
    } else if (TipePertanyaan.pertanyaanKartu == tipePertanyaan) {
      return List.generate(
          listSoalController.length,
          (index) =>
              (listSoalController[index].getState() as PertanyaanKartuState)
                  .getSoalData());
    } else if (TipePertanyaan.pertanyaanKartuCabang == tipePertanyaan) {
      return List.generate(
          listSoalCabang.length,
          (index) =>
              (listSoalCabang[index].getState() as PertanyaanCabangKartuState)
                  .getSoalData());
    } else {
      return [];
    }
  }

  List<Map<String, dynamic>> getDataFormV2() {
    final hasil = List.generate(listSoalController.length, (index) {
      if (listSoalController[index].getTipePertanyaan() ==
          TipePertanyaan.pertanyaanKlasik) {
        return (listSoalController[index].getState() as PertanyaanKlasikState)
            .getSoalData();
      }
      //  else if (listSoalController[index].getTipePertanyaan() ==
      //     TipePertanyaan.pertanyaanKlasikCabang) {
      //   return (listSoalController[index].getState()
      //           as PertanyaanCabangKlasikState)
      //       .getSoalData();
      // }
      else if (listSoalController[index].getTipePertanyaan() ==
          TipePertanyaan.pertanyaanKartu) {
        return (listSoalController[index].getState() as PertanyaanKartuState)
            .getSoalData();
      }
      // else if (listSoalController[index].getTipePertanyaan() ==
      //     TipePertanyaan.pertanyaanKartuCabang) {
      //   return (listSoalController[index].getState()
      //           as PertanyaanCabangKartuState)
      //       .getSoalData();
      // }
      else {
        return (listSoalController[index].getState() as PembatasState)
            .getSoalData();
      }
    });
    return hasil;
  }

  Map<String, dynamic> formToMapKlasik() {
    return <String, dynamic>{
      'judul': controllerJudul.text,
      'petunjuk': controllerPetunjuk.text,
      // 'daftarSoal': getDataForm(TipePertanyaan.pertanyaanKlasik),
      'daftarSoal': getDataFormV2(),
      'daftarSoalCabang': getDataForm(TipePertanyaan.pertanyaanKlasikCabang),
      'tglUpdate': Timestamp.now(),
    };
  }

  Map<String, dynamic> formToMapKartu() {
    return <String, dynamic>{
      'judul': controllerJudul.text,
      'petunjuk': controllerPetunjuk.text,
      'daftarSoal': getDataForm(TipePertanyaan.pertanyaanKartu),
      'daftarSoalCabang': getDataForm(TipePertanyaan.pertanyaanKartuCabang),
      'tglUpdate': Timestamp.now(),
    };
  }
}
