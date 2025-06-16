import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hei_survei/features/laporan/laporan_kartu/laporan_kartu_page_controller.dart';
import 'package:hei_survei/features/laporan/models/data_kumpulan_jawaban.dart';
import 'package:hei_survei/features/laporan/models/data_soal_lama.dart';
import 'package:hei_survei/features/laporan/models/jawaban_survei.dart';
import 'package:hei_survei/features/laporan/models/laporan_survei_kartu.dart';
import 'package:hei_survei/features/laporan/models/pertanyaan_survei.dart';
import 'package:hei_survei/features/laporan/state/data_kumpulan_jawaban.dart';
import 'package:hei_survei/utils/backend.dart';

class LaporanKartuServices {
  Future<DataLaporanSurveiKartu?> getDataLaporanKartu(
    String idSurvei,
    DataKumpulanJawabanController laporanUtama,
    DataKumpulanJawabanController laporanCabang,
    PageLaporanKartuController controller,
    PenghitungSoalController penghitungSoalController,
  ) async {
    try {
      Map<String, String> mapTemp = await getDataAwal(idSurvei);

      final daftarPertanyaan = await getPertanyaanFormKartu(
        mapTemp['idForm']!,
        laporanUtama,
        penghitungSoalController,
      );
      final daftarPertanyaanCabang =
          await getPertanyaanFormKartuCabang(mapTemp['idForm']!, laporanCabang);
      //
      //
      final allRespon = await getAllRespon(idSurvei, laporanUtama);
      final allResponCabang = await getAllResponCabang(idSurvei, laporanUtama);
      final dataLaporanSurvei = DataLaporanSurveiKartu(
        idSurvei: idSurvei,
        judul: mapTemp['judul']!,
        deskripsi: mapTemp['deskripsi']!,
        daftarPertanyaanKartu: daftarPertanyaan,
        listRespon: allRespon,
        daftarPertanyaanKartuCabang: daftarPertanyaanCabang,
        listResponCabang: allResponCabang,
      );
      return dataLaporanSurvei;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<PertanyaanKartu>> getPertanyaanFormKartu(
    String idForm,
    DataKumpulanJawabanController dataKumpulan,
    PenghitungSoalController penghitungSoalController,
  ) async {
    try {
      int acc = 0;
      Map<String, dynamic> dataFormJson = {};
      List<PertanyaanKartu> hasil = [];
      final responRef =
          FirebaseFirestore.instance.collection('form-kartu').doc(idForm);
      await responRef.get().then((value) {
        dataFormJson = value.data()!;
        final list = dataFormJson['daftarSoal'] as List<dynamic>;

        hasil = List.generate(list.length,
            (index) => PertanyaanKartu.fromJson(json.encode(list[index])));
      }).onError((error, stackTrace) {
        print(error);
      });

      for (var element in hasil) {
        acc++;
        if (element.dataSoal.tipeSoal == "Pilihan Ganda" ||
            element.dataSoal.tipeSoal == "Kotak Centang") {
          DataPilgan dataPilgan = element.dataSoal as DataPilgan;

          Map<String, dynamic> mapTemp = {};
          for (var e in dataPilgan.listJawaban) {
            mapTemp[e.idData] = 0;
          }
          if (dataPilgan.lainnya) {
            mapTemp['Lainnya-xyz'] = 0;
          }
          dataKumpulan.pushDataBaru(
            dataPilgan.idSoal,
            DataKumpulanJawaban(
              dataJawaban: mapTemp,
              idSoal: dataPilgan.idSoal,
              tipeJawaban: dataPilgan.tipeSoal,
            ),
          );
        } else if (element.dataSoal.tipeSoal == "Gambar Ganda" ||
            element.dataSoal.tipeSoal == "Carousel") {
          // print("dapat gg atau carousel");
          DataGambarGanda dataGG = element.dataSoal as DataGambarGanda;
          Map<String, dynamic> mapTemp = {};
          for (var e in dataGG.listDataGambar) {
            // print("ini id Jawaban => ${e.idData}");
            mapTemp[e.idData] = 0;
          }
          dataKumpulan.pushDataBaru(
              dataGG.idSoal,
              DataKumpulanJawaban(
                dataJawaban: mapTemp,
                idSoal: dataGG.idSoal,
                tipeJawaban: dataGG.tipeSoal,
              ));
        } else if (element.dataSoal.tipeSoal == "Urutan Pilihan") {
          DataUrutan dataUrutan = element.dataSoal as DataUrutan;
          Map<String, dynamic> mapTemp = {};
          //bagian ini yg perlu diperbaiki, nnati bukan text controller tapi id dari jawaban
          for (var e in dataUrutan.listDataOpsi) {
            mapTemp[e.idData] = 0;
          }
          dataKumpulan.pushDataBaru(
            dataUrutan.idSoal,
            DataKumpulanJawaban(
              dataJawaban: mapTemp,
              idSoal: dataUrutan.idSoal,
              tipeJawaban: dataUrutan.tipeSoal,
            ),
          );
        } else if (element.dataSoal.tipeSoal == "Slider Angka") {
          DataSlider dataSlider = element.dataSoal as DataSlider;
          Map<String, dynamic> mapTemp = {};
          for (var i = dataSlider.min; i < dataSlider.max + 1; i++) {
            mapTemp[i.toString()] = 0;
          }
          dataKumpulan.pushDataBaru(
            dataSlider.idSoal,
            DataKumpulanJawaban(
              dataJawaban: mapTemp,
              idSoal: dataSlider.idSoal,
              tipeJawaban: dataSlider.tipeSoal,
            ),
          );
        } else if (element.dataSoal.tipeSoal == "pembatas") {
          acc--;
        } else {
          //teks - teks, angka, image picker, tanggal, waktu
          DataSoal dataSoal = element.dataSoal;
          dataKumpulan.pushDataBaru(
            dataSoal.idSoal,
            DataKumpulanJawaban(
              dataJawaban: {},
              idSoal: dataSoal.idSoal,
              tipeJawaban: dataSoal.tipeSoal,
            ),
          );
        }
      }
      penghitungSoalController.updateNilai(acc);
      return hasil;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<PertanyaanKartuCabang>> getPertanyaanFormKartuCabang(
    String idForm,
    DataKumpulanJawabanController dataKumpulan,
  ) async {
    try {
      Map<String, dynamic> dataFormJson = {};
      List<PertanyaanKartuCabang> hasil = [];
      final responRef =
          FirebaseFirestore.instance.collection('form-kartu').doc(idForm);
      await responRef.get().then((value) {
        dataFormJson = value.data()!;
        final list = dataFormJson['daftarSoalCabang'] as List<dynamic>;

        hasil = List.generate(
            list.length,
            (index) =>
                PertanyaanKartuCabang.fromJson(json.encode(list[index])));
      }).onError((error, stackTrace) {
        print(error);
      });

      for (var element in hasil) {
        if (element.dataSoal.tipeSoal == "Pilihan Ganda" ||
            element.dataSoal.tipeSoal == "Kotak Centang") {
          DataPilgan dataPilgan = element.dataSoal as DataPilgan;

          Map<String, dynamic> mapTemp = {};
          for (var e in dataPilgan.listJawaban) {
            mapTemp[e.idData] = 0;
          }
          if (dataPilgan.lainnya) {
            mapTemp['Lainnya-xyz'] = 0;
          }
          dataKumpulan.pushDataBaru(
            dataPilgan.idSoal,
            DataKumpulanJawaban(
              dataJawaban: mapTemp,
              idSoal: dataPilgan.idSoal,
              tipeJawaban: dataPilgan.tipeSoal,
            ),
          );
        } else if (element.dataSoal.tipeSoal == "Gambar Ganda" ||
            element.dataSoal.tipeSoal == "Carousel") {
          DataGambarGanda dataGG = element.dataSoal as DataGambarGanda;
          Map<String, dynamic> mapTemp = {};
          for (var e in dataGG.listDataGambar) {
            mapTemp[e.idData] = 0;
          }
          dataKumpulan.pushDataBaru(
              dataGG.idSoal,
              DataKumpulanJawaban(
                dataJawaban: mapTemp,
                idSoal: dataGG.idSoal,
                tipeJawaban: dataGG.tipeSoal,
              ));
        } else if (element.dataSoal.tipeSoal == "Urutan Pilihan") {
          DataUrutan dataUrutan = element.dataSoal as DataUrutan;
          Map<String, dynamic> mapTemp = {};
          //bagian ini yg perlu diperbaiki, nnati bukan text controller tapi id dari jawaban
          for (var e in dataUrutan.listDataOpsi) {
            mapTemp[e.idData] = 0;
          }
          dataKumpulan.pushDataBaru(
            dataUrutan.idSoal,
            DataKumpulanJawaban(
              dataJawaban: mapTemp,
              idSoal: dataUrutan.idSoal,
              tipeJawaban: dataUrutan.tipeSoal,
            ),
          );
        } else if (element.dataSoal.tipeSoal == "Slider Angka") {
          DataSlider dataSlider = element.dataSoal as DataSlider;
          Map<String, dynamic> mapTemp = {};
          for (var i = dataSlider.min; i < dataSlider.max + 1; i++) {
            mapTemp[i.toString()] = 0;
          }
          dataKumpulan.pushDataBaru(
            dataSlider.idSoal,
            DataKumpulanJawaban(
              dataJawaban: mapTemp,
              idSoal: dataSlider.idSoal,
              tipeJawaban: dataSlider.tipeSoal,
            ),
          );
        } else if (element.dataSoal.tipeSoal == "pembatas") {
        } else {
          //teks - teks, angka, image picker, tanggal, waktu
          DataSoal dataSoal = element.dataSoal;
          dataKumpulan.pushDataBaru(
            dataSoal.idSoal,
            DataKumpulanJawaban(
              dataJawaban: {},
              idSoal: dataSoal.idSoal,
              tipeJawaban: dataSoal.tipeSoal,
            ),
          );
        }
      }

      return hasil;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<ResponSurvei>> getAllRespon(
      String idSurvei, DataKumpulanJawabanController laporanUtama) async {
    try {
      List<ResponSurvei> hasilRespon = [];
      final responRef = FirebaseFirestore.instance
          .collection('jawaban-survei-v3')
          .where('idSurvei', isEqualTo: idSurvei);
      // print("idSurvei target $idSurvei");

      await responRef.get().then((value) {
        for (var e in value.docs) {
          hasilRespon.add(ResponSurvei.fromMapX(e.data(), laporanUtama));
        }
        // print("Selesai kumpulkan respon ${hasilRespon.length}");
      }).onError((error, stackTrace) {
        print(error);
      });
      return hasilRespon;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<ResponSurvei>> getAllResponCabang(
      String idSurvei, DataKumpulanJawabanController laporanUtama) async {
    try {
      List<ResponSurvei> hasilRespon = [];
      final responRef = FirebaseFirestore.instance
          .collection('jawaban-survei-v3')
          .where('idSurvei', isEqualTo: idSurvei);
      await responRef.get().then((value) {
        for (var e in value.docs) {
          hasilRespon.add(ResponSurvei.fromMapCabang(e.data(), laporanUtama));
        }
      }).onError((error, stackTrace) {
        print(error);
      });
      return hasilRespon;
    } catch (e) {
      print(e.toString() + "error dari get all respon cabang");
      return [];
    }
  }

  Future<Map<String, String>> getDataAwal(String idSurvei) async {
    try {
      String request = """
query GetIdFormSurvei(\$idSurvei: String!) {
  getIdFormSurvei(idSurvei: \$idSurvei) {
    code,idForm,status,judul,deskripsi
  }
}
      """;

      Map<String, dynamic>? data =
          await Backend().serverConnection(query: request, mapVariable: {
        "idSurvei": idSurvei,
      });

      if (data!['getIdFormSurvei']['code'] == 200) {
        String idForm = data['getIdFormSurvei']['idForm'] as String;
        String judul = data['getIdFormSurvei']['judul'] as String;
        String deskripsi = data['getIdFormSurvei']['deskripsi'] as String;
        return {
          'idForm': idForm,
          'judul': judul,
          'deskripsi': deskripsi,
        };
      } else {
        return {};
      }
    } catch (e) {
      print(e);
      return {};
    }
  }
}
