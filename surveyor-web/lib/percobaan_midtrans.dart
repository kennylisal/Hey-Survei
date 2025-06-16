import 'package:excel/excel.dart';

import 'package:flutter/material.dart';
import 'package:hei_survei/features/katalog/broadcast_controller.dart';

// import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class PercobaanExcel extends StatelessWidget {
  const PercobaanExcel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              // final hasil = await BroadcastController()
              //     .pengecekanBroadcast('HSV - 0136a7d', context);
              if (!context.mounted) return;
              final hasil = await BroadcastController().broadcastSurvei(
                  "Survei percobaan",
                  "https://www.youtube.com/watch?v=9BDmC5u_MLE&t=4973s",
                  // listEmail,
                  ["kennylisal5@gmail.com", "bluevangelis@gmail.com"],
                  context);
              print(hasil);
            },
            child: Text("pengecekan")),
      ),
    );
  }
}

  // createExcel() {
  //   try {
  //     var excel = Excel.createExcel();
  //     // excel.rename(excel.getDefaultSheet()!, "Test Sheet");

  //     // Sheet sheet = excel["Test Sheet"];
  //     Sheet sheet = excel[excel.getDefaultSheet()!];
  //     sheet.setColumnWidth(0, 30);
  //     // sheet.setColumnAutoFit(0);
  //     var cell1 = sheet
  //         .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0)); //E 0

  //     cell1.value = TextCellValue('Tolong');
  //     cell1.cellStyle = CellStyle(
  //         backgroundColorHex: '#1AFF1A',
  //         fontFamily: getFontFamily(FontFamily.Calisto_MT),
  //         fontSize: 15);

  //     var cell2 = sheet.cell(CellIndex.indexByString("A2"));

  //     cell2.value = TextCellValue('Bisakan');

  //     // var cell3 =

  //     // cell2.value = DateCellValue(year: 2023, month: 4, day: 20);

  //     var fileBytes = excel.save(fileName: 'TyGod.xlsx');
  //   } catch (e) {
  //     print(e);
  //   }
  // }

// String decrypt(String keyString, enc.Encrypted encryptedData) {
//     final key = enc.Key.fromUtf8(keyString);
//     final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
//     final initVector = enc.IV.fromUtf8(keyString.substring(0, 16));
//     return encrypter.decrypt(encryptedData, iv: initVector);
//   }

//   enc.Encrypted encrypt(String keyString, String plainText) {
//     final key = enc.Key.fromUtf8(keyString);
//     final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
//     final initVector = enc.IV.fromUtf8(keyString.substring(0, 16));
//     enc.Encrypted encryptedData = encrypter.encrypt(plainText, iv: initVector);
//     return encryptedData;
//   }

//   String cobaCrypt() {
//     try {
//       final key = "RahasiaHeySurvei";
//       final plainText = "18x04y99z";
//       enc.Encrypted encrypted = encrypt(key, plainText);
//       print(encrypted.base16);
//       // String decryptedText = decrypt(key, encrypted);
//       String decryptedText =
//           decrypt(key, enc.Encrypted.fromBase16('6768a3c500387f6a9f2778b61d'));
//       return decryptedText;
//     } catch (e) {
//       return "-x-";
//     }
//   }

//   Future<bool> cekExist(String idForm) async {
//     try {
//       bool hasil = false;
//       final surveiRef =
//           FirebaseFirestore.instance.collection('form-klasik').doc(idForm);

//       await surveiRef.get().then((value) {
//         if (value.exists) {
//           hasil = true;
//         }
//       }).onError((error, stackTrace) {
//         log(error.toString());
//       });
//       return hasil;
//     } catch (e) {
//       log(e.toString());
//       return false;
//     }
//   }

//   cobaKriptografi() {
//     final plainText = "12345";
//     final textEnkripsi = Kriptografi.encrypt(plainText);
//     final textDekrip = Kriptografi.decrypt(textEnkripsi);
//     print(textDekrip);
//   }
// class GoogleSignInCoba extends StatefulWidget {
//   const GoogleSignInCoba({super.key});

//   @override
//   State<GoogleSignInCoba> createState() => _GoogleSignInCobaState();
// }

