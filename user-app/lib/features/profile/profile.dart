import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:survei_aplikasi/features/app/app.dart';
import 'package:survei_aplikasi/features/app/router/router_constant.dart';
import 'package:survei_aplikasi/features/profile/penarikan_dana.dart';
import 'package:survei_aplikasi/features/profile/profile_controller.dart';
import 'package:survei_aplikasi/features/profile/sejarah_kontribusi.dart';
import 'package:survei_aplikasi/features/profile/user_data.dart';
import 'package:survei_aplikasi/features/profile/widget/container_teks_general.dart';
import 'package:survei_aplikasi/features/profile/widget/container_update_demo.dart';
import 'package:survei_aplikasi/features/profile/widget/halaman_ganti_pass.dart';
import 'package:survei_aplikasi/features/profile/widget/tampilan_demografi.dart';
import 'package:survei_aplikasi/features/profile/widget/tampilan_info_user.dart';
import 'package:survei_aplikasi/utils/loading_biasa.dart';
import 'package:url_launcher/url_launcher.dart';

enum DaftarHalaman { profile, edit, penarikan, history }

class HalamanProfile extends ConsumerStatefulWidget {
  HalamanProfile({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HalamanProfileState();
}

class _HalamanProfileState extends ConsumerState<HalamanProfile>
// with AutomaticKeepAliveClientMixin<HalamanProfile>
{
  //pemilihan kota
  List<String> listKota = [];
  List<String> listInterest = [];
  String kotaPilihan = "";
  List<String> pilihanInterest = [];
  DateTime? tglLahir;
  //
  bool isLoadingGambar = false;
  UserData? user;
  bool isModeEdit = false;
  var mode = DaftarHalaman.profile;
  final passLama = TextEditingController();
  final passBaru = TextEditingController();
  bool bisaUpdateDemo = false;
  //Daftar widgget
  // late Widget updateDemo;
  //update demo yang dicari untuk demografi data

  initData() async {
    listKota = await ProfileController().getAllKota();
    listInterest = await ProfileController().getAllInterest();
    user = await ProfileController().getUserData();
    bisaUpdateDemo = await ProfileController().bisaUpdateDemo();
    setState(() {});
  }

  Widget generateTampilanAwal({
    required bool isEditMode,
    required Function()? onPressedVerifikasiHP,
    required Function()? onPressedUpdatePass,
    required Function()? onPressedEditProfile,
    required TextEditingController passBaru,
    required TextEditingController passLama,
    required Function()? onPressedModeNormal,
    required UserData user,
  }) {
    return Column(
      children: [
        ContainerTeks(
          judul: "Email",
          text: user.email,
          iconData: Icons.email,
          warnaTeks: Colors.black,
        ),
        (!isEditMode)
            ? Column(
                children: [
                  ContainerTeks(
                    judul: "Tanggal Bergabung",
                    text: DateFormat('dd / MMMM / yyyy')
                        .format(user.waktu_pendaftaran),
                    iconData: Icons.calendar_today,
                    warnaTeks: Colors.black,
                  ),
                  ContainerTeks(
                    judul: "Verifikasi Nomor HP",
                    text: (user.isAuthenticated) ? "Sudah" : "Belum",
                    iconData: Icons.phone_android,
                    warnaTeks:
                        (user.isAuthenticated) ? Colors.blue : Colors.red,
                  ),
                  TampilanDemografi(user: user),
                  ElevatedButton(
                      onPressed: onPressedEditProfile,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 26)),
                      child: Text(
                        "Edit Profile",
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                      )),
                  SizedBox(height: 20),
                  if (!user.isAuthenticated)
                    ElevatedButton(
                        onPressed: onPressedVerifikasiHP,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightGreen,
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 26)),
                        child: Text(
                          "Verifikasi No Hp",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        )),
                  const SizedBox(height: 20),
                ],
              )
            : Column(
                children: [
                  ContainerUpdatePassword(
                    passBaru: passBaru,
                    passLama: passLama,
                    onPressed: onPressedUpdatePass,
                  ),
                  const SizedBox(height: 20),
                  //disini bisa dinganti" dgn backend
                  if (user.kota == "" || bisaUpdateDemo)
                    ContainerUpdateDemografi(
                      kotaPilihan: kotaPilihan,
                      listInterest: listInterest,
                      listKota: listKota,
                      onChangedInterest: (value) => gantiInterest(value),
                      onChangedKota: (value) => gantiKota(value),
                      onPressedGantiTanggal: () async => await pilihTanggal(),
                      onSubmit: () async => await onSubmitUtama(),
                      pilihanInterest: pilihanInterest,
                      tglLahir: tglLahir,
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: onPressedModeNormal,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo.shade600,
                          padding: const EdgeInsets.symmetric(
                              vertical: 22, horizontal: 26)),
                      child: Text(
                        "Mode Normal",
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                      )),
                  const SizedBox(height: 15),
                  ElevatedButton(
                      onPressed: () async {
                        final Uri url =
                            Uri.parse('https://phase-one-ta.web.app');
                        if (!await launchUrl(url)) {
                          log("Error buka web");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo.shade600,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 15)),
                      child: Text(
                        "Pengajuan Penghapusan Akun",
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                      )),
                  const SizedBox(height: 15),
                ],
              )
      ],
    );
  }

  Widget tampilanTanggalDemo() {
    if (tglLahir != null) {
      return Text(
        //"${dataTanggal.date!.day} : ${dataTanggal.date!.month} : ${dataTanggal.date!.year} ",
        DateFormat("dd / MMMM / yyyy").format(tglLahir!),
        style: Theme.of(context)
            .textTheme
            .headlineMedium!
            .copyWith(fontWeight: FontWeight.bold),
      );
    } else {
      return SizedBox();
    }
  }

  gantiGambarProfile() async {
    if (!isLoadingGambar) {
      setState(() {
        isLoadingGambar = true;
      });
      String hasil = await ProfileController().gantiFoto(context);
      if (hasil != "") {
        user!.url_gambar = hasil;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "Berhasil ganti gambar",
        )));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "Gagal ganti gambar",
        )));
      }
      setState(() {
        isLoadingGambar = false;
      });
    }
  }

  gantiInterest(List<String?> value) {
    print;
    setState(() {
      pilihanInterest = List.generate(value.length, (index) => value[index]!);
    });
  }

  gantiKota(String? value) {
    print;
    setState(() {
      kotaPilihan = value!;
    });
  }

  pilihTanggal() async {
    DateTime? newDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        //initialDate: dataTanggal.date,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    // print(newDate);
    // if (newDate == null) return;
    setState(() {
      tglLahir = newDate;
      print("ganti tanggal ----------- $tglLahir");
    });
  }

  updateUserDemoLokal() {
    user!.tglLahir = tglLahir!;
    user!.kota = kotaPilihan;
    user!.interest = pilihanInterest;
  }

  onSubmitUtama() async {
    if (tglLahir == null || kotaPilihan == "" || pilihanInterest.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lengkapi Dahulus seluruh pengisian data")));
    } else if (pilihanInterest.length > 4) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Interest maksimal 4")));
    } else {
      bool hasil = await ProfileController().udpateDemo(
          tglLahir!.millisecondsSinceEpoch, kotaPilihan, pilihanInterest);
      if (!context.mounted) return;
      if (hasil) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("berhasil perbarui demografi")));
        isModeEdit = false;
        updateUserDemoLokal();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Gagal perbarui demografi")));
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    initData();
    super.initState();
  }
  //   AlertDialog alert = AlertDialog(
  //   title: Text("Peringatan"),
  //   content: Text("Yakin mau keluar dari akun ini?"),
  //   actions: [
  //     TextButton(
  //         onPressed: () {
  //           Future.delayed(
  //             Duration.zero,
  //             () {
  //               Navigator.of(context).pop();
  //             },
  //           );

  //           ref.read(authProvider.notifier).signOut(context);
  //         },
  //         child: Text("Oke")),
  //     TextButton(
  //         onPressed: () {
  //           Future.delayed(
  //             Duration.zero,
  //             () {
  //               Navigator.of(context).pop();
  //             },
  //           );
  //         },
  //         child: Text("Batal")),
  //   ],
  // );

  AlertDialog generateAlertLogOut() {
    return AlertDialog(
      title: Text("Peringatan"),
      content: Text("Yakin mau keluar dari akun ini?"),
      actions: [
        TextButton(
            onPressed: () {
              Future.delayed(
                Duration.zero,
                () {
                  Navigator.of(context).pop();
                },
              );

              ref.read(authProvider.notifier).signOut(context);
            },
            child: Text("Oke")),
        TextButton(
            onPressed: () {
              Future.delayed(
                Duration.zero,
                () {
                  Navigator.of(context).pop();
                },
              );
            },
            child: Text("Batal")),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);

    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.blue.shade100,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: (user == null)
                  ? SizedBox(width: double.infinity, child: LoadingBiasa())
                  : SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 12),
                                child: CircleAvatar(
                                  backgroundColor: Colors.red,
                                  child: IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) =>
                                                generateAlertLogOut());
                                      },
                                      icon: Icon(
                                        Icons.logout,
                                        color: Colors.white,
                                      ),
                                      color: Colors.red),
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      mode = DaftarHalaman.profile;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.person_rounded,
                                    color: Colors.blue,
                                    size: 34,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isModeEdit = false;
                                      mode = DaftarHalaman.penarikan;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.monetization_on,
                                    color: Colors.green,
                                    size: 30,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isModeEdit = false;
                                      mode = DaftarHalaman.history;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.history_edu,
                                    size: 30,
                                    color: Colors.yellow.shade700,
                                  )),
                            ],
                          ),
                          Stack(
                            children: [
                              Container(
                                width: 152,
                                height: 152,
                                decoration: BoxDecoration(
                                  color: const Color(0xff7c94b6),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                ),
                                child: (isLoadingGambar)
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ))
                                    : InkWell(
                                        onTap: () async {
                                          if (isModeEdit) {
                                            await gantiGambarProfile();
                                          }
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl: user!.url_gambar,
                                          imageBuilder:
                                              (context, imageProvider) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover)),
                                            );
                                          },
                                          placeholder: (context, url) =>
                                              Padding(
                                            padding: const EdgeInsets.all(9.0),
                                            child: CircularProgressIndicator(),
                                          ),
                                          errorWidget: (context, url, error) {
                                            print(error);
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(Icons.error,
                                                    size: 30,
                                                    color: Colors.red),
                                                Text(
                                                  "Gambar Gagal Dimuat",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displayMedium!
                                                      .copyWith(
                                                        fontSize: 18,
                                                        color: Colors.red,
                                                      ),
                                                )
                                              ],
                                            );
                                          },
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                              if (isModeEdit)
                                Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.indigoAccent),
                                  child: const Icon(Icons.settings),
                                )
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (mode == DaftarHalaman.profile)
                            generateTampilanAwal(
                              isEditMode: isModeEdit,
                              onPressedVerifikasiHP: () =>
                                  context.pushNamed(RouteConstant.otp),
                              onPressedUpdatePass: () async {
                                bool hasil = await ProfileController()
                                    .gantiPassword(
                                        passLama.text, passBaru.text, context);
                                if (!context.mounted) return;
                                if (hasil) {
                                  passLama.text = "";
                                  passBaru.text = "";
                                }
                                setState(() {});
                              },
                              onPressedEditProfile: () {
                                setState(() {
                                  isModeEdit = true;
                                });
                              },
                              onPressedModeNormal: () {
                                setState(() {
                                  isModeEdit = false;
                                });
                              },
                              passBaru: passBaru,
                              passLama: passLama,
                              user: user!,
                            )
                          else if (mode == DaftarHalaman.penarikan)
                            PenarikanDana(
                              poin: user!.poin,
                              email: user!.email,
                            )
                          else if (mode == DaftarHalaman.history)
                            TampilanHistory(
                              constraints: constraints,
                            )
                        ],
                      ),
                    ),
            );
          },
        ));
  }

  @override
  //  bool get wantKeepAlive => (baseUri == Uri.base.toString());
  bool get wantKeepAlive => true;
}




