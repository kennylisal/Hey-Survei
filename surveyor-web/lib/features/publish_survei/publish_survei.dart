import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hei_survei/app/app.dart';
import 'package:hei_survei/app/routing/route_constant.dart';
import 'package:hei_survei/constants.dart';
import 'package:hei_survei/features/publish_survei/model/d_survei.dart';
import 'package:hei_survei/features/publish_survei/model/respon_midtrans.dart';

import 'package:hei_survei/features/publish_survei/survei_controller.dart';
import 'package:hei_survei/features/publish_survei/widgets/container_angka.dart';
import 'package:hei_survei/features/publish_survei/widgets/container_insentif.dart';
import 'package:hei_survei/features/publish_survei/widgets/container_partisipan.dart';
import 'package:hei_survei/features/publish_survei/widgets/container_ringkasan.dart';
import 'package:hei_survei/features/publish_survei/widgets/field_multiline.dart';
import 'package:hei_survei/features/publish_survei/widgets_publish/hal_selesai.dart';
import 'package:hei_survei/features/publish_survei/widgets_publish/header_publish.dart';
import 'package:hei_survei/features/publish_survei/widgets_publish/tombol_atas_publish.dart';
import 'package:hei_survei/utils/currency.dart';
import 'package:hei_survei/utils/loading_biasa.dart';
import 'package:uuid/uuid.dart';

class PublishBaru extends ConsumerStatefulWidget {
  PublishBaru({
    super.key,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PublishBaruState();
}

class _PublishBaruState extends ConsumerState<PublishBaru> {
  String mode = "normal";
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

  bool halAkhir = false; //penanda kelar

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
  List<String> listKota = [];
  List<String> listKotaPilihan = [];
  String pesanErrorInterest = "";
  String pesanErrorKota = "";
  String pesanErrorJual = "";
  String emailUser = "";

  Map<String, bool>? mapCheck;

  // late Map<String, dynamic> mapDataForm;
  late String mapDataForm;
  @override
  initState() {
    super.initState();
    if (!ref.exists(dataUtamaProvider) ||
        ref.read(dataUtamaProvider).idFormPublish == "") {
      context.goNamed(RouteConstant.halamanAuth);
    }
    // if (false) {
    // }
    else {
      idForm = ref.read(dataUtamaProvider).idFormPublish;
      tipeForm = ref.read(dataUtamaProvider).jenisFormPublish;
      emailUser = ref.read(authProvider).user.email;
      Future(() async {
        ref.read(dataUtamaProvider.notifier).bersihkanDataPublish();
        mapDataForm = await SurveiController().getDataForm(idForm!, tipeForm!);
        //diatas yang dibutuhkan, dibawah sampah
        // mapDataForm =
        //     await SurveiController().getDataForm('64af35cf', 'klasik');
        // controllerJudul = TextEditingController(text: "terserah");
        //
        controllerJudul = TextEditingController(text: mapDataForm);
        if (mapDataForm == "-=-j") {
          context.goNamed(RouteConstant.halamanAuth);
        }
        print(mapDataForm);
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
        setState(() {});
      });
    }
  }

  tambahHarga(int biaya) {
    biayaPerPartisipan += biaya;
    setState(() {});
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

  //ini yg dipakai
  publishSurvei() async {
    String hasilKategori = generateKategoriData();
    setState(() {
      print("sesudah generate kategori");
      mode = "loading";
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Publikasi sedang diproses, mohon tunggu")));
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
        DemografiInterest: (isDemografiInterest) ? listKotaPilihan : [],
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
          urlGambar: "");
      if (hasil) {
        //disini kalau sukses
        //
        if (!context.mounted) return;
        context.goNamed(RouteConstant.halamanAuth);
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Terjadi kesalahan server, mohon coba lagi")));
        setState(() {
          mode = "normal";
        });
      }
    } catch (e) {
      print(e);
    }
  }

  publishSurveiLengkap() async {
    String hasilKategori = generateKategoriData();
    setState(() {
      print("sesudah generate kategori");
      mode = "loading";
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Publikasi sedang diproses, mohon tunggu")));
    });
    try {
      String idBaru = const Uuid().v4().substring(0, 6);
      log("ini id baru survei -> $idBaru");
      int hargaPembuatan =
          (jumlahPartisipan * (insetifPerPartisipan + biayaPerPartisipan));
      final prosesTransaksi =
          await prosesPembuatanTagihan(hargaPembuatan, idBaru);
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
          DemografiInterest: (isDemografiInterest) ? listKotaPilihan : [],
          batasPartisipan: jumlahPartisipan,
          diJual: isJual,
          hargaJual: (isJual) ? int.parse(controllerBiayaPembelian.text) : -1,
        );

        bool pakaiDemografi =
            (isDemografiUsia || isDemografiKota || isDemografiInterest);
        print("Sampai bagian mau publish");
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
          urlGambar: "",
        );
        print("ini hasilnya ->  $hasil");
        if (hasil) {
          //disini kalau sukses
          //
          // if (!context.mounted) return;
          // context.goNamed(RouteConstant.home);
          setState(() {
            halAkhir = true;
          });
        } else {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Terjadi kesalahan server, mohon coba lagi")));
        }
      }
    } catch (e) {
      setState(() {
        mode = "normal";
      });
      print(e);
    }
  }

