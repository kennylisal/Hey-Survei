import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hei_survei/features/katalog/broadcast_controller.dart';
import 'package:hei_survei/features/katalog/model/survei_data.dart';
import 'package:hei_survei/features/katalog/widgets/gambar_survei_kartu.dart';
import 'package:hei_survei/features/katalog/widgets/kartu_survei.dart';
import 'package:hei_survei/features/surveiku/widget/kartu_surveiku_v2.dart';
import 'package:hei_survei/utils/dynamiclink_creator.dart';
import 'package:hei_survei/utils/generator_pdf.dart';
import 'package:intl/intl.dart';

class KartuSurveiAktif extends StatefulWidget {
  KartuSurveiAktif({
    super.key,
    required this.dataKartu,
    required this.isTerbitan,
    required this.onTapDetail,
    required this.onTapLaporan,
    required this.onTapQR,
    required this.onTapLink,
  });
  SurveiData dataKartu;
  Function() onTapDetail;
  Function() onTapLaporan;
  Function() onTapQR;
  Function() onTapLink;
  bool isTerbitan;

  @override
  State<KartuSurveiAktif> createState() => _KartuSurveikuState();
}

class _KartuSurveikuState extends State<KartuSurveiAktif> {
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

  Future<bool> brodcastSurvei(String link) async {
    final pengecekan = await BroadcastController()
        .pengecekanBroadcast(widget.dataKartu.id_survei, context);
    if (pengecekan) {
      if (!context.mounted) return false;
      final hasilBroadcast = await BroadcastController()
          .broadcastSurvei(widget.dataKartu.judul, link, [], context);
      if (!context.mounted) return false;
      if (hasilBroadcast) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Broadcast Sukses")));
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Terjadi Kesalahan Broadcast")));
        return false;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Terjadi Kesalahan Program")));
      return false;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("link telah terjiplak")));
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
                      backgroundColor: Color.fromARGB(255, 255, 155, 89),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 18),
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
                const SizedBox(width: 12),
                ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        final hasil = await DynamicLinkCreator()
                            .buildDynamicLink(widget.dataKartu.id_survei);
                        if (hasil != null) {
                          await brodcastSurvei(hasil);
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
                      backgroundColor: Colors.orange.shade300,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 18),
                      side: const BorderSide(width: 1.5, color: Colors.black),
                    ),
                    child: Text(
                      "Broadcast Survei",
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    )),
              ],
            ),
          ],
        ),
      );
    } else
      return SizedBox();
  }

  bool modeDetail = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 380,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container(
          //   decoration: BoxDecoration(
          //       color: (widget.isTerbitan)
          //           ? Colors.lightBlue.shade400
          //           : Colors.green,
          //       borderRadius: BorderRadius.only(
          //           topLeft: Radius.circular(12),
          //           topRight: Radius.circular(12))),
          //   margin: const EdgeInsets.only(left: 18),
          //   padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
          //   child: Text(
          //     (widget.isTerbitan) ? "Terbitan" : "Terbeli",
          //     style: Theme.of(context)
          //         .textTheme
          //         .displaySmall!
          //         .copyWith(fontSize: 19, color: Colors.black),
          //   ),
          // ),
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
          generateBotContent(),
        ],
      ),
    );
  }
}
