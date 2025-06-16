// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:hei_survei/features/survei/model/data_form.dart';
// import 'package:hei_survei/features/survei/survei_services.dart';

// import 'package:hei_survei/app/routing/route_constant.dart';

// import 'package:hei_survei/utils/hover_builder.dart';
// import 'package:hei_survei/utils/navigasi_atas.dart';

// class BuatSurveiPage extends StatefulWidget {
//   const BuatSurveiPage({super.key});

//   @override
//   State<BuatSurveiPage> createState() => _BuatSurveiPageState();
// }

// class _BuatSurveiPageState extends State<BuatSurveiPage> {
//   String status = "Loading";
//   List<Widget> widgetTampilan = [];

//   final snackBar = SnackBar(content: Text("Terjadi Masalah Server"));

//   List<Widget> getWidgetAwal(BuildContext context) {
//     return [
//       KotakFormKlasikBaru(
//         onTap: () async {
//           setState(() {
//             status = "Loading";
//           });
//           String idBaru = await SurveiServices().buatFormKlasik();

//           if (!context.mounted) return;

//           if (idBaru != "Gagal") {
//             context.pushNamed(RouteConstant.formKlasik, pathParameters: {
//               'idForm': idBaru,
//             });
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(snackBar);
//           }
//         },
//       ),
//       KotakFormKartuBaru(
//         onTap: () async {
//           setState(() {
//             status = "Loading";
//           });
//           String idBaru = await SurveiServices().buatFormKartu();

//           if (!context.mounted) return;

//           if (idBaru != "Gagal") {
//             context.pushNamed(RouteConstant.formKlasik, pathParameters: {
//               'idForm': idBaru,
//             });
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(snackBar);
//           }
//         },
//       ),
//     ];
//   }

//   getDataFromDB(BuildContext context) async {
//     Map<String, dynamic>? mapQuery = await SurveiServices().ambilForm();

//     List<Object?> dataSurvei = mapQuery!["getFormku"]["data"];
//     List<DataForm> data = List.generate(dataSurvei.length,
//         (index) => DataForm.fromJson(json.encode(dataSurvei[index])));

//     if (!context.mounted) return;

//     widgetTampilan = getWidgetAwal(context);

//     final temp = List.generate(
//         data.length,
//         (index) => KotakForm(
//               textJudul: data[index].judul,
//               textTanggal: data[index].tanggal,
//               isKlasik: data[index].isKlasik,
//               onTap: () {
//                 if (data[index].isKlasik) {
//                   print(data[index].id);
//                   context.pushNamed(RouteConstant.formKlasik, pathParameters: {
//                     'idForm': data[index].id,
//                   });
//                 } else {
//                   print(data[index].id);
//                   context.pushNamed(RouteConstant.formKartu, pathParameters: {
//                     'idForm': data[index].id,
//                   });
//                 }
//               },
//             ));
//     widgetTampilan.addAll(temp);
//     status = "Normal";
//     setState(() {});
//   }

//   List<Widget> rowGenerator(BuildContext context, int pembagi) {
//     int indexInduk = -1;
//     //List<Widget> listWidget = getListSurvei(context);
//     List<Widget> listWidget = widgetTampilan;
//     List<Widget> hasil =
//         List.generate(listWidget.length ~/ pembagi + 1, (index) {
//       return Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: List.generate(pembagi, (index) {
//             if (indexInduk < listWidget.length - 1) {
//               indexInduk++;
//               return listWidget[indexInduk];
//             } else
//               return SizedBox(
//                 width: 275,
//               );
//           }));
//     });

//     return hasil;
//   }

//   Widget getKonten(BuildContext context, BoxConstraints constraints) {
//     if (status == "Normal" && widgetTampilan.isNotEmpty) {
//       return Column(
//           children: rowGenerator(
//               context,
//               (constraints.maxWidth > 1800)
//                   ? 4
//                   : (constraints.maxWidth > 1500)
//                       ? 3
//                       : (constraints.maxWidth > 825)
//                           ? 2
//                           : 1));
//     } else {
//       return const Center(
//         child: SizedBox(
//           height: 100,
//           width: 100,
//           child: CircularProgressIndicator(strokeWidth: 16),
//         ),
//       );
//     }
//   }

