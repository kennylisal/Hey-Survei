// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:aplikasi_admin/features/formV2/widget/loading_form.dart';
import 'package:aplikasi_admin/features/laporan_survei/laporan_controller.dart';
import 'package:aplikasi_admin/features/laporan_survei/models/order.dart';
import 'package:aplikasi_admin/features/laporan_survei/widgets/container_tanggal.dart';
import 'package:aplikasi_admin/features/laporan_survei/widgets/filter_laporan.dart';
import 'package:aplikasi_admin/features/laporan_survei/widgets/header_laporan.dart';
import 'package:aplikasi_admin/features/laporan_survei/widgets/konten_tabel_survei.dart';
import 'package:aplikasi_admin/features/laporan_survei/widgets/search_laporan.dart';
import 'package:aplikasi_admin/features/laporan_survei/widgets/tidak_ada_data.dart';
import 'package:aplikasi_admin/features/laporan_survei/widgets/tombol_cari_laporan.dart';
import 'package:aplikasi_admin/features/laporan_survei/widgets/tombol_print.dart';
import 'package:aplikasi_admin/utils/currency_format.dart';
import 'package:aplikasi_admin/utils/pdf_laporan.dart';
import 'package:aplikasi_admin/utils/web_pagination.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HalamanReportOrder extends StatefulWidget {
  HalamanReportOrder({
    super.key,
    required this.constraints,
  });
  BoxConstraints constraints;
  @override
  State<HalamanReportOrder> createState() => _HalamanReportOrderState();
}

class _HalamanReportOrderState extends State<HalamanReportOrder> {
  final controller = TextEditingController();
  final awalController = TextEditingController();
  final akhirController = TextEditingController();
  DateTime? tglAwal;
  DateTime? tglAkhir;
  List<Order> listData = [];

  bool isLoading = false;

  int pilihanFilter = 3;

  final controllerSearch = TextEditingController();
  int jumlahHalaman = 0;
  int jumlahItemPerhalaman = 7;
  int ctrPagination = 1;
  List<Order> listDataSimpanan = [];
  List<Order> listDataTampilan = []; //ini yg menentunkan ap ditampilkan

  filterSurvei() {
    if (pilihanFilter == 1) {
      listData.sort((b, a) => a.totalHarga.compareTo(b.totalHarga));
      //termahal
    } else if (pilihanFilter == 2) {
      listData.sort((a, b) => a.totalHarga.compareTo(b.totalHarga));
    } else if (pilihanFilter == 3) {
      //terbaru
      listData
          .sort((b, a) => a.tanggalPenerbitan.compareTo(b.tanggalPenerbitan));
    } else {
      listData
          .sort((a, b) => a.tanggalPenerbitan.compareTo(b.tanggalPenerbitan));
    }
  }

  Widget contentGenerator() {
    if (isLoading) {
      return LoadingBiasa(text: "Memuat Order yang sesuai");
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
            const SizedBox(height: 12),
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

  findOrder() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      if (tglAwal != null && tglAkhir != null) {
        final awal = (tglAwal!.millisecondsSinceEpoch / 1000).toInt();
        final akhir = (tglAkhir!.millisecondsSinceEpoch / 1000).toInt();

        print(awal.toInt());
        listData =
            await ReportController().getOrderReport(context, awal, akhir);
        if (listData.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Tidak ada transaksi di rentang ini")));
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
      List<Order> temp = listDataSimpanan.sublist(awal, jumlah);
      listDataTampilan = temp;
      print("ini list ditampilkan ${listDataTampilan}");
    }
    setState(() {});
  }

  siapkanData() {
    //disini filter dan search dijalankan
    filterSurvei();

    listDataSimpanan = listData
        .where((element) =>
            element.emailUser.toLowerCase().contains(controllerSearch.text))
        .toList();
    print(
        "ini jumlah didapat dari siapakan data => ${listDataSimpanan.length}");
  }

  Widget generateTabel() {
    //sebelum ini proses search dan urutan
    // filterSurvei();
    return Column(
      children: [
        HeaderLaporanOrder(
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
              hintText: "Cari Email",
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
        KontenTabelLaporanOrder(
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
              hintText: "",
              onSubmitted: (p0) {},
              onTap: () {},
              textJudul: "Laporan Pembelian Survei",
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
                    onPressed: () => findOrder(),
                    text: "Cari Transaksi",
                    icon: const Icon(
                      Icons.find_in_page,
                      size: 25.5,
                      color: Colors.white,
                    ),
                  ),
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

class HeaderLaporanOrder extends StatelessWidget {
  HeaderLaporanOrder({
    super.key,
    required this.listData,
    required this.tglAkhir,
    required this.tglAwal,
  });
  List<Order> listData;
  String tglAwal;
  String tglAkhir;
  int totalKeuntungan() {
    int ctr = 0;
    for (var element in listData) {
      ctr += ((element.totalHarga * (100 - element.persenan)) ~/ 100).toInt();
    }
    return ctr;
    //ingat persenan
    // return ctr;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Total Transaksi : ${listData.length}",
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 2, color: Colors.black))),
                child: Text(
                  "Total Keuntungan : " +
                      CurrencyFormat.convertToIdr(totalKeuntungan(), 2),
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              TombolPrint(
                onPressed: () async {
                  final hasil = await PdfLaporan().generatePdfOrder(
                      listData, totalKeuntungan(), tglAwal, tglAkhir, 9);
                  if (!hasil) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Gagal proses laporan")));
                  }
                },
              ),
            ],
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 4.5, color: Colors.black))),
          ),
        ],
      ),
    );
  }
}