  Future<ResponMidtrans?> buatMidTrans(int hargaPembuatan) async {
    ResponMidtrans? hasil = await SurveiController().buatMidTrans(
        idTrans: const Uuid().v4().substring(0, 6),
        jumlahPembayaran: hargaPembuatan);
    return hasil;
  }

  //tembak ini jadi bagian backend saja lmao-----
  // Future<bool> pembuatanTagihan(
  //     ResponMidtrans midTrans, int hargaPembuatan, String idSurvei) async {
  //   //realtime database
  //   final userId = SharedPrefs.getString(prefUserId) ?? "";
  //   if (userId != "") {
  //     try {
  //       DatabaseReference dbRef =
  //           FirebaseDatabase.instance.ref('tagihan/$userId');
  //       await dbRef.set({
  //         // "judul": "Survei pertama lewat aplikasi",
  //         "judul": controllerJudul.text,
  //         "totalPembayaran": hargaPembuatan,
  //         "namaBank": midTrans.bank,
  //         "nomorVA": midTrans.nomorVA,
  //         'idOrder': midTrans.idOrder
  //       });
  //       print("selesai bikin tagihan");
  //       DatabaseReference dbRefDetail =
  //           FirebaseDatabase.instance.ref('authTagihan/${midTrans.idOrder}');
  //       await dbRefDetail
  //           .set({"idUser": userId, "idSurvei": idSurvei, "tipe": "survei"});
  //       print("selesai bikin auth tagihan tagihan");
  //       return true;
  //     } catch (e) {
  //       print(e);
  //       return false;
  //     }
  //   } else {
  //     return false;
  //   }
  // }

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

  bool cekErrorDemografi() {
    bool tempMap = hasilInterest().isNotEmpty;
    if (isDemografiKota && listKotaPilihan.isEmpty) {
      setState(() {
        pesanErrorKota = " Minimal pilih satu kota";
      });
    }
    // if (isDemografiInterest) {
    //   mapCheck!.forEach((key, value) {
    //     if (value) tempMap = true;
    //   });
    // }
    if (hasilInterest().isEmpty && isDemografiInterest) {
      setState(() {
        pesanErrorInterest = " Minimal pilih satu interest target";
      });
    }
    // print(listKotaPilihan);
    // print(hasilInterest());
    print(
        "hasil err demo ${((!isDemografiKota || (isDemografiKota && listKotaPilihan.isNotEmpty)) && (!isDemografiInterest || (tempMap && isDemografiInterest)))}");
    return ((!isDemografiKota ||
            (isDemografiKota && listKotaPilihan.isNotEmpty)) &&
        (!isDemografiInterest || (tempMap && isDemografiInterest)));
  }

