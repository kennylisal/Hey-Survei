import 'package:aplikasi_admin/features/formV2/widget/loading_form.dart';
import 'package:aplikasi_admin/features/master_barrel/widgets/active_banned_row.dart';
import 'package:aplikasi_admin/features/master_component/field_container.dart';
import 'package:aplikasi_admin/features/master_component/header_master.dart';
import 'package:aplikasi_admin/features/master_user/user.dart';
import 'package:aplikasi_admin/features/master_user/user_controller.dart';
import 'package:aplikasi_admin/utils/hover_builder.dart';
import 'package:aplikasi_admin/utils/web_pagination.dart';
import 'package:flutter/material.dart';

class HalamanUser extends StatefulWidget {
  HalamanUser({
    super.key,
    required this.constraints,
  });
  BoxConstraints constraints;
  @override
  State<HalamanUser> createState() => _HalamanUserState();
}

class _HalamanUserState extends State<HalamanUser> {
  List<UserModel> listData = [];
  List<UserModel> listDataSimpanan = [];
  List<UserModel> listDataTampilan = [];

  int jumlahHalaman = 0;
  int jumlahItemPerhalaman = 10;
  int ctrPagination = 1;

  String kataSearch = "";

  final controller = TextEditingController();

  @override
  void initState() {
    Future(() async {
      listData = await UserController().getAllUser(context);
      listDataSimpanan = listData;
      setPagination();
      setState(() {});
    });
    super.initState();
  }

  siapkanData() {
    setState(() {
      kataSearch = controller.text;
      listDataSimpanan = listData
          .where((element) => element.email.toLowerCase().contains(kataSearch))
          .toList();
    });
  }

  setPagination() {
    if (listDataSimpanan.isEmpty) {
      jumlahHalaman = 0;
      ctrPagination = 0;
      isiHasilDitampilkan(0);
    } else {
      jumlahHalaman = (listDataSimpanan.length ~/ jumlahItemPerhalaman) +
          ((listDataSimpanan.length % jumlahItemPerhalaman > 0) ? 1 : 0);
      print(
          "isi hasil ditampilkan ->  lbh 1 || jumlah halaman -> $jumlahHalaman");
      isiHasilDitampilkan(1);
      ctrPagination = 1;
    }
  }

  isiHasilDitampilkan(int nomorHalaman) {
    if (nomorHalaman != 0) {
      int index = nomorHalaman - 1;
      int awal = index * jumlahItemPerhalaman;
      int jumlah = 0;
      if ((awal + jumlahItemPerhalaman) >= listDataSimpanan.length) {
        jumlah = listDataSimpanan.length;
      } else {
        jumlah = nomorHalaman * jumlahItemPerhalaman;
      }

      print("ini awal -> $awal || ini jumlah -> $jumlah");
      List<UserModel> temp = listDataSimpanan.sublist(awal, jumlah);
      listDataTampilan = temp;
    }
    setState(() {});
  }

