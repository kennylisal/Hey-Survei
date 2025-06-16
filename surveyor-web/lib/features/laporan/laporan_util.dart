import 'package:flutter/material.dart';
import 'package:hei_survei/features/laporan/constanst.dart';
import 'package:hei_survei/features/laporan/models/data_soal_lama.dart';
import 'package:hei_survei/features/laporan/models/jawaban_survei.dart';
import 'package:hei_survei/features/laporan/widgets/container_urutan.dart';
import 'package:hei_survei/features/laporan/widgets/jawaban_carousel.dart';
import 'package:hei_survei/features/laporan/widgets/jawaban_image_picker.dart';
import 'package:hei_survei/features/laporan/widgets/jawaban_slider_laporan.dart';
import 'package:hei_survei/features/laporan/widgets/jawaban_tabel.dart';
import 'package:hei_survei/features/laporan/widgets/jawaban_tanggal.dart';
import 'package:hei_survei/features/laporan/widgets/jawaban_teks.dart';
import 'package:hei_survei/features/laporan/widgets/jawaban_waktu.dart';
import 'package:hei_survei/features/laporan/widgets/pilihan_gambar_ganda.dart';
import 'package:hei_survei/features/laporan/widgets/pilihan_kotak_centang.dart';
import 'package:hei_survei/features/laporan/widgets/pilihan_pilgan.dart';
import 'package:hei_survei/features/laporan/widgets/tidak_menjawab.dart';
import 'package:intl/intl.dart';

class LaporanUtils {
  List<TipeCharts> getJenisChartTersdia(String tipeSoal) {
    if (tipeSoal == "Pilihan Ganda" ||
        tipeSoal == "Kotak Centang" ||
        tipeSoal == "Urutan Pilihan" ||
        tipeSoal == "Gambar Ganda" ||
        tipeSoal == "Carousel") {
      return listChartDataString;
    } else if (tipeSoal == "Slider Angka") {
      return listChartDataAngka;
    } else if (tipeSoal == "Teks" ||
        tipeSoal == "Teks Paragraf" ||
        tipeSoal == "Tanggal" ||
        tipeSoal == "Waktu" ||
        tipeSoal == "Angka") {
      return listChartDataTabel;
    } else {
      //tabel dan image picker
      return listChartDataTabelNomor;
    }
  }

