import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:survei_aplikasi/constants.dart';
import 'package:survei_aplikasi/features/form_kartu/state/state_form_kartu.dart';
import 'package:survei_aplikasi/features/form_kartu/widgets/judul_form_kartu_kotak.dart';
import 'package:survei_aplikasi/features/form_klasik/constant.dart';
import 'package:survei_aplikasi/features/form_klasik/models/data_error.dart';
import 'package:survei_aplikasi/features/form_klasik/models/data_pertanyaan.dart';
import 'package:survei_aplikasi/features/form_klasik/state/controller_pertanyaan.dart';
import 'package:survei_aplikasi/utils/shared_pref.dart';
import 'package:uuid/uuid.dart';

class FormKartuController extends StateNotifier<FormKartuState> {
  FormKartuController({required FormKartuState formKartu}) : super(formKartu);
  int indexSoal = 0;
  int indexSoalCabang = 0;
  bool isCabangShown = false;
  List<PertanyaanController> listCabangTampilan = [];
  int totalSoalUtama = -1;
  int totalSoalCabang = -1;
  bool isSelesai = false;
  int insentifSurvei = 0;

  prosesPenyelesaian() {
    isSelesai = true;
    state = state.copyWith();
  }

  String getJudul() => state.judul;

  getIndex() => indexSoal;

  Widget generateJudul() {
    if (indexSoal == 0) {
      return JudulFormKartuKotak(judul: state.judul, petunjuk: state.deskripsi);
    } else {
      return JudulFormKartuKotakFalse(
          judul: state.judul, petunjuk: state.deskripsi);
    }
  }

