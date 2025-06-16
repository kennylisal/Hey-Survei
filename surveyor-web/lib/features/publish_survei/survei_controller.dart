import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hei_survei/features/publish_survei/model/respon_midtrans.dart';
import 'package:hei_survei/utils/backend.dart';
import 'package:hei_survei/constants.dart';

import 'package:hei_survei/features/katalog/model/kategori.dart';
import 'package:hei_survei/features/katalog/model/survei_data.dart';
import 'package:hei_survei/features/publish_survei/model/d_survei.dart';
import 'package:hei_survei/features/publish_survei/model/data_form.dart';

import 'package:hei_survei/features/publish_survei/model/survei.dart';
import 'package:hei_survei/utils/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:hei_survei/features/publish_survei/model/detail_survei.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SurveiController {
  Future<String> pilihGambarSurvei(BuildContext context) async {
    try {
      Uint8List? selectedImageBytes;
      String urlGambar = "";
      //bagian pilih gambar
      FilePickerResult? fileResult = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'heic'],
      );
      if (fileResult != null) {
        // print(fileResult.files.first.size);

        selectedImageBytes = fileResult.files.first.bytes;
        //Bagian ngeupload gambar
        //
        String namaBaru = Uuid().v4().substring(0, 11);
        firebase_storage.UploadTask uploadTask;

        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('form')
            .child('/' + namaBaru);

        final metaData =
            firebase_storage.SettableMetadata(contentType: 'image/jpeg');

        uploadTask = ref.putData(selectedImageBytes!, metaData);

        await uploadTask.whenComplete(() => null);
        urlGambar = await ref.getDownloadURL();

        print('uploaded image URL : $urlGambar');
        //
        //bagian update form
        if (!context.mounted)
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
            "Gambar berhasil di-upload",
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  fontSize: 24,
                  color: Colors.white,
                ),
          )));
      } else {
        if (!context.mounted)
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: const Text("Pemilihan gambar gagal")));
      }
      return urlGambar;
    } catch (e) {
      print(e);
      return "";
    }
  }

  Future<bool> buatRTDB({
    required String judul,
    required int totalPembayaran,
    required String namaBank,
    required String nomorVA,
    required String idOrder,
    required String idSurvei,
  }) async {
    try {
      final userId = SharedPrefs.getString(prefUserId) ?? "";
      String request = """
mutation Mutation(\$trans: inputTrans!) {
  bikinTrans(trans: \$trans) {
    code,data,status
  }
}
      """;
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: request, mapVariable: {
        "trans": {
          "judul": judul,
          "idOrder": idOrder,
          "idSurvei": idSurvei,
          "idUser": userId,
          "namaBank": namaBank,
          "nomorVA": nomorVA,
          "totalPembayaran": totalPembayaran
        }
      });
      if (data!['bikinTrans']['code'] == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<ResponMidtrans?> buatMidTrans({
    required String idTrans,
    required int jumlahPembayaran,
  }) async {
    try {
      String request = """
mutation Mutation(\$idTrans: String!, \$jumlahPembayaran: Int!) {
  cobaMid(idTrans: \$idTrans, jumlahPembayaran: \$jumlahPembayaran) {
    code,status,nomorVA,bank,idOrder
  }
}
      """;
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: request, mapVariable: {
        'idTrans': idTrans,
        'jumlahPembayaran': jumlahPembayaran,
      });
      log("Ini data midtrasn => $data");
      if (data!['cobaMid']['code'] == 200) {
        ResponMidtrans temp = ResponMidtrans(
            bank: data['cobaMid']['bank'],
            nomorVA: data['cobaMid']['nomorVA'],
            idOrder: data['cobaMid']['idOrder']);
        return temp;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

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

//   Future<Map<String, dynamic>> getDataForm(String idForm, String tipe) async {
//     //ambil IdForm, judulnya dan jumlah soalnya
//     try {
//       String request = """
// query Query(\$idForm: String!, \$tipe: String!) {
//   getPublishData(idForm: \$idForm, tipe: \$tipe) {
//     code,judul,status
//     jumlahSoal
//     tipe
//   }
// }
//     """;

//       final variables = {
//         'idForm': idForm,
//         'tipe': tipe,
//       };
//       Map<String, dynamic>? data = await Backend()
//           .serverConnection(query: request, mapVariable: variables);

//       print("ini data- >" + data.toString());

//       if (data!['getPublishData']['code'] == 200) {
//         return {
//           'judul': data['getPublishData']['judul'],
//           'jumlahSoal': data['getPublishData']['jumlahSoal'],
//           'tipe': data['getPublishData']['jumlahSoal'] as int,
//         };
//       } else {
//         return {
//           'judul': "",
//         };
//       }
//     } catch (e) {
//       print(e);
//       return {
//         'judul': "",
//       };
//     }
//   }

  Future<String> getDataForm(String idForm, String tipe) async {
    //ambil IdForm, judulnya dan jumlah soalnya
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

  Future<Map<String, int>> getHargaReward() async {
    try {
      String request = """ 
        query GetReward {
  getReward {
    biaya
    code
    insentif
    message
    special
  }
}
    """;
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: request, mapVariable: {});

      if (data!['getReward']['code'] == 200) {
        return {
          'hargapPerSurvei': data['getReward']['biaya'],
          'insentifPerPartisipan': data['getReward']['insentif'],
          'hargaSpecial': data['getReward']['special'],
        };
      } else {
        return {
          'hargapPerSurvei': 0,
          'insentifPerPartisipan': 0,
          'hargaSpecial': 0,
        };
      }
    } catch (e) {
      print(e);
      return {
        'hargapPerSurvei': 0,
        'insentifPerPartisipan': 0,
        'hargaSpecial': 0,
      };
    }
  }

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
        "idUser": SharedPrefs.getString(prefUserId) ?? "70fc9a56",
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
        "idUser": SharedPrefs.getString(prefUserId) ?? "70fc9a56",
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
          query: request,
          mapVariable: {
            "idUser": SharedPrefs.getString(prefUserId) ?? "70fc9a56"
          });

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

  Future<bool> publishSurveiMidtrans({
    required String idForm,
    required String judul,
    required String deskripsi,
    required String kategori,
    required String emailUser,
    required int durasi,
    required int batasPartisipan,
    required int harga,
    required bool isKlasik,
    required bool pakaiDemografi,
    required DSurveiInput dSurvei,
    required String idSurvei,
    //url gambar walaupun masuk dSurvei tp dikasih masuk tanpa DsurveiInput
    required String urlGambar,
  }) async {
    try {
      String query = """
mutation Mutation(\$survei: AddSurveiInput!, \$idForm: String!, \$idUser: String!, \$idSurvei: String, \$dSurvei: dSurveiInput) {
  publishSurveiMidtrans(survei: \$survei, idForm: \$idForm, idUser: \$idUser, idSurvei: \$idSurvei, dSurvei: \$dSurvei) {
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
          'emailUser': emailUser,
        },
        "idForm": idForm,
        'idUser': SharedPrefs.getString(prefUserId) ?? "70fc9a56",
        'dSurvei': {
          'hargaPerPartisipan': dSurvei.hargaPerPartisipan,
          'insentifPerPartisipan': dSurvei.insentifPerPartisipan,
          'demografiUsia': dSurvei.demografiUsia,
          'demografiLokasi': dSurvei.demografiLokasi,
          'demografiInterest': dSurvei.DemografiInterest,
          'batasPartisipan': dSurvei.batasPartisipan,
          'diJual': dSurvei.diJual,
          'hargaJual': dSurvei.hargaJual,
          'urlGambar': urlGambar,
        },
        "idSurvei": idSurvei,
      };
      print("mau kirim data ke server");
      final data = await Backend()
          .serverConnection(query: query, mapVariable: variables);
      print(data);
      if (data!['publishSurveiMidtrans']['code'] == 200) {
        //print(data['publishSurveiBaru']['data']);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> publishSurvei({
    required String idForm,
    required String judul,
    required String deskripsi,
    required String kategori,
    required String emailUser,
    required int durasi,
    required int batasPartisipan,
    required int harga,
    required bool isKlasik,
    required bool pakaiDemografi,
    required DSurveiInput dSurvei,
    //url gambar walaupun masuk dSurvei tp dikasih masuk tanpa DsurveiInput
    required String urlGambar,
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
          'emailUser': emailUser,
        },
        "idForm": idForm,
        'idUser': SharedPrefs.getString(prefUserId) ?? "70fc9a56",
        'dSurvei': {
          'hargaPerPartisipan': dSurvei.hargaPerPartisipan,
          'insentifPerPartisipan': dSurvei.insentifPerPartisipan,
          'demografiUsia': dSurvei.demografiUsia,
          'demografiLokasi': dSurvei.demografiLokasi,
          'demografiInterest': dSurvei.DemografiInterest,
          'batasPartisipan': dSurvei.batasPartisipan,
          'diJual': dSurvei.diJual,
          'hargaJual': dSurvei.hargaJual,
          'urlGambar': urlGambar,
        }
      };
      print("mau kirim data ke server");
      final data = await Backend()
          .serverConnection(query: query, mapVariable: variables);
      print(data);
      if (data!['publishSurveiBaru']['code'] == 200) {
        //print(data['publishSurveiBaru']['data']);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<SurveiData>> getSurveiKuV2() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? idUser = SharedPrefs.getString(prefUserId) ?? "70fc9a56";
      String query = """
          query GetSurveiByUser(\$idUser: String!) {
  getSurveiByUser(idUser: \$idUser) {
    code,status,data {
      batasPartisipan,deskripsi,harga,id_survei,judul,jumlahPartisipan,kategori,status,tanggal_penerbitan,tipe,waktu,idUser,gambarSurvei
    }
  }
}
    """;
      final data = await Backend()
          .serverConnection(query: query, mapVariable: {"idUser": idUser});
      if (data!['getSurveiByUser']['code'] == 200) {
        List<Object?> dataSurvei = data["getSurveiByUser"]["data"];
        List<SurveiData> list = List.generate(dataSurvei.length,
            (index) => SurveiData.fromJson(json.encode(dataSurvei[index])));
        return list;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<SurveiX?> getSurveiData(String idSurvei) async {
    try {
      String query = """
query Query(\$idSurvei: String!) {
  getSurveiDetail(idSurvei: \$idSurvei) {
    code,status,hSurvei {
      batasPartisipan,deskripsi,harga,id_survei,judul,jumlahPartisipan,kategori,status,tanggal_penerbitan,
      isKlasik,durasi,idUser,batasPartisipan,demografiInterest,demografiLokasi,demografiUsia,hargaPerPartisipan,insentifPerPartisipan,diJual,hargaJual,idForm,gambarSurvei
    }
  }
}
    """;

      final data = await Backend()
          .serverConnection(query: query, mapVariable: {"idSurvei": idSurvei});
      if (data!['getSurveiDetail']['code'] == 200) {
        Object? dataSurvei = data["getSurveiDetail"]["hSurvei"];
        SurveiData Hsurvei = SurveiData.fromJson(json.encode(dataSurvei));
        //
        print("sudah proses Hsurvei");
        Object? dataDSurvei = data["getSurveiDetail"]["hSurvei"];
        // print(dataDSurvei);
        DetailSurvei dSurvei = DetailSurvei.fromJson(json.encode(dataDSurvei));
        SurveiX dataSurveiLengkap =
            SurveiX(detailSurvei: dSurvei, headerSurvei: Hsurvei);
        return dataSurveiLengkap;
        // return null;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<int> hitungJumlahSoalKartu(String idForm) async {
    try {
      Map<String, dynamic> dataFormJson = {};
      final surveiRef =
          FirebaseFirestore.instance.collection('form-kartu').doc(idForm);
      await surveiRef.get().then((value) {
        dataFormJson = value.data()!;
      }).onError((error, stackTrace) {
        log(error.toString());
      });
      return dataFormJson['daftarSoal'].length;
    } catch (e) {
      log(e.toString());
      return 0;
    }
  }

  Future<int> hitungJumlahSoalKlasik(String idForm) async {
    try {
      Map<String, dynamic> dataFormJson = {};
      final surveiRef =
          FirebaseFirestore.instance.collection('form-klasik').doc(idForm);
      await surveiRef.get().then((value) {
        dataFormJson = value.data()!;
      }).onError((error, stackTrace) {
        log(error.toString());
      });
      int acc = 0;
      for (Map<String, dynamic> map in dataFormJson['daftarSoal']) {
        if (map['isPembatas'] == null) {
          acc++;
        }
      }
      return acc;
    } catch (e) {
      log(e.toString());
      return 0;
    }
  }
}