// class _HalamanProfileState extends ConsumerState<HalamanProfile>
// // with AutomaticKeepAliveClientMixin<HalamanProfile>
// {
//   //pemilihan kota
//   List<String> listKota = [];
//   List<String> listInterest = [];
//   String kotaPilihan = "";
//   List<String> pilihanInterest = [];
//   DateTime? tglLahir;
//   //
//   bool isLoadingGambar = false;
//   UserData? user;
//   bool isModeEdit = false;
//   var mode = DaftarHalaman.profile;
//   final passLama = TextEditingController();
//   final passBaru = TextEditingController();
//   //Daftar widgget
//   late Widget updateDemo;
//   //update demo yang dicari untuk demografi data

//   initData() async {
//     listKota = await ProfileController().getAllKota();
//     listInterest = await ProfileController().getAllInterest();
//     user = await ProfileController().getUserData();
//     updateDemo = ContainerUpdateDemografi(
//       kotaPilihan: kotaPilihan,
//       listInterest: listInterest,
//       listKota: listKota,
//       onChangedInterest: (value) => gantiInterest(value),
//       onChangedKota: (value) => gantiKota(value),
//       onPressedGantiTanggal: () async => await pilihTanggal(),
//       onSubmit: () async => await onSubmitUtama(),
//       pilihanInterest: pilihanInterest,
//       tglLahir: tglLahir,
//       tampilanTanggal: tampilanTanggalDemo(),
//     );
//     setState(() {});
//   }

