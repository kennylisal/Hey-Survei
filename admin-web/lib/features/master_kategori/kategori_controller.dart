import 'dart:convert';

import 'package:aplikasi_admin/utils/backend.dart';
import 'package:aplikasi_admin/features/master_kategori/kategori.dart';
import 'package:flutter/material.dart';

class KategoriController {
  void updateKategori(BuildContext context, String id, String nama) async {
    try {
      String query = """ 
      mutation UpdateKategori(\$idKategori: String!, \$nama: String!) {
        updateKategori(idKategori: \$idKategori, nama: \$nama) {
        code,data,status  
        }
      }
    """;
      Map<String, dynamic> map = {
        "idKategori": id,
        "nama": nama,
      };

      Map<String, dynamic>? data =
          await Backend().serverConnection(query: query, mapVariable: map);

      if (!context.mounted) return;
      if (data!['updateKategori']['code'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Kategori berhasil diUpdate")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Terjadi Kesalahan Server")));
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Terjadi Kesalahan Program")));
    }
  }

  Future<bool> hapusKategori(
    BuildContext context,
    String id,
  ) async {
    try {
      String query = """ 
      mutation HapusKategori(\$idKategori: String!) {
        hapusKategori(idKategori: \$idKategori) {
        code,data,status  
        }
      }
    """;
      Map<String, dynamic> map = {
        "idKategori": id,
      };
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: query, mapVariable: map);

      if (!context.mounted) return false;
      if (data!['hapusKategori']['code'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Kategori berhasil dihapus")));
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Terjadi Kesalahan Server")));
        return false;
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Terjadi Kesalahan Program")));
      return false;
    }
  }

  void buatKategori(BuildContext context, String nama, String id) async {
    try {
      String query = """ 
mutation BuatFAQ(\$nama: String!, \$idKategori: String!) {
  buatKategori(nama: \$nama, idKategori: \$idKategori) {
    code,data,status
  }
}
    """;
      Map<String, dynamic> map = {"nama": nama, "idKategori": id};
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: query, mapVariable: map);

      if (!context.mounted) return;
      if (data!['buatKategori']['code'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Kategori berhasil dibuat")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Terjadi Kesalahan Server")));
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Terjadi Kesalahan Program")));
    }
  }

  Future<List<Kategori>> getKategori() async {
    try {
      String query = """ 
        query Query {
          getAllKategori {
          code,message,data {
            id,nama
          }  
          }
        }
    """;
      Map<String, dynamic> map = {};
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: query, mapVariable: map);

      if (data!['getAllKategori']['code'] == 200) {
        List<Object?> dataKategori = data['getAllKategori']['data'];
        List<Kategori> temp = List.generate(dataKategori.length,
            (index) => Kategori.fromJson(json.encode(dataKategori[index])));
        print(temp);
        return temp;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}