  bool cekErrorForm() {
    if (isPakaiKategoriBiasa) {
      if (pilihanRadio == "") {
        pesanErrorRadio = "Pilih kategori survei";
      } else {
        pesanErrorRadio = "";
      }
      setState(() {});
    } else {
      pesanErrorRadio = "";
      setState(() {});
    }
    // print(pilihanRadio != "");
    return (pilihanRadio != "");
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
                    .copyWith(fontSize: 16, color: Colors.black
                        //color: Colors.grey.shade100,
                        ),
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
                const SizedBox(height: 30),
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
                        style:
                            Theme.of(context).textTheme.displayLarge!.copyWith(
                                  color: Colors.black,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                        children: [
                      TextSpan(
                        text: pesanErrorKota,
                        style:
                            Theme.of(context).textTheme.displayLarge!.copyWith(
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(26)),
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
                const SizedBox(height: 30),
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
                        style:
                            Theme.of(context).textTheme.displayLarge!.copyWith(
                                  color: Colors.black,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                        children: [
                      TextSpan(
                        text: pesanErrorInterest,
                        style:
                            Theme.of(context).textTheme.displayLarge!.copyWith(
                                  color: Colors.black,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                      )
                    ])),
                kategoriGenerator(constraints),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget generatePilihanKategori(BoxConstraints constraints) {
    if (isPakaiKategoriBiasa) {
      return Column(
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
        textJudul: "Deskripsi Survei",
        minLines: 1,
        hintText: "Masukkan Kategori Custom anda",
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

  Widget generateKontenUtama() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Form(
          key: _publishKey,
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
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                        flex: 8,
                        child: (isModeDetail)
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: constraints.maxWidth * 0.0255,
                                    vertical: 16),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: constraints.maxWidth * 0.02),
                                  decoration: BoxDecoration(
                                      color: Colors.blueGrey.shade100,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            IconButton.filled(
                                                onPressed: () {
                                                  context.goNamed(RouteConstant
                                                      .halamanAuth);
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
                                                  .copyWith(
                                                      fontSize: 18,
                                                      color: Colors.black),
                                            ),
                                          ],
                                        ),
                                        Center(
                                          child: Text(
                                            "Detail Survei",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(
                                                    fontSize: 32,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                            if (controllerDeskripsi.text ==
                                                "") {
                                              return "Masukkan Deskripsi Survei";
                                            } else
                                              return null;
                                          },
                                        ),
                                        const SizedBox(height: 15),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const SizedBox(width: 16),
                                            Text(
                                              "Pakai Kategori Standar",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                      fontSize: 18,
                                                      color: Colors.black),
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
                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            ContainerAngkaPublish(
                                              iconData: Icons.timer_rounded,
                                              textJudul: "Perkiraan Waktu (m)",
                                              controller: controllerPerkiraan,
                                              validator: (p0) {
                                                if (controllerPerkiraan.text ==
                                                    "") {
                                                  return "Masukkan waktu pengerjaan";
                                                } else
                                                  return null;
                                              },
                                            ),
                                            const SizedBox(width: 60),
                                            ContainerAngkaPublish(
                                              validator: (p0) => null,
                                              iconData: Icons.monetization_on,
                                              textJudul: "Biaya Per Survei",
                                              controller: TextEditingController(
                                                  text: CurrencyFormat
                                                      .convertToIdr(
                                                          biayaPerPartisipan,
                                                          2)),
                                              enabled: false,
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            KotakPartisipan(
                                              jumlah: jumlahPartisipan,
                                              kurang: () =>
                                                  ubahPartisipan(false),
                                              tambah: () =>
                                                  ubahPartisipan(true),
                                            ),
                                            KotakInsentif(
                                              harga:
                                                  CurrencyFormat.convertToIdr(
                                                      insetifPerPartisipan, 2),
                                              kurang: () => ubahInsentif(false),
                                              tambah: () => ubahInsentif(true),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Jual Survei ?",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                      fontSize: 18,
                                                      color: Colors.blueGrey),
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
                                                controller:
                                                    controllerBiayaPembelian,
                                                validator: (p0) {
                                                  if (controllerBiayaPembelian
                                                              .text ==
                                                          "" &&
                                                      isJual) {
                                                    return "Masukkan harga survei anda";
                                                  } else
                                                    return null;
                                                },
                                              ),
                                            SizedBox(width: 4),
                                            Text(
                                              pesanErrorJual,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayLarge!
                                                  .copyWith(
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
                                ))
                            : kontenDemoGenerator(constraints)),
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: const EdgeInsets.only(
                            right: 14, top: 7, bottom: 28),
                        width: double.infinity,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Ringkasan Pembayaran",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 6),
                              // ContainerRingkasan(
                              //   judul: "Jumlah Partisipan",
                              //   text: "$jumlahPartisipan Partisipan",
                              // ),
                              // ContainerRingkasan(
                              //   text: CurrencyFormat.convertToIdr(
                              //       insetifPerPartisipan, 2),
                              //   judul: 'Insentif per Partisipan',
                              // ),
                              // ContainerRingkasan(
                              //   text: CurrencyFormat.convertToIdr(
                              //       biayaPerPartisipan, 2),
                              //   judul: "Biaya Survei per Partisipan",
                              // ),
                              const SizedBox(height: 14),
                              Text(
                                "Total Pembayaran",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w600,
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
                                    borderRadius: BorderRadius.circular(4)),
                                margin: const EdgeInsets.only(top: 1),
                                padding: const EdgeInsets.all(10),
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Partisipan x (Insentif + Biaya / Survei)",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "$jumlahPartisipan x (${CurrencyFormat.convertToIdr(insetifPerPartisipan, 2)} + ${CurrencyFormat.convertToIdr(biayaPerPartisipan, 2)})",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            fontSize: 21.5,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Total : " +
                                          CurrencyFormat.convertToIdr(
                                              (jumlahPartisipan *
                                                  (insetifPerPartisipan +
                                                      biayaPerPartisipan)),
                                              2),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            fontSize: 23,
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
                                      final isValidForm =
                                          _publishKey.currentState!.validate();
                                      final isValidDemografi =
                                          (_demografiKey.currentState == null)
                                              ? true
                                              : _demografiKey.currentState!
                                                  .validate();
                                      if (isValidForm &&
                                          isValidDemografi &&
                                          cekErrorDemografi() &&
                                          cekErrorForm()) {
                                        print("sukses pengecekan");

                                        showAlertDialog(context);
                                      }

                                      setState(() {});
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
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
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget kontenGenerator() {
    return (mode == "normal")
        ? generateKontenUtama()
        : LoadingBiasa(
            text: "Sedang memproses publikasi",
            pakaiKembali: false,
          );
  }

  Widget bodyGenerator() {
    if (halAkhir) {
      return const SelesaiOrder();
    } else if (isDone) {
      return LoadingBiasa(
        text: "Memproses Transaksi Survei",
        pakaiKembali: false,
      );
    } else {
      return (insetifPerPartisipan == 0)
          ? LoadingBiasa(
              text: "Memuat Data Survei dan Harga",
              pakaiKembali: true,
            )
          : kontenGenerator();
    }
  }

  bool isDone = false;

  final _publishKey = GlobalKey<FormState>();
  final _demografiKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade100,
      body: bodyGenerator(),
    );
  }
}
