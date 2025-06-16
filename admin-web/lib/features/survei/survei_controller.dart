import 'dart:convert';

import 'package:aplikasi_admin/constants.dart';
import 'package:aplikasi_admin/features/survei/models/d_survei.dart';
import 'package:aplikasi_admin/features/survei/models/data_form.dart';
import 'package:aplikasi_admin/features/survei/models/kategori.dart';
import 'package:aplikasi_admin/utils/backend.dart';
import 'package:uuid/uuid.dart';

class SurveiController {
  Future<List<String>> getAllInterest() async {
    try {
      List<String> hasil = [];
      String request = """
query Query {
  getAllInterest {
    code,data,status
  }
}
      """;
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: request, mapVariable: {});
      if (data!['getAllInterest']['code'] == 200) {
        List<Object?> result = data['getAllInterest']['data'];
        hasil =
            List.generate(result.length, (index) => result[index] as String);
      }
      return hasil;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<String>> getAllKota() async {
    try {
      List<String> hasil = [];
      String request = """
query Query {
  getAllKota {
    code
    data
    status
  }
}
      """;
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: request, mapVariable: {});
      if (data!['getAllKota']['code'] == 200) {
        List<Object?> result = data['getAllKota']['data'];
        hasil =
            List.generate(result.length, (index) => result[index] as String);
      }
      return hasil;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<String>> getAllKategori() async {
    try {
      List<Kategori> hasil = [];
      String request = """
query Query {
  getAllKategori {
  code,message,data {
    id,nama
  }  
  }
}
      """;
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: request, mapVariable: {});
      if (data!['getAllKategori']['code'] == 200) {
        // List<String> result = data['getAllKategori']['data'];
        List<Object?> result = data['getAllKategori']['data'];
        hasil = List.generate(result.length,
            (index) => Kategori.fromJson(json.encode(result[index])));
      }
      return List.generate(hasil.length, (index) => hasil[index].nama);
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<String> getDataForm(String idForm, String tipe) async {
    try {
      String request = """ 
query Query(\$idForm: String!, \$tipe: String!) {
  getPublishData(idForm: \$idForm, tipe: \$tipe) {
    code,judul,status
    jumlahSoal
    tipe
  }
}
    """;

      final variables = {
        'idForm': idForm,
        'tipe': tipe,
      };
      Map<String, dynamic>? data = await Backend()
          .serverConnection(query: request, mapVariable: variables);

      print("ini data- >" + data.toString());

      if (data!['getPublishData']['code'] == 200) {
        return data['getPublishData']['judul'] as String;
      } else {
        return "-=-j";
      }
    } catch (e) {
      print(e);
      return "-=-j";
    }
  }

//   Future<Map<String, int>> getHargaReward() async {
//     try {
//       String request = """
//         query GetReward {
//   getReward {
//     biaya
//     code
//     insentif
//     message
//     special
//   }
// }
//     """;
//       Map<String, dynamic>? data =
//           await Backend().serverConnection(query: request, mapVariable: {});

//       if (data!['getReward']['code'] == 200) {
//         return {
//           'hargapPerSurvei': data['getReward']['biaya'],
//           'insentifPerPartisipan': data['getReward']['insentif'],
//           'hargaSpecial': data['getReward']['special'],
//         };
//       } else {
//         return {
//           'hargapPerSurvei': 0,
//           'insentifPerPartisipan': 0,
//           'hargaSpecial': 0,
//         };
//       }
//     } catch (e) {
//       print(e);
//       return {
//         'hargapPerSurvei': 0,
//         'insentifPerPartisipan': 0,
//         'hargaSpecial': 0,
//       };
//     }
//   }

  Future<String> buatFormKartu() async {
    try {
      String idBaru = const Uuid().v4().substring(0, 8);
      String request = """ 
mutation BuatFormKartu(\$idForm: String!, \$idUser: String!) {
  buatFormKartu(idForm: \$idForm, idUser: \$idUser) {
    code,data,status
  }
}
    """;

      final variables = {
        "idForm": idBaru,
        "idUser": idUserAdmin,
      };

      final data = await Backend()
          .serverConnection(query: request, mapVariable: variables);

      if (data!['buatFormKartu']['code'] == 200) {
        return idBaru;
      } else {
        return "gagal";
      }
    } catch (e) {
      print(e);
      return "gagal";
    }
  }

  Future<String> buatFormKlasik() async {
    try {
      String idBaru = const Uuid().v4().substring(0, 8);
      String request = """ 
mutation Mutation(\$idForm: String!, \$idUser: String!) {
  buatFormKlasik(idForm: \$idForm, idUser: \$idUser) {
    code,data,status
  }
}
    """;

      final variables = {
        "idForm": idBaru,
        "idUser": idUserAdmin,
      };

      final data = await Backend()
          .serverConnection(query: request, mapVariable: variables);

      if (data!['buatFormKlasik']['code'] == 200) {
        return idBaru;
      } else {
        return "gagal";
      }
    } catch (e) {
      print(e);
      return "gagal";
    }
  }

  Future<List<DataForm>> ambilForm(String idUser) async {
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
      final data = await Backend().serverConnection(
          query: request, mapVariable: {"idUser": idUserAdmin});

      if (data!['getFormkuV2']['code'] == 200) {
        List<Object?> dataSurvei = data["getFormkuV2"]["data"];
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

  Future<bool> publishSurvei({
    required String idForm,
    required String judul,
    required String deskripsi,
    required String kategori,
    required int durasi,
    required int batasPartisipan,
    required int harga,
    required bool isKlasik,
    required bool pakaiDemografi,
    required DSurvei dSurvei,
  }) async {
    try {
      String query = """
mutation Mutation(\$survei: AddSurveiInput!, \$idForm: String!, \$idUser: String!, \$dSurvei: dSurveiInput) {
  publishSurveiBaru(survei: \$survei, idForm: \$idForm, idUser: \$idUser, dSurvei: \$dSurvei) {
    code,data,status
  }
}
    """;

      final variables = {
        "survei": {
          "judul": judul,
          "batasPartisipan": batasPartisipan,
          "deskripsi": deskripsi,
          "durasi": durasi,
          "harga": harga,
          "isKlasik": isKlasik,
          "kategori": kategori,
          "status": "aktif",
          'pakaiDemografi': pakaiDemografi,
          'emailUser': "AdminHeiSurvei"
        },
        "idForm": idForm,
        'idUser': idUserAdmin,
        'dSurvei': {
          'hargaPerPartisipan': dSurvei.hargaPerPartisipan,
          'insentifPerPartisipan': dSurvei.insentifPerPartisipan,
          'demografiUsia': dSurvei.demografiUsia,
          'demografiLokasi': dSurvei.demografiLokasi,
          'demografiInterest': dSurvei.DemografiInterest,
          'batasPartisipan': dSurvei.batasPartisipan,
          'diJual': dSurvei.diJual,
          'hargaJual': dSurvei.hargaJual,
        }
      };
      print("mau kirim data ke server");
      final data = await Backend()
          .serverConnection(query: query, mapVariable: variables);
      print(data);
      if (data!['publishSurveiBaru']['code'] == 200) {
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