// class _GoogleSignInCobaState extends State<GoogleSignInCoba> {
//   final GoogleSignIn googleSignIn = GoogleSignIn();
//   String? name, imageUrl, userEmail, uid;
//   Future<User?> signInWithGoogle() async {
//     // Initialize Firebase
//     // await Firebase.initializeApp();
//     User? user;
//     FirebaseAuth auth = FirebaseAuth.instance;
//     // The `GoogleAuthProvider` can only be
//     // used while running on the web
//     GoogleAuthProvider authProvider = GoogleAuthProvider();

//     try {
//       final UserCredential userCredential =
//           await auth.signInWithPopup(authProvider);
//       user = userCredential.user;
//     } catch (e) {
//       print(e);
//     }

//     if (user != null) {
//       uid = user.uid;
//       name = user.displayName;
//       userEmail = user.email;
//       imageUrl = user.photoURL;

//       // SharedPreferences prefs = await SharedPreferences.getInstance();
//       // prefs.setBool('auth', true);
//       print("name: $name");
//       print("userEmail: $userEmail");
//       print("imageUrl: $imageUrl");
//     }
//     return user;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           ElevatedButton(
//               onPressed: () {
//                 signInWithGoogle();
//               },
//               child: Text("Google Sign In")),
//         ],
//       ),
//     );
//   }
// }

// class PlaygroundGambarUpload extends StatefulWidget {
//   const PlaygroundGambarUpload({super.key});

//   @override
//   State<PlaygroundGambarUpload> createState() => _PlaygroundGambarUploadState();
// }

// class _PlaygroundGambarUploadState extends State<PlaygroundGambarUpload> {
//   Uint8List? selectedImageBytes;
//   String selectFile = '';
//   String urlGambar = "";
//   pilihGamabr() async {
//     //bikin nama baru
//     //compress
//     FilePickerResult? fileResult = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowMultiple: false,
//       allowedExtensions: ['jpg', 'jpeg', 'png'],
//     );
//     if (fileResult != null) {
//       // print(fileResult.files.first.size);
//       selectFile = fileResult.files.first.name;
//       selectedImageBytes = fileResult.files.first.bytes;
//     }
//     // print(fileResult!.files[0].size);

//     if (fileResult != null) {
//       setState(() {
//         selectFile = fileResult.files.first.name;
//         selectedImageBytes = fileResult.files.first.bytes;
//       });
//     } else {
//       print("File tidak sesuai extension atau belum pilih");
//     }

//     print(selectFile);
//   }

//   uploadGambar() async {
//     try {
//       if (selectedImageBytes != null) {
//         String namaBaru = Uuid().v4().substring(0, 11);
//         firebase_storage.UploadTask uploadTask;

//         firebase_storage.Reference ref = firebase_storage
//             .FirebaseStorage.instance
//             .ref()
//             .child('eksp')
//             .child('/' + namaBaru);

//         final metaData =
//             firebase_storage.SettableMetadata(contentType: 'image/jpeg');

//         uploadTask = ref.putData(selectedImageBytes!, metaData);

