import 'package:flutter/material.dart';
import 'package:hei_survei/utils/generator_pdf.dart';

class PercobaanDrawer extends StatelessWidget {
  const PercobaanDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SideBar(),
        body: Column(
          children: [
            ElevatedButton(
                onPressed: () async {
                  await PdfUtils().displayPdf('abcde');
                },
                child: Text("klik"))
          ],
        ));
  }
}

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.blue.shade600.withOpacity(0.8),
      child: ListView(children: [
        ListTile(
          title: Text("Survei Aktif"),
          leading: Icon(Icons.email),
        ),
      ]),
    );
  }
}

// class Provinsi {
//   String id;
//   String name;
//   Provinsi({
//     required this.id,
//     required this.name,
//   });

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'id': id,
//       'name': name,
//     };
//   }

//   factory Provinsi.fromMap(Map<String, dynamic> map) {
//     return Provinsi(
//       id: map['id'] as String,
//       name: map['name'] as String,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory Provinsi.fromJson(String source) =>
//       Provinsi.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() => 'Provinsi(id: $id, name: $name)';
// }

// class Kota {
//   String id;
//   String province_id;
//   String name;
//   Kota({
//     required this.id,
//     required this.province_id,
//     required this.name,
//   });

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'id': id,
//       'province_id': province_id,
//       'name': name,
//     };
//   }

//   factory Kota.fromMap(Map<String, dynamic> map) {
//     return Kota(
//       id: map['id'] as String,
//       province_id: map['province_id'] as String,
//       name: map['name'] as String,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory Kota.fromJson(String source) =>
//       Kota.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() => 'Kota(id: $id, province_id: $province_id, name: $name)';
// }

// class CobaPLay extends StatefulWidget {
//   const CobaPLay({super.key});

//   @override
//   State<CobaPLay> createState() => _CobaPLayState();
// }

// class _CobaPLayState extends State<CobaPLay> {
//   List<SurveiData> dataPenting = [];
//   List<String> countriesList = [
//     'Pakistan',
//     'Afghanistan',
//     'America',
//     'China',
//     'Indonesia'
//   ];
//   String itemSelected = '';
//   @override
//   void initState() {
//     Future(() async {
//       SurveiX? surveiTemp = await SurveiController().getSurveiData("idSurvei");
//       print(surveiTemp!.detailSurvei.demografiLokasi);
//     });
//     super.initState();
//   }

//   List<String> items = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: Column(children: []));
//   }
// }

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';
// import 'package:hei_survei/constants.dart';

// class PlayGround extends StatefulWidget {
//   const PlayGround({super.key});

//   @override
//   State<PlayGround> createState() => _PlayGroundState();
// }

// class _PlayGroundState extends State<PlayGround> {
//   List<bool> listBool = [false, false, false];

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: const EdgeInsets.all(32),
//         width: 750,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             ContainerBaru(
//               onTap: () {},
//               isClicked: true,
//               pertanyaan: "",
//               jawaban: "",
//             )
//             // ContainerFAQ(
//             //   pertanyaan:
//             //       "Pertanyaan blabla asdfjbapofbaeofawoefbaoefjbawfubaefbawfbawfbawefjbsfbasefawbefawebfawbfawifbawifjei",
//             //   jawaban: "Jawaban standar",
//             //   onTap: () {},
//             //   isClicked: listBool[0],
//             // ),
//             // InkWell(
//             //   onTap: () {
//             //     setState(() {
//             //       listBool[0] = true;
//             //     });
//             //   },
//             //   child: Row(
//             //     children: [
//             //       Container(
//             //         width: 500,
//             //         padding: EdgeInsets.all(8),
//             //         decoration: BoxDecoration(
//             //           color: Colors.blue.shade600,
//             //         ),
//             //         child: Text(
//             //           "Pertanyaan blabla asdfjbapofbaeofawoefbaoefjbawfubaefbawfbawfbawefjbsfbasefawbefawebfawbfawifbawifjei",
//             //           style: Theme.of(context).textTheme.labelLarge!.copyWith(
//             //                 color: Colors.black,
//             //                 fontSize: 16,
//             //               ),
//             //         ),
//             //       ),
//             //       Container(
//             //         width: 50,
//             //         height: 50,
//             //         decoration: BoxDecoration(
//             //           color: Colors.blue.shade600,
//             //         ),
//             //         child: Center(
//             //           child: CircleAvatar(
//             //               backgroundColor: Colors.white,
//             //               child: Icon(
//             //                 Icons.keyboard_arrow_down,
//             //                 color: Colors.blue.shade600,
//             //                 size: 40,
//             //                 weight: 40,
//             //               )),
//             //         ),
//             //       )
//             //     ],
//             //   ),
//             // ),
//             // (listBool[0])
//             //     ? Container(
//             //         width: 250,
//             //         height: 50,
//             //         decoration: BoxDecoration(
//             //           color: Colors.blue.shade200,
//             //         ),
//             //       )
//             //     : SizedBox(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ContainerBaru extends StatelessWidget {
//   ContainerBaru({
//     super.key,
//     required this.onTap,
//     required this.isClicked,
//     required this.pertanyaan,
//     required this.jawaban,
//   });
//   Function() onTap;
//   bool isClicked;
//   String pertanyaan;
//   String jawaban;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Expanded(
//               flex: 8,
//               child: Container(
//                 height: 60,
//                 color: Colors.blue.shade600,
//                 child: Text(
//                     "Pertanyaan blabla asdfjbapofbaeofawoefbaoefjbawfubaefbawfbawfbawefjbsfbasefawbefawebfawbfawifbawifjei"),
//               ),
//             ),
//             Expanded(
//               flex: 1,
//               child: InkWell(
//                 onTap: onTap,
//                 child: Container(
//                   height: 60,
//                   color: Colors.blue.shade600,
//                   child: Center(
//                     child: CircleAvatar(
//                         backgroundColor: Colors.white,
//                         child: Icon(
//                           Icons.keyboard_arrow_down,
//                           color: Colors.blue.shade600,
//                           size: 40,
//                           weight: 40,
//                         )),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         Container(
//           width: double.infinity,
//           height: 250,
//           color: Colors.blue.shade200,
//         )
//       ],
//     );
//   }
// }

