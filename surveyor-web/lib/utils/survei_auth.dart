import 'package:hei_survei/constants.dart';
import 'package:hei_survei/utils/backend.dart';
import 'package:hei_survei/utils/shared_pref.dart';

class SurveiAuth {
  Future<bool> cekCredForm(String idForm, String tipeForm) async {
    try {
      String idUser = SharedPrefs.getString(prefUserId) ?? "";
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
          "idUser": SharedPrefs.getString(prefUserId) ?? "70fc9a56",
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

  Future<bool> cekCredPreview(String idForm, String tipeForm) async {
    try {
      String idUser = SharedPrefs.getString(prefUserId) ?? "";
      if (idUser != "") {
        String request = """ 
query CekAuthSurvei(\$idForm: String!, \$tipe: String) {
  cekPreviewSurvei(idForm:\$idForm, tipe: \$tipe) {
    code,data,status
  }
}
    """;
        final data =
            await Backend().serverConnection(query: request, mapVariable: {
          "idUser": SharedPrefs.getString(prefUserId) ?? "70fc9a56",
          'tipe': tipeForm,
        });
        print(data);
        if (data!['cekPreviewSurvei']['code'] == 200) {
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