  Widget generateJawabanLaporan(
      DataSoal dataSoal, JawabanPertanyaan jawaban, BuildContext context) {
    // print(dataSoal.tipeSoal);
    if (dataSoal.tipeSoal == "Tabel") {
      DataTabel dataTabel = dataSoal as DataTabel;

      Map<int, List<String>> mapHasil = jawaban.getJawabanTabel();
      return TabelJawabanLaporan(dataTabel: dataTabel, mapHasil: mapHasil);
    } else if (dataSoal.tipeSoal == "Pilihan Ganda") {
      final pilihanJawaban = jawaban.getJawabanPilgan();
      if (pilihanJawaban['pilihan'] == "zxc") {
        return TidakMenjawab();
      } else {
        DataPilgan dataTemp = dataSoal as DataPilgan;

        return Column(
          children: [
            for (final e in dataTemp.listController)
              PilihanPilgan(
                  isJawaban: (pilihanJawaban['pilihan']! == e.text),
                  text: e.text)
          ],
        );
      }
    } else if (dataSoal.tipeSoal == "Kotak Centang") {
      final listJawaban = jawaban.getJawabanKotakCentangX();
      if (listJawaban.isEmpty) {
        return const TidakMenjawab();
      } else {
        DataPilgan dataTemp = dataSoal as DataPilgan;
        List<String> idPilihan = [];

        for (var element in listJawaban) {
          idPilihan.add(element['idPilihan']!);
        }
        return Column(
          children: [
            for (var e in dataTemp.listJawaban)
              PilihanKotakCentang(
                  isCentang: idPilihan.contains(e.idData), text: e.text)
          ],
        );
      }
    } else if (dataSoal.tipeSoal == "Urutan Pilihan") {
      final listJawaban = jawaban.getJawabanUrutan();
      return Column(
        children: [
          for (var i = 0; i < listJawaban.length; i++)
            PilihanUrutan(
                text: listJawaban[i]['pilihan']!, nomor: (i + 1).toString())
        ],
      );
    } else if (dataSoal.tipeSoal == "Tanggal") {
      int temp = jawaban.getJawabanTanggal();
      if (temp == -1) {
        return TidakMenjawab();
      } else {
        final hasil = DateFormat("dd-MMMM-yyyy")
            .format(DateTime.fromMillisecondsSinceEpoch(temp * 1000));
        return JawabanTanggal(tanggal: hasil);
      }
    } else if (dataSoal.tipeSoal == "Waktu") {
      final hasil = jawaban.getJawabanWaktu();
      return JawabanWaktu(jam: hasil['jam']!, menit: hasil['menit']!);
    } else if (dataSoal.tipeSoal == "Gambar Ganda") {
      final temp = jawaban.getJawabanGGX();
      if (temp['pilihan'] == "zxc") {
        return TidakMenjawab();
      } else {
        DataGambarGanda dataGG = dataSoal as DataGambarGanda;
        return Column(
          children: [
            for (final e in dataGG.listDataGambar)
              PilihanGG(
                isJawaban: (temp['idPilihan'] == e.idData),
                urlImage: e.urlGambar,
              )
            // PilihanGG(isJawaban: (temp == e.urlGambar), urlImage: e.urlGambar)
          ],
        );
      }
    } else if (dataSoal.tipeSoal == "Image Picker") {
      final urlGambar = jawaban.mapJawaban;
      if (urlGambar == "zxc") {
        return TidakMenjawab();
      } else {
        String temp =
            "https://firebasestorage.googleapis.com/v0/b/hei-survei-v1.appspot.com/o/eksp%2Fe4f16735-f3?alt=media&token=a5ecedef-c4c8-491b-99fb-6709c22664b1";
        return JawabanImagePickerLaporan(urlGambar: urlGambar);
      }
    } else if (dataSoal.tipeSoal == "Slider Angka") {
      final temp = jawaban.getJawabanAngka();
      if (temp == -1) {
        return const TidakMenjawab();
      } else {
        DataSlider dataSlider = dataSoal as DataSlider;
        return JawabanSliderLaporan(
          nilaiJawaban: temp,
          maximal: dataSlider.max,
          minimal: dataSlider.min,
          teksMax: dataSlider.labelMax.text,
          teksMin: dataSlider.labelMin.text,
        );
      }
    } else if (dataSoal.tipeSoal == "Teks" ||
        dataSoal.tipeSoal == "Teks Paragraf") {
      final temp = jawaban.getJawabanTeks();
      return JawabanTeksLaporan(text: temp);
      // return JawabanTeksLaporan(
      //   text:
      //       "Ini contoh jawaban yg ditampilkan untuk dicoba pada percoban pertama, semoga berhasil.");
      // return SizedBox();
    } else if (dataSoal.tipeSoal == "Carousel") {
      final temp = jawaban.getJawabanGGX();
      if (temp['pilihan'] == "zxc") {
        return TidakMenjawab();
      } else {
        DataGambarGanda dataGG = dataSoal as DataGambarGanda;
        return Column(
          children: [
            for (final e in dataGG.listDataGambar)
              PilihanCarousel(
                isJawaban: (temp['idPilihan'] == e.idData),
                urlImage: e.urlGambar,
              )
          ],
        );
      }
    } else if (dataSoal.tipeSoal == "Angka") {
      final temp = jawaban.getJawabanAngka();
      return JawabanTeksLaporan(text: temp.toString());
    } else {
      return Text(dataSoal.tipeSoal);
    }
  }
}