//         await uploadTask.whenComplete(() => null);
//         String imageUrl = await ref.getDownloadURL();
//         setState(() {
//           urlGambar = imageUrl;
//         });
//         print('uploaded image URL : $imageUrl');
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           children: [
//             Container(
//               margin: const EdgeInsets.only(top: 12, bottom: 4),
//               height: 180,
//               width: 320,
//               decoration: BoxDecoration(
//                 border: Border.all(width: 2),
//               ),
//               child: CachedNetworkImage(
//                 filterQuality: FilterQuality.medium,
//                 imageUrl: urlGambar,
//                 imageBuilder: (context, imageProvider) {
//                   return Container(
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image: imageProvider,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   );
//                 },
//                 progressIndicatorBuilder: (context, url, downloadProgress) =>
//                     CircularProgressIndicator(value: downloadProgress.progress),
//                 errorWidget: (context, url, error) {
//                   return const Icon(
//                     Icons.error,
//                     size: 48,
//                     color: Colors.red,
//                   );
//                 },
//               ),
//             ),
//             // if (selectFile.isNotEmpty)
//             //   Image.memory(
//             //     Uint8List.fromList(selectedImageBytes!),
//             //     width: 300,
//             //     height: 300,
//             //     fit: BoxFit.fill,
//             //   ),
//             SizedBox(height: 30),
//             Container(
//                 width: 280,
//                 height: 60,
//                 margin:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//                 child: ElevatedButton(
//                     onPressed: () async => pilihGamabr(),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue.shade900,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     child: Text(
//                       "Pilih Gambar",
//                       style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                             color: Colors.white,
//                             fontSize: 23,
//                             fontWeight: FontWeight.bold,
//                           ),
//                     ))),
//             SizedBox(height: 30),
//             Container(
//                 width: 280,
//                 height: 60,
//                 margin:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//                 child: ElevatedButton(
//                     onPressed: () async => uploadGambar(),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue.shade900,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     child: Text(
//                       "Upload Gambar",
//                       style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                             color: Colors.white,
//                             fontSize: 23,
//                             fontWeight: FontWeight.bold,
//                           ),
//                     ))),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class Playground extends StatelessWidget {
//   const Playground({super.key});
//   List<DataPertanyaanFormKartu> dbDataProcessing(
//       Map<String, dynamic> dataForm, String indexKey, bool isCabang) {
//     List<DataPertanyaanFormKartu> dataSoalTemp = [];
//     for (Map<String, dynamic> map in dataForm[indexKey]) {
//       if ((map['tipeSoal'] as String) == "Pilihan Ganda" ||
//           (map['tipeSoal'] as String) == "Kotak Centang") {
//         dataSoalTemp.add(DataPertanyaanFormKartu(
//           dataSoal: DataPilgan.fromMapV2(map),
//           isWajib: (map["isWajib"] as int) == 1 ? true : false,
//           pertanyaanSoal: Delta.fromJson(
//             map['pertanyaanSoal'],
//           ),
//           urlGambar: map['urlGambar'] as String,
//           modelSoal: map['modelPertanyaan'] as String,
//           kataJawaban: (isCabang) ? map['kataJawaban'] as String : "",
//           kataPertanyaan: (isCabang) ? map['kataPertanyaan'] as String : "",
//           idJawabanAsal: (isCabang) ? map['idJawabanAsal'] as String : "",
//         ));
//       } else if ((map['tipeSoal'] as String) == "Slider Angka") {
//         dataSoalTemp.add(DataPertanyaanFormKartu(
//           dataSoal: DataSlider.fromMap(map),
//           isWajib: (map["isWajib"] as int) == 1 ? true : false,
//           pertanyaanSoal: Delta.fromJson(
//             map['pertanyaanSoal'],
//           ),
//           urlGambar: map['urlGambar'] as String,
//           modelSoal: map['modelPertanyaan'] as String,
//           kataJawaban: (isCabang) ? map['kataJawaban'] as String : "",
//           kataPertanyaan: (isCabang) ? map['kataPertanyaan'] as String : "",
//           idJawabanAsal: (isCabang) ? map['idJawabanAsal'] as String : "",
//         ));
//       } else if ((map['tipeSoal'] as String) == "Gambar Ganda" ||
//           (map['tipeSoal'] as String) == "Carousel") {
//         dataSoalTemp.add(DataPertanyaanFormKartu(
//           dataSoal: DataGambarGanda.fromMap(map),
//           isWajib: (map["isWajib"] as int) == 1 ? true : false,
//           pertanyaanSoal: Delta.fromJson(
//             map['pertanyaanSoal'],
//           ),
//           urlGambar: map['urlGambar'] as String,
//           modelSoal: map['modelPertanyaan'] as String,
//           kataJawaban: (isCabang) ? map['kataJawaban'] as String : "",
//           kataPertanyaan: (isCabang) ? map['kataPertanyaan'] as String : "",
//           idJawabanAsal: (isCabang) ? map['idJawabanAsal'] as String : "",
//         ));
//       } else if ((map['tipeSoal'] as String) == "Tabel") {
//         dataSoalTemp.add(DataPertanyaanFormKartu(
//           dataSoal: DataTabel.fromMap(map),
//           isWajib: (map["isWajib"] as int) == 1 ? true : false,
//           pertanyaanSoal: Delta.fromJson(
//             map['pertanyaanSoal'],
//           ),
//           urlGambar: map['urlGambar'] as String,
//           modelSoal: map['modelPertanyaan'] as String,
//           kataJawaban: (isCabang) ? map['kataJawaban'] as String : "",
//           kataPertanyaan: (isCabang) ? map['kataPertanyaan'] as String : "",
//           idJawabanAsal: (isCabang) ? map['idJawabanAsal'] as String : "",
//         ));
//       } else if ((map['tipeSoal'] as String) == "Urutan Pilihan") {
//         dataSoalTemp.add(DataPertanyaanFormKartu(
//           dataSoal: DataUrutan.fromMap(map),
//           isWajib: (map["isWajib"] as int) == 1 ? true : false,
//           pertanyaanSoal: Delta.fromJson(map['pertanyaanSoal']),
//           urlGambar: map['urlGambar'] as String,
//           modelSoal: map['modelPertanyaan'] as String,
//           kataJawaban: (isCabang) ? map['kataJawaban'] as String : "",
//           kataPertanyaan: (isCabang) ? map['kataPertanyaan'] as String : "",
//           idJawabanAsal: (isCabang) ? map['idJawabanAsal'] as String : "",
//         ));
//       } else {
//         dataSoalTemp.add(DataPertanyaanFormKartu(
//           dataSoal: DataSoal.fromMap(map),
//           isWajib: (map["isWajib"] as int) == 1 ? true : false,
//           pertanyaanSoal: Delta.fromJson(
//             map['pertanyaanSoal'],
//           ),
//           urlGambar: map['urlGambar'] as String,
//           modelSoal: map['modelPertanyaan'] as String,
//           kataJawaban: (isCabang) ? map['kataJawaban'] as String : "",
//           kataPertanyaan: (isCabang) ? map['kataPertanyaan'] as String : "",
//           idJawabanAsal: (isCabang) ? map['idJawabanAsal'] as String : "",
//         ));
//       }
//     }
//     return dataSoalTemp;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(
//       child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
//           decoration: BoxDecoration(
//               color: Colors.black, borderRadius: BorderRadius.circular(16)),
//           child: ElevatedButton(
//             onPressed: () async {
//               try {
//                 Map<String, dynamic> dataFormJson = {};
//                 final surveiKartuRef = FirebaseFirestore.instance
//                     .collection('form-card')
//                     .doc('kartu pertama');

