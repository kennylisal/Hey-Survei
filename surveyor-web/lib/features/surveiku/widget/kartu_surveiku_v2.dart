import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hei_survei/features/katalog/model/survei_data.dart';
import 'package:hei_survei/features/katalog/widgets/gambar_survei_kartu.dart';
import 'package:hei_survei/features/surveiku/widget/komponen_kartu_surveiku.dart';
import 'package:hei_survei/utils/dynamiclink_creator.dart';
import 'package:hei_survei/utils/generator_pdf.dart';
import 'package:intl/intl.dart';

class KartuSurveiV2 extends StatefulWidget {
  KartuSurveiV2({
    super.key,
    required this.dataKartu,
    required this.isTerbitan,
    required this.onTapDetail,
    required this.onTapLaporan,
    required this.onTapLink,
    required this.onTapQR,
  });
  SurveiData dataKartu;
  Function() onTapDetail;
  Function() onTapLaporan;
  Function() onTapQR;
  Function() onTapLink;
  bool isTerbitan;

  @override
  State<KartuSurveiV2> createState() => _KartuSurveikuState();
}

class _KartuSurveikuState extends State<KartuSurveiV2> {
  bool modeDetail = false;
  bool isLoading = false;
  Widget generateBotContent() {
    if (isLoading) {
      return const Row(
        children: [
          SizedBox(width: 50),
          SizedBox(
            height: 45,
            width: 45,
            child: CircularProgressIndicator(
              strokeWidth: 6,
            ),
          ),
        ],
      );
    } else {
      return generateDetail();
    }
  }

  generateFoto() {
    if (widget.dataKartu.gambarSurvei == "") {
      return (widget.dataKartu.isKlasik)
          ? const FotoKlasik()
          : const FotoKartu();
    } else {
      return Container(
        height: 120,
        width: 148,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 3,
            color: Colors.black,
          ),
        ),
        child: GambarSurveiKartu(urlGamabr: widget.dataKartu.gambarSurvei),
      );
    }
  }

  Widget generateDetail() {
    if (modeDetail) {
      return Container(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: ElevatedButton(
                      onPressed: widget.onTapDetail,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 18),
                        side: const BorderSide(
                          width: 1.5,
                          color: Colors.black,
                        ),
                      ),
                      child: Text(
                        "Detail",
                        style:
                            Theme.of(context).textTheme.displaySmall!.copyWith(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                      )),
                ),
                const SizedBox(width: 14),
                ElevatedButton(
                    onPressed: widget.onTapLaporan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 228, 118),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 18),
                      side: const BorderSide(width: 1.5, color: Colors.black),
                    ),
                    child: Text(
                      "Laporan",
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    )),
                const SizedBox(width: 14),
                ElevatedButton(
                    onPressed: () async {
                      print("masuk qr");
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        final hasil = await DynamicLinkCreator()
                            .buildDynamicLink(widget.dataKartu.id_survei);
                        if (hasil != null) {
                          PdfUtils().displayPdf(hasil);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Terjadi Kesalahan")));
                        }
                      } catch (e) {}
                      setState(() {
                        isLoading = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 160, 109, 255),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 18),
                      side: const BorderSide(width: 1.5, color: Colors.black),
                    ),
                    child: Text(
                      "QR Code",
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    )),
              ],
            ),
            const SizedBox(height: 11),
            ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  try {
                    final hasil = await DynamicLinkCreator()
                        .buildDynamicLink(widget.dataKartu.id_survei);
                    if (hasil != null) {
                      Clipboard.setData(ClipboardData(text: hasil));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("link telah terjiplak")));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Terjadi Kesalahan")));
                    }
                  } catch (e) {}
                  setState(() {
                    isLoading = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 155, 89),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                  side: const BorderSide(width: 1.5, color: Colors.black),
                ),
                child: Text(
                  "Copy Link",
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                )),
          ],
        ),
      );
    } else
      return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 385,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                color: (widget.isTerbitan)
                    ? Colors.lightBlue.shade400
                    : Colors.green,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
            margin: const EdgeInsets.only(left: 18),
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
            child: Text(
              (widget.isTerbitan) ? "Terbitan" : "Terbeli",
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontSize: 19, color: Colors.black),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                modeDetail = !modeDetail;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 406,
              margin: const EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.only(
                top: 9,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(21),
                border: Border.all(width: 3, color: Colors.black),
                boxShadow: [
                  BoxShadow(
                    color: Colors.transparent,
                    spreadRadius: 6,
                    blurRadius: 3,
                    offset: Offset(0, 6), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      widget.dataKartu.judul,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(Icons.timelapse),
                        SizedBox(width: 4),
                        Text(
                          "${widget.dataKartu.durasi} menit",
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                        ),
                        Spacer(),
                        StatusForm(status: widget.dataKartu.status),
                      ],
                    ),
                  ),
                  Divider(color: Colors.grey.shade800, height: 12),
                  Container(
                    height: 125,
                    child: Row(
                      children: [
                        // (widget.dataKartu.isKlasik)
                        //     ? const FotoKlasik()
                        //     : const FotoKartu(),
                        generateFoto(),
                        SingleChildScrollView(
                          child: Container(
                            padding: const EdgeInsets.only(right: 0),
                            width: 215,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 4),
                                Text(
                                  widget.dataKartu.deskripsi,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(
                                          fontSize: 13,
                                          color: Colors.black,
                                          letterSpacing: 1.25,
                                          height: 1.6),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(color: Colors.grey.shade800),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 18, right: 18, top: 0, bottom: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        JumlahPartisipan(
                          batasPartisipan:
                              widget.dataKartu.batasPartisipan.toString(),
                          jumlahPartisipan:
                              widget.dataKartu.jumlahPartisipan.toString(),
                        ),
                        Text(
                          DateFormat('dd-MMMM-yyyy')
                              .format(widget.dataKartu.tanggalPenerbitan),
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          //
          // generateDetail(),
          generateBotContent(),
        ],
      ),
    );
  }
}

class StatusForm extends StatelessWidget {
  StatusForm({
    super.key,
    required this.status,
  });
  String status;

  @override
  Widget build(BuildContext context) {
    Color warnaPilihan = Colors.black;
    if (status == "aktif") {
      warnaPilihan = Colors.red;
    } else if (status == "selesai") {
      warnaPilihan = Colors.blue;
    } else if (status == "banned") {
      warnaPilihan = Colors.yellow;
    }
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration:
              BoxDecoration(color: warnaPilihan, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          status,
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontWeight: FontWeight.bold, fontSize: 17.5, color: Colors.black),
        ),
      ],
    );
  }
}

