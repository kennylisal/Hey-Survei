import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:survei_aplikasi/features/form_kartu/widgets/form_x.dart';
import 'package:survei_aplikasi/features/form_kartu/widgets/form_x_non_foto.dart';
import 'package:survei_aplikasi/features/form_kartu/widgets/form_y.dart';
import 'package:survei_aplikasi/features/form_kartu/widgets/form_z.dart';
import 'package:survei_aplikasi/features/form_klasik/constant.dart';
import 'package:survei_aplikasi/features/form_klasik/models/data_error.dart';
import 'package:survei_aplikasi/features/form_klasik/models/data_pertanyaan.dart';
import 'package:survei_aplikasi/features/form_klasik/state/state_pertanyaan.dart';
import 'package:survei_aplikasi/features/form_klasik/widgets/checkbox.dart';
import 'package:survei_aplikasi/features/form_klasik/widgets/jawaban_angka.dart';
import 'package:survei_aplikasi/features/form_klasik/widgets/jawaban_carousel.dart';
import 'package:survei_aplikasi/features/form_klasik/widgets/jawaban_gg.dart';
import 'package:survei_aplikasi/features/form_klasik/widgets/jawaban_image_picker.dart';
import 'package:survei_aplikasi/features/form_klasik/widgets/jawaban_paragraf.dart';
import 'package:survei_aplikasi/features/form_klasik/widgets/jawaban_slider.dart';
import 'package:survei_aplikasi/features/form_klasik/widgets/jawaban_tabel.dart';
import 'package:survei_aplikasi/features/form_klasik/widgets/jawaban_tanggal.dart';
import 'package:survei_aplikasi/features/form_klasik/widgets/jawaban_teks.dart';
import 'package:survei_aplikasi/features/form_klasik/widgets/jawaban_urutan.dart';
import 'package:survei_aplikasi/features/form_klasik/widgets/jawaban_waktu.dart';
import 'package:survei_aplikasi/features/form_klasik/widgets/soal_klasik_google.dart';
import 'package:survei_aplikasi/features/form_klasik/widgets_atas_form/pembatas.dart';
import 'package:survei_aplikasi/features/form_klasik/widgets/pilgan.dart';
import 'package:survei_aplikasi/features/form_klasik/widgets/soal_klasik.dart';
import 'package:survei_aplikasi/features/form_klasik/widgets_atas_form/pembatas_baru.dart';
import 'package:survei_aplikasi/features/form_klasik/widgets_atas_form/pembatas_google.dart';
import 'package:survei_aplikasi/features/form_klasik/widgets_atas_form/pembatas_polos.dart';

class PertanyaanController extends StateNotifier<PertanyaanState> {
  PertanyaanController({required PertanyaanState pertanyaanState})
      : super(pertanyaanState);

  bool isWajib() => state.isWajib;
  QuillController getQuillController() => state.documentQuill;
  bool isBergambar() => (state as PertanyaanStateKlasik).isBergambar;
  String urlGambar() => (state as PertanyaanStateKlasik).urlGambarSoal;
  TipePertanyaan getTipePertanyaan() => state.tipePertanyaan;
  Tipesoal getTipeSoal() => state.dataPertanyaan.tipeSoal;
  DataPertanyaan getDataPertanyaan() => state.dataPertanyaan;

  String getIdSoal() => state.dataPertanyaan.idSoal;

  String getUrlGambarKartu() => (state as PertanyaanStateKartu).urlGambar;

  String getIdAsalCabangKlasik() =>
      (state as PertanyaanStateKlasikCabang).idJawabanAsal;

  String getIdAsalCabangKartu() =>
      (state as PertanyaanStateKartuCabang).idJawabanAsal;

