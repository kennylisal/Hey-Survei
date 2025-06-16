// import 'package:aplikasi_admin/app/widget_component/row_container.dart';
// import 'package:aplikasi_admin/features/master_user/user.dart';
// import 'package:aplikasi_admin/features/master_user/user_controller.dart';
// import 'package:aplikasi_admin/utils/hover_builder.dart';
// import 'package:aplikasi_admin/utils/loading_lingkaran.dart';
// import 'package:flutter/material.dart';

// class MasterUser extends StatefulWidget {
//   const MasterUser({super.key});

//   @override
//   State<MasterUser> createState() => _MasterUserState();
// }

// class _MasterUserState extends State<MasterUser> {
//   List<UserModel> listUser = [];
//   List<UserModel> listTampilan = [];

//   UserModel pilihan = UserModel(
//       email: "",
//       username: "",
//       tgl: "",
//       isVerified: false,
//       isBanned: false,
//       idUser: "");

//   String kataSearch = "";

//   @override
//   void initState() {
//     Future(() async {
//       listUser = await UserController().getAllUser(context);
//       setState(() {});
//     });
//     super.initState();
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
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.primaryContainer,
//       body: LayoutBuilder(
//         builder: (context, constraints) => SingleChildScrollView(
//           child: Center(
//             child: Container(
//               padding: const EdgeInsets.all(20),
//               width: 875,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Column(
//                 children: [
//                   Container(
//                     height: 50,
//                     width: 450,
//                     padding: const EdgeInsets.only(
//                       left: 17,
//                       top: 17,
//                     ),
//                     decoration: BoxDecoration(
//                       border: Border.all(width: 1),
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: TextField(
//                       onSubmitted: (value) {
//                         if (listUser.isNotEmpty) {
//                           setState(() {
//                             kataSearch = value;
//                           });
//                         }
//                       },
//                       textInputAction: TextInputAction.search,
//                       style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                             color: Colors.black,
//                             fontSize: 17,
//                           ),
//                       decoration: InputDecoration.collapsed(
//                         hintText: "Cari email",
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   (listUser.isNotEmpty)
//                       ? Container(
//                           height: 400,
//                           width: 760,
//                           decoration:
//                               BoxDecoration(border: Border.all(width: 1)),
//                           child: SingleChildScrollView(
//                             scrollDirection: Axis.vertical,
//                             child: Table(
//                               columnWidths: const <int, TableColumnWidth>{
//                                 0: FractionColumnWidth(0.25),
//                                 1: FractionColumnWidth(0.25),
//                                 2: FractionColumnWidth(0.25),
//                                 3: FractionColumnWidth(0.125),
//                                 4: FractionColumnWidth(0.125),
//                               },
//                               border: TableBorder.all(),
//                               children: [
//                                 TableRow(
//                                   children: [
//                                     Container(
//                                       height: 40,
//                                       child: Center(
//                                           child: Text(
//                                         "Email",
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .displayLarge!
//                                             .copyWith(
//                                               color: Colors.black,
//                                               fontSize: 21,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                       )),
//                                     ),
//                                     Container(
//                                       height: 40,
//                                       child: Center(
//                                           child: Text(
//                                         "Username",
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .displayLarge!
//                                             .copyWith(
//                                               color: Colors.black,
//                                               fontSize: 21,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                       )),
//                                     ),
//                                     Container(
//                                       height: 40,
//                                       child: Center(
//                                           child: Text(
//                                         "Tanggal Daftar",
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .displayLarge!
//                                             .copyWith(
//                                               color: Colors.black,
//                                               fontSize: 21,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                       )),
//                                     ),
//                                     Container(
//                                       height: 40,
//                                       child: Center(
//                                           child: Text(
//                                         "Verified",
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .displayLarge!
//                                             .copyWith(
//                                               color: Colors.black,
//                                               fontSize: 21,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                       )),
//                                     ),
//                                     Container(
//                                       height: 40,
//                                       child: Center(
//                                           child: Text(
//                                         "Banned",
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .displayLarge!
//                                             .copyWith(
//                                               color: Colors.black,
//                                               fontSize: 21,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                       )),
//                                     ),
//                                   ],
//                                 ),
//                                 ...generateTableRow(context)
//                               ],
//                             ),
//                           ),
//                         )
//                       : LoadingLingkaran(
//                           width: 175,
//                           height: 175,
//                           strokeWidth: 16,
//                         ),
//                   const SizedBox(height: 32),
//                   Column(
//                     children: [
//                       RowContainer(
//                           text: "Email",
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               vertical: 16,
//                               horizontal: 16,
//                             ),
//                             decoration: BoxDecoration(
//                                 border: Border.all(
//                                   width: 1,
//                                   color: Colors.black,
//                                 ),
//                                 borderRadius: BorderRadius.circular(24)),
//                             child: Text(
//                               pilihan.email,
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .labelLarge!
//                                   .copyWith(
//                                     color: Colors.black,
//                                     fontSize: 17,
//                                   ),
//                             ),
//                           )),
//                       const SizedBox(height: 16),
//                       RowContainer(
//                           text: "Username",
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               vertical: 16,
//                               horizontal: 16,
//                             ),
//                             decoration: BoxDecoration(
//                                 border: Border.all(
//                                   width: 1,
//                                   color: Colors.black,
//                                 ),
//                                 borderRadius: BorderRadius.circular(24)),
//                             child: Text(
//                               pilihan.username,
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .labelLarge!
//                                   .copyWith(
//                                     color: Colors.black,
//                                     fontSize: 17,
//                                   ),
//                             ),
//                           )),
//                       const SizedBox(height: 16),
//                       RowContainer(
//                           text: "Tanggal",
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               vertical: 16,
//                               horizontal: 16,
//                             ),
//                             decoration: BoxDecoration(
//                                 border: Border.all(
//                                   width: 1,
//                                   color: Colors.black,
//                                 ),
//                                 borderRadius: BorderRadius.circular(24)),
//                             child: Text(
//                               pilihan.tgl,
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .labelLarge!
//                                   .copyWith(
//                                     color: Colors.black,
//                                     fontSize: 17,
//                                   ),
//                             ),
//                           )),
//                       const SizedBox(height: 16),
//                       RowContainer(
//                           text: "Verified",
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               vertical: 16,
//                               horizontal: 16,
//                             ),
//                             decoration: BoxDecoration(
//                                 border: Border.all(
//                                   width: 1,
//                                   color: Colors.black,
//                                 ),
//                                 borderRadius: BorderRadius.circular(24)),
//                             child: Text(
//                               (pilihan.isVerified) ? "Iya" : "Tidak",
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .labelLarge!
//                                   .copyWith(
//                                     color: Colors.black,
//                                     fontSize: 17,
//                                   ),
//                             ),
//                           )),
//                       const SizedBox(height: 16),
//                       RowContainer(
//                           text: "Banned",
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               vertical: 16,
//                               horizontal: 16,
//                             ),
//                             decoration: BoxDecoration(
//                                 border: Border.all(
//                                   width: 1,
//                                   color: Colors.black,
//                                 ),
//                                 borderRadius: BorderRadius.circular(24)),
//                             child: Text(
//                               (pilihan.isBanned) ? "Iya" : "Tidak",
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .labelLarge!
//                                   .copyWith(
//                                     color: Colors.black,
//                                     fontSize: 17,
//                                   ),
//                             ),
//                           )),
//                       const SizedBox(height: 16),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           ElevatedButton(
//                             onPressed: () {
//                               if (pilihan.idUser != "") {
//                                 UserController().setUserStatus(
//                                     context, pilihan.idUser, false);
//                                 setState(() {
//                                   pilihan.isBanned = false;
//                                   listUser.removeWhere((element) =>
//                                       element.idUser == pilihan.idUser);
//                                   listUser.add(pilihan);
//                                 });
//                               }
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.blueAccent.shade700,
//                             ),
//                             child: Container(
//                               height: 50,
//                               width: 135,
//                               child: Center(
//                                 child: Text(
//                                   "Aktifkan User",
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .labelSmall!
//                                       .copyWith(
//                                         fontSize: 17,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.white,
//                                       ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           ElevatedButton(
//                             onPressed: () {
//                               if (pilihan.idUser != "") {
//                                 UserController().setUserStatus(
//                                     context, pilihan.idUser, true);
//                                 setState(() {
//                                   pilihan.isBanned = true;
//                                   listUser.removeWhere((element) =>
//                                       element.idUser == pilihan.idUser);
//                                   listUser.add(pilihan);
//                                 });
//                               }
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.red.shade600,
//                             ),
//                             child: Container(
//                               height: 50,
//                               width: 100,
//                               child: Center(
//                                 child: Text(
//                                   "Ban User",
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .labelSmall!
//                                       .copyWith(
//                                         fontSize: 17,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.white,
//                                       ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