//   Widget generateTampilanAwal({
//     required bool isEditMode,
//     required Function()? onPressedVerifikasiHP,
//     required Function()? onPressedUpdatePass,
//     required Function()? onPressedEditProfile,
//     required TextEditingController passBaru,
//     required TextEditingController passLama,
//     Function()? onPressedModeNormal,
//     required UserData user,
//   }) {
//     return Column(
//       children: [
//         ContainerTeks(
//           judul: "Email",
//           text: user.email,
//           iconData: Icons.email,
//           warnaTeks: Colors.black,
//         ),
//         (!isEditMode)
//             ? Column(
//                 children: [
//                   ContainerTeks(
//                     judul: "Tanggal Bergabung",
//                     text: DateFormat('dd / MMMM / yyyy')
//                         .format(user.waktu_pendaftaran),
//                     iconData: Icons.calendar_today,
//                     warnaTeks: Colors.black,
//                   ),
//                   ContainerTeks(
//                     judul: "Verifikasi Nomor HP",
//                     text: (user.isAuthenticated) ? "Sudah" : "Belum",
//                     iconData: Icons.phone_android,
//                     warnaTeks:
//                         (user.isAuthenticated) ? Colors.blue : Colors.red,
//                   ),
//                   TampilanDemografi(user: user),
//                   ElevatedButton(
//                       onPressed: onPressedEditProfile,
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue,
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 15, horizontal: 26)),
//                       child: Text(
//                         "Edit Profile",
//                         style:
//                             Theme.of(context).textTheme.displayMedium!.copyWith(
//                                   fontSize: 20,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                       )),
//                   SizedBox(height: 20),
//                   if (!user.isAuthenticated)
//                     ElevatedButton(
//                         onPressed: onPressedVerifikasiHP,
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.lightGreen,
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 15, horizontal: 26)),
//                         child: Text(
//                           "Verifikasi No Hp",
//                           style: Theme.of(context)
//                               .textTheme
//                               .displayMedium!
//                               .copyWith(
//                                 fontSize: 20,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                         )),
//                   const SizedBox(height: 20),
//                 ],
//               )
//             : Column(
//                 children: [
//                   ContainerUpdatePassword(
//                     passBaru: passBaru,
//                     passLama: passLama,
//                     onPressed: onPressedUpdatePass,
//                   ),
//                   const SizedBox(height: 20),
//                   //disini bisa dinganti" dgn backend
//                   if (user.kota == "")
//                     ContainerUpdateDemografi(
//                       kotaPilihan: kotaPilihan,
//                       listInterest: listInterest,
//                       listKota: listKota,
//                       onChangedInterest: (value) => gantiInterest(value),
//                       onChangedKota: (value) => gantiKota(value),
//                       onPressedGantiTanggal: () async => await pilihTanggal(),
//                       onSubmit: () async => await onSubmitUtama(),
//                       pilihanInterest: pilihanInterest,
//                       tglLahir: tglLahir,
//                       tampilanTanggal: tampilanTanggalDemo(),
//                     ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                       onPressed: onPressedModeNormal,
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.indigo.shade600,
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 22, horizontal: 26)),
//                       child: Text(
//                         "Mode Normal",
//                         style:
//                             Theme.of(context).textTheme.displayMedium!.copyWith(
//                                   fontSize: 20,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                       )),
//                   SizedBox(height: 15),
//                 ],
//               )
//       ],
//     );
//   }