class KontenTabelLaporanOrder extends StatelessWidget {
  KontenTabelLaporanOrder({
    super.key,
    required this.listData,
    required this.tglAkhir,
    required this.tglAwal,
  });
  List<Order> listData;
  String tglAwal;
  String tglAkhir;
  List<TableRow> generateTableRow(BuildContext context) {
    List<TableRow> temp = [];
    for (var element in listData) {
      int persenan = 100 - element.persenan;
      temp.add(TableRow(children: [
        Container(
          padding: const EdgeInsets.only(top: 16, left: 12),
          child: Text(
            element.idOrder,
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 17,
                  overflow: TextOverflow.ellipsis,
                ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 16, left: 12),
          child: Text(
            element.emailUser,
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 17,
                  overflow: TextOverflow.ellipsis,
                ),
          ),
        ),
        Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              DateFormat('dd-MMMM-yyyy').format(element.tanggalPenerbitan),
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: Colors.black,
                    fontSize: 17,
                    overflow: TextOverflow.ellipsis,
                  ),
            )),
        Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              "${persenan.toString()} %",
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: Colors.black,
                    fontSize: 17,
                    overflow: TextOverflow.ellipsis,
                  ),
            )),
        Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              CurrencyFormat.convertToIdr(
                  ((element.totalHarga * persenan) ~/ 100), 2),
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: Colors.black,
                    fontSize: 17,
                    overflow: TextOverflow.ellipsis,
                  ),
            )),
      ]));
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1300,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Daftar Pembelian Survei",
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 10),
            Table(
              columnWidths: const <int, TableColumnWidth>{
                0: FractionColumnWidth(0.225),
                1: FractionColumnWidth(0.25),
                2: FractionColumnWidth(0.20),
                3: FractionColumnWidth(0.1),
                4: FractionColumnWidth(0.175),
              },
              border: TableBorder.all(
                borderRadius: BorderRadius.circular(20),
                width: 2,
              ),
              children: [
                TableRow(
                  children: [
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.blueAccent.shade100,
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(20))),
                      child: Center(
                          child: Text(
                        "ID Order",
                        style:
                            Theme.of(context).textTheme.displayLarge!.copyWith(
                                  color: Colors.black,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                      )),
                    ),
                    Container(
                      color: Colors.blueAccent.shade100,
                      height: 40,
                      child: Center(
                          child: Text(
                        "Email Pengguna",
                        style:
                            Theme.of(context).textTheme.displayLarge!.copyWith(
                                  color: Colors.black,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                      )),
                    ),
                    Container(
                      color: Colors.blueAccent.shade100,
                      height: 40,
                      child: Center(
                          child: Text(
                        "Tanggal",
                        style:
                            Theme.of(context).textTheme.displayLarge!.copyWith(
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
                        "Persenan",
                        style:
                            Theme.of(context).textTheme.displayLarge!.copyWith(
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
                          borderRadius:
                              BorderRadius.only(topRight: Radius.circular(20))),
                      child: Center(
                          child: Text(
                        "Total",
                        style:
                            Theme.of(context).textTheme.displayLarge!.copyWith(
                                  color: Colors.black,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                      )),
                    ),
                  ],
                ),
                ...generateTableRow(context),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
