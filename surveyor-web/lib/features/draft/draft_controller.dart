import 'dart:convert';
import 'package:hei_survei/utils/backend.dart';
import 'package:hei_survei/constants.dart';
import 'package:hei_survei/features/publish_survei/model/data_form.dart';
import 'package:hei_survei/utils/shared_pref.dart';

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
        "idUser": SharedPrefs.getString(prefUserId) ?? "70fc9a56",
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

  Future<bool> hapusDraft({
    required bool isKlasik,
    required String idForm,
  }) async {
    try {
      String request = """ 
mutation Mutation(\$idForm: String!, \$isKlasik: Boolean!) {
  hapusDraft(idForm: \$idForm, isKlasik: \$isKlasik) {
    code,data,status
  }
}
    """;
      final data =
          await Backend().serverConnection(query: request, mapVariable: {
        "idForm": idForm,
        "isKlasik": isKlasik,
      });
      if (data!['hapusDraft']['code'] == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