//   Widget tampilanTanggalDemo() {
//     if (tglLahir != null) {
//       return Text(
//         //"${dataTanggal.date!.day} : ${dataTanggal.date!.month} : ${dataTanggal.date!.year} ",
//         DateFormat("dd / MMMM / yyyy").format(tglLahir!),
//         style: Theme.of(context)
//             .textTheme
//             .headlineMedium!
//             .copyWith(fontWeight: FontWeight.bold),
//       );
//     } else {
//       return SizedBox();
//     }
//   }

//   gantiGambarProfile() async {
//     if (!isLoadingGambar) {
//       setState(() {
//         isLoadingGambar = true;
//       });
//       String hasil = await ProfileController().gantiFoto(context);
//       if (hasil != "") {
//         user!.url_gambar = hasil;
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//             content: Text(
//           "Berhasil ganti gambar",
//         )));
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//             content: Text(
//           "Gagal ganti gambar",
//         )));
//       }
//       setState(() {
//         isLoadingGambar = false;
//       });
//     }
//   }

//   gantiInterest(List<String?> value) {
//     print;
//     setState(() {
//       pilihanInterest = List.generate(value.length, (index) => value[index]!);
//     });
//   }

//   gantiKota(String? value) {
//     print;
//     setState(() {
//       kotaPilihan = value!;
//     });
//   }

