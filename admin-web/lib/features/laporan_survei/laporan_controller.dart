import 'dart:convert';

import 'package:aplikasi_admin/features/laporan_survei/models/order.dart';
import 'package:aplikasi_admin/features/master_survei/survei.dart';
import 'package:aplikasi_admin/utils/backend.dart';
import 'package:flutter/material.dart';

class ReportController {
  Future<List<SurveiData>> getSurveiReport(
      BuildContext context, int tglAwal, int tglAkhir) async {
    try {
      String query = """ 
query CobaTanggal(\$tglAwal: Int!, \$tglAkhir: Int!) {
  getLaporanSurvei(tglAwal: \$tglAwal, tglAkhir: \$tglAkhir) {
        code,status,data {
      batasPartisipan,deskripsi,durasi,hargaJual,id_survei,isKlasik,judul,jumlahPartisipan,kategori,status,tanggal_penerbitan,emailUser,harga
    }
  }
}
    """;
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: query, mapVariable: {
        'tglAwal': tglAwal,
        'tglAkhir': tglAkhir,
      });
      // print(data);
      if (data!['getLaporanSurvei']['code'] == 200) {
        List<Object?> dataSurvei = data["getLaporanSurvei"]["data"];
        print("ini jumlah data yg didapat" + dataSurvei.length.toString());
        List<SurveiData> temp = List.generate(dataSurvei.length,
            (index) => SurveiData.fromJson(json.encode(dataSurvei[index])));
        // print("ini temp $temp");
        return temp;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Order>> getOrderReport(
      BuildContext context, int tglAwal, int tglAkhir) async {
    try {
      String query = """ 
query CobaTanggal(\$tglAwal: Int!, \$tglAkhir: Int!) {
  getOrderLaporan(tglAwal: \$tglAwal, tglAkhir: \$tglAkhir) {
    code,status,data {
      emailUser,hargaTotal,idOrder,tanggal,presentasi
    }
  }
}
    """;
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: query, mapVariable: {
        'tglAwal': tglAwal,
        'tglAkhir': tglAkhir,
      });
      print("ini tgl awal" + tglAwal.toString());
      print("ini tgl awal" + tglAkhir.toString());
      print(data);
      if (data!['getOrderLaporan']['code'] == 200) {
        List<Object?> dataTemp = data["getOrderLaporan"]["data"];
        List<Order> dataOrder = List.generate(dataTemp.length,
            (index) => Order.fromJson(json.encode(dataTemp[index])));
        return dataOrder;
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString() + "Aysdkfsgdkfg");
      return [];
    }
  }
}
