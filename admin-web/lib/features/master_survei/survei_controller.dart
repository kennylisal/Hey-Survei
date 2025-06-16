import 'dart:convert';

import 'package:aplikasi_admin/utils/backend.dart';
import 'package:aplikasi_admin/features/master_survei/survei.dart';
import 'package:flutter/material.dart';

class MasterSurveiController {
  Future<List<SurveiData>> getAllSurvei(BuildContext context) async {
    try {
      String query = """ 
query GetAllSurveiReport {
  getAllSurveiReport {
    code,status,data {
      batasPartisipan,deskripsi,durasi,hargaJual,id_survei,isKlasik,judul,
      jumlahPartisipan,kategori,status,tanggal_penerbitan,emailUser,harga
    }
  }
}
    """;
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: query, mapVariable: {});
      if (data!['getAllSurveiReport']['code'] == 200) {
        List<Object?> dataFAQ = data["getAllSurveiReport"]["data"];
        List<SurveiData> temp = List.generate(dataFAQ.length,
            (index) => SurveiData.fromJson(json.encode(dataFAQ[index])));
        print("ini temp $temp");
        return temp;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<bool> setSurveiStatus(
      BuildContext context, String idSurvei, String status) async {
    try {
      String query = """ 
mutation Mutation(\$idSurvei: String!, \$status: String!) {
  setSurveiStatus(idSurvei: \$idSurvei, status: \$status) {
    code,data,status
  }
}
    """;
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: query, mapVariable: {
        "idSurvei": idSurvei,
        "status": status,
      });
      if (!context.mounted) return false;

      if (data!['setSurveiStatus']['code'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Status survei telah diUpdate")));
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Terjadi Kesalahan Server")));
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Terjadi Kesalahan Program")));
      return false;
    }
  }
}
