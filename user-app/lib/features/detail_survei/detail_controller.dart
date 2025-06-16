import 'dart:convert';

import 'package:survei_aplikasi/features/detail_survei/user_detail.dart';
import 'package:survei_aplikasi/features/search/model/h_survei.dart';
import 'package:survei_aplikasi/utils/graphql_db.dart';

class DetailController {
  Future<DataDetailSurvei?> getDetailSurvei(String idUsurvei) async {
    try {
      String query = """ 
query Query(\$idSurvei: String) {
  getSurveiDetail(idSurvei: \$idSurvei) {
    code,status,user {
      email
    }
    survei {
      id_survei,tanggal_penerbitan,judul,kategori,insentif,judul,deskripsi,isKlasik,durasi
    }
  }
}
    """;
      Map<String, dynamic>? data = await BackendConnection()
          .serverConnection(query: query, mapVariable: {'idSurvei': idUsurvei});
      if (data!['getSurveiDetail']['code'] == 200) {
        Object? dataSurvei = data['getSurveiDetail']['survei'];
        Object? dataUser = data['getSurveiDetail']['user'];
        HSurvei hSurvei = HSurvei.fromJson(json.encode(dataSurvei));
        UserDetail userDetail = UserDetail.fromJson(json.encode(dataUser));

        return DataDetailSurvei(hSurvei: hSurvei, user: userDetail);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

//   Future<String> cekIjinPengisian(String idSurvei) async {
//     try {
//       String query = """
// query Query(\$idSurvei: String!) {
//   cekIsiSurvei(idSurvei: \$idSurvei) {
//     code,pesan,status
//   }
// }
//     """;
//       Map<String, dynamic>? data = await BackendConnection()
//           .serverConnection(query: query, mapVariable: {'idSurvei': idSurvei});
//       if (data!['cekIsiSurvei']['code'] == 200) {
//         return true;
//       } else {
//         return false;
//       }
//     } catch (e) {
//       print(e);
//       return false;
//     }
//   }

  Future<String> cekIjinPengisian(String idSurvei) async {
    try {
      String query = """ 
query Query(\$idSurvei: String!) {
  cekIsiSurvei(idSurvei: \$idSurvei) {
    code,pesan,status
  }
}
    """;
      Map<String, dynamic>? data = await BackendConnection()
          .serverConnection(query: query, mapVariable: {'idSurvei': idSurvei});
      if (data!['cekIsiSurvei']['code'] == 200) {
        return data['cekIsiSurvei']['pesan'] as String;
      } else {
        return "xxx";
      }
    } catch (e) {
      print(e);
      return "xxx";
    }
  }

  Future<String> getidForm(String idSurvei) async {
    try {
      String query = """ 
query Query(\$idSurvei: String!) {
  getIdForm(idSurvei: \$idSurvei) {
    code,pesan,status
  }
}
    """;
      Map<String, dynamic>? data = await BackendConnection()
          .serverConnection(query: query, mapVariable: {'idSurvei': idSurvei});
      if (data!['getIdForm']['code'] == 200) {
        return data['getIdForm']['pesan'] as String;
      } else {
        return "";
      }
    } catch (e) {
      print(e);
      return "";
    }
  }
}

class DataDetailSurvei {
  HSurvei hSurvei;
  UserDetail user;
  DataDetailSurvei({
    required this.hSurvei,
    required this.user,
  });
}
