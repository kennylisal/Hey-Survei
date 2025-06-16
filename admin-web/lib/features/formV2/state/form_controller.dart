import 'dart:typed_data';

import 'package:aplikasi_admin/features/formV2/constant.dart';

import 'package:aplikasi_admin/features/formV2/data_utility.dart';
import 'package:aplikasi_admin/features/formV2/model/data_error.dart';
import 'package:aplikasi_admin/features/formV2/model/data_soal.dart';
import 'package:aplikasi_admin/features/formV2/state/form_state.dart';
import 'package:aplikasi_admin/features/formV2/state/pertanyaan_controller.dart';
import 'package:aplikasi_admin/features/formV2/state/pertanyaan_state.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

enum CekSoal { soal, batas, none }

class FormController extends StateNotifier<FormStateX> {
  FormController({required FormStateX formKlasikState})
      : super(formKlasikState);

  Map<String, dynamic>? soalCopy;
  bool isLoading = false;
  //Dibawah semua functio dan prosedur
  TextEditingController getJudulController() => state.controllerJudul;
  // TextEditingController getPetunjukController() => state.controllerPetunjuk;

  List<PertanyaanController> getListUtama() => state.listSoalController;
  List<PertanyaanController> getListCabang() => state.listSoalCabang;

  FormStateX getState() => state;

  String getId() => state.idForm;

  HalamanForm getHalaman() => state.halamanForm;

  gantiHalaman(HalamanForm halaman) {
    state = state.copyWith(halamanForm: halaman);
  }

