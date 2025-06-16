import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hei_survei/features/form/constant.dart';
import 'package:hei_survei/features/form/data_utility.dart';
import 'package:hei_survei/features/form/model/data_error.dart';
import 'package:hei_survei/features/form/model/data_soal.dart';
import 'package:hei_survei/features/form/state/form_controller.dart';
import 'package:hei_survei/features/form/state/pertanyaan_state.dart';
import 'package:hei_survei/features/form/widget_jawaban/container_gg.dart';
import 'package:hei_survei/features/form/widget_jawaban/container_jawaban_pilgan.dart';
import 'package:hei_survei/features/form/widget_jawaban/container_urutan.dart';
import 'package:hei_survei/features/form/widget_jawaban/jawaban_angka.dart';
import 'package:hei_survei/features/form/widget_jawaban/jawaban_image_picker.dart';
import 'package:hei_survei/features/form/widget_jawaban/jawaban_paragraf.dart';
import 'package:hei_survei/features/form/widget_jawaban/jawaban_slider.dart';
import 'package:hei_survei/features/form/widget_jawaban/jawaban_tabel.dart';
import 'package:hei_survei/features/form/widget_jawaban/jawaban_tanggal.dart';
import 'package:hei_survei/features/form/widget_jawaban/jawaban_teks.dart';
import 'package:hei_survei/features/form/widget_jawaban/jawaban_waktu.dart';
import 'package:hei_survei/features/preview/data_utility.dart';
import 'package:hei_survei/features/preview/widget_jawaban.dart/container_preview_gg.dart';
import 'package:hei_survei/features/preview/widget_jawaban.dart/container_preview_pilgan.dart';
import 'package:hei_survei/features/preview/widget_jawaban.dart/container_preview_urutan.dart';
import 'package:hei_survei/features/preview/widget_jawaban.dart/preview_jawaban_slider.dart';
import 'package:hei_survei/features/preview/widget_jawaban.dart/preview_jawaban_tabel.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class PertanyaanController extends StateNotifier<PertanyaanState> {
  PertanyaanController({required PertanyaanState pertanyaanState})
      : super(pertanyaanState);

  Tipesoal getTipeSoal() => state.dataSoal.tipeSoal;
  String getIdAsalCabangKlasik() => state.getIdJawabanAsalKlasik();
  String getIdAsalCabangKartu() => state.getIdJawabanAsalKartu();
  bool isCabang() => state.isCabang();
  TipePertanyaan getTipePertanyaan() => state.tipePertanyaan;

  PertanyaanState getState() => state;

  String getUrlGambarKartu() => (state as PertanyaanKartuState).urlGambar;

  //jawaban

  DataErrorSoal cekSoal() {
    if (state.dataSoal.tipeSoal == Tipesoal.pilihanGanda ||
        state.dataSoal.tipeSoal == Tipesoal.kotakCentang) {
      // final hasil = DataErrorSoal(pesan: "", isError: false);
      DataPilgan temp = (state.dataSoal as DataPilgan);
      DataErrorSoal hasil = DataErrorSoal(pesan: "", isError: false);
      hasil = cekListDataKosong(temp.listJawaban);
      if (hasil.isError) return hasil;
      hasil = cekListDuplikat(temp.listJawaban);
      if (hasil.isError) return hasil;
      hasil = cekSoalKosong();
      if (hasil.isError) return hasil;
      return hasil;
    } else if (state.dataSoal.tipeSoal == Tipesoal.gambarGanda ||
        state.dataSoal.tipeSoal == Tipesoal.carousel) {
      DataGambarGanda temp = (state.dataSoal as DataGambarGanda);
      DataErrorSoal hasil = DataErrorSoal(pesan: "", isError: false);
      hasil = cekListDataKosongGG(temp.listDataGambar);
      if (hasil.isError) return hasil;
      hasil = cekListDuplikatGG(temp.listDataGambar);
      if (hasil.isError) return hasil;
      hasil = cekSoalKosong();
      if (hasil.isError) return hasil;
      return hasil;
      // DataGambarGanda
    } else if (state.dataSoal.tipeSoal == Tipesoal.urutanPilihan) {
      DataUrutan temp = (state.dataSoal as DataUrutan);
      DataErrorSoal hasil = DataErrorSoal(pesan: "", isError: false);
      hasil = cekListDataKosong(temp.listDataOpsi);
      if (hasil.isError) return hasil;
      hasil = cekListDuplikat(temp.listDataOpsi);
      if (hasil.isError) return hasil;
      hasil = cekSoalKosong();
      if (hasil.isError) return hasil;
      return hasil;
    } else {
      return DataErrorSoal(pesan: "", isError: false);
    }
  }

  DataErrorSoal cekListDataKosong(List<DataOpsi> list) {
    DataErrorSoal hasil = DataErrorSoal(pesan: "", isError: false);
    for (var element in list) {
      if (element.textController.text == "") {
        print("ini elemen yg bikin masalah -> ${element.text}");
        hasil = DataErrorSoal(pesan: "Terdapat opsi kosong", isError: true);
        break;
      }
    }
    return hasil;
  }

  DataErrorSoal cekListDuplikat(List<DataOpsi> list) {
    DataErrorSoal hasil = DataErrorSoal(pesan: "", isError: false);
    for (var i = 0; i < list.length; i++) {
      for (var j = 0; j < list.length; j++) {
        if (i != j) {
          if (list[i].textController.text == list[j].textController.text) {
            hasil =
                DataErrorSoal(pesan: "Terdapat opsi duplikat", isError: true);
            break;
          }
        }
      }
      if (hasil.isError) break;
    }
    return hasil;
  }

  DataErrorSoal cekListDataKosongGG(List<DataOpsi> list) {
    DataErrorSoal hasil = DataErrorSoal(pesan: "", isError: false);
    for (var element in list) {
      if (element.text == "") {
        print("ini elemen yg bikin masalah -> ${element.text}");
        hasil = DataErrorSoal(pesan: "Terdapat opsi kosong", isError: true);
        break;
      }
    }
    return hasil;
  }

  DataErrorSoal cekListDuplikatGG(List<DataOpsi> list) {
    DataErrorSoal hasil = DataErrorSoal(pesan: "", isError: false);
    for (var i = 0; i < list.length; i++) {
      for (var j = 0; j < list.length; j++) {
        if (i != j) {
          if (list[i].text == list[j].text) {
            hasil =
                DataErrorSoal(pesan: "Terdapat opsi duplikat", isError: true);
            break;
          }
        }
      }
      if (hasil.isError) break;
    }
    return hasil;
  }

  DataErrorSoal cekSoalKosong() {
    DataErrorSoal hasil = DataErrorSoal(pesan: "", isError: false);
    if (state.quillController.document.toDelta().toString().length == 11) {
      hasil = DataErrorSoal(pesan: "Soal pertanyaan kosong", isError: true);
    }
    return hasil;
  }

  TextEditingController getPembatasController() =>
      (state as PembatasState).controllerBagian;

  refreshUI() {
    if (state.tipePertanyaan == TipePertanyaan.pertanyaanKlasik) {
      // state = state.copyWith();
      state = (state as PertanyaanKlasikState).copyWith();
    } else if (state.tipePertanyaan == TipePertanyaan.pertanyaanKlasikCabang) {
      state = (state as PertanyaanCabangKlasikState);
    } else if (state.tipePertanyaan == TipePertanyaan.pertanyaanKartu) {
      state = (state as PertanyaanKartuState);
    } else if (state.tipePertanyaan == TipePertanyaan.pertanyaanKartuCabang) {
      state = (state as PertanyaanCabangKartuState);
    }
  }

  bool isPertanyaanKartu() {
    return (state.tipePertanyaan == TipePertanyaan.pertanyaanKartu ||
        state.tipePertanyaan == TipePertanyaan.pertanyaanKartuCabang);
  }

  //soal standar
  getQController() => state.quillController;
  String getIdSoal() => state.dataSoal.idSoal;
  Widget generateFooterKlasik(BuildContext context, FormController controller) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!isCabang())
            Text(
              "Wajib",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          const SizedBox(width: 8),
          if (!isCabang())
            Switch(
              value: state.isWajib,
              onChanged: (value) {
                setWajib(value);
                controller.refreshUI();
              },
            ),
          const SizedBox(width: 16),
          if (!isCabang())
            IconButton(
              icon: const Icon(Icons.copy_sharp),
              onPressed: () {
                controller.simpanSoalClipBoard(getIdSoal(), context);
              },
            ),
          const Spacer(),
          CircleAvatar(
            radius: 23,
            backgroundColor: Colors.red,
            child: IconButton(
                tooltip: 'hapus pertanyaan',
                onPressed: () {
                  controller.hapusSoal(getIdSoal(), isCabang());
                },
                icon: Icon(
                  Icons.delete,
                  size: 23,
                  color: Colors.white,
                )),
          ),
          // IconButton.filled(
          //   tooltip: "Hapus Pertanyaan",
          //   onPressed: () {
          //     controller.hapusSoal(getIdSoal(), isCabang());
          //   },
          //   icon: const Icon(
          //     Icons.delete_forever_sharp,
          //     size: 28,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget generateText() => Text(getIdSoal());

  Widget generateTipeSoal() => Text(getTipeSoal().value);

  Widget generateFooterKartu(
      BuildContext context, FormController formController) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!isCabang())
            Text(
              "Wajib",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          const SizedBox(width: 8),
          if (!isCabang())
            Switch(
              value: state.isWajib,
              onChanged: (value) {
                setWajib(value);
                formController.refreshUI();
              },
            ),
          const SizedBox(width: 16),
          if (!isCabang())
            IconButton(
              icon: const Icon(Icons.copy_sharp),
              onPressed: () {
                formController.simpanSoalClipBoard(getIdSoal(), context);
              },
            ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget generateWidgetSoalKartu(
      PertanyaanController controller, FormController formController) {
    if (state.dataSoal.tipeSoal == Tipesoal.pilihanGanda) {
      final temp = state.dataSoal.getDataPilgan();

      return ContainerJawabanPilgan(
        listOpsi: DataUtility().generateOpsiJawaban(
          temp.listJawaban,
          controller,
          formController,
        ),
        islainnyaAktif: temp.lainnya,
        controller: controller,
        formController: formController,
      );
    } else if (state.dataSoal.tipeSoal == Tipesoal.kotakCentang) {
      final temp = state.dataSoal.getDataPilgan();

      return ContainerJawabanPilgan(
        listOpsi: DataUtility().generateOpsiJawaban(
          temp.listJawaban,
          controller,
          formController,
        ),
        islainnyaAktif: temp.lainnya,
        controller: controller,
        formController: formController,
      );
    } else if (state.dataSoal.tipeSoal == Tipesoal.sliderAngka) {
      final temp = state.dataSoal.getDataSlider();
      return JawabanSlider(
        dataSlider: temp,
        controller: this,
        formController: formController,
      );
    } else if (state.dataSoal.tipeSoal == Tipesoal.urutanPilihan) {
      final temp = state.dataSoal.getDataUrutan();
      return ContainerUrutanPilihan(
        listOpsi: DataUtility().generateOpsiJawaban(
          temp.listDataOpsi,
          this,
          formController,
        ),
        controller: this,
        formController: formController,
      );
    }
    //tabel & gambar ganda
    else if (state.dataSoal.tipeSoal == Tipesoal.gambarGanda) {
      final temp = state.dataSoal.getDataGG();
      return ContainerGG(
        controller: this,
        listOpsi: DataUtility().generateOpsiGambar(
          temp.listDataGambar,
          this,
          formController,
        ),
        formController: formController,
      );
    } else if (state.dataSoal.tipeSoal == Tipesoal.carousel) {
      final temp = state.dataSoal.getDataGG();
      return ContainerGG(
        controller: this,
        listOpsi: DataUtility().generateOpsiGambar(
          temp.listDataGambar,
          this,
          formController,
        ),
        formController: formController,
      );
    } else if (state.dataSoal.tipeSoal == Tipesoal.tabel) {
      final temp = state.dataSoal.getDataTabel();
      return JawabanTabel(
        controller: this,
        dataTable: temp,
        formController: formController,
      );
    }
    //dibawah semua bagian yg normal
    else if (state.dataSoal.tipeSoal == Tipesoal.teks) {
      return const JawabanTeks();
    } else if (state.dataSoal.tipeSoal == Tipesoal.paragraf) {
      return const JawabanParagraf();
    } else if (state.dataSoal.tipeSoal == Tipesoal.tanggal) {
      return const JawabanTanggal();
    } else if (state.dataSoal.tipeSoal == Tipesoal.waktu) {
      return const JawabanWaktu();
    } else if (state.dataSoal.tipeSoal == Tipesoal.angka) {
      return const JawabanAngka();
    } else if (state.dataSoal.tipeSoal == Tipesoal.imagePicker) {
      return const JawabanImagePicker();
    } else {
      return const SizedBox();
    }
  }

  Widget generateJawabanPreview(PertanyaanController controller) {
    if (state.dataSoal.tipeSoal == Tipesoal.pilihanGanda) {
      final temp = state.dataSoal.getDataPilgan();
      return ContainerPreviewPilgan(
          controller: controller,
          islainnyaAktif: temp.lainnya,
          listOpsi: PreviewDataUtility().generateOpsiJawaban(
            temp.listJawaban,
            controller,
          ));
    } else if (state.dataSoal.tipeSoal == Tipesoal.kotakCentang) {
      final temp = state.dataSoal.getDataPilgan();
      return ContainerPreviewPilgan(
          controller: controller,
          islainnyaAktif: temp.lainnya,
          listOpsi: PreviewDataUtility().generateOpsiJawaban(
            temp.listJawaban,
            controller,
          ));
    } else if (state.dataSoal.tipeSoal == Tipesoal.sliderAngka) {
      final temp = state.dataSoal.getDataSlider();
      return PreviewJawabanSlider(
        dataSlider: temp,
        controller: this,
      );
    } else if (state.dataSoal.tipeSoal == Tipesoal.urutanPilihan) {
      final temp = state.dataSoal.getDataUrutan();
      return PreviewContainerUrutan(
        listOpsi: PreviewDataUtility().generateOpsiJawaban(
          temp.listDataOpsi,
          this,
        ),
        controller: this,
      );
    } else if (state.dataSoal.tipeSoal == Tipesoal.gambarGanda) {
      final temp = state.dataSoal.getDataGG();
      return PreviewContainerGG(
        controller: this,
        listOpsi: PreviewDataUtility().generateOpsiGambar(
          temp.listDataGambar,
          this,
        ),
      );
    } else if (state.dataSoal.tipeSoal == Tipesoal.carousel) {
      final temp = state.dataSoal.getDataGG();
      return PreviewContainerGG(
        controller: this,
        listOpsi: PreviewDataUtility().generateOpsiGambar(
          temp.listDataGambar,
          this,
        ),
      );
    } else if (state.dataSoal.tipeSoal == Tipesoal.tabel) {
      final temp = state.dataSoal.getDataTabel();
      return PreviewJawabanTabel(
        controller: this,
        dataTable: temp,
      );
    } else if (state.dataSoal.tipeSoal == Tipesoal.teks) {
      return const JawabanTeks();
    } else if (state.dataSoal.tipeSoal == Tipesoal.paragraf) {
      return const JawabanParagraf();
    } else if (state.dataSoal.tipeSoal == Tipesoal.tanggal) {
      return const JawabanTanggal();
    } else if (state.dataSoal.tipeSoal == Tipesoal.waktu) {
      return const JawabanWaktu();
    } else if (state.dataSoal.tipeSoal == Tipesoal.angka) {
      return const JawabanAngka();
    } else if (state.dataSoal.tipeSoal == Tipesoal.imagePicker) {
      return const JawabanImagePicker();
    } else {
      return const SizedBox();
    }
  }

  // Widget generateWidgetSoal(PertanyaanController controller) {
  //   if (state.dataSoal.tipeSoal == Tipesoal.pilihanGanda) {
  //     final temp = state.dataSoal.getDataPilgan();

  //     return ContainerJawabanPilgan(
  //       listOpsi: DataUtility().generateOpsiJawaban(
  //         temp.listJawaban,
  //         controller,
  //         state.formController,
  //       ),
  //       islainnyaAktif: temp.lainnya,
  //       controller: controller,
  //     );
  //   } else if (state.dataSoal.tipeSoal == Tipesoal.kotakCentang) {
  //     final temp = state.dataSoal.getDataPilgan();
  //     final controller = this;

  //     return ContainerJawabanPilgan(
  //       listOpsi: DataUtility().generateOpsiJawaban(
  //         temp.listJawaban,
  //         controller,
  //         state.formController,
  //       ),
  //       islainnyaAktif: temp.lainnya,
  //       controller: controller,
  //     );
  //   } else if (state.dataSoal.tipeSoal == Tipesoal.sliderAngka) {
  //     final temp = state.dataSoal.getDataSlider();
  //     return JawabanSlider(dataSlider: temp, controller: this);
  //   } else if (state.dataSoal.tipeSoal == Tipesoal.urutanPilihan) {
  //     final temp = state.dataSoal.getDataUrutan();
  //     return ContainerUrutanPilihan(
  //       listOpsi: DataUtility().generateOpsiJawaban(
  //         temp.listDataOpsi,
  //         this,
  //         state.formController,
  //       ),
  //       controller: this,
  //     );
  //   }
  //   //tabel & gambar ganda
  //   else if (state.dataSoal.tipeSoal == Tipesoal.gambarGanda) {
  //     final temp = state.dataSoal.getDataGG();
  //     return ContainerGG(
  //       controller: this,
  //       listOpsi: DataUtility().generateOpsiGambar(
  //           temp.listDataGambar, this, state.formController),
  //     );
  //   } else if (state.dataSoal.tipeSoal == Tipesoal.carousel) {
  //     final temp = state.dataSoal.getDataGG();
  //     return ContainerGG(
  //       controller: this,
  //       listOpsi: DataUtility().generateOpsiGambar(
  //           temp.listDataGambar, this, state.formController),
  //     );
  //   } else if (state.dataSoal.tipeSoal == Tipesoal.tabel) {
  //     final temp = state.dataSoal.getDataTabel();
  //     return JawabanTabel(controller: this, dataTable: temp);
  //   }
  //   //dibawah semua bagian yg normal
  //   else if (state.dataSoal.tipeSoal == Tipesoal.teks) {
  //     return const JawabanTeks();
  //   } else if (state.dataSoal.tipeSoal == Tipesoal.paragraf) {
  //     return const JawabanParagraf();
  //   } else if (state.dataSoal.tipeSoal == Tipesoal.tanggal) {
  //     return const JawabanTanggal();
  //   } else if (state.dataSoal.tipeSoal == Tipesoal.waktu) {
  //     return const JawabanWaktu();
  //   } else if (state.dataSoal.tipeSoal == Tipesoal.angka) {
  //     return const JawabanAngka();
  //   } else if (state.dataSoal.tipeSoal == Tipesoal.imagePicker) {
  //     return const JawabanImagePicker();
  //   } else {
  //     return const SizedBox();
  //   }
  // }

  //kartu
  gantiModelSoal(ModelSoal modelSoal) {
    if (isCabang()) {
      (state as PertanyaanCabangKartuState).model = modelSoal;
    } else {
      (state as PertanyaanKartuState).model = modelSoal;
    }
    // refreshUI();
  }

  ModelSoal getModelSoal() {
    if (isCabang()) {
      return (state as PertanyaanCabangKartuState).model;
    } else {
      return (state as PertanyaanKartuState).model;
    }
  }

  gantiGambarKartu(bool isCabang, String url) {
    if (isCabang) {
      final temp = state as PertanyaanCabangKartuState;
      temp.urlGambar = url;
    } else {
      final temp = state as PertanyaanKartuState;
      temp.urlGambar = url;
    }
  }
  //

  gantiIdSoal(String idSoal) {
    state.dataSoal.idSoal = idSoal;
  }

  aturUrlGambar(BuildContext context) async {
    try {
      Uint8List? selectedImageBytes;
      String urlGambar = "";
      //bagian pilih gambar
      FilePickerResult? fileResult = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );
      if (fileResult != null) {
        // print(fileResult.files.first.size);

        selectedImageBytes = fileResult.files.first.bytes;
        //Bagian ngeupload gambar
        //
        String namaBaru = Uuid().v4().substring(0, 11);
        firebase_storage.UploadTask uploadTask;

        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('form')
            .child('/' + namaBaru);

        final metaData =
            firebase_storage.SettableMetadata(contentType: 'image/jpeg');

        uploadTask = ref.putData(selectedImageBytes!, metaData);

        await uploadTask.whenComplete(() => null);
        urlGambar = await ref.getDownloadURL();

        print('uploaded image URL : $urlGambar');
        //
        //bagian update form
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          "Gambar sedang di-Upload",
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontSize: 24,
                color: Colors.blue,
              ),
        )));
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text("Belum ada gambar yang dipilih")));
      }
      final temp = state as PertanyaanKlasikState;
      temp.urlGambar = urlGambar;
      state = temp.copyWith(urlGambar: urlGambar);
    } catch (e) {
      print(e);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: const Text("Gagal proses gambar")));
    }
  }

  setLogicGambar(bool value) {
    final temp = state as PertanyaanKlasikState;
    temp.isBergambar = value;
    // state = temp.copyWith(isBergambar: value);
  }

  setWajib(bool value) {
    state.isWajib = value;
    refreshUI();
    // state = state.copyWith(isWajib: value);
  }

  //dibawah semua untuk jawaban
  //kalau ada mau mutasi, lgsg ganti isi list dengan pertanyaanKlasikState (atau kartu) dengan copyWith
  tambahBaris() {
    final temp = state.dataSoal as DataTabel;
    if (temp.baris < 3) {
      temp.baris++;
      // state = state.copyWith(dataSoal: temp);
      refreshUI();
    }
  }

  kurangBaris() {
    final temp = state.dataSoal as DataTabel;
    if (temp.baris > 1) {
      temp.baris--;
      temp.listJudul[temp.baris].text = "Judul ${temp.baris + 1}";
      // state = state.copyWith(dataSoal: temp);
      refreshUI();
    }
  }

  tambahKolom() {
    final temp = state.dataSoal as DataTabel;
    if (temp.kolom < 7) {
      temp.kolom++;
      // state = state.copyWith(dataSoal: temp);
      refreshUI();
    }
  }

  kurangKolom() {
    final temp = state.dataSoal as DataTabel;
    if (temp.kolom > 1) {
      temp.kolom--;
      // state = state.copyWith(dataSoal: temp);
      refreshUI();
    }
  }

  switchJudul(bool logic) {
    final temp = state.dataSoal as DataTabel;
    temp.berjudul = logic;
    // state = state.copyWith(dataSoal: temp);
    refreshUI();
  }

  updateMinSlider(int value) {
    final temp = state.dataSoal as DataSlider;
    temp.min = value;
    // state = state.copyWith(dataSoal: temp);
    refreshUI();
  }

  updateMaxSlider(int value) {
    final temp = state.dataSoal as DataSlider;
    temp.max = value;
    // state = state.copyWith(dataSoal: temp);
    refreshUI();
  }

  tambahOpsiGG(Tipesoal tipesoal) {
    final temp = state.dataSoal as DataGambarGanda;
    DataOpsi dataBaru = DataOpsi(
        text: "",
        idData: const Uuid().v4().substring(0, 8),
        textController: TextEditingController());

    temp.listDataGambar.add(dataBaru);
    // state = state.copyWith(dataSoal: temp);
    refreshUI();
  }

  gantiUrlGambarGG(String url, String idJawaban) {
    final temp = state.dataSoal as DataGambarGanda;
    temp.listDataGambar
        .firstWhere((element) => element.idData == idJawaban)
        .text = url;
    // state = state.copyWith(dataSoal: temp);
    refreshUI();
  }

  tambahOpsiPilgan(Tipesoal tipesoal) {
    final temp = state.dataSoal as DataPilgan;
    DataOpsi dataBaru = DataOpsi(
        text: "",
        idData: const Uuid().v4().substring(0, 8),
        textController: TextEditingController());
    temp.listJawaban.add(dataBaru);
    refreshUI();
  }

  setLainnya(bool logic) {
    final temp = state.dataSoal as DataPilgan;
    temp.lainnya = logic;
    refreshUI();
    // state = state.copyWith(dataSoal: temp);
  }

  hapusOpsi(String idOpsi, Tipesoal tipesoal) {
    if (tipesoal == Tipesoal.pilihanGanda ||
        tipesoal == Tipesoal.kotakCentang) {
      final temp = state.dataSoal as DataPilgan;
      if (temp.listJawaban.length > 1) {
        state.formController.hapusSeluruhCabang(idOpsi);
        temp.listJawaban.removeWhere((element) => element.idData == idOpsi);
      }
    } else if (tipesoal == Tipesoal.urutanPilihan) {
      final temp = state.dataSoal as DataUrutan;
      if (temp.listDataOpsi.length > 1) {
        temp.listDataOpsi.removeWhere((element) => element.idData == idOpsi);
        // state = state.copyWith(dataSoal: temp);
      }
    } else if (tipesoal == Tipesoal.gambarGanda ||
        tipesoal == Tipesoal.carousel) {
      final temp = state.dataSoal as DataGambarGanda;
      if (temp.listDataGambar.length > 1) {
        temp.listDataGambar.removeWhere((element) => element.idData == idOpsi);

        // state = state.copyWith(dataSoal: temp);
      }
    }
    refreshUI();
  }

  DataOpsi tambahOpsiUrutan() {
    final temp = state.dataSoal as DataUrutan;
    DataOpsi dataBaru = DataOpsi(
        text: "",
        idData: const Uuid().v4().substring(0, 8),
        textController: TextEditingController());
    temp.listDataOpsi.add(dataBaru);
    refreshUI();
    return dataBaru;
    // state = state.copyWith(dataSoal: temp);
  }

  gantiTipeJawaban(Tipesoal tipesoalBaru) {
    if (state.dataSoal.tipeSoal == Tipesoal.pilihanGanda && !state.isCabang()) {
      state.formController.hapusSeluruhCabang(state.dataSoal.idSoal);
    }
    if (tipesoalBaru == Tipesoal.pilihanGanda) {
      final dTemp = DataOpsi(
        text: "",
        idData: "jawaban - ${const Uuid().v4().substring(0, 8)}",
        textController: TextEditingController(),
      );

      DataPilgan dataPilgan = DataPilgan(
        lainnya: false,
        listJawaban: [dTemp],
        tipeSoal: tipesoalBaru,
        idSoal: state.dataSoal.idSoal,
      );
      state.dataSoal = dataPilgan;
      // state = getPertanyaanKlasik().copyWith(dataSoal: dataPilgan);
    } else if (tipesoalBaru == Tipesoal.kotakCentang) {
      final dTemp = DataOpsi(
        text: "",
        idData: "jawaban - ${const Uuid().v4().substring(0, 8)}",
        textController: TextEditingController(),
      );
      DataPilgan dataPilgan = DataPilgan(
        lainnya: false,
        listJawaban: [dTemp],
        tipeSoal: tipesoalBaru,
        idSoal: state.dataSoal.idSoal,
      );
      // state = state.copyWith(dataSoal: dataPilgan);
      state.dataSoal = dataPilgan;
      // state = getPertanyaanKlasik().copyWith(dataSoal: dataPilgan);
    } else if (tipesoalBaru == Tipesoal.sliderAngka) {
      DataSlider dataSlider = DataSlider(
        min: 1,
        max: 10,
        labelMin: TextEditingController(),
        labelMax: TextEditingController(),
        idSoal: state.dataSoal.idSoal,
        tipeSoal: tipesoalBaru,
      );
      state.dataSoal = dataSlider;
      // state = getPertanyaanKlasik().copyWith(dataSoal: dataSlider);
    } else if (tipesoalBaru == Tipesoal.tabel) {
      DataTabel dataTabel = DataTabel(
        tipeSoal: Tipesoal.tabel,
        idSoal: state.dataSoal.idSoal,
        kolom: 1,
        baris: 3,
        listJudul: [
          TextEditingController(
            text: "Judul 1",
          ),
          TextEditingController(
            text: "Judul 2",
          ),
          TextEditingController(
            text: "Judul 3",
          ),
        ],
      );
      state.dataSoal = dataTabel;
      // state = getPertanyaanKlasik().copyWith(dataSoal: dataTabel);
    } else if (tipesoalBaru == Tipesoal.gambarGanda) {
      final dTemp = DataOpsi(
        text: "",
        idData: "jawaban - ${const Uuid().v4().substring(0, 8)}",
        textController: TextEditingController(),
      );
      DataGambarGanda dataGambarGanda = DataGambarGanda(
        tipeSoal: tipesoalBaru,
        idSoal: state.dataSoal.idSoal,
        listDataGambar: [dTemp],
      );
      state.dataSoal = dataGambarGanda;
      // state = getPertanyaanKlasik().copyWith(dataSoal: dataGambarGanda);
    } else if (tipesoalBaru == Tipesoal.carousel) {
      final dTemp = DataOpsi(
        text: "",
        idData: "jawaban - ${const Uuid().v4().substring(0, 8)}",
        textController: TextEditingController(),
      );
      DataGambarGanda dataGambarGanda = DataGambarGanda(
        tipeSoal: tipesoalBaru,
        idSoal: state.dataSoal.idSoal,
        listDataGambar: [dTemp],
      );
      state.dataSoal = dataGambarGanda;
      // state = getPertanyaanKlasik().copyWith(dataSoal: dataGambarGanda);
    } else if (tipesoalBaru == Tipesoal.urutanPilihan) {
      final dTemp = DataOpsi(
        text: "",
        idData: "jawaban - ${const Uuid().v4().substring(0, 8)}",
        textController: TextEditingController(),
      );
      final dataUrutan = DataUrutan(
        tipeSoal: tipesoalBaru,
        idSoal: state.dataSoal.idSoal,
        listDataOpsi: [dTemp],
      );
      state.dataSoal = dataUrutan;
      // state = getPertanyaanKlasik().copyWith(dataSoal: dataUrutan);
    } else {
      DataSoal dataSoal =
          DataSoal(tipeSoal: tipesoalBaru, idSoal: state.dataSoal.idSoal);
      state.dataSoal = dataSoal;
      // state = state.copyWith(dataSoal: dataS oal);
    }
  }

  gantiTipeJawabanKlasik(Tipesoal tipesoalBaru, FormController formController) {
    if (state.dataSoal.tipeSoal == Tipesoal.pilihanGanda && !state.isCabang()) {
      final temp = state.dataSoal as DataPilgan;
      for (var element in temp.listJawaban) {
        formController.hapusSeluruhCabang(element.idData);
      }
    }
    if (tipesoalBaru == Tipesoal.pilihanGanda) {
      final dTemp = DataOpsi(
        text: "",
        idData: "jawaban - ${const Uuid().v4().substring(0, 8)}",
        textController: TextEditingController(),
      );

      DataPilgan dataPilgan = DataPilgan(
        lainnya: false,
        listJawaban: [dTemp],
        tipeSoal: tipesoalBaru,
        idSoal: state.dataSoal.idSoal,
      );
      state.dataSoal = dataPilgan;
      // state = getPertanyaanKlasik().copyWith(dataSoal: dataPilgan);
    } else if (tipesoalBaru == Tipesoal.kotakCentang) {
      final dTemp = DataOpsi(
        text: "",
        idData: "jawaban - ${const Uuid().v4().substring(0, 8)}",
        textController: TextEditingController(),
      );
      DataPilgan dataPilgan = DataPilgan(
        lainnya: false,
        listJawaban: [dTemp],
        tipeSoal: tipesoalBaru,
        idSoal: state.dataSoal.idSoal,
      );
      // state = state.copyWith(dataSoal: dataPilgan);
      state.dataSoal = dataPilgan;
      // state = getPertanyaanKlasik().copyWith(dataSoal: dataPilgan);
    } else if (tipesoalBaru == Tipesoal.sliderAngka) {
      DataSlider dataSlider = DataSlider(
        min: 1,
        max: 10,
        labelMin: TextEditingController(),
        labelMax: TextEditingController(),
        idSoal: state.dataSoal.idSoal,
        tipeSoal: tipesoalBaru,
      );
      state.dataSoal = dataSlider;
      // state = getPertanyaanKlasik().copyWith(dataSoal: dataSlider);
    } else if (tipesoalBaru == Tipesoal.tabel) {
      DataTabel dataTabel = DataTabel(
        tipeSoal: Tipesoal.tabel,
        idSoal: state.dataSoal.idSoal,
        kolom: 1,
        baris: 3,
        listJudul: [
          TextEditingController(
            text: "Judul 1",
          ),
          TextEditingController(
            text: "Judul 2",
          ),
          TextEditingController(
            text: "Judul 3",
          ),
        ],
      );
      state.dataSoal = dataTabel;
      // state = getPertanyaanKlasik().copyWith(dataSoal: dataTabel);
    } else if (tipesoalBaru == Tipesoal.gambarGanda) {
      final dTemp = DataOpsi(
        text: "",
        idData: "jawaban - ${const Uuid().v4().substring(0, 8)}",
        textController: TextEditingController(),
      );
      DataGambarGanda dataGambarGanda = DataGambarGanda(
        tipeSoal: tipesoalBaru,
        idSoal: state.dataSoal.idSoal,
        listDataGambar: [dTemp],
      );
      state.dataSoal = dataGambarGanda;
      // state = getPertanyaanKlasik().copyWith(dataSoal: dataGambarGanda);
    } else if (tipesoalBaru == Tipesoal.carousel) {
      final dTemp = DataOpsi(
        text: "",
        idData: "jawaban - ${const Uuid().v4().substring(0, 8)}",
        textController: TextEditingController(),
      );
      DataGambarGanda dataGambarGanda = DataGambarGanda(
        tipeSoal: tipesoalBaru,
        idSoal: state.dataSoal.idSoal,
        listDataGambar: [dTemp],
      );
      state.dataSoal = dataGambarGanda;
      // state = getPertanyaanKlasik().copyWith(dataSoal: dataGambarGanda);
    } else if (tipesoalBaru == Tipesoal.urutanPilihan) {
      final dTemp = DataOpsi(
        text: "",
        idData: "jawaban - ${const Uuid().v4().substring(0, 8)}",
        textController: TextEditingController(),
      );
      final dataUrutan = DataUrutan(
        tipeSoal: tipesoalBaru,
        idSoal: state.dataSoal.idSoal,
        listDataOpsi: [dTemp],
      );
      state.dataSoal = dataUrutan;
      // state = getPertanyaanKlasik().copyWith(dataSoal: dataUrutan);
    } else {
      DataSoal dataSoal =
          DataSoal(tipeSoal: tipesoalBaru, idSoal: state.dataSoal.idSoal);
      state.dataSoal = dataSoal;
      // state = state.copyWith(dataSoal: dataS oal);
    }
  }
}


  // factory PertanyaanController.copyPertanyaan(
  //     PertanyaanController pertanyaanController) {
  //   late PertanyaanState state;
  //   if (pertanyaanController.getTipePertanyaan() == TipePertanyaan.pertanyaanKlasik) {

  //   }
  //   else{
  //     state = pertanyaanController.getState()
  //   }
  //   // PertanyaanKlasikState getPertanyaanKlasik() =>
  //   //     (state as PertanyaanKlasikState);

  //   // PertanyaanCabangKlasikState getPertanyaanCabangKlasik() =>
  //   //     (state as PertanyaanCabangKlasikState);

  //   // PertanyaanKartuState getPertanyaanKartu() => (state as PertanyaanKartuState);

  //   // PertanyaanCabangKartuState gerPertanyaanCabangKartu() =>
  //   //     (state as PertanyaanCabangKartuState);
  //   // final state = pertanyaanController.getPertanyaanKlasik();
  //   state.persiapanCopySoal();
  //   return PertanyaanController(pertanyaanState: state);
  // }

    //

  //klasik
  // isBergambar() => (state as PertanyaanKlasikState).isBergambar;
  // getUrlGambar() => (state as PertanyaanKlasikState).urlGambar;
  //

  //cabang klasik
  // String getKataPertanyaan() {
  //   return (state as PertanyaanCabangKlasikState).kataPertanyaan;
  // }

  // String getKataJawaban() {
  //   final temp = (state as PertanyaanCabangKlasikState);
  //   return temp.kataJawban;
  // }
  //