  Widget generateWidgetJawaban() {
    if (state.dataPertanyaan.tipeSoal == Tipesoal.pilihanGanda) {
      final temp = (state.dataPertanyaan as DataPilgan);
      return JawabanPilganZ(dataPilgan: temp, controller: this);
    } else if (state.dataPertanyaan.tipeSoal == Tipesoal.angka) {
      final temp = (state.dataPertanyaan as DataAngka);
      return JawabanAngkaZ(dataAngka: temp);
    } else if (state.dataPertanyaan.tipeSoal == Tipesoal.carousel) {
      DataGambarGanda temp = (state.dataPertanyaan as DataGambarGanda);
      return JawabanCarouselZ(dataCarousel: temp, controller: this);
    } else if (state.dataPertanyaan.tipeSoal == Tipesoal.imagePicker) {
      DataGambar temp = (state.dataPertanyaan as DataGambar);
      return JawabanImagePicker(dataGambar: temp, controller: this);
    } else if (state.dataPertanyaan.tipeSoal == Tipesoal.kotakCentang) {
      DataCheckBox temp = (state.dataPertanyaan as DataCheckBox);
      return JawabanCheckBoxZ(controller: this, dataCheckBox: temp);
    } else if (state.dataPertanyaan.tipeSoal == Tipesoal.paragraf) {
      DataTeks temp = (state.dataPertanyaan as DataTeks);
      return JawabanParagrafZ(dataTeks: temp);
    } else if (state.dataPertanyaan.tipeSoal == Tipesoal.gambarGanda) {
      DataGambarGanda temp = (state.dataPertanyaan as DataGambarGanda);
      return JawabanGambarGandaZ(dataGG: temp, controller: this);
    } else if (state.dataPertanyaan.tipeSoal == Tipesoal.sliderAngka) {
      DataSlider temp = (state.dataPertanyaan as DataSlider);
      return JawabanSliderZ(controller: this, dataSlider: temp);
    } else if (state.dataPertanyaan.tipeSoal == Tipesoal.tabel) {
      DataTabel temp = (state.dataPertanyaan as DataTabel);
      return JawabanTabelZ(dataTabel: temp);
    } else if (state.dataPertanyaan.tipeSoal == Tipesoal.tanggal) {
      DataTanggal temp = (state.dataPertanyaan as DataTanggal);
      return JawabanTanggalZ(controller: this, dataTanggal: temp);
    } else if (state.dataPertanyaan.tipeSoal == Tipesoal.teks) {
      DataTeks temp = (state.dataPertanyaan as DataTeks);
      return JawabanTeksZ(dataTeks: temp);
    } else if (state.dataPertanyaan.tipeSoal == Tipesoal.urutanPilihan) {
      DataUrutan temp = (state.dataPertanyaan as DataUrutan);
      return JawabanUrutan(controller: this, dataUrutan: temp);
    } else if (state.dataPertanyaan.tipeSoal == Tipesoal.waktu) {
      DataWaktu temp = (state.dataPertanyaan as DataWaktu);
      return JawabanWaktu(dataWaktu: temp, controller: this);
    } else {
      return const SizedBox();
    }
  }

  gantiNilaiSlider(double value) {
    DataSlider temp = (state.dataPertanyaan as DataSlider);
    temp.nilai = value;
    // state = state.copyWith(dataPertanyaan: temp);
    if (state.tipePertanyaan == TipePertanyaan.pertanyaanKlasik) {
      state = (state as PertanyaanStateKlasik).copyWith(dataPertanyaan: temp);
    } else if (state.tipePertanyaan == TipePertanyaan.pertanyaanKlasikCabang) {
      state =
          (state as PertanyaanStateKlasikCabang).copyWith(dataPertanyaan: temp);
    } else if (state.tipePertanyaan == TipePertanyaan.pertanyaanKartu) {
      state = (state as PertanyaanStateKartu).copyWith(dataPertanyaan: temp);
    } else if (state.tipePertanyaan == TipePertanyaan.pertanyaanKartuCabang) {
      state =
          (state as PertanyaanStateKartuCabang).copyWith(dataPertanyaan: temp);
    }
  }

  gantiWaktu(TimeOfDay waktu) {
    DataWaktu temp = (state.dataPertanyaan as DataWaktu);
    temp.waktu = waktu;
    // state = state.copyWith(dataPertanyaan: temp);
    if (state.tipePertanyaan == TipePertanyaan.pertanyaanKlasik) {
      state = (state as PertanyaanStateKlasik).copyWith(dataPertanyaan: temp);
    } else if (state.tipePertanyaan == TipePertanyaan.pertanyaanKlasikCabang) {
      state =
          (state as PertanyaanStateKlasikCabang).copyWith(dataPertanyaan: temp);
    } else if (state.tipePertanyaan == TipePertanyaan.pertanyaanKartu) {
      state = (state as PertanyaanStateKartu).copyWith(dataPertanyaan: temp);
    } else if (state.tipePertanyaan == TipePertanyaan.pertanyaanKartuCabang) {
      state =
          (state as PertanyaanStateKartuCabang).copyWith(dataPertanyaan: temp);
    }
  }