class JumlahPartisipan extends StatelessWidget {
  JumlahPartisipan({
    super.key,
    required this.jumlahPartisipan,
    required this.batasPartisipan,
  });
  String jumlahPartisipan;
  String batasPartisipan;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.person),
        const SizedBox(width: 2),
        RichText(
            text: TextSpan(
                text: jumlahPartisipan,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black),
                children: [
              TextSpan(text: ' / '),
              TextSpan(text: batasPartisipan)
            ]))
      ],
    );
  }
}

// if (modeDetail)
//   Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       ElevatedButton(
//           onPressed: widget.onTapDetail,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.blueAccent.shade400,
//             padding: const EdgeInsets.symmetric(
//                 vertical: 8, horizontal: 18),
//             side: const BorderSide(width: 1.5, color: Colors.black),
//           ),
//           child: Text(
//             "Detail",
//             style: Theme.of(context)
//                 .textTheme
//                 .displaySmall!
//                 .copyWith(fontSize: 17, color: Colors.black),
//           )),
//       const SizedBox(width: 14),
//       ElevatedButton(
//           onPressed: widget.onTapLaporan,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color.fromARGB(255, 0, 228, 118),
//             padding: const EdgeInsets.symmetric(
//                 vertical: 8, horizontal: 18),
//             side: const BorderSide(width: 1.5, color: Colors.black),
//           ),
//           child: Text(
//             "Laporan",
//             style: Theme.of(context)
//                 .textTheme
//                 .displaySmall!
//                 .copyWith(fontSize: 17, color: Colors.black),
//           )),
//       const SizedBox(width: 14),
//       ElevatedButton(
//           onPressed: () {},
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color.fromARGB(255, 0, 228, 118),
//             padding: const EdgeInsets.symmetric(
//                 vertical: 8, horizontal: 18),
//             side: const BorderSide(width: 1.5, color: Colors.black),
//           ),
//           child: Text(
//             "Link & QR Code",
//             style: Theme.of(context)
//                 .textTheme
//                 .displaySmall!
//                 .copyWith(fontSize: 17, color: Colors.black),
//           )),
//     ],
//   ),
// if (modeDetail)
//   Container(
//     width: 300,
//     child: Expanded(
//       child: Row(
//         children: [
//           const SizedBox(width: 12),
//           Text(
//             "Link :",
//             style: Theme.of(context).textTheme.displaySmall!.copyWith(
//                 fontSize: 14,
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(width: 10),
//           Flexible(
//             child: TextField(
//               controller: TextEditingController(
//                   text:
//                       "style: Theme.of(context).textTheme.displaySmall!.copyWith( sdfkjs;ldkfhs;elf"),
//               readOnly: true,
//               decoration: const InputDecoration(
//                 hintText: "Nama Survei",
//                 border: InputBorder.none,
//               ),
//               style: Theme.of(context)
//                   .textTheme
//                   .displaySmall!
//                   .copyWith(
//                       fontSize: 14,
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     ),
//   )
