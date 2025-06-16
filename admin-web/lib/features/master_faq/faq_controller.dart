import 'dart:convert';

import 'package:aplikasi_admin/utils/backend.dart';
import 'package:aplikasi_admin/features/master_faq/faq.dart';
import 'package:flutter/material.dart';

class FAQController {
  Future<void> updateFAQ(BuildContext context, String pertanyaan,
      String jawaban, String id) async {
    try {
      String query = """ 
    mutation UpdateFAQ(\$idFaq: String!, \$pertanyaan: String!, \$jawaban: String!) {
      updateFAQ(idFAQ: \$idFaq, pertanyaan: \$pertanyaan, jawaban: \$jawaban) {
        code,data,status
      }
    }
  """;
      Map<String, dynamic> map = {
        "idFaq": id,
        "pertanyaan": pertanyaan,
        "jawaban": jawaban,
      };
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: query, mapVariable: map);

      if (!context.mounted) return;
      if (data!['updateFAQ']['code'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("FAQ berhasil diUpdate")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Terjadi Kesalahan Server")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Terjadi Kesalahan Program")));
    }
  }

  Future<bool> buatFAQ(
    BuildContext context,
    String id,
    String pertanyaan,
    String jawaban,
  ) async {
    try {
      String query = """ 
mutation BuatFAQ(\$idFaq: String!, \$pertanyaan: String!, \$jawaban: String!) {
  buatFAQ(idFAQ: \$idFaq, pertanyaan: \$pertanyaan, jawaban: \$jawaban) {
  code,data,status  
  }
}
    """;
      Map<String, dynamic> map = {
        "pertanyaan": pertanyaan,
        "jawaban": jawaban,
        'idFaq': id,
      };

      Map<String, dynamic>? data =
          await Backend().serverConnection(query: query, mapVariable: map);

      if (!context.mounted) return false;
      if (data!['buatFAQ']['code'] == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("FAQ berhasil dibuat")));
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

  Future<bool> hapusFAQ(BuildContext context, String id) async {
    try {
      String query = """ 
        mutation HapusFAQ(\$idFaq: String!) {
          hapusFAQ(idFAQ: \$idFaq) {
          code,data,status  
          }
        }
    """;
      Map<String, dynamic> map = {
        "idFaq": id,
      };

      Map<String, dynamic>? data =
          await Backend().serverConnection(query: query, mapVariable: map);

      if (!context.mounted) return false;
      if (data!['hapusFAQ']['code'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("FAQ berhasil dihapus")));
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

  Future<List<FAQ>> getFAQ() async {
    try {
      String query = """ 
        query GetFAQ {
          getFAQ {
          code,data {
            id,jawaban,pertanyaan
          },status
          }
        }
    """;
      Map<String, dynamic> map = {};
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: query, mapVariable: map);
      if (data!['getFAQ']['code'] == 200) {
        List<Object?> dataFAQ = data["getFAQ"]["data"];
        List<FAQ> temp = List.generate(dataFAQ.length,
            (index) => FAQ.fromJson(json.encode(dataFAQ[index])));
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
  //procedurenya terima dan proses apakah berhasil atau tidak baru kembalikan data yg diperlukan
}
