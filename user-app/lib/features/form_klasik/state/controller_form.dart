// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:survei_aplikasi/features/app/router/router_constant.dart';
import 'package:survei_aplikasi/features/form_klasik/constant.dart';
import 'package:survei_aplikasi/features/form_klasik/models/data_pertanyaan.dart';
import 'package:survei_aplikasi/features/form_klasik/widgets_atas_form/judul_form.dart';
import 'package:uuid/uuid.dart';

import 'package:survei_aplikasi/constants.dart';
import 'package:survei_aplikasi/features/form_klasik/state/controller_pertanyaan.dart';
import 'package:survei_aplikasi/features/form_klasik/state/state_form.dart';
import 'package:survei_aplikasi/utils/shared_pref.dart';

class FormController extends StateNotifier<FormStateX> {
  FormController({required FormStateX formStateX}) : super(formStateX);
  int indexSoal = 0;
  int jumlahBagian = -1;
  int jumlahPertanyaan = -1;
  bool isCabangShown = false;
  List<PertanyaanController> listUtamaTampilan = [];
  List<PertanyaanController> listCabangTampilan = [];
  //dibawah yang seru
  Map<int, List<int>> pembagianSoal = {};
  List<PertanyaanController> getListUtama() => state.listDataPertanyaan;
  String getJudul() => state.judul;

  //dibawah bagian penyelesaian form
  bool isSelesai = false;
  int insentifSurvei = 0;

  tunjukkanHasil() {
    print(state.formToMap());
  }

