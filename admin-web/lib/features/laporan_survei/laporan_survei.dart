import 'package:aplikasi_admin/features/formV2/widget/loading_form.dart';
import 'package:aplikasi_admin/features/laporan_survei/laporan_controller.dart';
import 'package:aplikasi_admin/features/laporan_survei/widgets/container_tanggal.dart';
import 'package:aplikasi_admin/features/laporan_survei/widgets/filter_laporan.dart';
import 'package:aplikasi_admin/features/laporan_survei/widgets/header_laporan.dart';
import 'package:aplikasi_admin/features/laporan_survei/widgets/konten_tabel_survei.dart';
import 'package:aplikasi_admin/features/laporan_survei/widgets/search_laporan.dart';
import 'package:aplikasi_admin/features/laporan_survei/widgets/tidak_ada_data.dart';
import 'package:aplikasi_admin/features/laporan_survei/widgets/tombol_cari_laporan.dart';
import 'package:aplikasi_admin/features/master_survei/survei.dart';
import 'package:aplikasi_admin/utils/web_pagination.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HalamanReportSurvei extends StatefulWidget {
  HalamanReportSurvei({
    super.key,
    required this.constraints,
  });
  BoxConstraints constraints;
  @override
  State<HalamanReportSurvei> createState() => _HalamanReportSurveiState();
}

class _HalamanReportSurveiState extends State<HalamanReportSurvei> {
  //sejauh ini begini strukturnya
  // find dulu -> ini langkah pertama
  //baru in between itu search dan filter => mereka sifatnya kek mengurangi ji gitu
  // isi hasil ditampilakn -> ini selalu paling terakhir & berguna untk ditampilkan
  //generateBody yang nemple ke build

  //note
  //tiap search atas (yg pakai tanggal) => semua di reset

  //ListData -> ListDataSimpanan => ListDataTampilan

  final controller = TextEditingController();
  final awalController = TextEditingController();
  final akhirController = TextEditingController();
  final controllerSearch = TextEditingController();
  DateTime? tglAwal;
  DateTime? tglAkhir;
  List<SurveiData> listData = [];

  bool isLoading = false;

  int pilihanFilter = 3;

  int jumlahHalaman = 0;
  int jumlahItemPerhalaman = 7;
  int ctrPagination = 1;
  List<SurveiData> listDataSimpanan = [];
  List<SurveiData> listDataTampilan = []; //ini yg menentunkan ap ditampilkan

  filterSurvei() {
    if (pilihanFilter == 1) {
      listData.sort((b, a) => a.harga.compareTo(b.harga));
      //termahal
    } else if (pilihanFilter == 2) {
      listData.sort((a, b) => a.harga.compareTo(b.harga));
    } else if (pilihanFilter == 3) {
      listData
          .sort((b, a) => a.tanggalPenerbitan.compareTo(b.tanggalPenerbitan));
    } else {
      listData
          .sort((a, b) => a.tanggalPenerbitan.compareTo(b.tanggalPenerbitan));
    }
  }

