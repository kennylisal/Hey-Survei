import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hei_survei/constants.dart';
import 'package:hei_survei/features/form/state/form_controller.dart';
import 'package:hei_survei/features/form/state/form_state.dart';
import 'package:hei_survei/features/form/state/pertanyaan_controller.dart';
import 'package:hei_survei/features/form/state/pertanyaan_state.dart';
import 'package:hei_survei/utils/backend.dart';
import 'package:hei_survei/utils/shared_pref.dart';

class DataFormController {
  Future<bool> cekExistKlasik(String idForm) async {
    try {
      bool hasil = false;
      final surveiRef =
          FirebaseFirestore.instance.collection('form-klasik').doc(idForm);

      await surveiRef.get().then((value) {
        if (value.exists) {
          hasil = true;
        }
      }).onError((error, stackTrace) {
        log(error.toString());
      });
      return hasil;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> cekExistKartu(String idForm) async {
    try {
      bool hasil = false;
      final surveiRef =
          FirebaseFirestore.instance.collection('form-kartu').doc(idForm);

      await surveiRef.get().then((value) {
        if (value.exists) {
          hasil = true;
        }
      }).onError((error, stackTrace) {
        log(error.toString());
      });
      return hasil;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<FormController?> setUpFormKlasikFlutter(String idForm) async {
    try {
      print("ini id form yang dibuka");
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
  // Future<FormController?> setUpFormKlasikFlutter(String idForm) async {
  //   try {
  //     String idPilihan = idForm;
  //     print(idPilihan);
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
  //       controllerPetunjuk:
  //           TextEditingController(text: dataFormJson['petunjuk'] as String),
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

  Future<FormController?> setUpFormKartuFlutter(String idForm) async {
    try {
      String tempX = idForm;
      print(idForm);
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

      List<PertanyaanKartuState> listSoalUtama =
          dbDataProcessingKartu(dataFormJson, controller);
      print("db process data selesai");
      List<PertanyaanCabangKartuState> listSoalCabang =
          dbDataProcessingCabangKartu(dataFormJson, controller);

      controller.isiControllerUtama([
        for (final data in listSoalUtama)
          PertanyaanController(pertanyaanState: data)
      ]);

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

  List<PertanyaanKlasikState> dbDataProcessingKlasik(
      Map<String, dynamic> dataForm, FormController controller) {
    String indexKey = 'daftarSoal';
    List<PertanyaanKlasikState> list = [];
    for (Map<String, dynamic> map in dataForm[indexKey]) {
      list.add(PertanyaanKlasikState.fromMap(map, controller));
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

  Future<bool> cekCredForm(String idForm, String tipeForm) async {
    try {
      String idUser = SharedPrefs.getString(prefUserId) ?? "70fc9a56";
      if (idUser != "") {
        String request = """ 
query CekAuthSurvei(\$idUser: String!, \$idForm: String!, \$tipe: String) {
  cekAuthSurvei(idUser: \$idUser, idForm: \$idForm, tipe: \$tipe) {
    code
    data
    status
  }
}
    """;
        final data =
            await Backend().serverConnection(query: request, mapVariable: {
          "idUser": idUser,
          "idForm": idForm,
          'tipe': tipeForm,
        });
        print(data);
        if (data!['cekAuthSurvei']['code'] == 200) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
