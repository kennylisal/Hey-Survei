import 'package:aplikasi_admin/features/formV2/constant.dart';
import 'package:aplikasi_admin/features/formV2/data_utility.dart';
import 'package:aplikasi_admin/features/formV2/model/data_soal.dart';
import 'package:aplikasi_admin/features/formV2/state/form_controller.dart';
import 'package:aplikasi_admin/features/formV2/state/form_state.dart';
import 'package:aplikasi_admin/features/formV2/state/pertanyaan_controller.dart';
import 'package:aplikasi_admin/features/formV2/state/pertanyaan_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class DataFormController {
  FormController? setUpFormKlasikPercobaan(String idForm) {
    try {
      String idPilihan = idForm;

      final temp = FormStateX(
        idForm: idForm,
        controllerJudul: TextEditingController(text: "Judul Standar"),
        controllerPetunjuk: TextEditingController(text: "Petunjuk BIasa"),
        listSoalController: [],
        listSoalCabang: [],
        isCabangShown: false,
      );
      Map<String, dynamic> mapAwal = {
        "content": [
          {"insert": "Teks Pertanyaan\n"}
        ]
      };
      Map<String, dynamic> mapAwalx = {
        "content": [
          {"insert": "Teks Petunjuk\n"}
        ]
      };
      final controller = FormController(formKlasikState: temp);
      temp.listSoalController.add(
        PertanyaanController(
          pertanyaanState: PertanyaanKlasikState(
            quillController: DataUtility()
                .makeQuillController(Delta.fromJson(mapAwal["content"])),
            dataSoal: DataSoal(tipeSoal: Tipesoal.angka, idSoal: "IdSoal baru"),
            isWajib: false,
            tipePertanyaan: TipePertanyaan.pertanyaanKlasik,
            formController: controller,
            isBergambar: false,
            urlGambar: "",
          ),
        ),
      );

      final percobaanPembatas = PertanyaanController(
          pertanyaanState: PembatasState(
        controllerBagian: TextEditingController(),
        quillController: DataUtility()
            .makeQuillController(Delta.fromJson(mapAwalx["content"])),
        dataSoal:
            DataSoal(tipeSoal: Tipesoal.angka, idSoal: "PembatasPercobaan"),
        isWajib: false,
        tipePertanyaan: TipePertanyaan.pembatasPertanyaan,
        formController: controller,
      ));
      temp.listSoalController.add(percobaanPembatas);

      return controller;
    } catch (e) {
      print(e);
      print("error");
      return null;
    }
  }

  // Future<FormController?> setUpFormKlasikFlutter(String idForm) async {
  //   try {
  //     String idPilihan = idForm;
  //     // String idPilihan = "93a29dbd";
  //     Map<String, dynamic> dataFormJson = {};
  //     final surveiRef =
  //         FirebaseFirestore.instance.collection('form-klasik').doc(idPilihan);
  //     await surveiRef.get().then((value) {
  //       dataFormJson = value.data()!;
  //     }).onError((error, stackTrace) {
  //       print(error);
  //     });

  //     final temp = FormStateX(
  //       idForm: idForm,
  //       controllerJudul:
  //           TextEditingController(text: dataFormJson['judul'] as String),
  //       controllerPetunjuk: TextEditingController(),
  //       // controllerPetunjuk:
  //       //     TextEditingController(text: dataFormJson['petunjuk'] as String),
  //       listSoalController: [],
  //       listSoalCabang: [],
  //       isCabangShown: false,
  //     );

  //     final controller = FormController(formKlasikState: temp);

  //     List<PertanyaanKlasikState> listSoalUtama =
  //         dbDataProcessingKlasik(dataFormJson, controller);
  //     //
  //     List<PertanyaanCabangKlasikState> listSoalCabang =
  //         dbDataProcessingCabangKlasik(dataFormJson, controller);
  //     //
  //     controller.isiControllerUtama([
  //       for (final data in listSoalUtama)
  //         PertanyaanController(pertanyaanState: data)
  //     ]);
  //     //
  //     controller.isiControllerCabang([
  //       for (final data in listSoalCabang)
  //         PertanyaanController(pertanyaanState: data)
  //     ]);
  //     return controller;
  //   } catch (e) {
  //     print(e);
  //     print("error");
  //     return null;
  //   }
  // }

  Future<FormController?> setUpFormKlasikFlutter(String idForm) async {
    try {
      String idPilihan = idForm;
      // String idPilihan = "93a29dbd";
      Map<String, dynamic> dataFormJson = {};
      final surveiRef =
          FirebaseFirestore.instance.collection('form-klasik').doc(idPilihan);
      await surveiRef.get().then((value) {
        dataFormJson = value.data()!;
      }).onError((error, stackTrace) {
        print(error);
      });

      final temp = FormStateX(
        idForm: idForm,
        controllerJudul:
            TextEditingController(text: dataFormJson['judul'] as String),
        controllerPetunjuk: TextEditingController(text: "Hapus ini"),
        // controllerPetunjuk:
        //     TextEditingController(text: dataFormJson['petunjuk'] as String),
        listSoalController: [],
        listSoalCabang: [],
        isCabangShown: false,
      );

      final controller = FormController(formKlasikState: temp);

      List<PertanyaanState> listSoalUtama =
          dbDataProcessingKlasikV2(dataFormJson, controller);
      //
      List<PertanyaanCabangKlasikState> listSoalCabang =
          dbDataProcessingCabangKlasik(dataFormJson, controller);
      //
      controller
          .isiControllerUtama(List.generate(listSoalUtama.length, (index) {
        if (listSoalUtama[index].tipePertanyaan ==
            TipePertanyaan.pembatasPertanyaan) {
          return PertanyaanController(
              pertanyaanState: (listSoalUtama[index] as PembatasState));
        } else {
          return PertanyaanController(
              pertanyaanState: (listSoalUtama[index] as PertanyaanKlasikState));
        }
      }));
      // controller.isiControllerUtama([
      //   for (final data in listSoalUtama)
      //     PertanyaanController(pertanyaanState: data)
      // ]);
      //
      controller.isiControllerCabang([
        for (final data in listSoalCabang)
          PertanyaanController(pertanyaanState: data)
      ]);
      return controller;
    } catch (e) {
      print(e);
      print("error");
      return null;
    }
  }

  Future<FormController?> setUpFormKartuFlutter(String idForm) async {
    try {
      String tempX = idForm;
      // String tempX = "xePercob444";
      Map<String, dynamic> dataFormJson = {};
      final surveiRef =
          FirebaseFirestore.instance.collection('form-kartu').doc(tempX);
      await surveiRef.get().then((value) {
        dataFormJson = value.data()!;
      }).onError((error, stackTrace) {
        print(error);
      });
      final temp = FormStateX(
        idForm: idForm,
        controllerJudul:
            TextEditingController(text: dataFormJson['judul'] as String),
        controllerPetunjuk:
            TextEditingController(text: dataFormJson['petunjuk'] as String),
        listSoalController: [],
        listSoalCabang: [],
        isCabangShown: false,
      );

      final controller = FormController(formKlasikState: temp);
      // print("bisa bikin state");
      List<PertanyaanKartuState> listSoalUtama =
          dbDataProcessingKartu(dataFormJson, controller);
      print("db process data selesai");
      //
      List<PertanyaanCabangKartuState> listSoalCabang =
          dbDataProcessingCabangKartu(dataFormJson, controller);
      //
      controller.isiControllerUtama([
        for (final data in listSoalUtama)
          PertanyaanController(pertanyaanState: data)
      ]);
      //
      controller.isiControllerCabang([
        for (final data in listSoalCabang)
          PertanyaanController(pertanyaanState: data)
      ]);

      return controller;
    } catch (e) {
      print(e);
      return null;
    }
  }

  List<PertanyaanKlasikState> dbDataProcessingKlasik(
      Map<String, dynamic> dataForm, FormController controller) {
    String indexKey = 'daftarSoal';
    List<PertanyaanKlasikState> list = [];
    for (Map<String, dynamic> map in dataForm[indexKey]) {
      list.add(PertanyaanKlasikState.fromMap(map, controller));
    }
    return list;
  }

  List<PertanyaanState> dbDataProcessingKlasikV2(
      Map<String, dynamic> dataForm, FormController controller) {
    String indexKey = 'daftarSoal';
    List<PertanyaanState> list = [];
    for (Map<String, dynamic> map in dataForm[indexKey]) {
      if (map['isPembatas'] == null) {
        list.add(PertanyaanKlasikState.fromMap(map, controller));
      } else {
        list.add(PembatasState.fromMap(map, controller));
      }
    }
    return list;
  }

  List<PertanyaanCabangKlasikState> dbDataProcessingCabangKlasik(
      Map<String, dynamic> dataForm, FormController controller) {
    String indexKey = 'daftarSoalCabang';
    List<PertanyaanCabangKlasikState> list = [];
    for (Map<String, dynamic> map in dataForm[indexKey]) {
      list.add(PertanyaanCabangKlasikState.fromMap(map, controller));
    }
    return list;
  }

  List<PertanyaanKartuState> dbDataProcessingKartu(
      Map<String, dynamic> dataForm, FormController controller) {
    String indexKey = 'daftarSoal';
    List<PertanyaanKartuState> list = [];
    for (Map<String, dynamic> map in dataForm[indexKey]) {
      list.add(PertanyaanKartuState.fromMap(map, controller));
    }
    return list;
  }

  List<PertanyaanCabangKartuState> dbDataProcessingCabangKartu(
      Map<String, dynamic> dataForm, FormController controller) {
    String indexKey = 'daftarSoalCabang';
    List<PertanyaanCabangKartuState> list = [];
    for (Map<String, dynamic> map in dataForm[indexKey]) {
      list.add(PertanyaanCabangKartuState.fromMap(map, controller));
    }
    return list;
  }
}
