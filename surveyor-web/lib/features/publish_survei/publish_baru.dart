import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hei_survei/app/app.dart';
import 'package:hei_survei/app/routing/route_constant.dart';
import 'package:hei_survei/app/widgets/header_non_main.dart';
import 'package:hei_survei/constants.dart';
import 'package:hei_survei/features/publish_survei/model/d_survei.dart';
import 'package:hei_survei/features/publish_survei/model/respon_midtrans.dart';
import 'package:hei_survei/features/publish_survei/survei_controller.dart';
import 'package:hei_survei/features/publish_survei/widgets/container_angka.dart';
import 'package:hei_survei/features/publish_survei/widgets/container_insentif.dart';
import 'package:hei_survei/features/publish_survei/widgets/container_partisipan.dart';
import 'package:hei_survei/features/publish_survei/widgets/container_ringkasan.dart';
import 'package:hei_survei/features/publish_survei/widgets/field_multiline.dart';
import 'package:hei_survei/features/publish_survei/widgets/tombol_gambar.dart';
import 'package:hei_survei/features/publish_survei/widgets_publish/halaman_pembayaran.dart';
import 'package:hei_survei/features/publish_survei/widgets_publish/header_publish.dart';
import 'package:hei_survei/features/publish_survei/widgets_publish/tombol_atas_publish.dart';
import 'package:hei_survei/features/surveiku/widget/foto_standar_form.dart';
import 'package:hei_survei/utils/currency.dart';
import 'package:hei_survei/utils/loading_biasa.dart';
import 'package:uuid/uuid.dart';

enum StatePublish {
  loadingAwal,
  prosesPengisian,
  prosesPublish,
  selesaiPublish
}