  List<TableRow> generateTableRow(BuildContext context) {
    List<TableRow> temp = [];
    listDataTampilan = listData
        .where((element) => element.email.toLowerCase().contains(kataSearch))
        .toList();
    for (var element in listDataTampilan) {
      temp.add(
        TableRow(
          children: [
            Container(
              height: 40,
              child: Center(
                  child: Text(
                element.email,
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
              )),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  element.tgl,
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color: Colors.black,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                ),
              ),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  (element.isVerified) ? "Iya" : "Tidak",
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color: Colors.black,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                ),
              ),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  (element.isBanned) ? "Iya" : "Tidak",
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color: Colors.black,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: AktifBannedRow(
                onPressedAktifkan: () async {
                  bool hasil = await UserController()
                      .setUserStatus(context, element.idUser, false);
                  if (hasil) {
                    setState(() {
                      element.isBanned = false;
                    });
                  }
                },
                onPressedBanned: () async {
                  bool hasil = await UserController()
                      .setUserStatus(context, element.idUser, true);
                  if (hasil) {
                    setState(() {
                      element.isBanned = true;
                    });
                  }
                },
              ),
            )
          ],
        ),
      );
    }

    return temp;
  }

  contentGenerator() {
    if (listData.isNotEmpty) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderMaster(
              constraints: widget.constraints,
              controller: controller,
              hintText: "Cari User / email",
              onSubmitted: (value) => siapkanData(),
              onTap: () => siapkanData(),
              onTapReset: () {
                controller.text = "";
                siapkanData();
              },
              textJudul: "Master User",
            ),
            const SizedBox(height: 18),
            Center(
              child: Text(
                "Daftar User",
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 18),
            Center(
              child: Container(
                width: 1250,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Table(
                    border: TableBorder.all(
                      borderRadius: BorderRadius.circular(20),
                      width: 2,
                    ),
                    columnWidths: const <int, TableColumnWidth>{
                      0: FractionColumnWidth(0.26),
                      1: FractionColumnWidth(0.25),
                      2: FractionColumnWidth(0.125),
                      3: FractionColumnWidth(0.125),
                      4: FractionColumnWidth(0.25),
                    },
                    children: [
                      TableRow(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.blueAccent.shade100,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20))),
                            height: 40,
                            child: Center(
                                child: Text(
                              "Email",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(
                                    color: Colors.black,
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                  ),
                            )),
                          ),
                          Container(
                            height: 40,
                            color: Colors.blueAccent.shade100,
                            child: Center(
                                child: Text(
                              "Tanggal Daftar",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(
                                    color: Colors.black,
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                  ),
                            )),
                          ),
                          Container(
                            height: 40,
                            color: Colors.blueAccent.shade100,
                            child: Center(
                                child: Text(
                              "Verified",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(
                                    color: Colors.black,
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                  ),
                            )),
                          ),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.shade100,
                            ),
                            child: Center(
                                child: Text(
                              "Banned",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(
                                    color: Colors.black,
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                  ),
                            )),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.blueAccent.shade100,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20))),
                            height: 40,
                            child: Center(
                                child: Text(
                              "Aksi",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(
                                    color: Colors.black,
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                  ),
                            )),
                          ),
                        ],
                      ),
                      ...generateTableRow(context)
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            WebPagination(
              onPageChanged: (value) {
                setState(() {
                  ctrPagination = value;
                  isiHasilDitampilkan(ctrPagination);
                });
              },
              currentPage: ctrPagination,
              totalPage: jumlahHalaman,
              displayItemCount: 5,
            ),
            const SizedBox(height: 14),
          ],
        ),
      );
    } else {
      return LoadingBiasa(text: "Memuat Data Pengguna");
    }
  }

  @override
  Widget build(BuildContext context) {
    return contentGenerator();
  }
}

// for (var i = 0; i < listTampilan.length; i++) {
    //   temp.add(
    //     TableRow(
    //       children: [
    //         Container(
    //           height: 40,
    //           child: Center(
    //               child: Text(
    //             listUser[i].email,
    //             style: Theme.of(context).textTheme.displayLarge!.copyWith(
    //                   color: Colors.black,
    //                   fontSize: 21,
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //           )),
    //         ),
    //         Center(
    //           child: Container(
    //             padding: const EdgeInsets.all(8),
    //             child: Text(
    //               listUser[i].tgl,
    //               style: Theme.of(context).textTheme.displayLarge!.copyWith(
    //                     color: Colors.black,
    //                     fontSize: 21,
    //                     fontWeight: FontWeight.bold,
    //                     overflow: TextOverflow.ellipsis,
    //                   ),
    //             ),
    //           ),
    //         ),
    //         Center(
    //           child: Container(
    //             padding: const EdgeInsets.all(8),
    //             child: Text(
    //               (listUser[i].isVerified) ? "Iya" : "Tidak",
    //               style: Theme.of(context).textTheme.displayLarge!.copyWith(
    //                     color: Colors.black,
    //                     fontSize: 21,
    //                     fontWeight: FontWeight.bold,
    //                     overflow: TextOverflow.ellipsis,
    //                   ),
    //             ),
    //           ),
    //         ),
    //         Center(
    //           child: Container(
    //             padding: const EdgeInsets.all(8),
    //             child: Text(
    //               (listUser[i].isBanned) ? "Iya" : "Tidak",
    //               style: Theme.of(context).textTheme.displayLarge!.copyWith(
    //                     color: Colors.black,
    //                     fontSize: 21,
    //                     fontWeight: FontWeight.bold,
    //                     overflow: TextOverflow.ellipsis,
    //                   ),
    //             ),
    //           ),
    //         ),
    //         Container(
    //           margin: const EdgeInsets.symmetric(vertical: 8),
    //           child: AktifBannedRow(
    //             onPressedAktifkan: () async {
    //               bool hasil = await UserController()
    //                   .setUserStatus(context, listUser[i].idUser, false);
    //               if (hasil) {
    //                 setState(() {
    //                   listUser[i].isBanned = false;
    //                 });
    //               }
    //             },
    //             onPressedBanned: () async {
    //               bool hasil = await UserController()
    //                   .setUserStatus(context, listUser[i].idUser, true);
    //               if (hasil) {
    //                 setState(() {
    //                   listUser[i].isBanned = true;
    //                 });
    //               }
    //             },
    //           ),
    //         )
    //       ],
    //     ),
    //   );
    // }