//   pilihTanggal() async {
//     DateTime? newDate = await showDatePicker(
//         context: context,
//         initialDate: DateTime.now(),
//         //initialDate: dataTanggal.date,
//         firstDate: DateTime(1900),
//         lastDate: DateTime(2100));
//     // print(newDate);
//     // if (newDate == null) return;
//     setState(() {
//       tglLahir = newDate;
//       print("ganti tanggal ----------- $tglLahir");
//     });
//   }

//   updateUserDemoLokal() {
//     user!.tglLahir = tglLahir!;
//     user!.kota = kotaPilihan;
//     user!.interest = pilihanInterest;
//   }

//   onSubmitUtama() async {
//     if (tglLahir == null || kotaPilihan == "" || pilihanInterest.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Lengkapi Dahulus seluruh pengisian data")));
//     } else if (pilihanInterest.length > 4) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Interest maksimal 4")));
//     } else {
//       bool hasil = await ProfileController().udpateDemo(
//           tglLahir!.millisecondsSinceEpoch, kotaPilihan, pilihanInterest);
//       if (!context.mounted) return;
//       if (hasil) {
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("berhasil perbarui demografi")));
//         isModeEdit = false;
//         updateUserDemoLokal();
//       } else {
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text("Gagal perbarui demografi")));
//       }
//     }
//     setState(() {});
//   }

//   @override
//   void initState() {
//     initData();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // super.build(context);
//     AlertDialog alert = AlertDialog(
//       title: Text("Peringatan"),
//       content: Text("Yakin mau keluar dari akun ini?"),
//       actions: [
//         TextButton(
//             onPressed: () {
//               Future.delayed(
//                 Duration.zero,
//                 () {
//                   Navigator.of(context).pop();
//                 },
//               );

//               ref.read(authProvider.notifier).signOut(context);
//             },
//             child: Text("Oke")),
//         TextButton(
//             onPressed: () {
//               Future.delayed(
//                 Duration.zero,
//                 () {
//                   Navigator.of(context).pop();
//                 },
//               );
//             },
//             child: Text("Batal")),
//       ],
//     );