  prosesPenyelesaian() {
    isSelesai = true;
    state = state.copyWith();
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
                  majuHalaman(context, idSurvei, emailUser);
                } catch (e) {
                  log(e.toString());
                }
              },
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
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton.filled(
              onPressed: () {
                try {
                  kebelakangHalaman();
                } catch (e) {
                  log(e.toString());
                }
              },
              icon: const Icon(Icons.chevron_left)),
          const Spacer(),
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800),
              onPressed: () {
                try {
                  majuHalaman(context, idSurvei, emailUser);
                } catch (e) {
                  log(e.toString());
                }
              },
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

  List<PertanyaanController> cariSoalCabang() {
    List<PertanyaanController> listTemp = [];
    for (var e in state.listDataPertanyaan) {
      if (e.getTipeSoal() == Tipesoal.pilihanGanda) {
        DataPilgan temp = (e.getDataPertanyaan() as DataPilgan);
        final idTarget = temp.pilihan.idPilihan;
        for (var element in state.listDataPertanyaanCabang) {
          if (element.getIdAsalCabangKlasik() == idTarget) {
            listTemp.add(element);
          }
        }
      }
    }
    return listTemp;
  }

  majuHalaman(BuildContext context, String idSurvei, String emailUser) async {
    //jika halaman cabang
    if (isCabangShown) {
      bool isEligible = true;
      int catatan = -1;
      for (var i = 0; i < listCabangTampilan.length; i++) {
        final error = listCabangTampilan[i].cekJawabanWajib();
        if (!error.isError) {
          catatan = i;
          isEligible = false;
          break;
        }
      }
      if (isEligible) {
        //Kirim jawaban==========================================
        final hasil = await submitJawaban(idSurvei, emailUser);
        if (hasil) {
          prosesPenyelesaian();
        } else {
          if (!context.mounted) return;
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          "Pertanyaan ke ${catatan + 1} belum terisi",
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(fontSize: 18, color: Colors.white),
        )));
      }
    }
    //jika halaman biasa
    else {
      bool isEligible = true;
      int catatan = -1;
      for (var i = 0; i < listUtamaTampilan.length; i++) {
        if (listUtamaTampilan[i].getTipePertanyaan() !=
            TipePertanyaan.pembatasPertanyaan) {
          final error = listUtamaTampilan[i].cekJawabanWajib();
          if (!error.isError) {
            catatan = i;
            isEligible = false;
            break;
          }
        }
      }
      if (isEligible) {
        if ((indexSoal + 1) == jumlahBagian) {
          if (state.listDataPertanyaanCabang.isEmpty) {
            //Kirim jawaban==========================================
            final hasil = await submitJawaban(idSurvei, emailUser);

            if (hasil) {
              prosesPenyelesaian();
            } else {
              if (!context.mounted) return;
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
            print("masuk cabang");
            listCabangTampilan = cariSoalCabang();
            if (listCabangTampilan.isEmpty) {
              //Kirim jawaban==========================================
              final hasil = await submitJawaban(idSurvei, emailUser);

              if (hasil) {
                prosesPenyelesaian();
              } else {
                if (!context.mounted) return;
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
        } else {
          indexSoal++;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          "Pertanyaan ke ${catatan} belum terisi",
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(fontSize: 18, color: Colors.white),
        )));
      }
    }
    state = state.copyWith();
  }

  kebelakangHalaman() {
    if (!isCabangShown) {
      if (indexSoal > 0) {
        indexSoal--;
      }
    } else {
      isCabangShown = false;
    }
    state = state.copyWith();
  }

  int generateJumlahSoalSebelumnya() {
    if (indexSoal == 0) {
      return 0;
    } else {
      int acc = 0;
      for (int i = 0; i < indexSoal; i++) {
        acc += pembagianSoal[indexSoal - 1]!.length;
      }
      return acc;
    }
  }

  int generateNomorAwal() {
    if (indexSoal == 0) {
      return 0;
    } else {
      print(generateJumlahSoalSebelumnya() - indexSoal);
      return generateJumlahSoalSebelumnya() - indexSoal;
    }
  }

  List<Widget> generateKonten(BuildContext context, String idSurvei,
      String emailUser, Widget judulSoal, double widthSize) {
    if (!isCabangShown) {
      List<int> indexTampilan = pembagianSoal[indexSoal]!;
      List<PertanyaanController> temp =
          List.generate(indexTampilan.length, (index) {
        int angka = indexTampilan[index];
        return state.listDataPertanyaan[angka];
      });
      listUtamaTampilan = temp;
      int nomorAwal = generateNomorAwal();
      return [
        for (int i = 0; i < listUtamaTampilan.length; i++)
          listUtamaTampilan[i].generateSoal(
            judulSoal,
            false,
            (nomorAwal + i),
            jumlahPertanyaan,
            widthSize,
          ),
        generateTombolBawah(context, idSurvei, emailUser),
        const SizedBox(height: 10),
        const SizedBox(height: 10),
      ];
    } else {
      return [
        for (int i = 0; i < listCabangTampilan.length; i++)
          listCabangTampilan[i].generateSoal(
            judulSoal,
            false,
            0,
            jumlahPertanyaan,
            widthSize,
          ),
        generateTombolBawah(context, idSurvei, emailUser),
        const SizedBox(height: 10),
        const SizedBox(height: 10),
      ];
    }
    // else {
    //   return [
    //     for (int i = 0; i < listUtamaTampilan.length; i++)
    //       listUtamaTampilan[i].generateSoal(
    //         judulSoal,
    //         false,
    //         0,
    //         jumlahPertanyaan,
    //         widthSize,
    //       ),
    //     generateTombolBawah(context, idSurvei, emailUser),
    //     const SizedBox(height: 10),
    //   ];
    // }
  }

  Future<bool> submitJawaban(String idSurvei, String emailPenjawab) async {
    try {
      print("$idSurvei || ${state.idForm}");
      var batch = FirebaseFirestore.instance.batch();
      int insentif = 0;
      Map<String, dynamic> hSurveiData = {};

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
        //
        //ganti status survei
        print("------- Tambah jumlah partisipan");
        if (((hSurveiData['jumlahPartisipan'] as int) + 1) ==
            (hSurveiData['batasPartisipan'] as int)) {
          batch.update(
              FirebaseFirestore.instance.collection('h_survei').doc(idSurvei),
              {'status': 'selesai'});
        }
        print("------- Update status h_survei");
        final idBaru = const Uuid().v4().substring(0, 8);
        final idUser = SharedPrefs.getString(prefUserid) ?? '8c6639a';
        var jawabanSurvei = state.formToMap();

        jawabanSurvei['idForm'] = state.idForm;
        jawabanSurvei['idSurvei'] = idSurvei;
        jawabanSurvei['tglPengisian'] = Timestamp.now();
        jawabanSurvei['insentif'] = insentif;
        jawabanSurvei['idUser'] = idUser;
        jawabanSurvei['emailPenjawab'] = emailPenjawab;
    
        insentifSurvei = insentif;
        batch.set(
          FirebaseFirestore.instance
              .collection('jawaban-survei-v3')
              .doc(idBaru),
          jawabanSurvei,
        );
        //update poinnya user

        batch.update(
            FirebaseFirestore.instance.collection('Users-survei').doc(idUser),
            {'poin': FieldValue.increment(insentif)});
        print("------- Tambah poin user");
        //
        await batch.commit();
        print("Berhasil proses jawaban -> $idBaru");
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Terjadi Error dan ini bpenyebanya : " + e.toString());
      return false;
    }
  }
}


  // kedepanHalaman(BuildContext context, String idSurvei, String emailUser) {
  //   //cek jika hal terakhir atau belum

  //   if ((indexSoal + 1) == jumlahBagian) {
  //     if (state.listDataPertanyaanCabang.isEmpty) {
  //       submitJawaban(idSurvei, emailUser);
  //     } else {
  //       listCabangTampilan = cariSoalCabang();
  //       isCabangShown = true;
  //     }
  //   } else {
  //     bool isEligible = true;
  //     int catatan = -1;
  //     for (var i = 0; i < listUtamaTampilan.length; i++) {
  //       if (listUtamaTampilan[i].getTipePertanyaan() !=
  //           TipePertanyaan.pembatasPertanyaan) {
  //         final error = listUtamaTampilan[i].cekJawabanWajib();
  //         if (!error.isError) {
  //           catatan = i;
  //           isEligible = false;
  //           break;
  //         }
  //       }
  //     }
  //     if (isEligible) {
  //       indexSoal++;
  //       state = state.copyWith();
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           content: Text(
  //         "Pertanyaan ke ${catatan} belum terisi",
  //         style: Theme.of(context)
  //             .textTheme
  //             .displaySmall!
  //             .copyWith(fontSize: 18, color: Colors.white),
  //       )));
  //     }
  //   }
  //   state = state.copyWith();
  // }