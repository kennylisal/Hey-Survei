import 'package:survei_aplikasi/constants.dart';
import 'package:survei_aplikasi/utils/graphql_db.dart';
import 'package:survei_aplikasi/utils/shared_pref.dart';

class LaporanController {
  Future<bool> pengajuanPencairan({
    required String email,
    required String laporan,
    required String idSurvei,
    required String judulSurvei,
  }) async {
    try {
      final idUser = SharedPrefs.getString(prefUserid) ?? "error";
      String request = """
mutation KirimReport(\$laporan: String!, \$email: String!, \$idUser: String!, \$idSurvei: String!, \$judulSurvei: String!) {
  kirimReport(laporan: \$laporan, email: \$email, idUser: \$idUser, idSurvei: \$idSurvei, judulSurvei: \$judulSurvei) {
    code,pesan,status
  }
}
      """;
      Map<String, dynamic>? data = await BackendConnection()
          .serverConnection(query: request, mapVariable: {
        "idUser": idUser,
        "laporan": laporan,
        "email": email,
        "idSurvei": idSurvei,
        'judulSurvei': judulSurvei,
      });
      if (data!['kirimReport']['code'] == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> kirimPenilaianSurvei({
    required String email,
    required String pesan,
    required String idSurvei,
    required String emailUser,
    required int nilai,
  }) async {
    try {
      final idUser = SharedPrefs.getString(prefUserid) ?? "error";
      String request = """
mutation Mutation(\$pesan: String!, \$nilai: Int!, \$idSurvei: String!, \$email: String!, \$idUser: String!) {
  kirimPenilaianSurvei(pesan: \$pesan, nilai: \$nilai, idSurvei: \$idSurvei, email: \$email, idUser: \$idUser) {
    code,pesan,status
  }
}
      """;
      Map<String, dynamic>? data = await BackendConnection()
          .serverConnection(query: request, mapVariable: {
        "pesan": pesan,
        "nilai": nilai,
        "idSurvei": idSurvei,
        "email": emailUser,
        "idUser": idUser,
      });
      if (data!['kirimPenilaianSurvei']['code'] == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