  gantiTanggal(DateTime date) {
    DataTanggal temp = (state.dataPertanyaan as DataTanggal);
    temp.date = date;
    // state = state.copyWith(dataPertanyaan: temp);
    if (state.tipePertanyaan == TipePertanyaan.pertanyaanKlasik) {
      state = (state as PertanyaanStateKlasik).copyWith(dataPertanyaan: temp);
    } else if (state.tipePertanyaan == TipePertanyaan.pertanyaanKlasikCabang) {
      state =
          (state as PertanyaanStateKlasikCabang).copyWith(dataPertanyaan: temp);
    } else if (state.tipePertanyaan == TipePertanyaan.pertanyaanKartu) {
      state = (state as PertanyaanStateKartu).copyWith(dataPertanyaan: temp);
    } else if (state.tipePertanyaan == TipePertanyaan.pertanyaanKartuCabang) {
      state =
          (state as PertanyaanStateKartuCabang).copyWith(dataPertanyaan: temp);
    }
  }

  gantiGambarJawaban(String value) {
    DataGambar temp = (state.dataPertanyaan as DataGambar);
    temp.urlGambar = value;
    // state = state.copyWith(dataPertanyaan: temp);
    if (state.tipePertanyaan == TipePertanyaan.pertanyaanKlasik) {
      state = (state as PertanyaanStateKlasik).copyWith(dataPertanyaan: temp);
    } else if (state.tipePertanyaan == TipePertanyaan.pertanyaanKlasikCabang) {
      state =
          (state as PertanyaanStateKlasikCabang).copyWith(dataPertanyaan: temp);
    } else if (state.tipePertanyaan == TipePertanyaan.pertanyaanKartu) {
      state = (state as PertanyaanStateKartu).copyWith(dataPertanyaan: temp);
    } else if (state.tipePertanyaan == TipePertanyaan.pertanyaanKartuCabang) {
      state =
          (state as PertanyaanStateKartuCabang).copyWith(dataPertanyaan: temp);
    }
  }

  gantiPilgan(DataOpsi pilgan) {
    DataPilgan temp = (state.dataPertanyaan as DataPilgan);
    temp.pilihan = pilgan;
    // state = state.copyWith(dataPertanyaan: temp);
    if (state.tipePertanyaan == TipePertanyaan.pertanyaanKlasik) {
      state = (state as PertanyaanStateKlasik).copyWith(dataPertanyaan: temp);
    } else if (state.tipePertanyaan == TipePertanyaan.pertanyaanKlasikCabang) {
      state =
          (state as PertanyaanStateKlasikCabang).copyWith(dataPertanyaan: temp);
    } else if (state.tipePertanyaan == TipePertanyaan.pertanyaanKartu) {
      state = (state as PertanyaanStateKartu).copyWith(dataPertanyaan: temp);
    } else if (state.tipePertanyaan == TipePertanyaan.pertanyaanKartuCabang) {
      state =
          (state as PertanyaanStateKartuCabang).copyWith(dataPertanyaan: temp);
    }
  }

  pilihJawabanCarousel(DataOpsi dataOpsi) {
    DataGambarGanda temp = (state.dataPertanyaan as DataGambarGanda);
    temp.pilihan = dataOpsi;
    // state = state.copyWith(dataPertanyaan: temp);
    if (state.tipePertanyaan == TipePertanyaan.pertanyaanKlasik) {
      state = (state as PertanyaanStateKlasik).copyWith(dataPertanyaan: temp);
    } else if (state.tipePertanyaan == TipePertanyaan.pertanyaanKlasikCabang) {
      state =
          (state as PertanyaanStateKlasikCabang).copyWith(dataPertanyaan: temp);
    } else if (state.tipePertanyaan == TipePertanyaan.pertanyaanKartu) {
      state = (state as PertanyaanStateKartu).copyWith(dataPertanyaan: temp);
    } else if (state.tipePertanyaan == TipePertanyaan.pertanyaanKartuCabang) {
      state =
          (state as PertanyaanStateKartuCabang).copyWith(dataPertanyaan: temp);
    }
  }