// class ContainerFAQ extends StatelessWidget {
//   ContainerFAQ({
//     super.key,
//     required this.onTap,
//     required this.isClicked,
//     required this.pertanyaan,
//     required this.jawaban,
//   });
//   Function() onTap;
//   bool isClicked;
//   String pertanyaan;
//   String jawaban;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         InkWell(
//           onTap: onTap,
//           child: Row(
//             children: [
//               Container(
//                 //width: 500,
//                 height: 70,
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.blue.shade600,
//                 ),
//                 child: Text(
//                   pertanyaan,
//                   style: Theme.of(context).textTheme.labelLarge!.copyWith(
//                         color: Colors.black,
//                         fontSize: 17,
//                       ),
//                 ),
//               ),
//               Container(
//                 //width: 50,
//                 height: 70,
//                 decoration: BoxDecoration(
//                   color: Colors.blue.shade600,
//                 ),
//                 child: Center(
//                   child: CircleAvatar(
//                       backgroundColor: Colors.white,
//                       child: Icon(
//                         Icons.keyboard_arrow_down,
//                         color: Colors.blue.shade600,
//                         size: 40,
//                         weight: 40,
//                       )),
//                 ),
//               )
//             ],
//           ),
//         ),
//         Container(
//           width: 500,
//           height: 50,
//           color: Colors.black,
//         )
//       ],
//     );
//   }
// }

// class Backend {
//   Future<Map<String, dynamic>?> serverConnection(
//       {required String query,
//       required Map<String, dynamic> mapVariable}) async {
//     try {
//       HttpLink link = HttpLink(linkGraphql);
//       GraphQLClient qlClient = GraphQLClient(
//         link: link,
//         cache: GraphQLCache(store: HiveStore()),
//       );

//       String request = query;

//       QueryResult result = await qlClient.query(QueryOptions(
//         document: gql(request),
//         variables: mapVariable,
//       ));
//       return result.data;
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }
// }

// class FAQService {
//   Future<List<FAQ>> getFAQ() async {
//     try {
//       String query = """
//         query GetFAQ {
//           getFAQ {
//           code,data {
//             id,jawaban,pertanyaan
//           },status
//           }
//         }
//     """;
//       Map<String, dynamic> map = {};
//       Map<String, dynamic>? data =
//           await Backend().serverConnection(query: query, mapVariable: map);
//       if (data!['getFAQ']['code'] == 200) {
//         List<Object?> dataFAQ = data["getFAQ"]["data"];
//         List<FAQ> temp = List.generate(dataFAQ.length,
//             (index) => FAQ.fromJson(json.encode(dataFAQ[index])));
//         print("ini temp $temp");
//         return temp;
//       } else {
//         return [];
//       }
//     } catch (e) {
//       print(e);
//       return [];
//     }
//   }
// }

// class FAQ {
//   String jawaban;
//   String idFAQ;
//   String pertanyaan;
//   FAQ({
//     required this.jawaban,
//     required this.idFAQ,
//     required this.pertanyaan,
//   });

//   factory FAQ.fromMap(Map<String, dynamic> map) {
//     return FAQ(
//       jawaban: map['jawaban'] as String,
//       idFAQ: map['id'] as String,
//       pertanyaan: map['pertanyaan'] as String,
//     );
//   }

//   factory FAQ.fromJson(String source) =>
//       FAQ.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() =>
//       'FAQ(jawaban: $jawaban, idFAQ: $idFAQ, pertanyaan: $pertanyaan)';
// }