  Widget contentGenerator() {
    if (isLoading) {
      return LoadingBiasa(text: "Memuat Survei yang sesuai");
    } else {
      if (listData.isEmpty) {
        return const TidakAdaData();
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 16,
              height: 10,
            ),
            generateTabel(),
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
        );
      }
    }
  }

  findSurvei() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      if (tglAwal != null && tglAkhir != null) {
        final awal = (tglAwal!.millisecondsSinceEpoch / 1000).toInt();
        final akhir = (tglAkhir!.millisecondsSinceEpoch / 1000).toInt();

        // print("persiapan tangkan data");
        print(awal.toInt());
        listData =
            await ReportController().getSurveiReport(context, awal, akhir);
        if (listData.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Tidak ada penerbitan di rentang ini")));
        } else {
          controllerSearch.text = "";
          siapkanData();
          setPagination();
        }
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Lengkapi tanggal dahulu")));
      }
      setState(() {
        isLoading = false;
      });
    }
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
      List<SurveiData> temp = listDataSimpanan.sublist(awal, jumlah);
      listDataTampilan = temp;
    }
    setState(() {});
  }

  siapkanData() {
    //disini filter dan search dijalankan
    filterSurvei();

    listDataSimpanan = listData
        .where((element) =>
            element.judul.toLowerCase().contains(controllerSearch.text))
        .toList();
    print(
        "ini jumlah didapat dari siapakan data => ${listDataSimpanan.length}");
  }

  Widget generateTabel() {
    return Column(
      children: [
        HeaderLaporanX(
          listData: listData,
          tglAwal: DateFormat('dd-MMMM-yyyy').format(tglAwal!),
          tglAkhir: DateFormat('dd-MMMM-yyyy').format(tglAkhir!),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 200),
            SearchLaporan(
              controller: controllerSearch,
              hintText: "Cari Survei",
              onSubmitted: (value) {
                siapkanData();
                setPagination();
              },
              onTapSearch: () {
                print("eliminasi search");
                siapkanData();
                setPagination();
              },
            ),
            FilterLaporan(
              onChanged: (value) {
                pilihanFilter = value!;
                siapkanData();
                setPagination();
              },
              pilihanFilter: pilihanFilter,
            ),
          ],
        ),
        const SizedBox(height: 2),
        KontenTabelLaporanSurvei(
          listData: listDataTampilan,
          tglAwal: DateFormat('dd-MMMM-yyyy').format(tglAwal!),
          tglAkhir: DateFormat('dd-MMMM-yyyy').format(tglAkhir!),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderLaporan(
              constraints: widget.constraints,
              controller: controller,
              hintText: "Cari Survei",
              onSubmitted: (p0) {},
              onTap: () {},
              textJudul: "Laporan Survei",
              onTapReset: () {},
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  PilihanTanggalLaporan(
                      controller: awalController,
                      onTap: () async {
                        //when click we have to show the datepicker
                        tglAwal = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(), //get today's date
                            firstDate: DateTime(
                                2000), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2101));
                        if (tglAwal != null) {
                          print(
                              tglAwal); //get the picked date in the format => 2022-07-04 00:00:00.000
                          String formattedDate = DateFormat('dd-MMMM-yyyy').format(
                              tglAwal!); // format date in required form here we use yyyy-MM-dd that means time is removed
                          print(
                              formattedDate); //formatted date output using intl package =>  2022-07-04
                          //You can format date as per your need

                          setState(() {
                            awalController.text =
                                formattedDate; //set foratted date to TextField value.
                          });
                        } else {
                          print("Date is not selected");
                        }
                      }),
                  const SizedBox(width: 60),
                  PilihanTanggalLaporan(
                    controller: akhirController,
                    onTap: () async {
                      //when click we have to show the datepicker
                      tglAkhir = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101));
                      if (tglAkhir != null) {
                        print(tglAkhir);
                        String formattedDate =
                            DateFormat('dd-MMMM-yyyy').format(tglAkhir!);
                        print(formattedDate);

                        setState(() {
                          akhirController.text = formattedDate;
                        });
                      } else {
                        print("Date is not selected");
                      }
                    },
                  ),
                  TombolCari(
                    onPressed: () => findSurvei(),
                    text: "Cari Survei",
                    icon: const Icon(
                      Icons.find_in_page,
                      size: 25.5,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            contentGenerator()
          ],
        ),
      ),
    );
  }
}



  // isiHasilDitampilkan(int nomorHalaman) {
  //   if (nomorHalaman != 0) {
  //     int index = nomorHalaman - 1;
  //     int awal = index * jumlahItemPerhalaman;
  //     int jumlah = 0;
  //     if ((awal + jumlahItemPerhalaman) >= listData.length) {
  //       jumlah = listDataSimpanan.length;
  //     } else {
  //       jumlah = nomorHalaman * jumlahItemPerhalaman;
  //     }

  //     print("ini awal -> $awal || ini jumlah -> $jumlah");
  //     List<SurveiData> temp = listDataSimpanan.sublist(awal, jumlah);
  //     listDataTampilan = temp;
  //   }
  //   setState(() {});
  // }

  // setPagination() {
  //   if (listData.isEmpty) {
  //     jumlahHalaman = 0;
  //     ctrPagination = 0;
  //     isiHasilDitampilkan(0);
  //   } else {
  //     jumlahHalaman = (listData.length ~/ jumlahItemPerhalaman) +
  //         ((listData.length % jumlahItemPerhalaman > 0) ? 1 : 0);
  //     print(
  //         "isi hasil ditampilkan ->  lbh 1 || jumlah halaman -> $jumlahHalaman");
  //     isiHasilDitampilkan(1);
  //     ctrPagination = 1;
  //   }
  // }

// Container(
//               width: 200,
//               color: Colors.grey.shade100,
//               margin: const EdgeInsets.only(left: 40),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Urutkan : "),
//                   InputDecorator(
//                     decoration: const InputDecoration(
//                         border: OutlineInputBorder(
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(4.0))),
//                         contentPadding: EdgeInsets.all(10)),
//                     child: DropdownButtonHideUnderline(
//                         child: DropdownButton(
//                       value: pilihanFilter,
//                       isDense: true,
//                       isExpanded: true,
//                       items: const [
//                         DropdownMenuItem(
//                           value: 1,
//                           child: Text("Biaya Tertinggi"),
//                         ),
//                         DropdownMenuItem(
//                           value: 2,
//                           child: Text("Biaya Terendah"),
//                         ),
//                         DropdownMenuItem(
//                           value: 3,
//                           child: Text("Terbaru"),
//                         ),
//                         DropdownMenuItem(
//                           value: 4,
//                           child: Text("Terlama"),
//                         ),
//                       ],
//                       onChanged: (value) {
//                         setState(() {
//                           pilihanFilter = value!;
//                         });
//                       },
//                     )),
//                   ),
//                 ],
//               ),
//             ),