  ubahOrderUrutan(int newIndex, int oldIndex) {
    DataUrutan temp = (state.dataPertanyaan as DataUrutan);
    DataOpsi item = temp.listPilihan.removeAt(oldIndex);
    temp.listPilihan.insert(newIndex, item);
    // state = state.copyWith(dataPertanyaan: temp);
    if (state.tipePertanyaan == TipePertanyaan.pertanyaanKlasik) {
      state = (state as PertanyaanStateKlasik).copyWith(dataPertanyaan: temp);
    } else if (state.tipePertanyaan == TipePertanyaan.pertanyaanKlasikCabang) {
      state =
          (state as PertanyaanStateKlasikCabang).copyWith(dataPertanyaan: temp);
    } else if (state.tipePertanyaan == TipePertanyaan.pertanyaanKartu) {
      state = (state as PertanyaanStateKartu).copyWith(dataPertanyaan: temp);
    } else if (state.tipePertanyaan == TipePertanyaan.pertanyaanKartuCabang) {
      state =
          (state as PertanyaanStateKartuCabang).copyWith(dataPertanyaan: temp);
    }
  }

  gantiCheckBox(bool logic, String value) {
    DataCheckBox temp = (state.dataPertanyaan as DataCheckBox);
    temp.mapCheck[value] = logic;
    // state = state.copyWith(dataPertanyaan: temp);
    if (state.tipePertanyaan == TipePertanyaan.pertanyaanKlasik) {
      state = (state as PertanyaanStateKlasik).copyWith(dataPertanyaan: temp);
    } else if (state.tipePertanyaan == TipePertanyaan.pertanyaanKlasikCabang) {
      state =
          (state as PertanyaanStateKlasikCabang).copyWith(dataPertanyaan: temp);
    } else if (state.tipePertanyaan == TipePertanyaan.pertanyaanKartu) {
      state = (state as PertanyaanStateKartu).copyWith(dataPertanyaan: temp);
    } else if (state.tipePertanyaan == TipePertanyaan.pertanyaanKartuCabang) {
      state =
          (state as PertanyaanStateKartuCabang).copyWith(dataPertanyaan: temp);
    }
  }

  gantiGambarGanda(DataOpsi dataOpsi) {
    DataGambarGanda temp = (state.dataPertanyaan as DataGambarGanda);
    temp.pilihan = dataOpsi;
    // state = state.copyWith(dataPertanyaan: temp);
    if (state.tipePertanyaan == TipePertanyaan.pertanyaanKlasik) {
      state = (state as PertanyaanStateKlasik).copyWith(dataPertanyaan: temp);
    } else if (state.tipePertanyaan == TipePertanyaan.pertanyaanKlasikCabang) {
      state =
          (state as PertanyaanStateKlasikCabang).copyWith(dataPertanyaan: temp);
    } else if (state.tipePertanyaan == TipePertanyaan.pertanyaanKartu) {
      state = (state as PertanyaanStateKartu).copyWith(dataPertanyaan: temp);
    } else if (state.tipePertanyaan == TipePertanyaan.pertanyaanKartuCabang) {
      state =
          (state as PertanyaanStateKartuCabang).copyWith(dataPertanyaan: temp);
    }
  }

  // Widget generateSoal(Widget judulSoal) {
  //   if (state.tipePertanyaan == TipePertanyaan.pembatasPertanyaan) {
  //     return PembatasSoal(state: (state as PembatasState));
  //   } else if (state.tipePertanyaan == TipePertanyaan.pertanyaanKlasikCabang) {
  //     return SoalKlasik(controller: this);
  //   } else {
  //     return SoalKlasik(controller: this);
  //   }
  // }
  Widget generateSoal(Widget judulSoal, bool isCabang, int index, int totalSoal,
      double widthSize) {
    if (state.tipePertanyaan == TipePertanyaan.pembatasPertanyaan) {
      return PembatasSoalBaru(
        state: (state as PembatasState),
        judulSoal: judulSoal,
        width: widthSize,
      );
    } else if (state.tipePertanyaan == TipePertanyaan.pertanyaanKlasikCabang) {
      return SoalKlasik(
        controller: this,
        index: index,
        isCabang: true,
        totalSoal: totalSoal,
      );
    } else {
      return SoalKlasik(
        controller: this,
        index: index,
        isCabang: isCabang,
        totalSoal: totalSoal,
      );
    }
  }

