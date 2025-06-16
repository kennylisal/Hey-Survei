import 'package:aplikasi_admin/utils/backend.dart';
import 'package:flutter/material.dart';

class RewardController {
  Future<void> perbaruiHarga(BuildContext context, int hargapPerSurvei,
      int hargaInsentif, int hargaSpecial) async {
    try {
      String query = """ 
mutation Mutation(\$insentif: Int!, \$hargaSurvei: Int!, \$special: Int!) {
updateReward(insentif: \$insentif, hargaSurvei: \$hargaSurvei, special: \$special) {
  code,data,status
}
}
  """;
      Map<String, dynamic> map = {
        "insentif": hargaInsentif,
        'hargaSurvei': hargapPerSurvei,
        'special': hargaSpecial,
      };
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: query, mapVariable: map);
      if (!context.mounted) return;
      if (data!['updateReward']['code'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Reward berhasil diperbarui")));
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

  Future<Map<String, int>?> getHargaReward(BuildContext context) async {
    try {
      String query = """ 
        query GetReward {
          getReward {
          biaya,code,insentif,message,special
          }
        }
    """;
      Map<String, dynamic> map = {};
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: query, mapVariable: map);
      //print(data);
      if (!context.mounted) return null;

      if (data!['getReward']['code'] == 200) {
        print(data);
        return {
          'hargapPerSurvei': data['getReward']['biaya'],
          'hargaPerPartisipan': data['getReward']['insentif'],
          'hargaSpecial': data['getReward']['special'],
        };
      } else {
        return {
          'hargapPerSurvei': 0,
          'hargaPerPartisipan': 0,
          'hargaSpecial': 0,
        };
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Terjadi Kesalahan Program")));
      return {
        'hargapPerSurvei': 0,
        'hargaPerPartisipan': 0,
        'hargaSpecial': 0,
      };
    }
  }
}