  Widget generateTombolBawah(
      BuildContext context, String idSurvei, String emailUser) {
    if (indexSoal == 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800),
              onPressed: () {
                try {
                  tambahIndex(context, idSurvei, emailUser);
                } catch (e) {
                  log(e.toString());
                }
              },
              icon: const Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
              label: Text(
                "Lanjut",
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
              )),
          const SizedBox(width: 10),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton.filled(
              onPressed: () {
                try {
                  kurangIndex();
                } catch (e) {
                  log(e.toString());
                }
              },
              icon: Icon(Icons.chevron_left)),
          const Spacer(),
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800),
              onPressed: () => tambahIndex(context, idSurvei, emailUser),
              icon: Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
              label: Text(
                "Lanjut",
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
              )),
          const SizedBox(width: 10),
        ],
      );
    }
  }

  DataError cekError() {
    DataError isElligible = DataError(idSoal: "", isError: true);
    for (var i = 0; i < state.listDataPertanyaan.length; i++) {
      if (state.listDataPertanyaan[i].cekJawabanWajib().isError == false) {
        isElligible = state.listDataPertanyaan[i].cekJawabanWajib();
        break;
      }
    }
    return isElligible;
  }

  DataError cekErrorCabang() {
    DataError isElligible = DataError(idSoal: "", isError: true);
    for (var i = 0; i < listCabangTampilan.length; i++) {
      if (listCabangTampilan[i].cekJawabanWajib().isError == false) {
        isElligible = listCabangTampilan[i].cekJawabanWajib();
        break;
      }
    }
    // print(isElligible);
    return isElligible;
  }

  tambahIndex(
      BuildContext context, String idSurvei, String emailPenjawab) async {
    if (!isCabangShown) {
      //bikin pengecekan
      //masuk cabang
      if ((indexSoal + 1) == totalSoalUtama) {
        DataError isElligible = cekError();
        if (isElligible.isError == false) {
          int indexSalah = state.listDataPertanyaan.indexWhere(
              (element) => element.getIdSoal() == isElligible.idSoal);
          indexSoal = indexSalah;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
            "Lengkapi dahulu jawabannnya",
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(fontSize: 18, color: Colors.white),
          )));
        } else {
          if (state.listDataPertanyaanCabang.isEmpty) {
            //Kirim jawaban==========================================
            final hasil = await submitJawaban(idSurvei, emailPenjawab);
            if (!context.mounted) return;
            if (hasil) {
              prosesPenyelesaian();
              // context.pushNamed(RouteConstant.home);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                "Gagal Mengirim jawaban",
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(fontSize: 18, color: Colors.white),
              )));
            }
          } else {
            //cari cabang
            listCabangTampilan = cariSoalCabang();
            totalSoalCabang = listCabangTampilan.length;
            if (listCabangTampilan.isEmpty) {
              //Kirim jawaban==========================================
              final hasil = await submitJawaban(idSurvei, emailPenjawab);
              if (!context.mounted) return;
              if (hasil) {
                prosesPenyelesaian();
                // context.pushNamed(RouteConstant.home);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                  "Gagal Mengirim jawaban",
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(fontSize: 18, color: Colors.white),
                )));
              }
            } else {
              isCabangShown = true;
            }
          }
        }
      } else {
        indexSoal++;
      }
    } else {
      if ((indexSoalCabang + 1) == totalSoalCabang) {
        //cek error
        //jika tidak error submit
        DataError isElligible = cekErrorCabang();
        if (isElligible.isError == false) {
          int indexSalah = listCabangTampilan.indexWhere(
              (element) => element.getIdSoal() == isElligible.idSoal);
          indexSoalCabang = indexSalah;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
            "Lengkapi dahulu jawabannnya",
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(fontSize: 18, color: Colors.white),
          )));
        } else {
          //Kirim jawaban==========================================
          final hasil = await submitJawaban(idSurvei, emailPenjawab);
          if (!context.mounted) return;
          if (hasil) {
            prosesPenyelesaian();
            // context.pushNamed(RouteConstant.home);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
              "Gagal Mengirim jawaban",
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontSize: 18, color: Colors.white),
            )));
          }
        }
      } else {
        indexSoalCabang++;
      }
    }
    state = state.copyWith();
  }

  kurangIndex() {
    if (!isCabangShown) {
      if (indexSoal > 0) {
        indexSoal--;
      }
    } else {
      if (indexSoalCabang > 0) {
        indexSoalCabang--;
      } else {
        isCabangShown = false;
      }
    }
    state = state.copyWith();
  }

  List<Widget> generateKonten(
      BuildContext context, String idSurvei, String emailUser) {
    if (isCabangShown) {
      final temp = listCabangTampilan[indexSoalCabang];
      return [
        generateJudul(),
        temp.generateSoalKartu(true, 0, 0),
        generateTombolBawah(context, idSurvei, emailUser),
        const SizedBox(height: 10),
      ];
    } else {
      final temp = state.listDataPertanyaan[indexSoal];
      //indexSoal /
      return [
        generateJudul(),
        temp.generateSoalKartu(false, indexSoal, totalSoalUtama),
        generateTombolBawah(context, idSurvei, emailUser),
        const SizedBox(height: 10),
      ];
    }
  }

  List<PertanyaanController> cariSoalCabang() {
    List<PertanyaanController> listTemp = [];
    for (var e in state.listDataPertanyaan) {
      if (e.getTipeSoal() == Tipesoal.pilihanGanda) {
        DataPilgan temp = (e.getDataPertanyaan() as DataPilgan);
        final idTarget = temp.pilihan.idPilihan;
        for (var element in state.listDataPertanyaanCabang) {
          if (element.getIdAsalCabangKartu() == idTarget) {
            listTemp.add(element);
          }
        }
      }
    }
    return listTemp;
  }

  Future<bool> submitJawaban(String idSurvei, String emailPenjawab) async {
    try {
      var batch = FirebaseFirestore.instance.batch();
      int insentif = 0;

      Map<String, dynamic> hSurveiData = {};
      // Map<String, dynamic> dSurveiData = {};

      final surveiRef =
          FirebaseFirestore.instance.collection('h_survei').doc(idSurvei);

      await surveiRef.get().then((value) {
        hSurveiData = value.data()!;
      }).onError((error, stackTrace) {
        print(error);
      });

      if (hSurveiData['status'] == "aktif") {
        insentif = hSurveiData['insentifPerPartisipan'] as int;

        //tambahpartisipan
        batch.update(
            FirebaseFirestore.instance.collection('h_survei').doc(idSurvei),
            {'jumlahPartisipan': (hSurveiData['jumlahPartisipan'] as int) + 1});

        if (((hSurveiData['jumlahPartisipan'] as int) + 1) ==
            (hSurveiData['batasPartisipan'] as int)) {
          batch.update(
              FirebaseFirestore.instance.collection('h_survei').doc(idSurvei),
              {'status': 'selesai'});
        }
        final idBaru = const Uuid().v4().substring(0, 8);
        final idUser = SharedPrefs.getString(prefUserid) ?? '8c6639a';
        var jawabanSurvei = state.formToMap();

        jawabanSurvei['idForm'] = state.idForm;
        jawabanSurvei['idSurvei'] = idSurvei;
        jawabanSurvei['tglPengisian'] = Timestamp.now();
        jawabanSurvei['idUser'] = idUser;
        jawabanSurvei['emailPenjawab'] = emailPenjawab;
        jawabanSurvei['insentif'] = insentif;

        insentifSurvei = insentif;
        batch.set(
          FirebaseFirestore.instance
              .collection('jawaban-survei-v3')
              .doc(idBaru),
          jawabanSurvei,
        );
        batch.update(
            FirebaseFirestore.instance.collection('Users-survei').doc(idUser),
            {'poin': FieldValue.increment(insentif)});
        print("------- Tambah poin user");
        //
        await batch.commit();
        print("Berhasil proses jawaban id Baru -> $idBaru");

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