  Widget generateSoalKartu(bool isCabang, int indexSekarang, int totalSoal) {
    final stateKartu = (state as PertanyaanStateKartu);
    if (stateKartu.urlGambar == "urlGambar" || stateKartu.urlGambar == "") {
      return FormKartuXFoto(
        controller: this,
        index: indexSekarang,
        isCabang: isCabang,
        totalSoal: totalSoal,
      );
    } else if (stateKartu.modelSoal == ModelSoal.modelX) {
      return FormKartuX(
        controller: this,
        index: indexSekarang,
        isCabang: isCabang,
        totalSoal: totalSoal,
      );
    } else if (stateKartu.modelSoal == ModelSoal.modelY) {
      return FormKartuY(
        controller: this,
        index: indexSekarang,
        isCabang: isCabang,
        totalSoal: totalSoal,
      );
    } else {
      return FormKartuZ(
        controller: this,
        index: indexSekarang,
        isCabang: isCabang,
        totalSoal: totalSoal,
      );
    }
    // if (isCabang) {
    //   return SizedBox();
    // } else {
    //   final stateKartu = (state as PertanyaanStateKartu);
    //   if (stateKartu.urlGambar == "") {
    //     return FormKartuXFoto(controller: this);
    //   } else if (stateKartu.modelSoal == ModelSoal.modelX) {
    //     return FormKartuX(controller: this);
    //   } else if (stateKartu.modelSoal == ModelSoal.modelY) {
    //     return FormKartuY(controller: this);
    //   } else {
    //     return FormKartuZ(controller: this);
    //   }
    // }
  }

  Map<String, dynamic> getJawabanData() {
    Map<String, dynamic> data = {};
    if (state.tipePertanyaan == TipePertanyaan.pembatasPertanyaan) {
      data = {
        'idSoal': state.dataPertanyaan.idSoal,
        'jawaban': 'pembatas',
        'tipeSoal': 'pembatas'
      };
    } else {
      if (state.dataPertanyaan.tipeSoal.value == "Pilihan Ganda") {
        data = (state.dataPertanyaan as DataPilgan).toMap();
      } else if (state.dataPertanyaan.tipeSoal.value == "Kotak Centang") {
        data = (state.dataPertanyaan as DataCheckBox).toMap();
      } else if (state.dataPertanyaan.tipeSoal.value == "Tanggal") {
        data = (state.dataPertanyaan as DataTanggal).toMap();
      } else if (state.dataPertanyaan.tipeSoal.value == "Waktu") {
        data = (state.dataPertanyaan as DataWaktu).toMap();
      } else if (state.dataPertanyaan.tipeSoal.value == "Slider Angka") {
        data = (state.dataPertanyaan as DataSlider).toMap();
      } else if (state.dataPertanyaan.tipeSoal.value == "Teks") {
        data = (state.dataPertanyaan as DataTeks).toMap();
      } else if (state.dataPertanyaan.tipeSoal.value == "Teks Paragraf") {
        data = (state.dataPertanyaan as DataTeks).toMap();
      } else if (state.dataPertanyaan.tipeSoal.value == "Gambar Ganda") {
        data = (state.dataPertanyaan as DataGambarGanda).toMap();
      } else if (state.dataPertanyaan.tipeSoal.value == "Carousel") {
        data = (state.dataPertanyaan as DataGambarGanda).toMap();
      } else if (state.dataPertanyaan.tipeSoal.value == "Angka") {
        data = (state.dataPertanyaan as DataAngka).toMap();
      } else if (state.dataPertanyaan.tipeSoal.value == "Urutan Pilihan") {
        data = (state.dataPertanyaan as DataUrutan).toMap();
      } else if (state.dataPertanyaan.tipeSoal.value == "Image Picker") {
        data = (state.dataPertanyaan as DataGambar).toMap();
      } else if (state.dataPertanyaan.tipeSoal.value == "Tabel") {
        data = (state.dataPertanyaan as DataTabel).toMap();
      }
    }

    return data;
  }

