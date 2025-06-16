import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:survei_aplikasi/constants.dart';
import 'package:survei_aplikasi/features/profile/data_sejarah.dart';
import 'package:survei_aplikasi/features/profile/user_data.dart';

import 'package:survei_aplikasi/utils/graphql_db.dart';
import 'package:survei_aplikasi/utils/shared_pref.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProfileController {
  Future<bool> bisaUpdateDemo() async {
    try {
      String request = """
query Query {
  demografiBisaUpdate {
    code,pesan,status
  }
}
      """;
      Map<String, dynamic>? data = await BackendConnection()
          .serverConnection(query: request, mapVariable: {});
      if (data!['demografiBisaUpdate']['code'] == 200) {
        final hasil = data['demografiBisaUpdate']['pesan'] as String;
        return (hasil == "true");
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<String> pengajuanPencairan({
    required String email,
    required int jumlah,
  }) async {
    try {
      final idUser = SharedPrefs.getString(prefUserid) ?? "8c6639a";
      String request = """
mutation Mutation(\$jumlah: Int!, \$idUser: String!, \$email: String!) {
  ajukanPencairan(jumlah: \$jumlah, idUser: \$idUser, email: \$email) {
    code,pesan,status
  }
}
      """;
      Map<String, dynamic>? data = await BackendConnection().serverConnection(
          query: request,
          mapVariable: {"idUser": idUser, "jumlah": jumlah, "email": email});
      if (data!['ajukanPencairan']['code'] == 200) {
        return data['ajukanPencairan']['pesan'] as String;
      } else {
        return data['ajukanPencairan']['pesan'] as String;
      }
    } catch (e) {
      print(e);
      return "Terjadi Erorr";
    }
  }

  Future<List<DataSejarah>> getAllSejarah() async {
    try {
      String request = """
query GetAllHistory(\$idUser: String!) {
  getAllHistory(idUser: \$idUser) {
    code,status,data {
      deskripsi,insentif,isKlasik,judul,tglPengisian,gambarSurvei,id_survei
    }
  }
}
      """;
      final idUser = SharedPrefs.getString(prefUserid) ?? "8c6639a";
      Map<String, dynamic>? data = await BackendConnection()
          .serverConnection(query: request, mapVariable: {
        "idUser": idUser,
      });
      print(data);
      if (data!['getAllHistory']['code'] == 200) {
        List<Object?> result = data['getAllHistory']['data'];
        final hasil = List.generate(result.length,
            (index) => DataSejarah.fromJson(json.encode(result[index])));
        return hasil;
      } else {
        return [];
      }
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<bool> kirimOTP(String noHP) async {
    try {
      final idUser = SharedPrefs.getString(prefUserid);
      String request = """
mutation Mutation(\$noHp: String!, \$idUser: String) {
  kirimSmsAuth(noHP: \$noHp, idUser: \$idUser) {
    code,pesan,status
  }
}
      """;
      Map<String, dynamic>? data = await BackendConnection()
          .serverConnection(query: request, mapVariable: {
        "idUser": idUser,
        "noHp": noHP,
      });
      print(data);
      if (data!['kirimSmsAuth']['code'] == 200) {
        return true;
      } else {
        print(data['kirimSmsAuth']['pesan']);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> cekNoHp(String noHp) async {
    try {
      String request = """
query Query(\$noHp: String!) {
  cekNoHp(noHP: \$noHp) {
    code,pesan,status
  }
}
      """;
      Map<String, dynamic>? data = await BackendConnection()
          .serverConnection(query: request, mapVariable: {
        "noHp": noHp,
      });
      print(data);
      if (data!['cekNoHp']['code'] == 200) {
        return true;
      } else {
        print(data['cekNoHp']['pesan']);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> autentikasiOTP(String kode) async {
    try {
      final idUser = SharedPrefs.getString(prefUserid);
      String request = """
mutation Mutation(\$kode: String!, \$idUser: String!) {
  autentikasiKodeSms(kode: \$kode, idUser: \$idUser) {
    code,pesan,status
  }
}
      """;
      Map<String, dynamic>? data = await BackendConnection()
          .serverConnection(query: request, mapVariable: {
        "idUser": idUser,
        "kode": kode,
      });
      print(data);
      if (data!['autentikasiKodeSms']['code'] == 200) {
        return true;
      } else {
        print(data['autentikasiKodeSms']['pesan']);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
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
      Map<String, dynamic>? data = await BackendConnection()
          .serverConnection(query: request, mapVariable: {});
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
      Map<String, dynamic>? data = await BackendConnection()
          .serverConnection(query: request, mapVariable: {});
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

  Future<File?> pilihGambar(BuildContext context) async {
    try {
      final file = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (file != null) {
        final path = file.path;
        File imageFile = File(path);
        final bytes = await imageFile.readAsBytes();
        print("ini besar file ${bytes.length}");
        if (bytes.length < 2300000) {
          return imageFile;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Besar file gambar maksimal 2,3MB")));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Belum ada gambar yg dipilih")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Belum ada gambar yg dipilih")));
      return null;
    }
  }

  Future<String> uploadGambar(File imageFile) async {
    String imageUrl = "";
    try {
      String namaBaru = Uuid().v4().substring(0, 11);
      firebase_storage.UploadTask uploadTask;

      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('eksp')
          .child('/' + namaBaru);

      final metaData =
          firebase_storage.SettableMetadata(contentType: 'image/jpeg');

      uploadTask = ref.putFile(imageFile, metaData);
      // uploadTask = ref.putFile(imageFile);

      await uploadTask.whenComplete(() {
        print("berhasil upload $namaBaru");
      });
      imageUrl = await ref.getDownloadURL();
      print('uploaded image URL : $imageUrl');
      return imageUrl;
    } catch (e) {
      print(e);
      return imageUrl;
    }
  }

  // Future<Uint8List?> pilihGambar(BuildContext context) async {
  //   Uint8List? selectedImageBytes;
  //   final file = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (file != null) {
  //     final path = file.path;
  //     //ini uint8
  //     final bytes = await File(path).readAsBytes();
  //     //
  //     if (bytes.length > 1000001) {
  //       selectedImageBytes =
  //           await FlutterImageCompress.compressWithList(bytes, quality: 90);
  //     } else {
  //       selectedImageBytes = bytes;
  //     }
  //     print("file gambar telah terpilih---------");
  //     return selectedImageBytes;
  //   } else {
  //     if (!context.mounted) return null;
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text("Belum ada gambar yg dipilih")));
  //     return null;
  //   }
  // }

  // Future<String> uploadGambar(Uint8List selectedImageBytes) async {
  //   try {
  //     print("----------masuk proses uploa gambar");
  //     String namaBaru = Uuid().v4().substring(0, 11);
  //     firebase_storage.UploadTask uploadTask;

  //     firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
  //         .ref()
  //         .child(namaFolderFotoProfile)
  //         .child('/' + namaBaru);

  //     final metaData =
  //         firebase_storage.SettableMetadata(contentType: 'image/jpeg');

  //     uploadTask = ref.putData(selectedImageBytes, metaData);

  //     await uploadTask.whenComplete(() => null);
  //     String imageUrl = "";
  //     imageUrl = await ref.getDownloadURL();
  //     print('uploaded image URL : $imageUrl');

  //     return imageUrl;
  //     // return "";
  //   } catch (e) {
  //     print(e);
  //     return "";
  //   }
  // }

  Future<String> gantiFoto(BuildContext context) async {
    try {
      final idUser = SharedPrefs.getString(prefUserid);
      File? selectedImageBytes = await pilihGambar(context);
      String urlBaru = "";

      if (selectedImageBytes != null) {
        print("Masuk proses mau upload gambar ----------------");
        urlBaru = await uploadGambar(selectedImageBytes);
      }

      if (urlBaru != "") {
        String request = """
mutation Mutation(\$urlFoto: String!, \$idUser: String!) {
  updateFoto(urlFoto: \$urlFoto, idUser: \$idUser) {
    code,pesan,status
  }
}
      """;
        Map<String, dynamic>? data = await BackendConnection()
            .serverConnection(query: request, mapVariable: {
          'idUser': idUser,
          'urlFoto': urlBaru,
        });
        if (data!['updateFoto']['code'] == 200) {
          return urlBaru;
        } else {
          print(data['updateFoto']['pesan'] as String);
          return "";
        }
      } else {
        return "";
      }
    } catch (e) {
      print(e);
      return "";
    }
  }

  Future<UserData?> getUserData() async {
    try {
      final idUser = SharedPrefs.getString(prefUserid) ?? '8c6639a';
      String request = """
query GetDataUser(\$idUser: String!) {
  getDataUser(idUser: \$idUser) {
    code,pesan,data {
      email,interest,kota,poin,url_gambar,waktu_pendaftaran,isAuthenticated,tglLahir
    }
  }
}
      """;
      Map<String, dynamic>? data = await BackendConnection()
          .serverConnection(query: request, mapVariable: {
        'idUser': idUser,
      });
      // print("ini data profile wehh $data");
      //print(data);
      if (data![getDataUser]['code'] == 200) {
        Object? result = data[getDataUser]['data'];
        UserData hasil = UserData.fromJson(json.encode(result));
        return hasil;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> gantiPassword(
      String passLama, String passBaru, BuildContext context) async {
    try {
      final idUser = SharedPrefs.getString(prefUserid) ?? '8c6639a';
      String request = """
mutation UpdateDemo(\$password: String!, \$idUser: String!, \$passwordLama: String!) {
  updatePassword(password: \$password, idUser: \$idUser, passwordLama: \$passwordLama) {
    code,pesan,status
  }
}
      """;
      print("ini id user $idUser");
      print("ini pass lama $passLama");
      print("ini pass lama $passBaru");
      Map<String, dynamic>? data = await BackendConnection()
          .serverConnection(query: request, mapVariable: {
        "idUser": idUser,
        "password": passBaru,
        "passwordLama": passLama,
      });
      print(data);
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data!['updatePassword']['pesan'] as String)));
      if (data['updatePassword']['code'] == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> udpateDemo(
      int tanggal, String kota, List<String> interest) async {
    try {
      final idUser = SharedPrefs.getString(prefUserid) ?? '8c6639a';
      String request = """
mutation UpdateDemo(\$kota: String!, \$tgl: Int!, \$interest: [String]!, \$idUser: String!) {
  updateDemo(kota: \$kota, tgl: \$tgl, interest: \$interest, idUser: \$idUser) {
    code,pesan,status
  }
}
      """;
      Map<String, dynamic>? data = await BackendConnection()
          .serverConnection(query: request, mapVariable: {
        "idUser": idUser,
        "kota": kota,
        "tgl": tanggal / 1000,
        "interest": interest,
      });

      print("ini data $data");
      if (data!['updateDemo']['code'] == 200) {
        return true;
      } else {
        print(data['updateDemo']['pesan'] as String);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
