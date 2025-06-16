// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hei_survei/constants.dart';
import 'package:hei_survei/utils/backend.dart';
import 'package:hei_survei/features/katalog/model/survei_data.dart';

import 'package:hei_survei/utils/shared_pref.dart';

class SurveikuController {
  Future<SurveikuData?> getSurveiAktif() async {
    try {
      String query = """
query GetSurveiKu(\$idUser: String!) {
  getSurveikuUtama(idUser: \$idUser) {
    code,status,survei {
       batasPartisipan,deskripsi,harga,id_survei,judul,jumlahPartisipan,kategori,status,tanggal_penerbitan,isKlasik,durasi,idUser,hargaJual,gambarSurvei
    }
  }
}
    """;
      print('ini idUser -> ${SharedPrefs.getString(prefUserId) ?? ""}');
      final data = await Backend().serverConnection(query: query, mapVariable: {
        "idUser": SharedPrefs.getString(prefUserId) ?? "70fc9a56",
      });
      if (data!['getSurveikuUtama']['code'] == 200) {
        //ini terbitan
        List<Object?> listSurvei = data['getSurveikuUtama']['survei'];
        print(listSurvei);
        List<SurveiData> surveiku = List.generate(listSurvei.length,
            (index) => SurveiData.fromJson(json.encode(listSurvei[index])));

        return SurveikuData(listSurvei: surveiku, listBeli: []);
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

  Future<SurveikuData?> getSurveiKu() async {
    try {
      String query = """
query GetSurveiKu(\$idUser: String!) {
  getSurveikuUtama(idUser: \$idUser) {
    code,status,survei {
       batasPartisipan,deskripsi,harga,id_survei,judul,jumlahPartisipan,kategori,status,tanggal_penerbitan,isKlasik,durasi,idUser,hargaJual,gambarSurvei
    },beli {
       batasPartisipan,deskripsi,harga,id_survei,judul,jumlahPartisipan,kategori,status,tanggal_penerbitan,isKlasik,durasi,idUser,hargaJual,gambarSurvei
    }
  }
}
    """;
      print('ini idUser -> ${SharedPrefs.getString(prefUserId) ?? ""}');
      final data = await Backend().serverConnection(query: query, mapVariable: {
        "idUser": SharedPrefs.getString(prefUserId) ?? "70fc9a56",
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
}

class SurveikuData {
  List<SurveiData> listSurvei;
  List<SurveiData> listBeli;
  SurveikuData({
    required this.listSurvei,
    required this.listBeli,
  });

  @override
  String toString() =>
      'SurveikuData(listSurvei: $listSurvei, listBeli: $listBeli)';
}
