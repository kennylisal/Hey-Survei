// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hei_survei/features/profile/models/sejarah_pembelian.dart';
import 'package:hei_survei/features/profile/models/sejarah_penambahan.dart';
import 'package:hei_survei/features/profile/models/sejarah_pencairan.dart';
import 'package:hei_survei/features/profile/user_data.dart';
import 'package:hei_survei/utils/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hei_survei/utils/backend.dart';
import 'package:hei_survei/constants.dart';

class ProfileController {
  Future<List<SejarahPenambahanPoin>> getUserSPP() async {
    try {
      final idUser = SharedPrefs.getString(prefUserId) ?? "70fc9a56";
      // final idUser = "8e0eed6";
      String request = """
query Query(\$idUser: String!) {
  getSPP(idUser: \$idUser) {
    code,status,data {
      emailPembeli,idOrder,tambahPoin,tglPenambahan,survei {
            id_survei,hargaJual,tanggal_penerbitan,judul,kategori,idUser,deskripsi,durasi,jumlahPartisipan,batasPartisipan,isKlasik,status,gambarSurvei

      }
    }
  }
}
      """;
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: request, mapVariable: {
        "idUser": idUser,
      });
      if (data!['getSPP']['code'] == 200) {
        List<Object?> result = data['getSPP']['data'];
        final hasil = List.generate(
            result.length,
            (index) =>
                SejarahPenambahanPoin.fromJson(json.encode(result[index])));
        return hasil;
      } else {
        return [];
      }
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<String> pengajuanPencairan({
    required String email,
    required int jumlah,
  }) async {
    try {
      final idUser = SharedPrefs.getString(prefUserId) ?? "70fc9a56";
      String request = """
mutation Mutation(\$jumlah: Int!, \$idUser: String!, \$email: String!) {
  ajukanPencairan(jumlah: \$jumlah, idUser: \$idUser, email: \$email) {
    code,data,status
  }
}
      """;
      print("$idUser sdf $email sasd $jumlah");
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: request, mapVariable: {
        "idUser": idUser,
        "jumlah": jumlah,
        "email": email,
      });
      if (data!['ajukanPencairan']['code'] == 200) {
        return data['ajukanPencairan']['data'] as String;
      } else {
        return data['ajukanPencairan']['data'] as String;
      }
    } catch (e) {
      log(e.toString() + "sdfs;dfdf");
      return "Terjadi Erorr";
    }
  }

  Future<List<SejarahPencairan>?> getAllSejarah() async {
    try {
      String request = """
query Query(\$idUser: String!) {
  getSejarahPencairan(idUser: \$idUser) {
    code
    data {
      aktif,jumlahPoin,waktu_pengajuan
    }
  }
}
      """;
      final idUser = SharedPrefs.getString(prefUserId) ?? "70fc9a56";
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: request, mapVariable: {
        "idUser": idUser,
      });
      print(data);
      if (data!['getSejarahPencairan']['code'] == 200) {
        List<Object?> result = data['getSejarahPencairan']['data'];
        final hasil = List.generate(result.length,
            (index) => SejarahPencairan.fromJson(json.encode(result[index])));
        return hasil;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<SejarahPembelian>?> getAllSejaraPembelianh() async {
    try {
      String request = """
query Query(\$idUser: String!) {
  getSejarahPembelian(idUser: \$idUser) {
    code,status,data {
      emailPembeli,idSejarah,idUser,namaSurvei,pendapatan,tglPembelian
    }
  }
}
      """;
      final idUser = SharedPrefs.getString(prefUserId) ?? "70fc9a56";
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: request, mapVariable: {
        "idUser": idUser,
      });
      print(data);
      if (data!['getSejarahPembelian']['code'] == 200) {
        List<Object?> result = data['getSejarahPembelian']['data'];
        final hasil = List.generate(result.length,
            (index) => SejarahPembelian.fromJson(json.encode(result[index])));
        return hasil;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<UserData?> getUserData() async {
    try {
      String? idUser = SharedPrefs.getString(prefUserId) ?? "70fc9a56";
      String request = """
query Query(\$idUser: String!) {
  getUserData(idUser: \$idUser) {
    code
    status
    data {
      email
      idUser
      urlGambar
      poin,
      username
    }
  }
}
      """;
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: request, mapVariable: {
        "idUser": idUser,
      });
      if (data!['getUserData']['code'] == 200) {
        Object? dataUser = data['getUserData']['data'];
        UserData hasil = UserData.fromJson(json.encode(dataUser));
        return hasil;
      } else {
        print("Gagal ambil data");
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> gantiPassword({
    required String passwordLama,
    required String passwordBaru,
    required BuildContext context,
  }) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? idUser = SharedPrefs.getString(prefUserId) ?? "70fc9a56";
      String request = """
mutation Mutation(\$password: String!, \$idUser: String!, \$passwordLama: String!) {
  updatePassword(password: \$password, idUser: \$idUser, passwordLama: \$passwordLama) {
    code,data,status
  }
}
      """;
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: request, mapVariable: {
        'password': passwordBaru,
        'passwordLama': passwordLama,
        "idUser": idUser,
      });
      if (data!['updatePassword']['code'] == 200) {
        return true;
      } else {
        if (!context.mounted) return false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Terjadi Kesalahan Server")));
        // print(data['updatePassword']['data']);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> gantiUsername(String usernameBaru, BuildContext context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? idUser = SharedPrefs.getString(prefUserId) ?? "70fc9a56";
      String request = """
mutation Mutation(\$username: String!, \$idUser: String!) {
  updateUsername(username: \$username, idUser: \$idUser) {
    code,data,status
  }
}
      """;
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: request, mapVariable: {
        'username': usernameBaru,
        "idUser": idUser,
      });
      if (data!['updatePassword']['code'] == 200) {
        return true;
      } else {
        if (!context.mounted) return false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Terjadi Kesalahan Server")));
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> gantiFoto(String urlFoto, BuildContext context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? idUser = SharedPrefs.getString(prefUserId) ?? "70fc9a56";
      String request = """
mutation Mutation(\$urlFoto: String!, \$idUser: String!) {
  updateFoto(urlFoto: \$urlFoto, idUser: \$idUser) {
    code,data,status
  }
}
      """;
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: request, mapVariable: {
        'urlFoto': urlFoto,
        "idUser": idUser,
      });
      if (data!['updateFoto']['code'] == 200) {
        if (!context.mounted) return false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Berhasil Perbarui Gambar")));
        return true;
      } else {
        if (!context.mounted) return false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Terjadi Kesalahan Server")));
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