  DataError cekJawabanWajib() {
    bool isEligible = true;
    String idSoal = "";
    if (state.isWajib) {
      if (state.dataPertanyaan.tipeSoal == Tipesoal.pilihanGanda) {
        DataPilgan temp = (state.dataPertanyaan as DataPilgan);
        if (temp.pilihan.idPilihan == "zxc") {
          isEligible = false;
          idSoal = temp.idSoal;
        }
      } else if (state.dataPertanyaan.tipeSoal == Tipesoal.angka) {
        final temp = (state.dataPertanyaan as DataAngka);
        if (temp.textEditingController.text.isEmpty) {
          isEligible = false;
          idSoal = temp.idSoal;
        }
      } else if (state.dataPertanyaan.tipeSoal == Tipesoal.carousel) {
        DataGambarGanda temp = (state.dataPertanyaan as DataGambarGanda);
        if (temp.pilihan.idPilihan == "zxc") {
          isEligible = false;
          idSoal = temp.idSoal;
        }
      } else if (state.dataPertanyaan.tipeSoal == Tipesoal.imagePicker) {
        DataGambar temp = (state.dataPertanyaan as DataGambar);
        if (temp.urlGambar == "") {
          isEligible = false;
          idSoal = temp.idSoal;
        }
      } else if (state.dataPertanyaan.tipeSoal == Tipesoal.kotakCentang) {
        DataCheckBox temp = (state.dataPertanyaan as DataCheckBox);
        bool pengecekan = false;
        for (final value in temp.mapCheck.values) {
          if (value) {
            pengecekan = value;
            break;
          }
        }
        if (!pengecekan) {
          isEligible = false;
          idSoal = temp.idSoal;
        }
      } else if (state.dataPertanyaan.tipeSoal == Tipesoal.paragraf) {
        DataTeks temp = (state.dataPertanyaan as DataTeks);
        if (temp.textController.text.isEmpty) {
          isEligible = false;
          idSoal = temp.idSoal;
        }
      } else if (state.dataPertanyaan.tipeSoal == Tipesoal.gambarGanda) {
        DataGambarGanda temp = (state.dataPertanyaan as DataGambarGanda);
        if (temp.pilihan.idPilihan == "zxc") {
          isEligible = false;
          idSoal = temp.idSoal;
        }
      } else if (state.dataPertanyaan.tipeSoal == Tipesoal.sliderAngka) {
        DataSlider temp = (state.dataPertanyaan as DataSlider);
      } else if (state.dataPertanyaan.tipeSoal == Tipesoal.tabel) {
        DataTabel temp = (state.dataPertanyaan as DataTabel);
        bool logic = false;
        for (var i = 0; i < temp.baris; i++) {
          for (var j = 0; j < temp.kolom; j++) {
            if (temp.mapController[i]![j].text != "") {
              logic = true;
              break;
            }
          }
        }
        if (!logic) {
          isEligible = false;
          idSoal = temp.idSoal;
        }
      } else if (state.dataPertanyaan.tipeSoal == Tipesoal.tanggal) {
        DataTanggal temp = (state.dataPertanyaan as DataTanggal);
        if (temp.date == null) {
          isEligible = false;
          idSoal = temp.idSoal;
        }
      } else if (state.dataPertanyaan.tipeSoal == Tipesoal.teks) {
        DataTeks temp = (state.dataPertanyaan as DataTeks);
        if (temp.textController.text.isEmpty) {
          isEligible = false;
          idSoal = temp.idSoal;
        }
      } else if (state.dataPertanyaan.tipeSoal == Tipesoal.urutanPilihan) {
        DataUrutan temp = (state.dataPertanyaan as DataUrutan);
      } else if (state.dataPertanyaan.tipeSoal == Tipesoal.waktu) {
        DataWaktu temp = (state.dataPertanyaan as DataWaktu);
        if (temp.waktu == null) {
          isEligible = false;
          idSoal = temp.idSoal;
        }
      }

      return DataError(idSoal: idSoal, isError: isEligible);
    } else {
      return DataError(idSoal: idSoal, isError: isEligible);
    }
  }
}