//                 await surveiKartuRef.get().then((value) {
//                   dataFormJson = value.data()!;
//                 }).onError((error, stackTrace) {
//                   print(error);
//                 });

//                 print(dataFormJson);

//                 List<DataPertanyaanFormKartu> dataSoalUtama =
//                     dbDataProcessing(dataFormJson, 'daftarSoal', false);
//                 List<DataPertanyaanFormKartu> dataSoalCabang =
//                     dbDataProcessing(dataFormJson, 'daftarSoalCabang', true);
//               } catch (e) {
//                 print(e);
//                 print("Data Database Gagal dibuat");
//               }
//             },
//             child: Text(
//               "Soal Cabang",
//               style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                   fontSize: 27,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.indigo),
//             ),
//           )),
//     ));
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:midtrans_sdk/midtrans_sdk.dart';

// import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

// class MidTrans extends StatefulWidget {
//   const MidTrans({super.key});

//   @override
//   State<MidTrans> createState() => _MidTransState();
// }

// class _MidTransState extends State<MidTrans> {
//   MidtransSDK? _midtrans;

//   @override
//   void initState() {
//     super.initState();
//     initSDK();
//   }

//   @override
//   void dispose() {
//     _midtrans?.removeTransactionFinishedCallback();
//     super.dispose();
//   }