// class HalamanUser extends StatefulWidget {
//   HalamanUser({
//     super.key,
//     required this.constraints,
//   });
//   BoxConstraints constraints;
//   @override
//   State<HalamanUser> createState() => _HalamanUserState();
// }

// class _HalamanUserState extends State<HalamanUser> {
//   List<UserModel> listUser = [];
//   List<UserModel> listTampilan = [];

//   UserModel pilihan = UserModel(
//     email: "",
//     username: "",
//     tgl: "",
//     isVerified: false,
//     isBanned: false,
//     idUser: "",
//   );

//   String kataSearch = "";

//   final controller = TextEditingController();
//   var controllerEmail = TextEditingController();
//   var controllerUsername = TextEditingController();
//   var controllerTanggal = TextEditingController();
//   var controllerVerif = TextEditingController();
//   var controllerBanned = TextEditingController();

//   @override
//   void initState() {
//     Future(() async {
//       listUser = await UserController().getAllUser(context);

//       setState(() {});
//     });
//     super.initState();
//   }

//   search() {
//     setState(() {
//       kataSearch = controller.text;
//     });
//   }

//   updateUser() {
//     int indexList =
//         listUser.indexWhere((element) => element.idUser == pilihan.idUser);
//     int indexTampilan =
//         listTampilan.indexWhere((element) => element.idUser == pilihan.idUser);
//     listUser[indexList] = pilihan;
//     listTampilan[indexTampilan] = pilihan;
//     setState(() {});
//   }

