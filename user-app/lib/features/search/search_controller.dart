import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:survei_aplikasi/constants.dart';
import 'package:survei_aplikasi/features/home/model/data_katalog.dart';
import 'package:survei_aplikasi/features/search/model/h_survei.dart';
import 'package:survei_aplikasi/utils/graphql_db.dart';
import 'package:survei_aplikasi/utils/shared_pref.dart';

class SearchControllerX {
  Future<List<String>> getSurveiPengecualian() async {
    try {
      final idUser = SharedPrefs.getString(prefUserid) ?? "8c6639a";
      List<String> hasil = [];
      String request = """
query GetAllHistory(\$idUser: String!) {
  getSurveiTerlarang(idUser: \$idUser) {
    code,data,status
  }
}
      """;
      Map<String, dynamic>? data = await BackendConnection()
          .serverConnection(query: request, mapVariable: {
        'idUser': idUser,
      });
      if (data!['getSurveiTerlarang']['code'] == 200) {
        List<Object?> result = data['getSurveiTerlarang']['data'];
        hasil =
            List.generate(result.length, (index) => result[index] as String);
      } else {
        return [];
      }
      return hasil;
    } catch (e) {
      print(e);
      return [];
    }
  }

//   Future<List<String>> getSurveiPengecualianUji() async {
//     try {
//       final idUser = SharedPrefs.getString(prefUserid) ?? "8c6639a";
//       List<String> hasil = [];
//       String request = """
// query GetAllHistory(\$idUser: String!) {
//   getSurveiTerlarangUjiCoba(idUser: \$idUser) {
//     code,data,status
//   }
// }
//       """;
//       Map<String, dynamic>? data = await BackendConnection()
//           .serverConnection(query: request, mapVariable: {
//         'idUser': idUser,
//       });
//       if (data!['getSurveiTerlarangUjiCoba']['code'] == 200) {
//         print("coba olah pengecualian");
//         List<Object?> result = data['getSurveiTerlarangUjiCoba']['data'];
//         hasil =
//             List.generate(result.length, (index) => result[index] as String);
//       } else {
//         return [];
//       }
//       return hasil;
//     } catch (e) {
//       print(e);
//       return [];
//     }
//   }

  Future<List<HSurvei>> getSurveiTerbaruDefault() async {
    //ini untuk ambi 10 biji
    try {
      List<HSurvei> hasil = [];
      String request = """
query Query {
  getDefaultSurvei {
    code,status,data {
      id_survei,tanggal_penerbitan,judul,kategori,insentif,judul,deskripsi,isKlasik,durasi,gambarSurvei
    }
  }
}
      """;

      Map<String, dynamic>? data = await BackendConnection()
          .serverConnection(query: request, mapVariable: {});
      print(data);
      if (data!['getDefaultSurvei']['code'] == 200) {
        List<Object?> dataHSurvei = data['getDefaultSurvei']['data'];

        hasil = List.generate(dataHSurvei.length,
            (index) => HSurvei.fromJson(json.encode(dataHSurvei[index])));
      }
      return hasil;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<HSurvei>> searchHSurvei({required String search}) async {
    try {
      List<HSurvei> hasil = [];
      String request = """
query Query(\$search: String!) {
  searchSurveiNormal(search: \$search) {
    code,status,data {
    id_survei,tanggal_penerbitan,judul,kategori,insentif,judul,deskripsi,isKlasik,durasi,gambarSurvei
  } 
  }
}
      """;

      Map<String, dynamic>? data = await BackendConnection()
          .serverConnection(query: request, mapVariable: {
        "search": search,
      });
      if (data!['searchSurveiNormal']['code'] == 200) {
        List<Object?> dataHSurvei = data['searchSurveiNormal']['data'];

        hasil = List.generate(dataHSurvei.length,
            (index) => HSurvei.fromJson(json.encode(dataHSurvei[index])));
      }
      // print(hasil);
      return hasil;
    } catch (e) {
      print(e);
      return [];
    }
  }
}

//   Future<List<DataKatalog>> getAllSurvei(BuildContext context) async {
//     try {
//       String query = """
// query GetDataUser {
//   getAllSurvei {
//   code,status,data {
//     deskripsi,durasi,id_form,id_survei,isKlasik,judul,kategori,status,tanggal
//   }
//   }
// }
//     """;
//       Map<String, dynamic>? data = await BackendConnection()
//           .serverConnection(query: query, mapVariable: {});
//       if (!context.mounted) return [];
//       if (data!['getAllSurvei']['code'] == 200) {
//         List<Object?> dataQuery = data["getAllSurvei"]["data"];
//         List<DataKatalog> listHasil = List.generate(dataQuery.length,
//             (index) => DataKatalog.fromJson(json.encode(dataQuery[index])));
//         print(listHasil);
//         return listHasil;
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//             content: Text(
//           "Terjadi Kesalahan Server",
//         )));
//         return [];
//       }
//     } catch (e) {
//       print(e);
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text(
//         "Terjadi Kesalahan Server",
//       )));
//       return [];
//     }
//   }