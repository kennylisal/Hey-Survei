import 'dart:convert';

import 'package:aplikasi_admin/constants.dart';
import 'package:aplikasi_admin/features/survei/models/data_form.dart';
import 'package:aplikasi_admin/utils/backend.dart';

class DraftController {
  Future<List<DataForm>> ambilForm() async {
    try {
      String request = """ 
        query Query(\$idUser: String!) {
  getFormkuV2(idUser: \$idUser) {
    code,status,data {
      id,judul,tanggal,tipe
    }
  }
}
    """;
      final data =
          await Backend().serverConnection(query: request, mapVariable: {
        "idUser": idUserAdmin,
      });

      if (data!['getFormkuV2']['code'] == 200) {
        List<Object?> dataSurvei = data["getFormkuV2"]["data"];
        print(dataSurvei);
        List<DataForm> list = List.generate(dataSurvei.length,
            (index) => DataForm.fromJson(json.encode(dataSurvei[index])));
        return list;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}
