import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:survei_aplikasi/features/search/model/h_survei.dart';
import 'package:survei_aplikasi/utils/graphql_db.dart';

class HomeController {
  Future<List<HSurvei>> getSurveiTerbaru() async {
    try {
      List<HSurvei> hasil = [];
      String request = """
query Query {
getSurveiTerbaru {
  code,status,data {
    id_survei,tanggal_penerbitan,judul,kategori,insentif,judul,deskripsi,isKlasik,durasi,gambarSurvei
  }
}
}
    """;

      Map<String, dynamic>? data = await BackendConnection()
          .serverConnection(query: request, mapVariable: {});
      if (data!['getSurveiTerbaru']['code'] == 200) {
        List<Object?> dataHSurvei = data['getSurveiTerbaru']['data'];
        print(data['getSurveiTerbaru']['data']);
        hasil = List.generate(dataHSurvei.length,
            (index) => HSurvei.fromJson(json.encode(dataHSurvei[index])));
      }
      return hasil;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<int> getPoinUser(String idUser) async {
    try {
      int nilai = 0;
      final userRef =
          FirebaseFirestore.instance.collection('Users-survei').doc(idUser);
      await userRef.get().then((value) {
        nilai = (value.data()!['poin'] as int);
      }).onError((error, stackTrace) {
        log(error.toString());
      });
      return nilai;
    } catch (e) {
      log(e.toString());
      return 0;
    }
  }

//   Future<List<HSurvei>> getSurveiUjiCoba() async {
//     try {
//       List<HSurvei> hasil = [];
//       String request = """
// query GetSurveiUjiCoba {
//   getSurveiUjiCoba {
//     code,status,data {
//       id_survei,tanggal_penerbitan,judul,kategori,insentif,judul,deskripsi,isKlasik,durasi
//     }
//   }
// }
//       """;

//       Map<String, dynamic>? data = await BackendConnection()
//           .serverConnection(query: request, mapVariable: {});
//       if (data!['getSurveiUjiCoba']['code'] == 200) {
//         List<Object?> dataHSurvei = data['getSurveiUjiCoba']['data'];
//         print(data['getSurveiUjiCoba']['data']);
//         hasil = List.generate(dataHSurvei.length,
//             (index) => HSurvei.fromJson(json.encode(dataHSurvei[index])));
//       }
//       return hasil;
//     } catch (e) {
//       print(e);
//       return [];
//     }
//   }
}