class PublishSurveiBaru extends ConsumerStatefulWidget {
  const PublishSurveiBaru({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PublishSurveiBaruState();
}

class _PublishSurveiBaruState extends ConsumerState<PublishSurveiBaru> {
  //pisahkan function untuk fungsi kiriman dan tapilan
  //nanti untuk liat pembuatan halaman utama lihat generateBuild()
  StatePublish stateHalaman = StatePublish.loadingAwal;
  //pilihan radio -> untuk ambil radiobutton kategori

  //data survei dan form
  String? idForm;
  String? tipeForm;
  Widget konten = const SizedBox();

  Widget kontenUtama = const SizedBox();
  Widget kontenDemo = const SizedBox();

  //variable angka
  int jumlahPartisipan = 25;
  int insetifPerPartisipan = 0;
  int biayaPerPartisipan = 0;
  int biayaSpesial = 0;
  //jumlahSoal
  int jumlahSoal = 0;

  //controller
  TextEditingController controllerJudul = TextEditingController();
  final controllerDeskripsi = TextEditingController();
  final controllerPerkiraan = TextEditingController();
  // final controllerBiayaPerSurvei =
  //     TextEditingController(text: CurrencyFormat.convertToIdr(biayaPerPartisipan, 2));
  final controllerBiayaPembelian = TextEditingController();
  final controllerKategoriCustom = TextEditingController();
  //
  bool isJual = false;

  bool isModeDetail = true;

  bool isPakaiKategoriBiasa = true;

  bool isPakaiFotoStandar = true;
  String urlImgSurvei = "";
  bool isLoadingTombolGambar = false;

  List<String> listKategori = [];

  //pilihan kategori dan errornya
  String pilihanRadio = "";
  String pesanErrorRadio = "";
  //
  //form demografi
  bool isDemografiUsia = false;
  bool isDemografiKota = false;
  bool isDemografiInterest = false;
  final controllerUmurMinimal = TextEditingController();
  List<String> listInterest = [];
  List<String> listInterestPiihan = [];
  List<String> listKota = [];
  List<String> listKotaPilihan = [];
  String pesanErrorInterest = "";
  String pesanErrorKota = "";
  String pesanErrorJual = "";
  String pesanErrorGambar = "";
  String emailUser = "";

  Map<String, bool>? mapCheck;

  // late Map<String, dynamic> mapDataForm;
  final _publishKey = GlobalKey<FormState>();
  final _demografiKey = GlobalKey<FormState>();
  late String mapDataForm;

  ////////bagian persiapan data
  @override
  initState() {
    //c9d78e31 -> ini kartu
    // initDataPercobaan();
    initData();
    super.initState();
  }

  // initHitung() async {
  //   // final jumlah = await SurveiController().hitungJumlahSoalKartu("c9d78e31");
  //   // print(jumlah);
  //   final jumlah = await SurveiController().hitungJumlahSoalKlasik("e7b87ff2");
  //   print(jumlah);
  // }

  initData() async {
    try {
      if (!ref.exists(dataUtamaProvider) ||
          ref.read(dataUtamaProvider).idFormPublish == "") {
        context.goNamed(RouteConstant.halamanAuth);
      } else {
        idForm = ref.read(dataUtamaProvider).idFormPublish;
        tipeForm = ref.read(dataUtamaProvider).jenisFormPublish;
        emailUser = ref.read(authProvider).user.email;
        log("sampai bagian ambil cred user");
        Future(() {
          ref.read(dataUtamaProvider.notifier).bersihkanDataPublish();
        });

        mapDataForm = await SurveiController().getDataForm(idForm!, tipeForm!);
        log("sampai bagian map dataform");
        if (tipeForm == "klasik") {
          jumlahSoal = await SurveiController().hitungJumlahSoalKlasik(idForm!);
        } else {
          jumlahSoal = await SurveiController().hitungJumlahSoalKartu(idForm!);
        }

        controllerJudul = TextEditingController(text: mapDataForm);
        if (mapDataForm == "-=-j") {
          if (!context.mounted) context.goNamed(RouteConstant.halamanAuth);
        }
        //bagian demografi interest
        listKota = await SurveiController().getAllKota();
        listInterest = await SurveiController().getAllInterest();
        mapCheck = Map.fromIterables(listInterest,
            List.from(List.generate(listInterest.length, (index) => false)));
        //ambil kategori data
        listKategori = await SurveiController().getAllKategori();
        //ambil reward data
        Map<String, int> temp = await SurveiController().getHargaReward();
        insetifPerPartisipan = temp['insentifPerPartisipan']!;
        biayaSpesial = temp['hargaSpecial']!;
        biayaPerPartisipan = temp['hargapPerSurvei']!;
        // konten = kontenGenerator();
        setState(() {
          stateHalaman = StatePublish.prosesPengisian;
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  initDataPercobaan() async {
    try {
      idForm = "e7b87ff2";
      tipeForm = 'klasik';
      emailUser = 'lisal@gmail.com';

      if (tipeForm == "klasik") {
        // jumlahSoal = await SurveiController().hitungJumlahSoalKlasik(idForm!);
        jumlahSoal = 8;
      } else {
        // jumlahSoal = await SurveiController().hitungJumlahSoalKartu(idForm!);
      }
      jumlahSoal = 8;

      // mapDataForm = await SurveiController().getDataForm(idForm!, tipeForm!);
      mapDataForm = 'Survei Kesehatan dan Olahraga';

      controllerJudul = TextEditingController(text: mapDataForm);
      if (mapDataForm == "-=-j") {
        if (!context.mounted) context.goNamed(RouteConstant.halamanAuth);
      }
      //bagian demografi interest
      listKota = await SurveiController().getAllKota();
      listInterest = await SurveiController().getAllInterest();
      mapCheck = Map.fromIterables(listInterest,
          List.from(List.generate(listInterest.length, (index) => false)));
      //ambil kategori data
      listKategori = await SurveiController().getAllKategori();
      //ambil reward data
      Map<String, int> temp = await SurveiController().getHargaReward();
      insetifPerPartisipan = temp['insentifPerPartisipan']!;
      biayaSpesial = temp['hargaSpecial']!;
      biayaPerPartisipan = temp['hargapPerSurvei']!;
      // konten = kontenGenerator();
      setState(() {
        stateHalaman = StatePublish.prosesPengisian;
      });
    } catch (e) {
      log(e.toString());
    }
  }

  int generateBiayaJumlahSoal() {
    if (jumlahSoal < 11) {
      return 0;
    } else {
      int hasilBagi = jumlahSoal ~/ 10;
      return 40000 * hasilBagi;
    }
  }

  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text(
        "Batal",
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
      ),
      onPressed: () {
        Navigator.pop(context, 'Cancel');
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Lanjut",
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
      ),
      onPressed: () async {
        Navigator.pop(context);
        // setState(() {
        //   stateHalaman = StatePublish.prosesPublish;
        // });
        // Future.delayed(Duration(seconds: 2));
        // setState(() {
        //   stateHalaman = StatePublish.selesaiPublish;
        // });
        if (isPembayaranMidtrans) {
          await publishSurveiLengkap();
        } else {
          await publishSurvei();
        }
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Notifikasi",
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(fontSize: 32, fontWeight: FontWeight.bold),
      ),
      content: Text(
        "Pastikan Data survei sudah tepat, Publikasikan Survei ?",
        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20),
      ),
      actions: [cancelButton, continueButton],
    );

    showDialog(
      context: context,
      builder: (context) => alert,
    );
  }

  tambahHarga(int biaya) {
    biayaPerPartisipan += biaya;
    setState(() {});
  }

  List<Widget> rowGeneratorFilter(int angka, BuildContext context) {
    int pembagi = angka;
    int indexInduk = -1;
    List<Widget> hasil = List.generate(
      listInterest.length ~/ pembagi + 1,
      (index) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(pembagi, (index) {
          if (indexInduk < listInterest.length - 1) {
            indexInduk++;
            String keyNow = listInterest[indexInduk];
            //print(indexInduk);
            return Expanded(
                child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Checkbox(
                    fillColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                    checkColor: Colors.black,
                    value: mapCheck![listInterest[indexInduk]],
                    onChanged: (value) {
                      setState(() {
                        mapCheck![keyNow] = value!;
                      });
                    },
                  ),
                  Container(
                    child: Text(
                      listInterest[indexInduk],
                      overflow: TextOverflow.fade,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                    ),
                  ),
                ],
              ),
            ));
          } else {
            return Expanded(child: SizedBox());
          }
        }),
      ),
    );
    return hasil;
  }

