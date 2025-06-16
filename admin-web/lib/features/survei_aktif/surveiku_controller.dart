import 'dart:convert';

import 'package:aplikasi_admin/constants.dart';
import 'package:aplikasi_admin/features/survei/models/survei_data.dart';
import 'package:aplikasi_admin/features/survei_aktif/models/data_detail_survei.dart';
import 'package:aplikasi_admin/features/survei_aktif/models/surveiku.dart';
import 'package:aplikasi_admin/utils/backend.dart';

class SurveikuController {
  Future<SurveikuData?> getSurveiKu() async {
    try {
      String query = """
query GetSurveiKu(\$idUser: String!) {
  getSurveikuUtama(idUser: \$idUser) {
    code,status,survei {
       batasPartisipan,deskripsi,harga,id_survei,judul,jumlahPartisipan,kategori,status,tanggal_penerbitan,isKlasik,durasi,idUser
    },beli {
       batasPartisipan,deskripsi,harga,id_survei,judul,jumlahPartisipan,kategori,status,tanggal_penerbitan,isKlasik,durasi,idUser
    }
  }
}
    """;

      final data = await Backend().serverConnection(query: query, mapVariable: {
        "idUser": idUserAdmin,
      });
      if (data!['getSurveikuUtama']['code'] == 200) {
        //ini terbitan
        List<Object?> listSurvei = data['getSurveikuUtama']['survei'];
        print(listSurvei);
        List<SurveiData> surveiku = List.generate(listSurvei.length,
            (index) => SurveiData.fromJson(json.encode(listSurvei[index])));

        //ini belanjaan
        List<Object?> listBeli = data['getSurveikuUtama']['beli'];
        List<SurveiData> belianku = List.generate(
            listBeli.length,
            (index) => SurveiData.fromJson(json.encode(listBeli[index]),
                isTerbitan: false));
        print(belianku);
        return SurveikuData(listSurvei: surveiku, listBeli: belianku);
      } else {
        return SurveikuData(
          listSurvei: [],
          listBeli: [],
        );
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<SurveiX?> getSurveiData(String idSurvei) async {
    try {
      String query = """
query Query(\$idSurvei: String!) {
  getSurveiDetail(idSurvei: \$idSurvei) {
    code,status,hSurvei {
      batasPartisipan,deskripsi,harga,id_survei,judul,jumlahPartisipan,kategori,status,tanggal_penerbitan,isKlasik,durasi,idUser,batasPartisipan,demografiInterest,demografiLokasi,demografiUsia,hargaPerPartisipan,insentifPerPartisipan,diJual,hargaJual,idForm
    }
  }
}
    """;

      final data = await Backend()
          .serverConnection(query: query, mapVariable: {"idSurvei": idSurvei});
      if (data!['getSurveiDetail']['code'] == 200) {
        Object? dataSurvei = data["getSurveiDetail"]["hSurvei"];
        SurveiData hSurvei = SurveiData.fromJson(json.encode(dataSurvei));
        //
        Object? dataDSurvei = data["getSurveiDetail"]["hSurvei"];
        // print(dataDSurvei);
        DetailSurvei dSurvei = DetailSurvei.fromJson(json.encode(dataDSurvei));
        SurveiX dataSurveiLengkap =
            SurveiX(detailSurvei: dSurvei, headerSurvei: hSurvei);
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
}