//   @override
//   void initState() {
//     Future(() {
//       //bisa pakai context disini tampaknya
//       getDataFromDB(context);
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.primaryContainer,
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           return Container(
//             padding: const EdgeInsets.all(20),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   NavigasiAtas(isSmall: (constraints.maxWidth < 780)),
//                   const SizedBox(height: 48),
//                   Center(
//                     child: RichText(
//                       text: TextSpan(
//                           text: "Survei Baru & ",
//                           style: Theme.of(context)
//                               .textTheme
//                               .displayLarge!
//                               .copyWith(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black),
//                           children: [
//                             TextSpan(
//                               text: "Draft",
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .displayLarge!
//                                   .copyWith(
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.redAccent,
//                                     fontStyle: FontStyle.italic,
//                                   ),
//                             ),
//                           ]),
//                     ),
//                   ),
//                   SizedBox(height: 64),
//                   getKonten(context, constraints)
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class KotakForm extends StatelessWidget {
//   KotakForm({
//     super.key,
//     required this.textJudul,
//     required this.textTanggal,
//     required this.isKlasik,
//     required this.onTap,
//   });
//   String textJudul;
//   String textTanggal;
//   bool isKlasik;
//   Function() onTap;
//   @override
//   Widget build(BuildContext context) {
//     return HoverBuilder(
//       builder: (isHovered) => InkWell(
//         onTap: onTap,
//         child: Stack(
//           children: [
//             AnimatedContainer(
//               margin: const EdgeInsets.symmetric(vertical: 12),
//               duration: const Duration(milliseconds: 350),
//               decoration: BoxDecoration(
//                 border: Border.all(
//                     width: 4,
//                     color: (isHovered) ? Colors.lightBlueAccent : Colors.black),
//                 borderRadius: BorderRadius.circular(24),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey,
//                     spreadRadius: 5,
//                     blurRadius: 2,
//                     offset: Offset(0, 4), // changes position of shadow
//                   ),
//                 ],
//               ),
//               child: Container(
//                 padding: const EdgeInsets.only(top: 6),
//                 width: 275,
//                 decoration: BoxDecoration(
//                     color: (isKlasik) ? Colors.greenAccent : Colors.redAccent,
//                     borderRadius: BorderRadius.circular(20)),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(20)),
//                       child: (isKlasik)
//                           ? Image.asset(
//                               'assets/logo-klasik.png',
//                               scale: 1.25,
//                             )
//                           : Image.asset(
//                               'assets/logo-kartu.png',
//                               scale: 1.25,
//                             ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.only(
//                           top: 10, left: 14, right: 14, bottom: 7),
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.only(
//                               bottomLeft: Radius.circular(20),
//                               bottomRight: Radius.circular(20))),
//                       child: Column(
//                         children: [
//                           Text(
//                             textJudul,
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .displaySmall!
//                                 .copyWith(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 18,
//                                     color: Colors.black),
//                             textAlign: TextAlign.justify,
//                           ),
//                           const SizedBox(height: 6),
//                           Align(
//                             alignment: Alignment.centerRight,
//                             child: Text(
//                               textTanggal,
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .displaySmall!
//                                   .copyWith(fontSize: 15, color: Colors.black),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 160,
//               child: Container(
//                 height: 10,
//                 width: 279,
//                 color: Colors.black,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FotoKlasik extends StatelessWidget {
//   const FotoKlasik({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.only(top: 6),
//       width: 275,
//       height: 206,
//       decoration: BoxDecoration(
//           border: Border.all(width: 3),
//           color: Colors.greenAccent,
//           borderRadius: BorderRadius.circular(20)),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(20), topRight: Radius.circular(20)),
//             ),
//             child: Image.asset(
//               'assets/logo-klasik.png',
//               scale: 1.25,
//             ),
//           ),
//           Container(
//             height: 50,
//             decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(18),
//                     bottomRight: Radius.circular(18))),
//             child: Center(
//               child: Text("Form Klasik",
//                   style: Theme.of(context).textTheme.displaySmall!.copyWith(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 22,
//                       color: Colors.black)),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// class KotakFormKlasikBaru extends StatelessWidget {
//   KotakFormKlasikBaru({
//     super.key,
//     required this.onTap,
//   });
//   Function() onTap;
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 10),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey,
//               spreadRadius: 5,
//               blurRadius: 2,
//               offset: Offset(2, 2), // changes position of shadow
//             ),
//           ],
//         ),
//         child: Stack(
//           children: [
//             Container(child: FotoKlasik()),
//             Positioned(
//               bottom: 45,
//               child: Container(
//                 height: 10,
//                 width: 273,
//                 color: Colors.black,
//               ),
//             ),
//             Positioned(
//               bottom: 22,
//               right: 8,
//               child: CircleAvatar(
//                 radius: 24,
//                 backgroundColor: Colors.blue,
//                 child: Icon(
//                   Icons.add,
//                   color: Colors.white,
//                   size: 35,
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class KotakFormKartuBaru extends StatelessWidget {
//   KotakFormKartuBaru({
//     super.key,
//     required this.onTap,
//   });
//   Function() onTap;
//   @override
//   Widget build(BuildContext context) {
//     return HoverBuilder(
//       builder: (isHovered) => InkWell(
//         onTap: onTap,
//         child: Stack(
//           children: [
//             Container(
//               margin: const EdgeInsets.symmetric(vertical: 10),
//               padding: const EdgeInsets.only(top: 6),
//               width: 275,
//               height: 206,
//               decoration: BoxDecoration(
//                 border: Border.all(width: 3),
//                 color: Colors.redAccent,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey,
//                     spreadRadius: 5,
//                     blurRadius: 2,
//                     offset: Offset(2, 2), // changes position of shadow
//                   ),
//                 ],
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(20)),
//                     child: Image.asset(
//                       'assets/logo-kartu.png',
//                       scale: 1.25,
//                     ),
//                   ),
//                   Container(
//                     height: 50,
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.only(
//                             bottomLeft: Radius.circular(18),
//                             bottomRight: Radius.circular(18))),
//                     child: Center(
//                       child: Text("Form Kartu",
//                           style: Theme.of(context)
//                               .textTheme
//                               .displaySmall!
//                               .copyWith(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 22,
//                                   color: Colors.black)),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             Positioned(
//               bottom: 51,
//               child: Container(
//                 height: 10,
//                 width: 273,
//                 color: Colors.black,
//               ),
//             ),
//             Positioned(
//               bottom: 22,
//               right: 8,
//               child: CircleAvatar(
//                 radius: 24,
//                 backgroundColor: Colors.blue,
//                 child: Icon(
//                   Icons.add,
//                   color: Colors.white,
//                   size: 35,
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

//   // getListSurvei(BuildContext context) {
//   //   return [
//   //     KotakFormKlasikBaru(
//   //       onTap: () async {
//   //         setState(() {
//   //           status = "Loading";
//   //         });
//   //         String idBaru = const Uuid().v4().substring(0, 8);
//   //         await SurveiServices().buatSurveiBaru(idBaru);

//   //         if (!context.mounted) return;

//   //         context.pushNamed(RouteConstant.formKlasik, pathParameters: {
//   //           'idForm': idBaru,
//   //         });
//   //       },
//   //     ),
//   //     KotakFormKartuBaru(),
//   //     KotakForm(
//   //       isKlasik: true,
//   //       textJudul:
//   //           "Survei kesehatan para mahasiswa istts tahun 2014 - 2019 loremp ipsum",
//   //       textTanggal: "20-08-2023",
//   //     ),
//   //     KotakForm(
//   //         isKlasik: false,
//   //         textJudul:
//   //             "Survei destinasi travel favorit para pekerja kantoran di kawasan gubeng 2023",
//   //         textTanggal: "20-03-2025"),
//   //     KotakForm(
//   //         isKlasik: true,
//   //         textJudul:
//   //             "Survei destinasi travel favorit para pekerja kantoran di kawasan gubeng 2023",
//   //         textTanggal: "20-03-2025"),
//   //     KotakForm(
//   //         isKlasik: false,
//   //         textJudul:
//   //             "Survei destinasi travel favorit para pekerja kantoran di kawasan gubeng 2023",
//   //         textTanggal: "20-03-2025"),
//   //     KotakForm(
//   //         isKlasik: true,
//   //         textJudul:
//   //             "Survei destinasi travel favorit para pekerja kantoran di kawasan gubeng 2023",
//   //         textTanggal: "20-03-2025"),
//   //   ];
//   // }