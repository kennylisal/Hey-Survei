import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hei_survei/constants.dart';
import 'package:hei_survei/features/buat_form/models/template_form.dart';
import 'package:hei_survei/utils/backend.dart';
import 'package:hei_survei/utils/shared_pref.dart';
import 'package:uuid/uuid.dart';

class BuatFormController {
  Future<List<TemplateForm>?> getTemplateList(bool isKlasik) async {
    try {
      String query = """
  query Query(\$isKlasik: Boolean) {
  getTemplateData(isKlasik: \$isKlasik) {
    code,status,data {
      idForm,judul,kategori,petunjuk
    }
  }
}
    """;
      final data = await Backend().serverConnection(query: query, mapVariable: {
        "isKlasik": isKlasik,
      });
      if (data!['getTemplateData']['code'] == 200) {
        List<Object?> listData = data['getTemplateData']['data'];
        print("mau generate list template");
        List<TemplateForm> listTemplate = List.generate(
            listData.length,
            (index) =>
                TemplateForm.fromJson(json.encode(listData[index]), isKlasik));
        return listTemplate;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<String> buatFormKlasikDariTemplate(
      {required String idForm, required BuildContext context}) async {
    try {
      String id = idForm;
      String idBaru = const Uuid().v4().substring(0, 8);
      Map<String, dynamic> dataFormJson = {};
      final surveiRef =
          FirebaseFirestore.instance.collection('form-klasik').doc(id);
      await surveiRef.get().then((value) {
        dataFormJson = value.data()!;
      }).onError((error, stackTrace) {
        print(error);
      });
      // print(dataFormJson['daftarSoal']);

      //map kiriman
      Map<String, dynamic> dataKiriman = {
        'daftarSoal': dataFormJson['daftarSoal'],
        'daftarSoalCabang': dataFormJson['daftarSoalCabang'],
        'petunjuk': "",
        'judul': "",
        'tglUpdate': Timestamp.now(),
        'id_user': SharedPrefs.getString(prefUserId) ?? "",
        'isPublished': false,
      };
      print(idBaru);

      final pembuatan =
          FirebaseFirestore.instance.collection('form-klasik').doc(idBaru);
      await pembuatan.set(dataKiriman).then((value) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Berhasil Buat Form")));
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Terjadi kesalaha server")));
      });

      return idBaru;
    } catch (e) {
      log(e.toString());
      return "";
    }
  }

  Future<String> buatFormKartuDariTemplate(
      {required String idForm, required BuildContext context}) async {
    try {
      String id = idForm;
      String idBaru = const Uuid().v4().substring(0, 8);
      Map<String, dynamic> dataFormJson = {};
      final surveiRef =
          FirebaseFirestore.instance.collection('form-kartu').doc(id);
      await surveiRef.get().then((value) {
        dataFormJson = value.data()!;
      }).onError((error, stackTrace) {
        print(error);
      });
      // print(dataFormJson['daftarSoal']);

      //map kiriman
      Map<String, dynamic> dataKiriman = {
        'daftarSoal': dataFormJson['daftarSoal'],
        'daftarSoalCabang': dataFormJson['daftarSoalCabang'],
        'petunjuk': "",
        'judul': "",
        'tglUpdate': Timestamp.now(),
        'id_user': SharedPrefs.getString(prefUserId) ?? "",
        'isPublished': false,
      };

      final pembuatan =
          FirebaseFirestore.instance.collection('form-kartu').doc(idBaru);
      await pembuatan.set(dataKiriman).then((value) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Berhasil Buat Form")));
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Terjadi kesalaha server")));
      });

      return idBaru;
    } catch (e) {
      log(e.toString());
      return "";
    }
  }
}