  Widget kategoriGenerator(BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: rowGeneratorFilter(
                (constraints.maxWidth > 1700)
                    ? 4
                    : (constraints.maxWidth > 1080)
                        ? 3
                        : (constraints.maxWidth > 780)
                            ? 2
                            : 1,
                context),
          ),
        ],
      ),
    );
  }

  List<String> hasilInterest() {
    List<String> hasil = [];
    mapCheck!.forEach((key, value) {
      if (value) hasil.add(key);
    });
    return hasil;
  }

  String generateKategoriData() {
    if (isPakaiKategoriBiasa) {
      return pilihanRadio;
    } else {
      return controllerKategoriCustom.text.toLowerCase();
    }
  }

  List<Widget> rowGeneratorV2(int angka, BuildContext context) {
    int pembagi = angka;
    int indexInduk = -1;
    List<Widget> hasil = List.generate(
      listKategori.length ~/ pembagi + 1,
      (index) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(pembagi, (index) {
          if (indexInduk < listKategori.length - 1) {
            indexInduk++;
            String keyNow = listKategori[indexInduk];
            //print(indexInduk);
            return Expanded(
                child: RadioListTile(
              fillColor:
                  MaterialStateColor.resolveWith((states) => Colors.black),
              title: Text(
                listKategori[indexInduk],
                overflow: TextOverflow.fade,
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(fontSize: 16, color: Colors.black),
              ),
              value: listKategori[indexInduk],
              groupValue: pilihanRadio,
              onChanged: (value) {
                setState(() {
                  pilihanRadio = value!;
                  print(pilihanRadio);
                });
              },
            ));
          } else {
            return const Expanded(child: SizedBox());
          }
        }),
      ),
    );
    return hasil;
  }

  /////////////////////bagian persiapan data

  ////////////////////////////////bagian publish survei
  publishSurvei() async {
    String hasilKategori = generateKategoriData();
    setState(() {
      stateHalaman = StatePublish.prosesPublish;
    });
    try {
      int hargaPembuatan =
          (jumlahPartisipan * (insetifPerPartisipan + biayaPerPartisipan));

      String tempPerkiraan =
          controllerPerkiraan.text == "" ? "0" : controllerPerkiraan.text;

      DSurveiInput dSurvei = DSurveiInput(
        hargaPerPartisipan: biayaPerPartisipan,
        insentifPerPartisipan: insetifPerPartisipan,
        demografiUsia:
            (isDemografiUsia) ? int.parse(controllerUmurMinimal.text) : -1,
        demografiLokasi: (isDemografiKota) ? listKotaPilihan : [],
        DemografiInterest: (isDemografiInterest) ? hasilInterest() : [],
        batasPartisipan: jumlahPartisipan,
        diJual: isJual,
        hargaJual: (isJual) ? int.parse(controllerBiayaPembelian.text) : -1,
      );

      bool pakaiDemografi =
          (isDemografiUsia || isDemografiKota || isDemografiInterest);

      bool hasil = await SurveiController().publishSurvei(
        idForm: idForm!,
        judul: controllerJudul.text,
        deskripsi: controllerDeskripsi.text,
        // kategori: pilihanRadio,
        kategori: hasilKategori,
        durasi: int.parse(tempPerkiraan),
        batasPartisipan: jumlahPartisipan,
        harga: hargaPembuatan,
        isKlasik: (tipeForm == "klasik"),
        dSurvei: dSurvei,
        pakaiDemografi: pakaiDemografi,
        emailUser: emailUser,
        urlGambar: urlImgSurvei,
      );
      if (hasil) {
        //disini kalau sukses
        //
        if (!context.mounted) return;
        context.goNamed(RouteConstant.halamanAuth);
      } else {
        if (!context.mounted)
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Terjadi kesalahan server, mohon coba lagi")));
        setState(() {
          stateHalaman = StatePublish.selesaiPublish;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  publishSurveiLengkap() async {
    String hasilKategori = generateKategoriData();
    setState(() {
      stateHalaman = StatePublish.prosesPublish;
    });
    try {
      String idBaru = const Uuid().v4().substring(0, 7);
      log("ini id baru survei -> $idBaru");
      int hargaPembuatan =
          (jumlahPartisipan * (insetifPerPartisipan + biayaPerPartisipan));
      final prosesTransaksi =
          await prosesPembuatanTagihan(hargaPembuatan, idBaru);
      //itu diatas untuk realtimeDB
      print("selesai proses pembuatan midtrans dkk");
      if (prosesTransaksi) {
        String tempPerkiraan =
            controllerPerkiraan.text == "" ? "0" : controllerPerkiraan.text;

        DSurveiInput dSurvei = DSurveiInput(
          hargaPerPartisipan: biayaPerPartisipan,
          insentifPerPartisipan: insetifPerPartisipan,
          demografiUsia:
              (isDemografiUsia) ? int.parse(controllerUmurMinimal.text) : -1,
          demografiLokasi: (isDemografiKota) ? listKotaPilihan : [],
          DemografiInterest: (isDemografiInterest) ? hasilInterest() : [],
          batasPartisipan: jumlahPartisipan,
          diJual: isJual,
          hargaJual: (isJual) ? int.parse(controllerBiayaPembelian.text) : -1,
        );

        bool pakaiDemografi =
            (isDemografiUsia || isDemografiKota || isDemografiInterest);
        print("Sampai bagian mau publish");
        print(dSurvei.toString());
        bool hasil = await SurveiController().publishSurveiMidtrans(
          idSurvei: idBaru,
          idForm: idForm!,
          judul: controllerJudul.text,
          deskripsi: controllerDeskripsi.text,
          // kategori: pilihanRadio,
          kategori: hasilKategori,
          durasi: int.parse(tempPerkiraan),
          batasPartisipan: jumlahPartisipan,
          harga: hargaPembuatan,
          isKlasik: (tipeForm == "klasik"),
          dSurvei: dSurvei,
          pakaiDemografi: pakaiDemografi,
          emailUser: emailUser,
          urlGambar: urlImgSurvei,
        );
        // bool hasil = true;
        print("ini hasilnya ->  $hasil");
        if (hasil) {
          ref.read(indexUtamaProvider.notifier).update((state) => 10);
          print("selesai ubah halaman utama");
          setState(() {
            stateHalaman = StatePublish.selesaiPublish;
            print("masuk setState");
          });
        } else {
          if (!context.mounted)
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Terjadi kesalahan server, mohon coba lagi")));
        }
      }
    } catch (e) {
      setState(() {
        stateHalaman = StatePublish.prosesPengisian;
      });
      print(e);
    }
  }

  Future<bool> prosesPembuatanTagihan(
      int hargaPembuatan, String idSurvei) async {
    ResponMidtrans? midTrans = await buatMidTrans(hargaPembuatan);
    print("buat midtrans");
    if (midTrans != null) {
      // bool logic = await pembuatanTagihan(midTrans, hargaPembuatan, idSurvei);
      bool logic = await SurveiController().buatRTDB(
        judul: controllerJudul.text,
        totalPembayaran: hargaPembuatan,
        namaBank: midTrans.bank,
        nomorVA: midTrans.nomorVA,
        idOrder: midTrans.idOrder,
        idSurvei: idSurvei,
      );
      print("buat RT DB");
      return logic;
    } else {
      setState(() {
        // mode = "normal";
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Gagal terhubung dengan midtrans")));
      });
      return false;
    }
  }

  Future<ResponMidtrans?> buatMidTrans(int hargaPembuatan) async {
    ResponMidtrans? hasil = await SurveiController().buatMidTrans(
        idTrans: const Uuid().v4().substring(0, 6),
        jumlahPembayaran: hargaPembuatan);
    return hasil;
  }
  ///////////////////////////publish survei

  ///Function interaksi UI
  ubahPartisipan(bool isTambah) {
    if (isTambah) {
      jumlahPartisipan += 25;
    } else if (jumlahPartisipan > 25) {
      jumlahPartisipan -= 25;
    }
    setState(() {});
  }

  ubahInsentif(bool isTambah) {
    if (isTambah) {
      insetifPerPartisipan += 100;
    } else if (insetifPerPartisipan > 500) {
      insetifPerPartisipan -= 100;
    }
    setState(() {});
  }

  bool cekErrorFoto() {
    if (!isPakaiFotoStandar && urlImgSurvei == "") {
      setState(() {
        pesanErrorGambar = "Masukkan Gambar Survei";
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Masukkan Gambar Survei Terlebih Dahulu")));
      return false;
    }
    return true;
  }

  bool cekErrorDemografi() {
    bool tempMap = hasilInterest().isNotEmpty;
    if (isDemografiKota && listKotaPilihan.isEmpty) {
      setState(() {
        pesanErrorKota = " Minimal pilih satu kota";
      });
    }

    if (hasilInterest().isEmpty && isDemografiInterest) {
      setState(() {
        pesanErrorInterest = " Minimal pilih satu interest target";
      });
    }

    log("hasil err demo ${((!isDemografiKota || (isDemografiKota && listKotaPilihan.isNotEmpty)) && (!isDemografiInterest || (tempMap && isDemografiInterest)))}");
    return ((!isDemografiKota ||
            (isDemografiKota && listKotaPilihan.isNotEmpty)) &&
        (!isDemografiInterest || (tempMap && isDemografiInterest)));
  }

  bool pengecekanSebelumPublish(bool isValidForm, bool isValidDemografi) {
    log("${isValidForm} || ${isValidDemografi} || ${cekErrorDemografi()} || ${cekErrorForm()} || ${cekErrorFoto()}");
    return (isValidForm &&
        isValidDemografi &&
        cekErrorDemografi() &&
        cekErrorForm() &&
        cekErrorFoto());
  }

  bool cekErrorForm() {
    if (isPakaiKategoriBiasa) {
      if (pilihanRadio == "") {
        pesanErrorRadio = "Pilih kategori survei";
      } else {
        pesanErrorRadio = "";
      }

      setState(() {});
      return (pilihanRadio != "");
    } else {
      if (controllerKategoriCustom.text.isEmpty)
        pesanErrorRadio = "Masukkan nama kategori custom";
      setState(() {});
      return (controllerKategoriCustom.text.isNotEmpty);
    }
  }

  bool cekTerjual() {
    bool logic = true;
    pesanErrorJual = "";
    if (isJual) {
      if (controllerBiayaPembelian.text == "") {
        logic = false;
        pesanErrorJual = "Masukkan Harga Penjuala Survei";
      }
    }
    setState(() {});
    return logic;
  }

  ////Function interaksi UI
  ///
  ///
  ///Generator UI

  //Demografi
  Widget kontenDemoGenerator(BoxConstraints constraints) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: constraints.maxWidth * 0.04, vertical: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 65),
        decoration: BoxDecoration(
            color: Colors.blueGrey.shade100,
            borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          child: Form(
            key: _demografiKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                generateUmurDemo(),
                const SizedBox(height: 30),
                generateKotaDemo(),
                const SizedBox(height: 30),
                generateHobiDemo(constraints),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget generateUmurDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Switch(
              value: isDemografiUsia,
              onChanged: (value) {
                setState(() {
                  isDemografiUsia = value;
                  tambahHarga((value) ? 200 : -200);
                });
              },
            ),
            const SizedBox(width: 20),
            Text(
              "Demografi Usia",
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
            )
          ],
        ),
        const SizedBox(height: 16),
        ContainerAngkaPublish(
          iconData: Icons.person,
          textJudul: "Minimal Usia Peserta",
          controller: controllerUmurMinimal,
          validator: (p0) {
            if (controllerPerkiraan.text == "" && isDemografiUsia) {
              return "Masukkan umur minimal";
            } else
              return null;
          },
        ),
      ],
    );
  }

  Widget generateKotaDemo() {
    return Column(
      children: [
        Row(
          children: [
            Switch(
              value: isDemografiKota,
              onChanged: (value) {
                setState(() {
                  isDemografiKota = value;
                });
                tambahHarga((value) ? 200 : -200);
              },
            ),
            const SizedBox(width: 20),
            Text(
              "Demografi Lokasi",
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
            )
          ],
        ),
        const SizedBox(height: 16),
        RichText(
            text: TextSpan(
                text: "Kota Peserta",
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                children: [
              TextSpan(
                text: pesanErrorKota,
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Colors.red,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
              )
            ])),
        const SizedBox(height: 6),
        Container(
          margin: EdgeInsets.only(right: 125),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(26)),
          child: DropdownSearch.multiSelection(
            items: listKota,
            popupProps: PopupPropsMultiSelection.menu(
              showSearchBox: true,
              showSelectedItems: true,
              disabledItemFn: (String s) => s.startsWith('Ix'),
            ),
            dropdownButtonProps: DropdownButtonProps(
              color: Colors.blue,
              icon: Icon(Icons.arrow_circle_down_rounded),
              iconSize: 40,
            ),
            dropdownDecoratorProps: DropDownDecoratorProps(
              textAlignVertical: TextAlignVertical.center,
              dropdownSearchDecoration: InputDecoration(
                  border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
              )),
            ),
            onChanged: (value) {
              print;
              setState(() {
                listKotaPilihan = value;
              });
            },
            selectedItems: listKotaPilihan,
          ),
        ),
      ],
    );
  }

  Widget generateHobiDemo(BoxConstraints constraints) {
    return Column(
      children: [
        Row(
          children: [
            Switch(
              value: isDemografiInterest,
              onChanged: (value) {
                setState(() {
                  isDemografiInterest = value;
                });
                tambahHarga((value) ? 200 : -200);
              },
            ),
            const SizedBox(width: 20),
            Text(
              "Demografi Interest",
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
            )
          ],
        ),
        const SizedBox(height: 16),
        RichText(
            text: TextSpan(
                text: "Target Interest Peserta",
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                children: [
              TextSpan(
                text: pesanErrorInterest,
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
              )
            ])),
        kategoriGenerator(constraints),
      ],
    );
  }

  //Demografi

  Widget generatePilihanKategori(BoxConstraints constraints) {
    if (isPakaiKategoriBiasa) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 16),
              child: RichText(
                text: TextSpan(
                  text: "Kategori (Pilih Satu)",
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color: Colors.black,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                  children: [
                    TextSpan(
                      text: "  $pesanErrorRadio",
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            color: Colors.red,
                            fontSize: 19,
                          ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            height: 175,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 250, 250, 250),
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...rowGeneratorV2(
                        (constraints.maxWidth > 1700)
                            ? 4
                            : (constraints.maxWidth > 1080)
                                ? 3
                                : (constraints.maxWidth > 780)
                                    ? 2
                                    : 1,
                        context),
                  ]),
            ),
          ),
        ],
      );
    } else {
      return FieldContainerMultiline(
        controller: controllerKategoriCustom,
        textJudul: "Kategori Survei",
        minLines: 1,
        hintText: "Masukkan Kategori Pilihan anda",
        validator: (value) {
          if (!isPakaiKategoriBiasa) {
            if (controllerKategoriCustom.text == "") {
              return "Masukkan Deskripsi Survei";
            } else
              return null;
          } else {
            return null;
          }
        },
      );
    }
  }

  Widget generatePilihanFoto() {
    Widget tampilanFoto = Container(
      height: 175,
      width: 225,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 3.25,
          color: Colors.black,
        ),
      ),
      child: (urlImgSurvei == "")
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.dangerous_outlined,
                    size: 30,
                    color: Colors.red,
                  ),
                  Text(
                    "Belum Ada Gambar",
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.red, fontSize: 16),
                  ),
                ],
              ),
            )
          : CachedNetworkImage(
              filterQuality: FilterQuality.medium,
              imageUrl: urlImgSurvei,
              imageBuilder: (context, imageProvider) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) {
                return const Icon(
                  Icons.error,
                  size: 48,
                  color: Colors.red,
                );
              },
            ),
    );

    if (isPakaiFotoStandar) {
      return Column(
        children: [
          FotoStandarForm(isKlasik: tipeForm == "klasik"),
          const SizedBox(height: 6),
          Text(
            "Foto form $tipeForm",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 15.75,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          // Container(
          //   height: 175,
          //   width: 225,
          //   margin: const EdgeInsets.symmetric(horizontal: 8),
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.circular(20),
          //     border: Border.all(
          //       width: 5,
          //       color: Colors.black,
          //     ),
          //   ),
          //   child: Center(
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Icon(
          //           Icons.dangerous_outlined,
          //           size: 30,
          //           color: Colors.red,
          //         ),
          //         Text(
          //           "Belum Ada Gambar",
          //           overflow: TextOverflow.ellipsis,
          //           style: Theme.of(context)
          //               .textTheme
          //               .titleLarge!
          //               .copyWith(color: Colors.red, fontSize: 16),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          tampilanFoto,
          TombolGambar(
            isLoading: isLoadingTombolGambar,
            onPressed: () async {
              setState(() {
                isLoadingTombolGambar = true;
              });
              urlImgSurvei =
                  await SurveiController().pilihGambarSurvei(context);
              setState(() {
                isLoadingTombolGambar = false;
              });
            },
          )
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 32),
          //   width: 230,
          //   height: 38,
          //   margin: const EdgeInsets.only(top: 14),
          //   child: ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //         shape: const RoundedRectangleBorder(
          //             borderRadius: BorderRadius.all(Radius.circular(8))),
          //         backgroundColor: Colors.blue),
          //     onPressed: () async {
          //       urlImgSurvei =
          //           await SurveiController().pilihGambarSurvei(context);
          //     },
          //     child: Text(
          //       "Pilih Gambar",
          //       overflow: TextOverflow.ellipsis,
          //       style: Theme.of(context)
          //           .textTheme
          //           .titleLarge!
          //           .copyWith(color: Colors.white, fontSize: 17),
          //     ),
          //   ),
          // ),
        ],
      );
    }
  }

  //konten utama
  Widget generateKontenUtama() {
    return LayoutBuilder(
      builder: (context, constraints) => Form(
        key: _publishKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const HeaderPublish(),
              TombolAtasPublish(
                onTapDemografi: () => setState(() {
                  isModeDetail = false;
                }),
                onTapDetail: () => setState(() {
                  isModeDetail = true;
                }),
              ),
              Container(
                width: constraints.maxWidth,
                height: 825,
                child: Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: generateKotakUtama(constraints),
                    ),
                    Expanded(
                      flex: 4,
                      child: generateKotakSamping(),
                    )
                  ],
                ),
              ),
              // FooterWeb(constraints: constraints)
            ],
          ),
        ),
      ),
    );
  }

  generateKotakUtama(BoxConstraints constraints) {
    if (isModeDetail) {
      return Container(
        padding: EdgeInsets.symmetric(
            horizontal: constraints.maxWidth * 0.0255, vertical: 16),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
              vertical: 16, horizontal: constraints.maxWidth * 0.02),
          decoration: BoxDecoration(
              color: Colors.blueGrey.shade100,
              borderRadius: BorderRadius.circular(20)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton.filled(
                        onPressed: () {
                          context.goNamed(RouteConstant.halamanAuth);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        )),
                    const SizedBox(width: 6),
                    Text(
                      "Kembali",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 18, color: Colors.black),
                    ),
                  ],
                ),
                Center(
                  child: Text(
                    "Detail Survei",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
                FieldContainerMultiline(
                  controller: controllerJudul,
                  textJudul: "Judul Survei",
                  minLines: 2,
                  hintText: "",
                  validator: (value) {
                    if (controllerJudul.text == "") {
                      return "Masukkan Judul Survei";
                    } else
                      return null;
                  },
                ),
                const SizedBox(height: 20),
                FieldContainerMultiline(
                  controller: controllerDeskripsi,
                  textJudul: "Deskripsi Survei",
                  minLines: 3,
                  hintText: "",
                  validator: (value) {
                    if (controllerDeskripsi.text == "") {
                      return "Masukkan Deskripsi Survei";
                    } else
                      return null;
                  },
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 16),
                    Text(
                      "Pakai Kategori Standar",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 18, color: Colors.black),
                    ),
                    const SizedBox(width: 12),
                    Switch(
                      value: isPakaiKategoriBiasa,
                      onChanged: (value) {
                        setState(() {
                          isPakaiKategoriBiasa = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                generatePilihanKategori(constraints),
                const SizedBox(height: 15),
                generateDaerahIstimewa(),
                // Row(
                //   children: [
                //     ContainerAngkaPublish(
                //       iconData: Icons.timer_rounded,
                //       textJudul: "Perkiraan Waktu (m)",
                //       controller: controllerPerkiraan,
                //       validator: (p0) {
                //         if (controllerPerkiraan.text == "") {
                //           return "Masukkan waktu pengerjaan";
                //         } else
                //           return null;
                //       },
                //     ),
                //     const SizedBox(width: 60),
                //     ContainerAngkaPublish(
                //       validator: (p0) => null,
                //       iconData: Icons.monetization_on,
                //       textJudul: "Biaya Per Survei",
                //       controller: TextEditingController(
                //           text: CurrencyFormat.convertToIdr(
                //               biayaPerPartisipan, 2)),
                //       enabled: false,
                //     ),
                //     Spacer(),
                //   ],
                // ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    KotakPartisipan(
                      jumlah: jumlahPartisipan,
                      kurang: () => ubahPartisipan(false),
                      tambah: () => ubahPartisipan(true),
                    ),
                    KotakInsentif(
                      harga:
                          CurrencyFormat.convertToIdr(insetifPerPartisipan, 2),
                      kurang: () => ubahInsentif(false),
                      tambah: () => ubahInsentif(true),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Jual Survei ?",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 18, color: Colors.blueGrey),
                    ),
                    const SizedBox(width: 8),
                    Switch(
                      value: isJual,
                      onChanged: (value) {
                        setState(() {
                          isJual = value;
                        });
                      },
                    ),
                    const SizedBox(width: 30),
                    if (isJual)
                      ContainerAngkaPublish(
                        textJudul: "Harga Pemberlian",
                        iconData: Icons.monetization_on,
                        controller: controllerBiayaPembelian,
                        validator: (p0) {
                          if (controllerBiayaPembelian.text == "" && isJual) {
                            return "Masukkan harga survei anda";
                          } else
                            return null;
                        },
                      ),
                    SizedBox(width: 4),
                    Text(
                      pesanErrorJual,
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            color: Colors.red,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    } else {
      return kontenDemoGenerator(constraints);
    }
  }

  Widget generateDaerahIstimewa() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 9.5),
                Text(
                  "Pakai Foto Standar",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 19, color: Colors.black),
                ),
                const SizedBox(width: 6),
                Switch(
                  value: isPakaiFotoStandar,
                  onChanged: (value) {
                    setState(() {
                      isPakaiFotoStandar = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(width: 3),
            if (pesanErrorGambar != "")
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text(
                  pesanErrorGambar,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 14, color: Colors.red),
                ),
              ),
            const SizedBox(height: 8),
            generatePilihanFoto(),
            const SizedBox(height: 20),
          ],
        ),
        Column(
          children: [
            ContainerAngkaPublish(
              iconData: Icons.timer_rounded,
              textJudul: "Perkiraan Waktu (m)",
              controller: controllerPerkiraan,
              validator: (p0) {
                if (controllerPerkiraan.text == "") {
                  return "Masukkan waktu pengerjaan";
                } else
                  return null;
              },
            ),
            const SizedBox(height: 20),
            ContainerAngkaPublish(
              validator: (p0) => null,
              iconData: Icons.monetization_on,
              textJudul: "Biaya Per Survei",
              controller: TextEditingController(
                  text: CurrencyFormat.convertToIdr(biayaPerPartisipan, 2)),
              enabled: false,
            ),
          ],
        ),
      ],
    );
  }

  generateKotakSamping() {
    return Container(
      padding: const EdgeInsets.only(right: 14, top: 7, bottom: 28),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ringkasan Pembayaran",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            ContainerJumlahSoal(
              jumlahSoal: jumlahSoal,
              hargaPertanyaan: generateBiayaJumlahSoal(),
            ),
            ContainerRingkasan(
              judul: "Jumlah Partisipan",
              text: "$jumlahPartisipan Partisipan",
              icon: Icon(
                Icons.person_rounded,
                size: 24,
                color: Colors.blue.shade600,
              ),
            ),
            ContainerRingkasan(
              text: CurrencyFormat.convertToIdr(insetifPerPartisipan, 2),
              judul: 'Insentif per Partisipan',
              icon: Icon(
                Icons.money,
                size: 24,
                color: Colors.blue.shade600,
              ),
            ),
            ContainerRingkasan(
              text: CurrencyFormat.convertToIdr(biayaPerPartisipan, 2),
              judul: "Biaya Survei per Partisipan",
              icon: Icon(
                Icons.monetization_on,
                size: 24,
                color: Colors.blue.shade600,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Rumus Total Pembayaran : ",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 21.5,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              "Partisipan x (Insentif + Biaya per Survei) +",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              "Biaya Pertanyaan",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border.all(
                    width: 1,
                    color: Colors.blueGrey,
                  ),
                  borderRadius: BorderRadius.circular(17.5)),
              margin: const EdgeInsets.only(top: 1),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.monetization_on,
                        size: 24,
                        color: Colors.green.shade600,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Total Biaya",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: 15.5,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "$jumlahPartisipan x (${CurrencyFormat.convertToIdr(insetifPerPartisipan, 2)} + ${CurrencyFormat.convertToIdr(biayaPerPartisipan, 2)}) +",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${CurrencyFormat.convertToIdr(generateBiayaJumlahSoal(), 2)}",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 5),
                  Divider(color: Colors.black, thickness: 3),
                  Text(
                    "Total : " +
                        CurrencyFormat.convertToIdr(
                            (jumlahPartisipan *
                                    (insetifPerPartisipan +
                                        biayaPerPartisipan)) +
                                generateBiayaJumlahSoal(),
                            2),
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: () async {
                    final isValidForm = _publishKey.currentState!.validate();
                    final isValidDemografi =
                        (_demografiKey.currentState == null)
                            ? true
                            : _demografiKey.currentState!.validate();
                    if (pengecekanSebelumPublish(
                        isValidForm, isValidDemografi)) {
                      print("sukses pengecekan");
                      showAlertDialog(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  child: Text(
                    "Publikasi Survei",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 22,
                        ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  //konten utama

  //body generator dan pengaturan state
  bodyGenerator() {
    if (stateHalaman == StatePublish.loadingAwal) {
      return LoadingBiasa(
          text: "Memuat Data Survei dan Harga", pakaiKembali: true);
    } else if (stateHalaman == StatePublish.prosesPengisian) {
      return generateKontenUtama();
    } else if (stateHalaman == StatePublish.prosesPublish) {
      return LoadingBiasa(
          text: "Sedang memproses publikasi", pakaiKembali: false);
    } else {
      return const SuksesPenerbitanSurvei();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: HeaderNonMain(),
      ),
      backgroundColor: Colors.lightBlue.shade100,
      body: bodyGenerator(),
    );
  }
}

class FooterWeb extends StatelessWidget {
  FooterWeb({
    super.key,
    required this.constraints,
  });
  BoxConstraints constraints;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: constraints.maxWidth,
      height: 56,
      color: Colors.blueGrey.shade500,
      padding: const EdgeInsets.symmetric(vertical: 10.5),
      child: Column(
        children: [
          Text(
            "Copyright Hey Survey 2024. All Right Reserved",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontSize: 12.5, color: Colors.white),
          ),
          const SizedBox(height: 2),
          Text(
            "Surabaya, Indonesia",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontSize: 12.5, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