//   void initSDK() async {
//     _midtrans = await MidtransSDK.init(
//       config: MidtransConfig(
//           clientKey: DotEnv.env['SB-Mid-client-tkphxx3OpjKZuGC_'] ?? "",
//           merchantBaseUrl: DotEnv.env[
//                   'https://www.instagram.com/georgerossrobinson/?utm_source=ig_embed'] ??
//               "",
//           colorTheme: ColorTheme(
//             colorPrimary: Colors.black,
//             colorPrimaryDark: Colors.green,
//             colorSecondary: Colors.amber,
//           )
//           // colorTheme: ColorTheme(
//           //   colorPrimary: Theme.of(context).colorScheme.secondary,
//           //   colorPrimaryDark: Theme.of(context).colorScheme.secondary,
//           //   colorSecondary: Theme.of(context).colorScheme.secondary,
//           // ),
//           ),
//     );
//     _midtrans?.setUIKitCustomSetting(
//       skipCustomerDetailsPages: true,
//     );
//     _midtrans!.setTransactionFinishedCallback((result) {
//       print(result.toJson());
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text("berhasil text"),
//         // ElevatedButton(
//         //     onPressed: () async {
//         //       _midtrans?.startPaymentUiFlow(
//         //         token: DotEnv.env['15d650d7-31a7-4210-8d2c-641111cc7c88'],
//         //       );
//         //       // _midtrans?.startPaymentUiFlow(
//         //       //   token: '4f5588b9-1662-4861-a2ac-df5eda7df2bc',
//         //       // );
//         //       print("mencoba bayar");
//         //     },
//         //     child: Text("pay now")),
//       ),
//     );
//   }
// }

// //Center(
//       //   child: Column(
//       //     children: [
//       //       Container(
//       //         height: 200,
//       //         width: 350,
//       //         decoration: BoxDecoration(
//       //             border: Border.all(
//       //               color: Colors.black,
//       //               width: 2,
//       //             ),
//       //             borderRadius: BorderRadius.circular(20)),
//       //         child: Row(
//       //           children: [
//       //             Expanded(
//       //                 flex: 4,
//       //                 child: Container(
//       //                   padding: const EdgeInsets.symmetric(
//       //                       horizontal: 4, vertical: 18),
//       //                   child: Column(
//       //                     mainAxisAlignment: MainAxisAlignment.start,
//       //                     children: [
//       //                       Text(
//       //                         "Jumlah Partisipan",
//       //                         style: Theme.of(context)
//       //                             .textTheme
//       //                             .displayLarge!
//       //                             .copyWith(
//       //                               color: Colors.black,
//       //                               fontSize: 24,
//       //                             ),
//       //                       ),
//       //                       const SizedBox(height: 6),
//       //                       Text(
//       //                         "250",
//       //                         style: Theme.of(context)
//       //                             .textTheme
//       //                             .displayLarge!
//       //                             .copyWith(
//       //                                 color: Colors.black,
//       //                                 fontSize: 51,
//       //                                 fontWeight: FontWeight.bold),
//       //                       ),
//       //                       const SizedBox(height: 28),
//       //                       RichText(
//       //                         text: TextSpan(
//       //                             text: "Biaya : ",
//       //                             style: Theme.of(context)
//       //                                 .textTheme
//       //                                 .displayLarge!
//       //                                 .copyWith(
//       //                                   color: Colors.black,
//       //                                   fontSize: 20,
//       //                                 ),
//       //                             children: [
//       //                               TextSpan(
//       //                                 text: "Rp 250.000",
//       //                                 style: Theme.of(context)
//       //                                     .textTheme
//       //                                     .displayLarge!
//       //                                     .copyWith(
//       //                                         color: Colors.black,
//       //                                         fontSize: 26,
//       //                                         fontWeight: FontWeight.bold),
//       //                               ),
//       //                             ]),
//       //                       )
//       //                     ],
//       //                   ),
//       //                 )),
//       //             Expanded(
//       //                 flex: 1,
//       //                 child: Container(
//       //                   padding: const EdgeInsets.symmetric(vertical: 16),
//       //                   child: Column(
//       //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       //                     children: [
//       //                       IconButton.filled(
//       //                         onPressed: () {},
//       //                         icon: Icon(Icons.add),
//       //                       ),
//       //                       IconButton.filled(
//       //                         onPressed: () {},
//       //                         icon: Icon(Icons.remove),
//       //                       )
//       //                     ],
//       //                   ),
//       //                 )),
//       //           ],
//       //         ),
//       //       ),
//       //       Text("Note : ")
//       //     ],
//       //   ),
//       // ),