  bool isUrutanKlasikOke(BuildContext context) {
    if (state.listSoalController.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Form Kosong")));
      return false;
    } else if (state.listSoalController[0].getTipePertanyaan() !=
        TipePertanyaan.pembatasPertanyaan) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Form harus diawali dengan pembatas")));
      return false;
    } else {
      CekSoal butuh = CekSoal.none;
      for (var element in state.listSoalController) {
        if (element.getTipePertanyaan() == TipePertanyaan.pembatasPertanyaan) {
          if (butuh == CekSoal.none) {
            butuh = CekSoal.soal;
          } else if (butuh == CekSoal.soal) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Form harus mengikuti format pembatas-soal")));
            return false;
          }
        } else {
          if (butuh == CekSoal.soal) {
            butuh = CekSoal.none;
          }
        }
      }
      if (butuh == CekSoal.none) {
        print("selesai pengecekan urutan");
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Form harus mengikuti format pembatas-soal")));
        return false;
      }
    }
  }

  bool isSeluruhSoalUtamaOke(BuildContext context) {
    DataErrorSoal tempError = DataErrorSoal(pesan: "", isError: false);
    int acc = 0;
    for (var element in state.listSoalController) {
      acc++;
      if (element.getTipePertanyaan() != TipePertanyaan.pembatasPertanyaan) {
        var hasil = element.cekSoal();
        if (hasil.isError) {
          tempError = hasil;
          print(element.getTipeSoal());
          break;
        }
      }
    }
    if (tempError.isError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Pada Komponen Soal ${acc} ${tempError.pesan}")));
      return false;
    } else {
      print("selesai pengecekan utama");
      return true;
    }
  }

  bool isSeluruhSoalCabangOke(BuildContext context) {
    DataErrorSoal tempError = DataErrorSoal(pesan: "", isError: false);
    int acc = 0;
    for (var element in state.listSoalCabang) {
      acc++;

      var hasil = element.cekSoal();
      if (hasil.isError) {
        tempError = hasil;

        break;
      }
    }
    if (tempError.isError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text("Pada Komponen Cabang Soal ${acc} ${tempError.pesan}")));
      return false;
    } else {
      print("selesai pengecekan cabang");
      return true;
    }
  }

  bool isSoalSekarangKartu() {
    return (state.listSoalController[0].getTipePertanyaan() ==
            TipePertanyaan.pertanyaanKartu ||
        state.listSoalController[0].getTipePertanyaan() ==
            TipePertanyaan.pertanyaanKartuCabang);
  }

  isCabangShown() => state.isCabangShown;
  isCabangEmpty() => state.listSoalCabang.isEmpty;

  isiControllerUtama(List<PertanyaanController> list) {
    state = state.copyWith(listSoalController: list);
  }

  isiControllerCabang(List<PertanyaanController> list) {
    state = state.copyWith(listSoalCabang: list);
  }

  refreshUI() {
    state = state.copyWith(listSoalController: [...state.listSoalController]);
  }

  //kartu
  int getIndexUtama() => state.indexUtama;
  int getIndexCabang() =>
      (state.listSoalCabang.isEmpty) ? -1 : state.indexCabang;
  int getLengtUtama() => state.listSoalController.length;
  int getLengtCabang() => state.listSoalCabang.length;
  gantiModelSoal(ModelSoal modelSoal) {
    if (state.isCabangShown) {
      state.listSoalCabang[state.indexCabang].gantiModelSoal(modelSoal);
    } else {
      state.listSoalController[state.indexUtama].gantiModelSoal(modelSoal);
    }
    state = state.copyWith();
  }

  kurangIndexSoal() {
    if (state.isCabangShown) {
      if (state.indexCabang != 0)
        state = state.copyWith(indexCabang: state.indexCabang - 1);
    } else {
      if (state.indexUtama != 0)
        state = state.copyWith(indexUtama: state.indexUtama - 1);
    }
    // state = state.copyWith();
  }

  tambahIndexSoal() {
    if (state.isCabangShown) {
      if (state.indexCabang + 1 < state.listSoalCabang.length)
        state = state.copyWith(indexCabang: state.indexCabang + 1);
    } else {
      if (state.indexUtama + 1 < state.listSoalController.length)
        state = state.copyWith(indexUtama: state.indexUtama + 1);
    }
    state = state.copyWith();
  }

  hapusSoalKartu() {
    if (state.isCabangShown) {
      List<PertanyaanController> myList = List.from(state.listSoalCabang);
      if (state.indexUtama != 0) {
        state.indexUtama--;
      }
      myList.removeAt(state.indexUtama);
      state = state.copyWith(listSoalCabang: myList);
    } else {
      if (state.listSoalController.length > 1) {
        List<PertanyaanController> myList = List.from(state.listSoalController);
        PertanyaanController temp = myList[state.indexUtama];

        if (temp.getTipeSoal() == Tipesoal.pilihanGanda) {
          //dibawah untuk hapus semua cabang
          final dataTemp = temp.state.dataSoal as DataPilgan;
          for (final data in dataTemp.listJawaban) {
            hapusSeluruhCabang(data.idData);
          }
        }
        myList.removeAt(state.indexUtama);
        if (state.indexUtama != 0) {
          state.indexUtama--;
        }
        state = state.copyWith(listSoalController: myList);
      }
    }
  }

  pindahkanIndex(int value) {
    if (state.isCabangShown) {
      state = state.copyWith(indexCabang: value - 1);
      // state.indexCabang = value - 1;
    } else {
      // state.indexUtama = value - 1;
      state = state.copyWith(indexUtama: value - 1);
    }
  }

  pasteSoalKartu(BuildContext context) {
    if (soalCopy == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Belum ada soal yang dipilih")));
    } else {
      final temp = PertanyaanKartuState.fromMap(soalCopy!, this);
      temp.persiapanCopySoal();
      soalCopy = null; //menjaga supaya kosong

      state.listSoalController.add(PertanyaanController(pertanyaanState: temp));
      state.indexUtama = state.listSoalController.length - 1;
      state = state.copyWith(listSoalController: state.listSoalController);
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Berhasil Jiplak Soal")));
  }

  Future<bool> updateFormKartuFlutter(BuildContext context) async {
    try {
      String idTemp = state.idForm;
      print(state.formToMapKartu());
      bool hasil = false;
      final surveiRef =
          FirebaseFirestore.instance.collection('form-kartu').doc(idTemp);
      await surveiRef.update(state.formToMapKartu()).then((value) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Berhasil Update Form")));
        hasil = true;
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Terjadi kesalaha server")));
        hasil = false;
      });
      return hasil;
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Terjadi kesalaha Program")));
      return false;
    }
  }

  Future<bool> updateFormKartuPublish(BuildContext context) async {
    try {
      String idTemp = state.idForm;
      print(state.formToMapKartu());
      bool hasil = false;
      final surveiRef =
          FirebaseFirestore.instance.collection('form-kartu').doc(idTemp);
      await surveiRef.update(state.formToMapKartu()).then((value) {
        hasil = true;
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Terjadi kesalaha server")));
        hasil = false;
      });
      return hasil;
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Terjadi kesalaha Program")));
      return false;
    }
  }

  Future<bool> buatTemplateKartu(BuildContext context, String kategori) async {
    try {
      String idTemp = state.idForm;
      bool hasil = false;
      final surveiRef =
          FirebaseFirestore.instance.collection('form-kartu').doc(idTemp);
      await surveiRef.update(state.formToTemplateKartu(kategori)).then((value) {
        hasil = true;
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Terjadi kesalaha server")));
        hasil = false;
      });
      return hasil;
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Terjadi kesalaha Program")));
      return false;
    }
  }

  Future<bool> buatTemplateKlasik(BuildContext context, String kategori) async {
    try {
      String idTemp = state.idForm;
      bool hasil = false;
      final surveiRef =
          FirebaseFirestore.instance.collection('form-klasik').doc(idTemp);
      await surveiRef.update(<String, dynamic>{
        'judul': controllerJudul.text,
        'petunjuk': 'Ini adalah template untuk survei $kategori',
        'daftarSoal': getDataFormV2(),
        'daftarSoalCabang': getDataForm(TipePertanyaan.pertanyaanKlasikCabang),
        'tglUpdate': Timestamp.now(),
        'isTemplate': true,
        'id_user': FieldValue.delete(),
        'kategori': kategori,
      }).then((value) {
        hasil = true;
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Terjadi kesalaha server")));
        hasil = false;
      });
      return hasil;
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Terjadi kesalaha Program")));
      return false;
    }
  }

  tambahSoalKartu() {
    print("mau tambah soal");
    Map<String, dynamic> mapAwal = {
      "content": [
        {"insert": "Teks Pertanyaan\n"}
      ]
    };
    String idSoal = "Soalx - ${const Uuid().v4().substring(0, 8)}";

    final dTemp = DataOpsi(
      text: "",
      idData: "jawaban - ${const Uuid().v4().substring(0, 8)}",
      textController: TextEditingController(),
    );

    DataPilgan dataAwal = DataPilgan(
      lainnya: false,
      listJawaban: [dTemp],
      tipeSoal: Tipesoal.pilihanGanda,
      idSoal: idSoal,
    );

    final temp = PertanyaanKartuState(
        formController: this,
        urlGambar: "urlGambar",
        quillController: DataUtility()
            .makeQuillController(Delta.fromJson(mapAwal["content"])),
        dataSoal: dataAwal,
        isWajib: false,
        tipePertanyaan: TipePertanyaan.pertanyaanKartu,
        model: ModelSoal.modelX);

    state.listSoalController.add(PertanyaanController(pertanyaanState: temp));
    state = state.copyWith(
      listSoalController: state.listSoalController,
      indexUtama: state.listSoalController.length - 1,
    );
    print(state.listSoalController.length);
  }

  gantiGambarPertanyaanPilihan(BuildContext context) async {
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
      if (state.isCabangShown) {
        state.listSoalCabang[state.indexCabang]
            .gantiGambarKartu(true, urlGambar);
      } else {
        state.listSoalController[state.indexUtama]
            .gantiGambarKartu(false, urlGambar);
      }

      refreshUI();
      // final temp = state as PertanyaanKlasikState;
      // temp.urlGambar = urlGambar;
    } catch (e) {
      print(e);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: const Text("Gagal proses gambar")));
    }
  }
  //

  tambahSoalCabang(
      String idOpsi, String idSoal, String textJawaban, BuildContext context) {
    String idSoalBaru = const Uuid().v4().substring(0, 8);

    Map<String, dynamic> mapAwal = {
      "content": [
        {"insert": "Soal Pertanyaan\n"}
      ]
    };
    final dTemp = DataOpsi(
      text: "",
      idData: "jawaban - ${const Uuid().v4().substring(0, 8)}",
      textController: TextEditingController(),
    );

    DataPilgan dataAwal = DataPilgan(
      lainnya: false,
      listJawaban: [dTemp],
      tipeSoal: Tipesoal.pilihanGanda,
      idSoal: idSoalBaru,
    );
    final target = state.listSoalController
        .firstWhere((element) => element.getIdSoal() == idSoal);
    String kataPertanyaan = target.state.quillController.document.toPlainText();

    if (isSoalSekarangKartu()) {
      final temp = PertanyaanCabangKartuState(
        model: ModelSoal.modelX,
        urlGambar: "",
        quillController: DataUtility()
            .makeQuillController(Delta.fromJson(mapAwal["content"])),
        dataSoal: dataAwal,
        isWajib: false,
        tipePertanyaan: TipePertanyaan.pertanyaanKartuCabang,
        kataJawban: textJawaban,
        idJawabanAsal: idOpsi,
        kataPertanyaan: kataPertanyaan,
        formController: this,
      );
      state.listSoalCabang.add(PertanyaanController(pertanyaanState: temp));
      state = state.copyWith(listSoalCabang: state.listSoalCabang);
    } else {
      final temp = PertanyaanCabangKlasikState(
        formController: this,
        isBergambar: false,
        urlGambar: "urlGambar",
        quillController: DataUtility()
            .makeQuillController(Delta.fromJson(mapAwal["content"])),
        dataSoal: dataAwal,
        isWajib: false,
        tipePertanyaan: TipePertanyaan.pertanyaanKlasikCabang,
        idJawabanAsal: idOpsi,
        kataJawban: textJawaban,
        kataPertanyaan: kataPertanyaan.substring(0, kataPertanyaan.length),
      );
      state.listSoalCabang.add(PertanyaanController(pertanyaanState: temp));
      state = state.copyWith(listSoalCabang: state.listSoalCabang);
    }
  }

  hapusSeluruhCabang(String idJawabanAsal) {
    List<PertanyaanController> myList = List.from(state.listSoalCabang);
    if (isSoalSekarangKartu()) {
      myList.removeWhere(
          (element) => element.getIdAsalCabangKartu() == idJawabanAsal);
    } else {
      myList.removeWhere(
          (element) => element.getIdAsalCabangKlasik() == idJawabanAsal);
    }

    state = state.copyWith(listSoalCabang: myList);
  }

  // hapusSoalCabang(String idSoal) {
  //   List<PertanyaanController> myList = List.from(state.listSoalCabang);
  //   myList.removeWhere((element) => element.getIdAsalCabangKlasik() == idSoal);
  //   state = state.copyWith(listSoalCabang: myList);
  // }

  gantiListDitampilkan() {
    state = state.copyWith(isCabangShown: !state.isCabangShown);
  }

  gantiListDitampilkanKartu(bool logic) {
    state = state.copyWith(isCabangShown: logic);
  }

  updateFormFlutter(BuildContext context) async {
    try {
      String idForm = state.idForm;
      // String idForm = "percobaan pembatas";
      // print(state.formToMapKlasik());
      final surveiRef =
          FirebaseFirestore.instance.collection('form-klasik').doc(idForm);

      await surveiRef.update(state.formToMapKlasik()).then((value) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Berhasil Update Form")));
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Terjadi kesalaha server")));
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Terjadi kesalaha Program")));
    }
  }

  updateFormFlutterTerakhir(BuildContext context) async {
    try {
      String idForm = state.idForm;
      bool hasil = false;
      final surveiRef =
          FirebaseFirestore.instance.collection('form-klasik').doc(idForm);

      await surveiRef.update(state.formToMapKlasik()).then((value) {
        hasil = true;
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Terjadi kesalaha server")));
      });
      return hasil;
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Terjadi kesalaha Program")));
    }
  }

  tukarPosisiSoal(int newIndex, int oldIndex, BuildContext context) {
    // print("ini index baru -> $newIndex & ini index lama $oldIndex");
    // print(
    //     "ini tipe yang kau goyangkan -> ${state.listSoalController[oldIndex].getTipePertanyaan()}");
    try {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      List<PertanyaanController> myList = List.from(state.listSoalController);
      PertanyaanController pertanyaanTarget = myList.removeAt(oldIndex);
      myList.insert(newIndex, pertanyaanTarget);
      state = state.copyWith(listSoalController: myList);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Terjasi Kesalahan Program")));
    }
  }

  simpanSoalClipBoard(String idSoal, BuildContext context) {
    PertanyaanController target = state.listSoalController
        .firstWhere((element) => element.getIdSoal() == idSoal);
    if (target.getTipePertanyaan() == TipePertanyaan.pertanyaanKlasik) {
      soalCopy = (target.state as PertanyaanKlasikState).getSoalData();
    } else if (target.getTipePertanyaan() ==
        TipePertanyaan.pertanyaanKlasikCabang) {
      soalCopy = (target.state as PertanyaanCabangKlasikState).getSoalData();
    } else if (target.getTipePertanyaan() == TipePertanyaan.pertanyaanKartu) {
      soalCopy = (target.state as PertanyaanKartuState).getSoalData();
    }
  }

  pasteSoal(BuildContext context) {
    if (soalCopy == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Belum ada soal yang dipilih")));
    } else {
      final temp = PertanyaanKlasikState.fromMap(soalCopy!, this);
      temp.persiapanCopySoal();
      soalCopy = null; //menjaga supaya kosong

      state.listSoalController.add(PertanyaanController(pertanyaanState: temp));
      state = state.copyWith(listSoalController: state.listSoalController);
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Berhasil Jiplak Soal")));
  }

  tambahSoal() {
    print("mau tambah soal");
    Map<String, dynamic> mapAwal = {
      "content": [
        {"insert": "Teks Pertanyaan\n"}
      ]
    };
    String idSoal = "Soalx - ${const Uuid().v4().substring(0, 8)}";

    final dTemp = DataOpsi(
      text: "",
      idData: "jawaban - ${const Uuid().v4().substring(0, 8)}",
      textController: TextEditingController(),
    );

    DataPilgan dataAwal = DataPilgan(
      lainnya: false,
      listJawaban: [dTemp],
      tipeSoal: Tipesoal.pilihanGanda,
      idSoal: idSoal,
    );

    final temp = PertanyaanKlasikState(
      formController: this,
      isBergambar: false,
      urlGambar: "urlGambar",
      quillController:
          DataUtility().makeQuillController(Delta.fromJson(mapAwal["content"])),
      dataSoal: dataAwal,
      isWajib: false,
      tipePertanyaan: TipePertanyaan.pertanyaanKlasik,
    );

    state.listSoalController.add(PertanyaanController(pertanyaanState: temp));
    state = state.copyWith(listSoalController: state.listSoalController);
  }

  tambahPembatas() {
    Map<String, dynamic> mapAwal = {
      "content": [
        {"insert": "Teks Petunjuk\n"}
      ]
    };
    final controllerBagian = TextEditingController();
    final dataSoal = DataSoal(
        tipeSoal: Tipesoal.angka,
        idSoal: "batas - ${const Uuid().v4().substring(0, 8)}");
    final controller = PertanyaanController(
      pertanyaanState: PembatasState(
          controllerBagian: controllerBagian,
          quillController: DataUtility()
              .makeQuillController(Delta.fromJson(mapAwal["content"])),
          dataSoal: dataSoal,
          isWajib: false,
          tipePertanyaan: TipePertanyaan.pembatasPertanyaan,
          formController: this),
    );
    state.listSoalController.add(controller);
    state = state.copyWith(listSoalController: state.listSoalController);
  }

  hapusPembatas(String idSoal) {
    List<PertanyaanController> myList = List.from(state.listSoalController);
    // PertanyaanController temp =
    //     myList.firstWhere((element) => element.getIdSoal() == idSoal);
    myList.removeWhere((element) => element.getIdSoal() == idSoal);
    state = state.copyWith(listSoalController: myList);
  }

  hapusSoal(String idSoal, bool isCabang) {
    print("Mau hapus $idSoal");
    if (!isCabang) {
      if (state.listSoalController.length > 1) {
        List<PertanyaanController> myList = List.from(state.listSoalController);

        PertanyaanController temp =
            myList.firstWhere((element) => element.getIdSoal() == idSoal);

        if (temp.getTipeSoal() == Tipesoal.pilihanGanda) {
          //dibawah untuk hapus semua cabang
          final dataTemp = temp.state.dataSoal as DataPilgan;
          for (final data in dataTemp.listJawaban) {
            hapusSeluruhCabang(data.idData);
          }
        }
        myList.removeWhere((element) => element.getIdSoal() == idSoal);
        state = state.copyWith(listSoalController: myList);
      }
    } else {
      List<PertanyaanController> myList = List.from(state.listSoalCabang);

      myList.removeWhere((element) => element.getIdSoal() == idSoal);
      state = state.copyWith(listSoalCabang: myList);
    }
  }
}
//dibawah bagian khusus untuk jawaban

  // aturLogicGambar(String idSoal, bool logic, bool isCabang) {
  //   if (!isCabang) {
  //     state.listSoalController
  //         .firstWhere((element) => element.getIdSoal() == idSoal)
  //         .setLogicGambar(logic);
  //     state = state.copyWith(listSoalController: state.listSoalController);
  //   } else {
  //     state.listSoalCabang
  //         .firstWhere((element) => element.getIdSoal() == idSoal)
  //         .setLogicGambar(logic);
  //     state = state.copyWith(listSoalCabang: state.listSoalCabang);
  //   }
  // }
    // aturWajibSoal(bool value, bool isCabang, String idSoal) {
  //   if (!isCabang) {
  //     state.listSoalController
  //         .firstWhere((element) => element.getIdSoal() == idSoal)
  //         .setWajib(value);
  //     state = state.copyWith(listSoalController: state.listSoalController);
  //   } else {
  //     state.listSoalCabang
  //         .firstWhere((element) => element.getIdSoal() == idSoal)
  //         .setWajib(value);
  //     state = state.copyWith(listSoalCabang: state.listSoalCabang);
  //   }
  // }

    // gantiTipeJawaban(String idSoal, Tipesoal tipesoalBaru, bool isCabang) {
  //   if (!isCabang) {
  //     state.listSoalController
  //         .firstWhere((element) => element.getIdSoal() == idSoal)
  //         .gantiTipeJawaban(tipesoalBaru);
  //     state = state.copyWith(listSoalController: state.listSoalController);
  //   } else {
  //     state.listSoalCabang
  //         .firstWhere((element) => element.getIdSoal() == idSoal)
  //         .gantiTipeJawaban(tipesoalBaru);
  //     state = state.copyWith(listSoalCabang: state.listSoalCabang);
  //   }
  // }

  // //pilgan
  // tambahOpsiPilgan(String idSoal, Tipesoal tipesoal, bool isCabang) {
  //   // print("non cabang");
  //   if (!isCabang) {
  //     state.listSoalController
  //         .firstWhere((element) => element.getIdSoal() == idSoal)
  //         .tambahOpsiPilgan(tipesoal);
  //     state = state.copyWith(listSoalController: state.listSoalController);
  //   } else {
  //     // print(idSoal);
  //     state.listSoalCabang
  //         .firstWhere((element) => element.getIdSoal() == idSoal)
  //         .tambahOpsiPilgan(tipesoal);
  //     state = state.copyWith(listSoalCabang: state.listSoalCabang);
  //   }
  // }

  // aktifkanLainnya(String idSoal, bool isCabang, bool logicAktif) {
  //   if (!isCabang) {
  //     state.listSoalController
  //         .firstWhere((element) => element.getIdSoal() == idSoal)
  //         .setLainnya(logicAktif);
  //     state = state.copyWith(listSoalController: state.listSoalController);
  //   } else {
  //     state.listSoalCabang
  //         .firstWhere((element) => element.getIdSoal() == idSoal)
  //         .setLainnya(logicAktif);
  //     state = state.copyWith(listSoalCabang: state.listSoalCabang);
  //   }
  // }

  // hapusOpsiJawaban(
  //     String idSoal, String idOpsi, bool isCabang, Tipesoal tipesoal) {
  //   if (!isCabang) {
  //     state.listSoalController
  //         .firstWhere((element) => element.getIdSoal() == idSoal)
  //         .hapusOpsi(idOpsi, tipesoal);
  //     state = state.copyWith(listSoalController: state.listSoalController);
  //   } else {
  //     state.listSoalCabang
  //         .firstWhere((element) => element.getIdSoal() == idSoal)
  //         .hapusOpsi(idOpsi, tipesoal);
  //     state = state.copyWith(listSoalCabang: state.listSoalCabang);
  //   }
  // }

  // //data urutan
  // tambahOpsiUrutan(String idSoal, Tipesoal tipesoal, bool isCabang) {
  //   if (!isCabang) {
  //     state.listSoalController
  //         .firstWhere((element) => element.getIdSoal() == idSoal)
  //         .tambahOpsiUrutan();
  //     state = state.copyWith(listSoalController: state.listSoalController);
  //   } else {
  //     state.listSoalCabang
  //         .firstWhere((element) => element.getIdSoal() == idSoal)
  //         .tambahOpsiUrutan();
  //     state = state.copyWith(listSoalCabang: state.listSoalCabang);
  //   }
  // }

  // //gambar ganda
  // tambahOpsiGG(String idSoal, Tipesoal tipesoal, bool isCabang) {
  //   if (!isCabang) {
  //     state.listSoalController
  //         .firstWhere((element) => element.getIdSoal() == idSoal)
  //         .tambahOpsiGG(tipesoal);
  //     state = state.copyWith(listSoalController: state.listSoalController);
  //   } else {
  //     state.listSoalCabang
  //         .firstWhere((element) => element.getIdSoal() == idSoal)
  //         .tambahOpsiGG(tipesoal);
  //     state = state.copyWith(listSoalCabang: state.listSoalCabang);
  //   }
  // }

  // gantiUrlGambarPilihan(
  //     String idSoal, String idJawaban, String url, bool isCabang) {
  //   if (!isCabang) {
  //     state.listSoalController
  //         .firstWhere((element) => element.getIdSoal() == idSoal)
  //         .gantiUrlGambarGG(url, idJawaban);
  //     state = state.copyWith(listSoalController: state.listSoalController);
  //   } else {
  //     state.listSoalCabang
  //         .firstWhere((element) => element.getIdSoal() == idSoal)
  //         .gantiUrlGambarGG(url, idJawaban);
  //     state = state.copyWith(listSoalCabang: state.listSoalCabang);
  //   }
  // }

  // //DataSlider
  // updateMinSlider(String idSoal, int value, bool isCabang) {
  //   if (!isCabang) {
  //     state.listSoalController
  //         .firstWhere((element) => element.getIdSoal() == idSoal)
  //         .updateMinSlider(value);
  //     state = state.copyWith(listSoalController: state.listSoalController);
  //   } else {
  //     state.listSoalCabang
  //         .firstWhere((element) => element.getIdSoal() == idSoal)
  //         .updateMinSlider(value);
  //     state = state.copyWith(listSoalCabang: state.listSoalCabang);
  //   }
  // }

  // updateMaxSlider(String idSoal, int value, bool isCabang) {
  //   if (!isCabang) {
  //     state.listSoalController
  //         .firstWhere((element) => element.getIdSoal() == idSoal)
  //         .updateMaxSlider(value);
  //     state = state.copyWith(listSoalController: state.listSoalController);
  //   } else {
  //     state.listSoalCabang
  //         .firstWhere((element) => element.getIdSoal() == idSoal)
  //         .updateMaxSlider(value);
  //     state = state.copyWith(listSoalCabang: state.listSoalCabang);
  //   }
  // }

  // //tabel
  // tambahBarisTabelSoal(String idSoal, bool isCabang) {
  //   if (!isCabang) {
  //     state.listSoalController
  //         .firstWhere((element) => element.getIdSoal() == idSoal)
  //         .tambahBaris();
  //     state = state.copyWith(listSoalController: state.listSoalController);
  //   } else {
  //     state.listSoalCabang
  //         .firstWhere((element) => element.getIdSoal() == idSoal)
  //         .tambahBaris();
  //     state = state.copyWith(listSoalCabang: state.listSoalCabang);
  //   }
  // }

  // kurangBarisTabelSoal(String idSoal, bool isCabang) {
  //   if (!isCabang) {
  //     state.listSoalController
  //         .firstWhere((element) => element.getIdSoal() == idSoal)
  //         .kurangBaris();
  //     state = state.copyWith(listSoalController: state.listSoalController);
  //   } else {
  //     state.listSoalCabang
  //         .firstWhere((element) => element.getIdSoal() == idSoal)
  //         .kurangBaris();
  //     state = state.copyWith(listSoalCabang: state.listSoalCabang);
  //   }
  // }

  // tambahKolomTabelSoal(String idSoal, bool isCabang) {
  //   if (!isCabang) {
  //     state.listSoalController
  //         .firstWhere((element) => element.getIdSoal() == idSoal)
  //         .tambahKolom();
  //     state = state.copyWith(listSoalController: state.listSoalController);
  //   } else {
  //     state.listSoalCabang
  //         .firstWhere((element) => element.getIdSoal() == idSoal)
  //         .tambahKolom();
  //     state = state.copyWith(listSoalCabang: state.listSoalCabang);
  //   }
  // }

  // kurangKolomTabelSoal(String idSoal, bool isCabang) {
  //   if (!isCabang) {
  //     state.listSoalController
  //         .firstWhere((element) => element.getIdSoal() == idSoal)
  //         .kurangKolom();
  //     state = state.copyWith(listSoalController: state.listSoalController);
  //   } else {
  //     state.listSoalCabang
  //         .firstWhere((element) => element.getIdSoal() == idSoal)
  //         .kurangKolom();
  //     state = state.copyWith(listSoalCabang: state.listSoalCabang);
  //   }
  // }

  // aturBerjudulTabelSoal(String idSoal, bool value, bool isCabang) {
  //   if (!isCabang) {
  //     state.listSoalController
  //         .firstWhere((element) => element.getIdSoal() == idSoal)
  //         .switchJudul(value);
  //     state = state.copyWith(listSoalController: state.listSoalController);
  //   } else {
  //     state.listSoalCabang
  //         .firstWhere((element) => element.getIdSoal() == idSoal)
  //         .switchJudul(value);
  //     state = state.copyWith(listSoalCabang: state.listSoalCabang);
  //   }
  // }


  // gantiGambarSoal(String idSoal, BuildContext context, bool isCabang) async {
  //   try {
  //     Uint8List? selectedImageBytes;
  //     String urlGambar = "";
  //     //bagian pilih gambar
  //     FilePickerResult? fileResult = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowMultiple: false,
  //       allowedExtensions: ['jpg', 'jpeg', 'png'],
  //     );
  //     if (fileResult != null) {
  //       // print(fileResult.files.first.size);

  //       selectedImageBytes = fileResult.files.first.bytes;
  //       //Bagian ngeupload gambar
  //       //
  //       String namaBaru = Uuid().v4().substring(0, 11);
  //       firebase_storage.UploadTask uploadTask;

  //       firebase_storage.Reference ref = firebase_storage
  //           .FirebaseStorage.instance
  //           .ref()
  //           .child('form')
  //           .child('/' + namaBaru);

  //       final metaData =
  //           firebase_storage.SettableMetadata(contentType: 'image/jpeg');

  //       uploadTask = ref.putData(selectedImageBytes!, metaData);

  //       await uploadTask.whenComplete(() => null);
  //       urlGambar = await ref.getDownloadURL();

  //       print('uploaded image URL : $urlGambar');
  //       //
  //       //bagian update form
  //       if (!context.mounted) return;
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           content: Text(
  //         "Gambar sedang di-Upload",
  //         style: Theme.of(context).textTheme.displaySmall!.copyWith(
  //               fontSize: 24,
  //               color: Colors.blue,
  //             ),
  //       )));
  //       if (isCabang) {
  //         state.listSoalCabang
  //             .firstWhere((element) => element.getIdSoal() == idSoal)
  //             .aturUrlGambar(urlGambar);
  //         state = state.copyWith(listSoalCabang: state.listSoalCabang);
  //       } else {
  //         state.listSoalController
  //             .firstWhere((element) => element.getIdSoal() == idSoal)
  //             .aturUrlGambar(urlGambar);
  //         state = state.copyWith(listSoalController: state.listSoalController);
  //       }
  //     } else {
  //       if (!context.mounted) return;
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: const Text("Belum ada gambar yang dipilih")));
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }