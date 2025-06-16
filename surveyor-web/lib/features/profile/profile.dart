import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hei_survei/app/app.dart';
import 'package:hei_survei/constants.dart';
import 'package:hei_survei/features/profile/models/sejarah_pembelian.dart';
import 'package:hei_survei/features/profile/models/sejarah_penambahan.dart';
import 'package:hei_survei/features/profile/models/sejarah_pencairan.dart';
import 'package:hei_survei/features/profile/profile_controller.dart';
import 'package:hei_survei/features/profile/user_data.dart';
import 'package:hei_survei/features/profile/widgets/field_container.dart';
import 'package:hei_survei/features/profile/widgets/kartu_SPP.dart';
import 'package:hei_survei/features/profile/widgets/kartu_pembelian.dart';
import 'package:hei_survei/features/profile/widgets/kartu_sejarah.dart';
import 'package:hei_survei/features/profile/widgets/kotak_samping.dart';
import 'package:hei_survei/features/profile/widgets/lingkaran_foto.dart';
import 'package:hei_survei/utils/currency.dart';
import 'package:hei_survei/utils/loading_biasa.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class HalamanProfile extends ConsumerStatefulWidget {
  HalamanProfile({
    super.key,
    required this.constraints,
  });
  BoxConstraints constraints;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HalamanProfileState();
}

class _HalamanProfileState extends ConsumerState<HalamanProfile> {
  bool isPerbaruan = false;
  UserData? userData;
  var controllerUsername = TextEditingController();
  // var controllerEmail = TextEditingController();
  String emailUser = "";
  var controllerPasswordLama = TextEditingController();
  var controllerPasswordBaru = TextEditingController();
  //loading tombol
  bool isLoadingPass = false;
  bool isLoadingName = false;
  //
  //pilihan gambar
  Uint8List? selectedImageBytes;
  String selectedFile = '';
  String urlGambarUser = '';
  //
  //persiapan userData
  // UserData userData = UserData(
  //   email: "kennylisal5@gmail.com",
  //   username: "kennyli",
  //   urlGambar:
  //       "https://firebasestorage.googleapis.com/v0/b/hei-survei-v1.appspot.com/o/profile%2Fcea693d8-4e?alt=media&token=f858e0cc-1484-4539-b631-e3971f49949e",
  //   poin: 500000,
  // );
  //
  //Persiapan yang berhubungan dengan dana
  List<SejarahPencairan>? listPencairan;
  List<SejarahPenambahanPoin>? listPembelian;
  final controller = TextEditingController();
  //

  pilihGamabr() async {
    //bikin nama baru
    //compress
    FilePickerResult? fileResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );
    if (fileResult != null) {
      print(fileResult.files.first.size);
      selectedFile = fileResult.files.first.name;
      selectedImageBytes = fileResult.files.first.bytes;
    }
    // print(fileResult!.files[0].size);

    if (fileResult != null) {
      setState(() {
        selectedFile = fileResult.files.first.name;
        selectedImageBytes = fileResult.files.first.bytes;
      });
    } else {
      print("File tidak sesuai extension atau belum pilih");
    }
    String urlBaru = await uploadGambar();
    if (urlBaru != '') {
      urlGambarUser = urlBaru;
    } else {}
    print(urlGambarUser);
    setState(() {});
  }

  Future<String> uploadGambar() async {
    try {
      if (selectedImageBytes != null) {
        String namaBaru = Uuid().v4().substring(0, 11);
        firebase_storage.UploadTask uploadTask;

        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('profile')
            .child('/' + namaBaru);

        final metaData =
            firebase_storage.SettableMetadata(contentType: 'image/jpeg');

        uploadTask = ref.putData(selectedImageBytes!, metaData);

        await uploadTask.whenComplete(() => null);
        String imageUrl = await ref.getDownloadURL();
        print('uploaded image URL : $imageUrl');

        return imageUrl;
      } else {
        return '';
      }
    } catch (e) {
      print(e);
      return '';
    }
  }

  bool isKecil() => widget.constraints.maxWidth > 1480;
  double panjangContainer() {
    return (isKecil() ? 780 : 500);
  }

  Widget kotakSamping(double width) => KotakSamping(
        marginKiri: (width < 1620) ? 0 : 150,
        onPressedKeluar: () async {
          setState(() {
            // userData = null;
          });
          await ref.read(authProvider.notifier).signOut(context);
        },
        onPressedPerbaruan: () {
          setState(() {
            isPerbaruan = true;
          });
        },
        onPressedTampilan: () {
          setState(() {
            isPerbaruan = false;
          });
        },
      );

  Widget generateUsernameField() {
    if (isPerbaruan) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 2)),
        child: Column(
          children: [
            FieldContainerText(
              controller: controllerUsername,
              textJudul: "Masukkan Username Baru",
              hintText: "Masukkan Username Baru",
              isObscure: false,
            ),
            const SizedBox(height: 20),
            ButtonProfile(
              text: "Perbarui Username",
              onPressed: () async {
                if (!isLoadingName) {
                  setState(() {
                    isLoadingName = true;
                  });
                  final hasil = await ProfileController()
                      .gantiUsername(controllerUsername.text, context);
                  if (hasil) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Username Berhasil Diperbarui")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "Username Telah digunakan, masukkan nama lain")));
                  }
                  setState(() {
                    isLoadingName = false;
                  });
                }
              },
              isLoading: isLoadingName,
            ),
          ],
        ),
      );
    } else {
      return FieldText(
        textJudul: "Username",
        text: controllerUsername.text,
      );
    }
  }

  Widget generatePasswordField() {
    if (isPerbaruan) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 2)),
        child: Column(
          children: [
            FieldContainerText(
              controller: controllerPasswordLama,
              textJudul: "Password Lama",
              hintText: "Masukkan Password lama anda disini",
              isObscure: true,
            ),
            const SizedBox(height: 20),
            FieldContainerText(
              controller: controllerPasswordBaru,
              textJudul: "Password Baru",
              hintText: "Masukka Password Baru anda disini",
              isObscure: true,
            ),
            const SizedBox(height: 20),
            ButtonProfile(
              text: "Perbarui Sandi",
              onPressed: () async {
                if (!isLoadingPass) {
                  setState(() {
                    isLoadingPass = true;
                  });
                  final hasil = await ProfileController().gantiPassword(
                    passwordLama: controllerPasswordLama.text,
                    passwordBaru: controllerPasswordBaru.text,
                    context: context,
                  );
                  if (hasil) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Sandi Berhasil Diperbarui")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Sandi Lama tidak sesuai")));
                  }
                  setState(() {
                    isLoadingPass = false;
                  });
                }
              },
              isLoading: isLoadingPass,
            ),
          ],
        ),
      );
    } else
      return SizedBox();
  }

  Widget contentProfileUtama() {
    return Container(
      width: panjangContainer(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 3, color: Colors.black)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 14),
            Text(
              "Halaman Profile",
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 48,
                  color: Colors.black),
            ),
            const SizedBox(height: 24),
            LingkaranFoto(
              isEditable: isPerbaruan,
              urlFoto: urlGambarUser,
              onTap: () async {
                await pilihGamabr();
                setState(() {});
                if (!context.mounted) return;
                await ProfileController().gantiFoto(urlGambarUser, context);
              },
            ),
            SizedBox(height: 18),
            FieldText(
              textJudul: "Email",
              text: emailUser,
            ),
            const SizedBox(height: 24),
            // generateUsernameField(),
            // const SizedBox(height: 24),
            generatePasswordField()
          ],
        ),
      ),
    );
  }

  Widget contentGenerator() {
    if (userData == null) {
      return LoadingBiasa(
        text: "Memuat Data",
        pakaiKembali: false,
      );
    } else {
      return contentProfileUtama();
    }
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  initData() async {
    userData = await ProfileController().getUserData();
    if (userData != null) {
      emailUser = userData!.email;
      controllerUsername.text = userData!.username;
      urlGambarUser = userData!.urlGambar;
      setState(() {});
      listPembelian = await ProfileController().getUserSPP();
      listPencairan = await ProfileController().getAllSejarah();
      print(listPembelian);
      setState(() {});
    }
  }

  Widget generateSejarahPencairan() {
    if (listPencairan == null) {
      return const SizedBox(
        height: 70,
        width: 70,
        child: CircularProgressIndicator(
          color: Colors.blue,
          strokeWidth: 7,
        ),
      );
    } else {
      if (listPencairan!.isEmpty) {
        return Image.asset(
          'assets/belum-ada-penarikan.png',
          height: 175,
        );
      } else {
        return Column(
          children: [for (var e in listPencairan!) KartuSejarah(data: e)],
        );
      }
    }
  }

  Widget generateSejarahPembelian() {
    if (listPembelian == null) {
      return const SizedBox(
        height: 70,
        width: 70,
        child: CircularProgressIndicator(
          color: Colors.blue,
          strokeWidth: 7,
        ),
      );
    } else {
      if (listPembelian!.isEmpty) {
        return Image.asset(
          'assets/belum-ada-pembelian.png',
          height: 175,
        );
      } else {
        return Column(
          children: [
            for (var e in listPembelian!) KartuSPP(isSmall: false, sejarah: e)
          ],
        );
      }
    }
  }

  bool pengecekanPengajuan() {
    if (controller.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("input kosong")));
      return false;
    } else if (userData!.poin < 10000) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Poin belum 10.000")));
      return false;
    } else if (int.parse(controller.text) < 10000) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Poin yang ditarik dibawah 10000")));
      return false;
    } else {
      return true;
    }
  }

  pengajuanPencairan() async {
    final cekAkhir = pengecekanPengajuan();
    if (cekAkhir) {
      if (listPencairan != null) {
        final hasil = await ProfileController().pengajuanPencairan(
            email: userData!.email, jumlah: int.parse(controller.text));
        if (!context.mounted) return;
        if (hasil == "Permintaan terkirim") {
          setState(() {
            listPencairan = null;
          });
          listPencairan = await ProfileController().getAllSejarah();
          setState(() {});
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(hasil)));
        }
      }
    }
  }

  Widget bodyGenerator() {
    if (userData != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                contentGenerator(),
                if (widget.constraints.maxWidth > 1175 && userData != null)
                  kotakSamping(widget.constraints.maxWidth),
              ],
            ),
          ),
          if (widget.constraints.maxWidth < 1175 && userData != null)
            Center(child: kotakSamping(widget.constraints.maxWidth)),
          const SizedBox(height: 12.5),
          Center(
            child: Text(
              "Pengolahan Dana",
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 48,
                  color: Colors.black),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
            height: 600,
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 2, color: Colors.blueGrey.shade300)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Container(
                  padding: EdgeInsets.all(14),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          "Penarikan Dana",
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35,
                                  color: Colors.black),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          margin:
                              EdgeInsets.only(bottom: 16, left: 24, right: 24),
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 18),
                          width: double.infinity,
                          //height: 120,
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.black),
                              color: Color.fromARGB(255, 0, 189, 63),
                              borderRadius: BorderRadius.circular(24)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Poin Anda",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                          fontSize: 19,
                                          color: Colors.white,
                                        ),
                                  ),
                                  Icon(
                                    Icons.monetization_on_rounded,
                                    size: 40,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                              Text(
                                CurrencyFormat.convertToIdr(userData!.poin, 2),
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                        fontSize: 36,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 14),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "Penarikan minimal Rp.10.000",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 9.5),
                          child: Row(
                            children: [
                              Flexible(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        width: 2,
                                        color: Colors.black,
                                      )),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 18.5, horizontal: 20),
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  child: TextField(
                                    controller: controller,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                          fontSize: 25,
                                          color: Colors.black,
                                        ),
                                    // controller: controllerAngka,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: InputDecoration.collapsed(
                                      hintText: "Poin yang mau ditarik",
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(
                                            fontSize: 22,
                                            color: Colors.black,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  controller.text = userData!.poin.toString();
                                },
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Icon(
                                    Icons.arrow_circle_up,
                                    color: Colors.white,
                                    size: 36,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            width: 280,
                            height: 60,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 16),
                            child: ElevatedButton(
                                onPressed: () async => pengajuanPencairan(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade600,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  "Ajukan Pencarian",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .copyWith(
                                        color: Colors.white,
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ))),
                        const SizedBox(height: 10),
                        Text(
                          "Sejarah Penarikan",
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                  color: Colors.black),
                        ),
                        const SizedBox(height: 10),
                        generateSejarahPencairan(),
                      ],
                    ),
                  ),
                )),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.all(14),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Hasil Pembelian Survei",
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35,
                                  color: Colors.black),
                        ),
                        const SizedBox(height: 10),
                        generateSejarahPembelian(),
                      ],
                    ),
                  ),
                ))
              ],
            ),
          ),
        ],
      );
    } else {
      return LoadingBiasa(text: "Memuat Data Profile", pakaiKembali: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return SingleChildScrollView(
      child: bodyGenerator(),
    );
  }

  // @override
  // bool get wantKeepAlive => (baseUri == Uri.base.toString());
}




// Stack(
                        //   children: [

                        //     InkWell(
                        //       onTap: () async {
                        //         // String urlBaru =
                        //         //     await ProfileController().gantiFoto(context);
                        //         // if (!context.mounted) return;
                        //         // ScaffoldMessenger.of(context)
                        //         //     .showSnackBar(const SnackBar(
                        //         //         content: Text(
                        //         //   "Berhasil perbarui gambar",
                        //         // )));
                        //         // if (urlBaru != "") {
                        //         //   print(urlBaru);
                        //         //   if (!context.mounted) return;
                        //         //   ref
                        //         //       .read(authProvider.notifier)
                        //         //       .gantiGambar(urlBaru, context);
                        //         // } else {
                        //         //   ScaffoldMessenger.of(context)
                        //         //       .showSnackBar(const SnackBar(
                        //         //           content: Text(
                        //         //     "Gagal upload gambar",
                        //         //   )));
                        //         // }
                        //       },
                        //       child: CircleAvatar(
                        //         backgroundColor: Colors.blue,
                        //         radius: 120,
                        //         child: CachedNetworkImage(
                        //           imageUrl:
                        //               // ref.watch(authProvider).user.urlGambar,

                        //               "https://firebasestorage.googleapis.com/v0/b/hei-survei-v1.appspot.com/o/images%2Ffoto%20profil%20kosong.jpeg?alt=media&token=6be0619a-508e-44d8-857f-08c316ec3aeb",
                        //           imageBuilder: (context, imageProvider) {
                        //             return Container(
                        //               decoration: BoxDecoration(
                        //                   shape: BoxShape.circle,
                        //                   image: DecorationImage(
                        //                       image: imageProvider,
                        //                       fit: BoxFit.cover)),
                        //             );
                        //           },
                        //           placeholder: (context, url) =>
                        //               CircularProgressIndicator(),
                        //           errorWidget: (context, url, error) {
                        //             print(error);
                        //             return Column(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.center,
                        //               children: [
                        //                 const Icon(Icons.error,
                        //                     size: 30, color: Colors.red),
                        //                 Text(
                        //                   "Gambar Gagal Dimuat",
                        //                   style: Theme.of(context)
                        //                       .textTheme
                        //                       .displayMedium!
                        //                       .copyWith(
                        //                         fontSize: 18,
                        //                         color: Colors.red,
                        //                       ),
                        //                 )
                        //               ],
                        //             );
                        //           },
                        //           fit: BoxFit.cover,
                        //         ),
                        //       ),
                        //     ),
                        //     Container(
                        //       width: 35,
                        //       height: 35,
                        //       decoration: BoxDecoration(
                        //           shape: BoxShape.circle,
                        //           color: Colors.indigoAccent),
                        //       child: const Icon(Icons.settings),
                        //     )
                        //   ],
                        // ),