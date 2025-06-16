import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hei_survei/features/laporan/laporan_klasik/laporan_page_controller.dart';
import 'package:hei_survei/features/laporan/models/data_kumpulan_jawaban.dart';
import 'package:hei_survei/features/laporan/models/data_soal_lama.dart';
import 'package:hei_survei/features/laporan/models/jawaban_survei.dart';
import 'package:hei_survei/features/laporan/models/laporan_survei_klasik.dart';
import 'package:hei_survei/features/laporan/models/pertanyaan_survei.dart';
import 'package:hei_survei/features/laporan/state/data_kumpulan_jawaban.dart';
import 'package:hei_survei/utils/backend.dart';

class LaporanServices {
  Future<DataLaporanSurveiKlasik?> getDataLaporanKlasik(
    String idSurvei,
    DataKumpulanJawabanController laporanUtama,
    DataKumpulanJawabanController laporanCabang,
    PageLaporanController controller,
    PenghitungSoalController penghitungSoalController,
  ) async {
    try {
      Map<String, String> mapTemp = await getDataAwal(idSurvei);
      //dibawah pada dasarnyangumpulin soal
      print("sukses get data awal");
      final daftarPertanyaan = await getPertanyaanFormKlasik(
        mapTemp['idForm']!,
        laporanUtama,
        penghitungSoalController,
      );
      print("sukses get pertanyaan utama");
      final daftarPertanyaanCabang = await getPertanyaanFormKlasikCabang(
          mapTemp['idForm']!, laporanCabang);
      print("sukses get pertanyaan cabang");
      //dibawah ngumpulin data dari jawaban-survei baru diproses
      //dalam bentuk ResponSurvei
      final allRespon = await getAllRespon(idSurvei, laporanUtama);
      final allResponCabang = await getAllResponCabang(idSurvei, laporanCabang);

      final dataLaporanSurvei = DataLaporanSurveiKlasik(
        idSurvei: idSurvei,
        judul: mapTemp['judul']!,
        deskripsi: mapTemp['deskripsi']!,
        daftarPertanyaanKlasik: daftarPertanyaan,
        listRespon: allRespon,
        daftarPertanyaanKlasikCabang: daftarPertanyaanCabang,
        listResponCabang: allResponCabang,
      );
      controller.setIdSurvei(idSurvei);
      return dataLaporanSurvei;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<ResponSurvei>> getAllRespon(
      String idSurvei, DataKumpulanJawabanController laporanUtama) async {
    try {
      List<ResponSurvei> hasilRespon = [];
      final responRef = FirebaseFirestore.instance
          .collection('jawaban-survei-v3')
          .where('idSurvei', isEqualTo: idSurvei);

      await responRef.get().then((value) {
        for (var e in value.docs) {
          hasilRespon.add(ResponSurvei.fromMapX(e.data(), laporanUtama));
        }
      }).onError((error, stackTrace) {
        print(error);
      });
      return hasilRespon;
    } catch (e) {
      print(e.toString() + "error dari get all responX");
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

  Future<List<PertanyaanKlasik>> getPertanyaanFormKlasik(
    String idForm,
    DataKumpulanJawabanController dataKumpulan,
    PenghitungSoalController penghitungSoalController,
  ) async {
    try {
      int acc = 0;
      Map<String, dynamic> dataFormJson = {};
      final responRef =
          FirebaseFirestore.instance.collection('form-klasik').doc(idForm);
      await responRef.get().then((value) {
        dataFormJson = value.data()!;
      }).onError((error, stackTrace) {
        print(error);
      });
      //bagian Kumpulan Soal Klasik===========================================================================
      final list = dataFormJson['daftarSoal'] as List<dynamic>;
      final hasil = List.generate(list.length,
          (index) => PertanyaanKlasik.fromJson(json.encode(list[index])));

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

  Future<List<PertanyaanKlasikCabang>> getPertanyaanFormKlasikCabang(
    String idForm,
    DataKumpulanJawabanController dataKumpulan,
  ) async {
    try {
      // int acc = 0;
      Map<String, dynamic> dataFormJson = {};
      final responRef =
          FirebaseFirestore.instance.collection('form-klasik').doc(idForm);
      await responRef.get().then((value) {
        dataFormJson = value.data()!;
      }).onError((error, stackTrace) {
        print(error);
      });
      final list = dataFormJson['daftarSoalCabang'] as List<dynamic>;
      final hasil = List.generate(list.length,
          (index) => PertanyaanKlasikCabang.fromJson(json.encode(list[index])));
      for (var element in hasil) {
        // acc++;
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
          // acc--;
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
      // penghitungSoalController.updateNilai(acc);
      return hasil;
    } catch (e) {
      print(e);
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

  // Future<List<ResponSurvei>> getAllRespon(String idSurvei) async {
  //   try {
  //     List<ResponSurvei> hasilRespon = [];
  //     final responRef = FirebaseFirestore.instance
  //         .collection('jawaban-survei')
  //         .where('idSurvei', isEqualTo: idSurvei);
  //     print("idSurvei target $idSurvei");

  //     await responRef.get().then((value) {
  //       for (var e in value.docs) {
  //         hasilRespon.add(ResponSurvei.fromMap(e.data()));
  //       }
  //     }).onError((error, stackTrace) {
  //       print(error);
  //     });
  //     return hasilRespon;
  //   } catch (e) {
  //     print(e);
  //     return [];
  //   }
  // }

  // bool cekAllFalse(List<bool> list) {
  //   bool logic = true;
  //   for (var i = 0; i < list.length; i++) {
  //     if (list[i]) {
  //       logic = false;
  //       break;
  //     }
  //   }
  //   return logic;
  // }

//  Widget generateJawabanLaporan(
//       DataSoal dataSoal, JawabanPertanyaan jawaban, BuildContext context) {
//     print(dataSoal.tipeSoal);
//     if (dataSoal.tipeSoal == "Tabel") {
//       DataTabel dataTabel = dataSoal as DataTabel;

//       Map<int, List<String>> mapHasil = jawaban.getJawabanTabel();
//       return TabelJawabanLaporan(dataTabel: dataTabel, mapHasil: mapHasil);
//     } else if (dataSoal.tipeSoal == "Pilihan Ganda") {
//       final pilihanJawaban = jawaban.getJawabanPilgan();
//       if (pilihanJawaban['pilihan'] == "zxc") {
//         return TidakMenjawab();
//       } else {
//         DataPilgan dataTemp = dataSoal as DataPilgan;

//         return Column(
//           children: [
//             for (final e in dataTemp.listController)
//               PilihanPilgan(
//                   isJawaban: (pilihanJawaban['pilihan']! == e.text),
//                   text: e.text)
//           ],
//         );
//       }
//     } else if (dataSoal.tipeSoal == "Kotak Centang") {
//       final listJawaban = jawaban.getJawabanKotakCentangX();
//       if (listJawaban.isEmpty) {
//         return const TidakMenjawab();
//       } else {
//         DataPilgan dataTemp = dataSoal as DataPilgan;
//         List<String> idPilihan = [];

//         for (var element in listJawaban) {
//           idPilihan.add(element['idPilihan']!);
//         }
//         return Column(
//           children: [
//             for (var e in dataTemp.listJawaban)
//               PilihanKotakCentang(
//                   isCentang: idPilihan.contains(e.idData), text: e.text)
//           ],
//         );
//       }
//       //dibawah jawaban yg dulu ada
//       // if (cekAllFalse(listJawaban)) {
//       //   return TidakMenjawab();
//       // } else {
//       //   DataPilgan dataTemp = dataSoal as DataPilgan;
//       //   return Column(
//       //     children: [
//       //       for (int i = 0; i < dataTemp.listController.length; i++)
//       //         PilihanKotakCentang(
//       //           isCentang: listJawaban[i],
//       //           text: dataTemp.listController[i].text,
//       //         )
//       //     ],
//       //   );
//       // }
//     } else if (dataSoal.tipeSoal == "Urutan Pilihan") {
//       final listJawaban = jawaban.getJawabanUrutan();
//       return Column(
//         children: [
//           for (var i = 0; i < listJawaban.length; i++)
//             PilihanUrutan(
//                 text: listJawaban[i]['pilihan']!, nomor: (i + 1).toString())
//         ],
//       );
//     } else if (dataSoal.tipeSoal == "Tanggal") {
//       int temp = jawaban.getJawabanTanggal();
//       if (temp == -1) {
//         return TidakMenjawab();
//       } else {
//         final hasil = DateFormat("dd-MMMM-yyyy")
//             .format(DateTime.fromMillisecondsSinceEpoch(temp * 1000));
//         return JawabanTanggal(tanggal: hasil);
//       }
//     } else if (dataSoal.tipeSoal == "Waktu") {
//       final hasil = jawaban.getJawabanWaktu();
//       return JawabanWaktu(jam: hasil['jam']!, menit: hasil['menit']!);
//     } else if (dataSoal.tipeSoal == "Gambar Ganda") {
//       final temp = jawaban.getJawabanGGX();
//       if (temp['pilihan'] == "zxc") {
//         return TidakMenjawab();
//       } else {
//         DataGambarGanda dataGG = dataSoal as DataGambarGanda;
//         return Column(
//           children: [
//             for (final e in dataGG.listDataGambar)
//               PilihanGG(
//                 isJawaban: (temp['idPilihan'] == e.idData),
//                 urlImage: e.urlGambar,
//               )
//             // PilihanGG(isJawaban: (temp == e.urlGambar), urlImage: e.urlGambar)
//           ],
//         );
//       }
//     } else if (dataSoal.tipeSoal == "Image Picker") {
//       final urlGambar = jawaban.mapJawaban;
//       if (urlGambar == "zxc") {
//         return TidakMenjawab();
//       } else {
//         String temp =
//             "https://firebasestorage.googleapis.com/v0/b/hei-survei-v1.appspot.com/o/eksp%2Fe4f16735-f3?alt=media&token=a5ecedef-c4c8-491b-99fb-6709c22664b1";
//         return JawabanImagePickerLaporan(urlGambar: urlGambar);
//       }
//     } else if (dataSoal.tipeSoal == "Slider Angka") {
//       final temp = jawaban.getJawabanAngka();
//       if (temp == -1) {
//         return const TidakMenjawab();
//       } else {
//         DataSlider dataSlider = dataSoal as DataSlider;
//         return JawabanSliderLaporan(
//           nilaiJawaban: temp,
//           maximal: dataSlider.max,
//           minimal: dataSlider.min,
//           teksMax: dataSlider.labelMax.text,
//           teksMin: dataSlider.labelMin.text,
//         );
//       }
//     } else if (dataSoal.tipeSoal == "Teks" ||
//         dataSoal.tipeSoal == "Teks Paragraf") {
//       final temp = jawaban.getJawabanTeks();
//       return JawabanTeksLaporan(text: temp);
//       // return JawabanTeksLaporan(
//       //   text:
//       //       "Ini contoh jawaban yg ditampilkan untuk dicoba pada percoban pertama, semoga berhasil.");
//       // return SizedBox();
//     } else if (dataSoal.tipeSoal == "Carousel") {
//       final temp = jawaban.getJawabanGGX();
//       if (temp['pilihan'] == "zxc") {
//         return TidakMenjawab();
//       } else {
//         DataGambarGanda dataGG = dataSoal as DataGambarGanda;
//         return Column(
//           children: [
//             for (final e in dataGG.listDataGambar)
//               PilihanCarousel(
//                 isJawaban: (temp['idPilihan'] == e.idData),
//                 urlImage: e.urlGambar,
//               )
//           ],
//         );
//       }
//     } else {
//       return Text(dataSoal.tipeSoal);
//     }
//   }
  // Future<DataLaporanSurveiKartu?> getDataLaporanKartu(String idSurvei) async {
  //   try {
  //     Map<String, String> mapTemp = await getDataAwal(idSurvei);
  //     final allRespon = await getAllRespon(idSurvei);
  //     final daftarPertanyaan = await getPertanyaanFormKartu(mapTemp['idForm']!);
  //     final dataLaporanSurvei = DataLaporanSurveiKartu(
  //       idSurvei: idSurvei,
  //       judul: mapTemp['judul']!,
  //       deskripsi: mapTemp['deskripsi']!,
  //       daftarPertanyaanKartu: daftarPertanyaan,
  //       listRespon: allRespon,
  //     );
  //     return dataLaporanSurvei;
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }


  // Future<DataLaporanSurveiKlasik?> getDataLaporanKlasik(String idSurvei) async {
  //   try {
  //     Map<String, String> mapTemp = await getDataAwal(idSurvei);
  //     final daftarPertanyaan =
  //         await getPertanyaanFormKlasik(mapTemp['idForm']!);

  //     final allRespon = await getAllRespon(idSurvei);

  //     final dataLaporanSurvei = DataLaporanSurveiKlasik(
  //       idSurvei: idSurvei,
  //       judul: mapTemp['judul']!,
  //       deskripsi: mapTemp['deskripsi']!,
  //       daftarPertanyaanKlasik: daftarPertanyaan,
  //       listRespon: allRespon,
  //     );
  //     return dataLaporanSurvei;
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }

  // List<PertanyaanKlasik> hasilPertanyaanKlasik(
  //     List<PertanyaanKlasik> daftarPertanyaan, ResponSurvei responSurvei) {
  //   return List.generate(
  //     daftarPertanyaan.length,
  //     (index) => daftarPertanyaan[index],
  //   );
  // }

  // List<PertanyaanKartu> hasilPertanyaanKartu(List<PertanyaanKartu> daftarPertanyaan, ResponSurvei responSurvei ){
  //   return List.generate(daftarPertanyaan.length, (index) => da)
  // }

  // Future<List<PertanyaanKlasik>> getPertanyaanFormKlasik(String idForm) async {
  //   try {
  //     Map<String, dynamic> dataFormJson = {};
  //     final responRef =
  //         FirebaseFirestore.instance.collection('form-klasik').doc(idForm);
  //     await responRef.get().then((value) {
  //       dataFormJson = value.data()!;
  //     }).onError((error, stackTrace) {
  //       print(error);
  //     });
  //     final list = dataFormJson['daftarSoal'] as List<dynamic>;
  //     final hasil = List.generate(list.length,
  //         (index) => PertanyaanKlasik.fromJson(json.encode(list[index])));
  //     return hasil;
  //   } catch (e) {
  //     print(e);
  //     return [];
  //   }
  // }

// Map<String, Map<String, int>> mergeSoalDanJawabanKlasik(
  //   DataLaporanSurveiKlasik dataLaporan,
  //   Map<String, DataChartJawaban> mapListJawaban,
  // ) {
  //   Map<String, Map<String, int>> hasilOlahanData = {};
  //   final listPertanyaan = dataLaporan.daftarPertanyaanKlasik;
  //   for (var element in listPertanyaan) {
  //     if (element.dataSoal.tipeSoal == "Pilihan Ganda") {
  //       DataPilgan dataPilgan = element.dataSoal as DataPilgan;
  //       hasilOlahanData[dataPilgan.idSoal] = {};
  //       //
  //       for (var i = 0; i < dataPilgan.listController.length; i++) {
  //         String text = dataPilgan.listController[i].text;
  //         final angka = mapListJawaban[dataPilgan.idSoal]!.mapChart[text] ?? 0;
  //         hasilOlahanData[dataPilgan.idSoal]![text] = angka;
  //       }
  //     } else if (element.dataSoal.tipeSoal == "Kotak Centang") {
  //       DataPilgan dataPilgan = element.dataSoal as DataPilgan;
  //       hasilOlahanData[dataPilgan.idSoal] = {};

  //       for (var i = 0; i < dataPilgan.listController.length; i++) {
  //         String text = dataPilgan.listController[i].text;
  //         final angka = mapListJawaban[dataPilgan.idSoal]!.mapChart[text] ?? 0;
  //         hasilOlahanData[dataPilgan.idSoal]![text] = angka;
  //       }
  //     } else if (element.dataSoal.tipeSoal == "Gambar Ganda" ||
  //         element.dataSoal.tipeSoal == "Carousel") {
  //       DataGambarGanda dataGG = element.dataSoal as DataGambarGanda;
  //       hasilOlahanData[dataGG.idSoal] = {};

  //       for (var i = 0; i < dataGG.listDataGambar.length; i++) {
  //         String text = dataGG.listDataGambar[i].urlGambar;
  //         final angka = mapListJawaban[dataGG.idSoal]!.mapChart[text] ?? 0;
  //         hasilOlahanData[dataGG.idSoal]![text] = angka;
  //       }
  //     } else if (element.dataSoal.tipeSoal == "Urutan Pilihan") {
  //       DataUrutan dataUrutan = element.dataSoal as DataUrutan;
  //       hasilOlahanData[dataUrutan.idSoal] = {};

  //       for (var i = 0; i < dataUrutan.listController.length; i++) {
  //         String text = dataUrutan.listController[i].text;
  //         final angka = mapListJawaban[dataUrutan.idSoal]!.mapChart[text] ?? 0;
  //         hasilOlahanData[dataUrutan.idSoal]![text] = angka;
  //       }
  //     } else if (element.dataSoal.tipeSoal == "Slider Angka") {
  //       DataSlider dataSlider = element.dataSoal as DataSlider;
  //       hasilOlahanData[dataSlider.idSoal] = {};

  //       for (var i = dataSlider.min; i <= dataSlider.max; i++) {
  //         final key = i.toString();
  //         final angka = mapListJawaban[dataSlider.idSoal]!.mapChart[key] ?? 0;
  //         hasilOlahanData[dataSlider.idSoal]![key] = angka;
  //       }
  //     } else {
  //       hasilOlahanData[element.dataSoal.idSoal] = {};
  //     }
  //   }

  //   return hasilOlahanData;
  // }

  //disini  untuk siapkan map penampungan jawaban
  // Map<String, DataChartJawaban> generateKumpulanJawabanKlasik(
  //     DataLaporanSurveiKlasik dataLaporan) {
  //   Map<String, DataChartJawaban> mapListJawaban = {};
  //   for (var e in dataLaporan.listRespon) {
  //     for (var p in e.daftarJawaban) {
  //       if (p.tipeSoal == "Pilihan Ganda") {
  //         final jawaban = p.getJawabanPilgan();
  //         if (mapListJawaban.containsKey(p.idSoal)) {
  //           if (mapListJawaban[p.idSoal]!
  //               .mapChart
  //               .containsKey(jawaban['pilihan'])) {
  //             int temp =
  //                 mapListJawaban[p.idSoal]!.mapChart[jawaban['pilihan']!]! + 1;
  //             mapListJawaban[p.idSoal]!.mapChart[jawaban['pilihan']!] = temp;
  //           } else {
  //             mapListJawaban[p.idSoal]!.mapChart[jawaban['pilihan']!] = 1;
  //           }
  //         } else {
  //           mapListJawaban[p.idSoal] = DataChartJawaban(
  //             tipeSoal: p.tipeSoal,
  //             mapChart: {
  //               jawaban['pilihan']!: 1,
  //             },
  //             idSoal: p.idSoal,
  //           );
  //         }
  //       } else if (p.tipeSoal == "Kotak Centang") {
  //         final jawaban = p.getJawabanKotakCentang();
  //         if (mapListJawaban.containsKey(p.idSoal)) {
  //           for (var i = 0; i < jawaban.length; i++) {
  //             int nilai = mapListJawaban[p.idSoal]!.mapChart[i.toString()]! + 1;
  //             mapListJawaban[p.idSoal]!.mapChart[i.toString()] = nilai;
  //           }
  //         } else {
  //           Map<String, int> mapTemp = {};
  //           for (var i = 0; i < jawaban.length; i++) {
  //             mapTemp[i.toString()] = (jawaban[i]) ? 1 : 0;
  //           }
  //           mapListJawaban[p.idSoal] = DataChartJawaban(
  //             tipeSoal: p.tipeSoal,
  //             mapChart: mapTemp,
  //             idSoal: p.idSoal,
  //           );
  //         }
  //       } else if (p.tipeSoal == "Gambar Ganda" || p.tipeSoal == "Carousel") {
  //         final jawaban = p.getJawabanGG();
  //         if (mapListJawaban.containsKey(p.idSoal)) {
  //           if (mapListJawaban[p.idSoal]!.mapChart.containsKey(jawaban)) {
  //             int temp = mapListJawaban[p.idSoal]!.mapChart[jawaban]! + 1;
  //             mapListJawaban[p.idSoal]!.mapChart[jawaban] = temp;
  //           } else {
  //             mapListJawaban[p.idSoal]!.mapChart[jawaban] = 1;
  //           }
  //         } else {
  //           mapListJawaban[p.idSoal] = DataChartJawaban(
  //             tipeSoal: p.tipeSoal,
  //             mapChart: {
  //               jawaban: 1,
  //             },
  //             idSoal: p.idSoal,
  //           );
  //         }
  //       } else if (p.tipeSoal == "Urutan Pilihan") {
  //         //hanya ambil jawaban teratas
  //         final jawaban = p.getJawabanUrutan()[0];
  //         if (mapListJawaban.containsKey(p.idSoal)) {
  //           if (mapListJawaban[p.idSoal]!.mapChart.containsKey(jawaban)) {
  //             int temp = mapListJawaban[p.idSoal]!.mapChart[jawaban]! + 1;
  //             mapListJawaban[p.idSoal]!.mapChart[jawaban] = temp;
  //           } else {
  //             mapListJawaban[p.idSoal]!.mapChart[jawaban] = 1;
  //           }
  //         } else {
  //           mapListJawaban[p.idSoal] = DataChartJawaban(
  //             tipeSoal: p.tipeSoal,
  //             mapChart: {
  //               jawaban: 1,
  //             },
  //             idSoal: p.idSoal,
  //           );
  //         }
  //       } else if (p.tipeSoal == "Slider Angka") {
  //         final jawaban = p.getJawabanAngka();
  //         if (mapListJawaban.containsKey(p.idSoal)) {
  //           if (mapListJawaban[p.idSoal]!
  //               .mapChart
  //               .containsKey(jawaban.toString())) {
  //             int temp =
  //                 mapListJawaban[p.idSoal]!.mapChart[jawaban.toString()]! + 1;
  //             mapListJawaban[p.idSoal]!.mapChart[jawaban.toString()] = temp;
  //           } else {
  //             mapListJawaban[p.idSoal]!.mapChart[jawaban.toString()] = 1;
  //           }
  //         } else {
  //           mapListJawaban[p.idSoal] = DataChartJawaban(
  //             tipeSoal: p.tipeSoal,
  //             mapChart: {
  //               jawaban.toString(): 1,
  //             },
  //             idSoal: p.idSoal,
  //           );
  //         }
  //       } else {
  //         mapListJawaban[p.idSoal] = DataChartJawaban(
  //           tipeSoal: p.tipeSoal,
  //           mapChart: {},
  //           idSoal: p.idSoal,
  //         );
  //       }
  //     }
  //   }

  //   return mapListJawaban;
  // }