//     return Scaffold(
//         extendBodyBehindAppBar: true,
//         backgroundColor: Colors.blue.shade100,
//         body: LayoutBuilder(
//           builder: (context, constraints) {
//             return SingleChildScrollView(
//               child: (user == null)
//                   ? SizedBox(width: double.infinity, child: LoadingBiasa())
//                   : SizedBox(
//                       width: double.infinity,
//                       child: Column(
//                         children: [
//                           const SizedBox(height: 20),
//                           Row(
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.only(left: 12),
//                                 child: CircleAvatar(
//                                   backgroundColor: Colors.red,
//                                   child: IconButton(
//                                       onPressed: () {
//                                         showDialog(
//                                             context: context,
//                                             builder: (context) => alert);
//                                       },
//                                       icon: Icon(
//                                         Icons.logout,
//                                         color: Colors.white,
//                                       ),
//                                       color: Colors.red),
//                                 ),
//                               ),
//                               Spacer(),
//                               IconButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       mode = DaftarHalaman.profile;
//                                     });
//                                   },
//                                   icon: Icon(
//                                     Icons.person_rounded,
//                                     color: Colors.blue,
//                                     size: 34,
//                                   )),
//                               IconButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       isModeEdit = false;
//                                       mode = DaftarHalaman.penarikan;
//                                     });
//                                   },
//                                   icon: Icon(
//                                     Icons.monetization_on,
//                                     color: Colors.green,
//                                     size: 30,
//                                   )),
//                               IconButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       isModeEdit = false;
//                                       mode = DaftarHalaman.history;
//                                     });
//                                   },
//                                   icon: Icon(
//                                     Icons.history_edu,
//                                     size: 30,
//                                     color: Colors.yellow.shade700,
//                                   )),
//                             ],
//                           ),
//                           Stack(
//                             children: [
//                               Container(
//                                 width: 152,
//                                 height: 152,
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xff7c94b6),
//                                   shape: BoxShape.circle,
//                                   border: Border.all(
//                                     color: Colors.black,
//                                     width: 2.0,
//                                   ),
//                                 ),
//                                 child: (isLoadingGambar)
//                                     ? const Center(
//                                         child: CircularProgressIndicator(
//                                         color: Colors.white,
//                                       ))
//                                     : InkWell(
//                                         onTap: () async {
//                                           if (isModeEdit) {
//                                             await gantiGambarProfile();
//                                           }
//                                         },
//                                         child: CachedNetworkImage(
//                                           imageUrl: user!.url_gambar,
//                                           imageBuilder:
//                                               (context, imageProvider) {
//                                             return Container(
//                                               decoration: BoxDecoration(
//                                                   shape: BoxShape.circle,
//                                                   image: DecorationImage(
//                                                       image: imageProvider,
//                                                       fit: BoxFit.cover)),
//                                             );
//                                           },
//                                           placeholder: (context, url) =>
//                                               Padding(
//                                             padding: const EdgeInsets.all(9.0),
//                                             child: CircularProgressIndicator(),
//                                           ),
//                                           errorWidget: (context, url, error) {
//                                             print(error);
//                                             return Column(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                               children: [
//                                                 const Icon(Icons.error,
//                                                     size: 30,
//                                                     color: Colors.red),
//                                                 Text(
//                                                   "Gambar Gagal Dimuat",
//                                                   style: Theme.of(context)
//                                                       .textTheme
//                                                       .displayMedium!
//                                                       .copyWith(
//                                                         fontSize: 18,
//                                                         color: Colors.red,
//                                                       ),
//                                                 )
//                                               ],
//                                             );
//                                           },
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                               ),
//                               if (isModeEdit)
//                                 Container(
//                                   width: 35,
//                                   height: 35,
//                                   decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: Colors.indigoAccent),
//                                   child: const Icon(Icons.settings),
//                                 )
//                             ],
//                           ),
//                           const SizedBox(height: 10),
//                           if (mode == DaftarHalaman.profile)
//                             TampilanAwal(
//                               isEditMode: isModeEdit,
//                               onPressedVerifikasiHP: () {
//                                 context.pushNamed(RouteConstant.otp);
//                               },
//                               onPressedUpdatePass: () async {
//                                 bool hasil = await ProfileController()
//                                     .gantiPassword(
//                                         passLama.text, passBaru.text, context);
//                                 if (!context.mounted) return;
//                                 if (hasil) {
//                                   passLama.text = "";
//                                   passBaru.text = "";
//                                 }
//                                 setState(() {});
//                               },
//                               onPressedEditProfile: () {
//                                 setState(() {
//                                   isModeEdit = true;
//                                 });
//                               },
//                               onPressedModeNormal: () {
//                                 setState(() {
//                                   isModeEdit = false;
//                                 });
//                               },
//                               passBaru: passBaru,
//                               passLama: passLama,
//                               user: user!,
//                               containerUpdateDemo: updateDemo,
//                             )
//                           else if (mode == DaftarHalaman.penarikan)
//                             PenarikanDana(
//                               poin: user!.poin,
//                               email: user!.email,
//                             )
//                           else if (mode == DaftarHalaman.history)
//                             TampilanHistory(
//                               constraints: constraints,
//                             )
//                         ],
//                       ),
//                     ),
//             );
//           },
//         ));
//   }

//   @override
//   //  bool get wantKeepAlive => (baseUri == Uri.base.toString());
//   bool get wantKeepAlive => true;
// }


// if (!isLoadingGambar) {
//   setState(() {
//     isLoadingGambar = true;
//   });
//   bool hasil = await ProfileController()
//       .gantiFoto(widget.idUser, context);
//   if (hasil) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(const SnackBar(
//             content: Text(
//       "Berhasil ganti gambar",
//     )));
//   } else {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(const SnackBar(
//             content: Text(
//       "Gagal ganti gambar",
//     )));
//   }
//   setState(() {
//     isLoadingGambar = false;
//   });
// }