//   List<TableRow> generateTableRow(BuildContext context) {
//     List<TableRow> temp = [];
//     listTampilan = listUser
//         .where((element) => element.email.toLowerCase().contains(kataSearch))
//         .toList();
//     print("ini list -> $listTampilan");
//     for (var element in listTampilan) {
//       temp.add(
//         TableRow(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               child: InkWell(
//                 onTap: () {
//                   setState(() {
//                     pilihan = element;
//                     controllerEmail.text = pilihan.email;
//                     controllerUsername.text = pilihan.username;
//                     controllerTanggal.text = pilihan.tgl;
//                     controllerVerif.text =
//                         (pilihan.isVerified) ? "Iya" : "Tidak";
//                     controllerBanned.text =
//                         (pilihan.isBanned) ? "Iya" : "Tidak";
//                   });
//                 },
//                 child: HoverBuilder(
//                   builder: (isHovered) => Text(
//                     element.email,
//                     style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                           color: (isHovered)
//                               ? Colors.greenAccent.shade400
//                               : Colors.black,
//                           fontSize: 21,
//                           fontWeight: FontWeight.bold,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.all(8),
//               child: Text(
//                 element.username,
//                 style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                       color: Colors.black,
//                       fontSize: 21,
//                       fontWeight: FontWeight.bold,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.all(8),
//               child: Text(
//                 element.tgl,
//                 style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                       color: Colors.black,
//                       fontSize: 21,
//                       fontWeight: FontWeight.bold,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.all(8),
//               child: Text(
//                 (element.isVerified) ? "Iya" : "Tidak",
//                 style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                       color: Colors.black,
//                       fontSize: 21,
//                       fontWeight: FontWeight.bold,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.all(8),
//               child: Text(
//                 (element.isBanned) ? "Iya" : "Tidak",
//                 style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                       color: Colors.black,
//                       fontSize: 21,
//                       fontWeight: FontWeight.bold,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//     return temp;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           HeaderMaster(
//             constraints: widget.constraints,
//             controller: controller,
//             hintText: "Cari User / email",
//             onSubmitted: (value) => search(),
//             onTap: () => search(),
//             onTapReset: () {
//               controller.text = "";
//               search();
//             },
//             textJudul: "Master User",
//           ),
//           const SizedBox(height: 40),
//           Center(
//             child: Text(
//               "Tabel Data",
//               style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                     color: Colors.black,
//                     fontSize: 26,
//                     fontWeight: FontWeight.bold,
//                   ),
//             ),
//           ),
//           Center(
//             child: Container(
//               height: 375,
//               width: 1250,
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.vertical,
//                 child: Table(
//                   border: TableBorder.all(
//                     borderRadius: BorderRadius.circular(20),
//                     width: 2,
//                   ),
//                   columnWidths: const <int, TableColumnWidth>{
//                     0: FractionColumnWidth(0.25),
//                     1: FractionColumnWidth(0.25),
//                     2: FractionColumnWidth(0.25),
//                     3: FractionColumnWidth(0.125),
//                     4: FractionColumnWidth(0.125),
//                   },
//                   children: [
//                     TableRow(
//                       children: [
//                         Container(
//                           decoration: BoxDecoration(
//                               color: Colors.blueAccent.shade100,
//                               borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(20))),
//                           height: 40,
//                           child: Center(
//                               child: Text(
//                             "Email",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .displayLarge!
//                                 .copyWith(
//                                   color: Colors.black,
//                                   fontSize: 21,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                           )),
//                         ),
//                         Container(
//                           height: 40,
//                           color: Colors.blueAccent.shade100,
//                           child: Center(
//                               child: Text(
//                             "Username",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .displayLarge!
//                                 .copyWith(
//                                   color: Colors.black,
//                                   fontSize: 21,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                           )),
//                         ),
//                         Container(
//                           height: 40,
//                           color: Colors.blueAccent.shade100,
//                           child: Center(
//                               child: Text(
//                             "Tanggal Daftar",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .displayLarge!
//                                 .copyWith(
//                                   color: Colors.black,
//                                   fontSize: 21,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                           )),
//                         ),
//                         Container(
//                           height: 40,
//                           color: Colors.blueAccent.shade100,
//                           child: Center(
//                               child: Text(
//                             "Verified",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .displayLarge!
//                                 .copyWith(
//                                   color: Colors.black,
//                                   fontSize: 21,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                           )),
//                         ),
//                         Container(
//                           height: 40,
//                           decoration: BoxDecoration(
//                               color: Colors.blueAccent.shade100,
//                               borderRadius: BorderRadius.only(
//                                   topRight: Radius.circular(20))),
//                           child: Center(
//                               child: Text(
//                             "Banned",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .displayLarge!
//                                 .copyWith(
//                                   color: Colors.black,
//                                   fontSize: 21,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                           )),
//                         ),
//                       ],
//                     ),
//                     ...generateTableRow(context)
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Row(
//             children: [
//               Expanded(
//                   child: Container(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 20, horizontal: 80),
//                 margin: const EdgeInsets.only(left: 48, right: 24),
//                 decoration: BoxDecoration(
//                     color: Colors.blueGrey.shade100.withOpacity(0.6),
//                     border: Border.all(width: 2, color: Colors.grey.shade400),
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.shade200.withOpacity(0.7),
//                         spreadRadius: 4,
//                         blurRadius: 4,
//                         offset: Offset(1, 1), // changes position of shadow
//                       ),
//                     ]),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Center(
//                       child: Text(
//                         "Detail user",
//                         style:
//                             Theme.of(context).textTheme.displayLarge!.copyWith(
//                                   color: Colors.black,
//                                   fontSize: 44,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                       ),
//                     ),
//                     const SizedBox(height: 48),
//                     FieldContainer(
//                       controller: controllerEmail,
//                       textJudul: "Email User",
//                       minLines: 1,
//                       hintText: "Email",
//                       enabled: false,
//                     ),
//                     const SizedBox(height: 18),
//                     FieldContainer(
//                       controller: controllerUsername,
//                       textJudul: "Username",
//                       minLines: 1,
//                       hintText: "Username",
//                       enabled: false,
//                     ),
//                     const SizedBox(height: 18),
//                     FieldContainer(
//                       controller: controllerTanggal,
//                       textJudul: "Tanggal Bergabung",
//                       minLines: 1,
//                       hintText: "Tgl",
//                       enabled: false,
//                     ),
//                     const SizedBox(height: 18),
//                     FieldContainer(
//                       controller: controllerVerif,
//                       textJudul: "Verified",
//                       minLines: 1,
//                       hintText: "true / false",
//                       enabled: false,
//                     ),
//                     const SizedBox(height: 18),
//                     FieldContainer(
//                       controller: controllerBanned,
//                       textJudul: "Banned",
//                       minLines: 1,
//                       hintText: "true / false",
//                       enabled: false,
//                     ),
//                     const SizedBox(height: 28),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         ElevatedButton(
//                           onPressed: () async {
//                             bool logic = await UserController()
//                                 .setUserStatus(context, pilihan.idUser, true);
//                             if (logic) {
//                               pilihan.isBanned = true;
//                               updateUser();
//                             }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.red,
//                           ),
//                           child: Container(
//                             height: 70,
//                             child: Center(
//                               child: Text(
//                                 "Ban user",
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .labelSmall!
//                                     .copyWith(
//                                       fontSize: 21,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 40),
//                         ElevatedButton(
//                           onPressed: () async {
//                             bool logic = await UserController()
//                                 .setUserStatus(context, pilihan.idUser, false);
//                             if (logic) {
//                               pilihan.isBanned = false;
//                               updateUser();
//                             }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blueAccent.shade700,
//                           ),
//                           child: Container(
//                             height: 70,
//                             child: Center(
//                               child: Text(
//                                 "Aktifkan user",
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .labelSmall!
//                                     .copyWith(
//                                       fontSize: 21,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               )),
//               Expanded(child: Container()),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
