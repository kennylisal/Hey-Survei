import 'package:aplikasi_admin/features/laporan_survei/models/order.dart';
import 'package:aplikasi_admin/features/master_survei/survei.dart';
import 'package:aplikasi_admin/utils/currency_format.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:uuid/uuid.dart';

class PdfLaporan {
  Future<bool> generatePdfOrder(List<Order> list, int jumlahHarga,
      String tglAwal, String tglAkhir, int jumlahBarisPerHalaman) async {
    final pdf = Document();
    final img = await rootBundle.load('assets/admin.png');
    final imageBytes = img.buffer.asUint8List();
    Image image1 = Image(MemoryImage(imageBytes));
    //penentuan halaman
    int jumlahHalaman = (list.length ~/ jumlahBarisPerHalaman) + 1;
    print("ini jumlah halaman $jumlahHalaman");
    //
    if (jumlahHalaman == 1) {
      pdf.addPage(MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          buildHeader(image1),
          SizedBox(height: 0.275 * PdfPageFormat.cm),
          buildTitleOrder(tglAwal, tglAkhir),
          buildTableOrder(list),
          SizedBox(height: 2.25 * PdfPageFormat.mm),
          buildHasil(jumlahHarga, list.length),
        ],
        footer: (context) => buildFooter(),
      ));
    } else {
      for (var i = 0; i < jumlahHalaman; i++) {
        if (jumlahHalaman == i + 1) {
          pdf.addPage(MultiPage(
            pageFormat: PdfPageFormat.a4,
            build: (context) => [
              buildHeader(image1),
              SizedBox(height: 0.275 * PdfPageFormat.cm),
              buildTitleOrder(tglAwal, tglAkhir),
              buildTableOrder(
                  list.sublist(i * jumlahBarisPerHalaman, list.length)),
              SizedBox(height: 3 * PdfPageFormat.mm),
              buildHasil(jumlahHarga, list.length),
            ],
            footer: (context) => buildFooter(),
          ));
        } else {
          pdf.addPage(MultiPage(
            pageFormat: PdfPageFormat.a4,
            build: (context) => [
              buildHeader(image1),
              SizedBox(height: 0.275 * PdfPageFormat.cm),
              buildTitle(tglAwal, tglAkhir),
              buildTableOrder(list.sublist(
                  i * jumlahBarisPerHalaman, (i + 1) * jumlahBarisPerHalaman)),
            ],
            footer: (context) => buildFooter(),
          ));
        }
      }
    }
    //

    return await Printing.layoutPdf(
      onLayout: (format) => pdf.save(),
    );
  }

  Future<bool> generatePdfSurvei(List<SurveiData> list, int jumlahHarga,
      String tglAwal, String tglAkhir, int jumlahBarisPerHalaman) async {
    final pdf = Document();
    final img = await rootBundle.load('assets/admin.png');
    final imageBytes = img.buffer.asUint8List();
    Image image1 = Image(MemoryImage(imageBytes));
    //penentuan halaman
    // int jumlahBarisPerHalaman = 7;
    int jumlahHalaman = (list.length ~/ jumlahBarisPerHalaman) + 1;
    print("ini jumlah halaman $jumlahHalaman");
    //
    if (jumlahHalaman == 1) {
      pdf.addPage(MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          buildHeader(image1),
          SizedBox(height: 0.275 * PdfPageFormat.cm),
          buildTitle(tglAwal, tglAkhir),
          buildTable(list),
          SizedBox(height: 2.25 * PdfPageFormat.mm),
          buildHasilOrder(jumlahHarga, list.length),
        ],
        footer: (context) => buildFooter(),
      ));
    } else {
      for (var i = 0; i < jumlahHalaman; i++) {
        if (jumlahHalaman == i + 1) {
          // print(
          //     " <kondisi akhir> ini list yg diambil ${i * jumlahBarisPerHalaman} || ${list.length}");
          pdf.addPage(MultiPage(
            pageFormat: PdfPageFormat.a4,
            build: (context) => [
              buildHeader(image1),
              SizedBox(height: 0.275 * PdfPageFormat.cm),
              buildTitle(tglAwal, tglAkhir),
              buildTable(list.sublist(i * jumlahBarisPerHalaman, list.length)),
              SizedBox(height: 3 * PdfPageFormat.mm),
              buildHasilOrder(jumlahHarga, list.length),
            ],
            footer: (context) => buildFooter(),
          ));
        } else {
          // print(
          //     " <kondisi biasa> ini list yg diambil ${i * jumlahBarisPerHalaman} || ${(i + 1) * jumlahBarisPerHalaman}}");

          pdf.addPage(MultiPage(
            pageFormat: PdfPageFormat.a4,
            build: (context) => [
              buildHeader(image1),
              SizedBox(height: 0.275 * PdfPageFormat.cm),
              buildTitle(tglAwal, tglAkhir),
              buildTable(list.sublist(
                  i * jumlahBarisPerHalaman, (i + 1) * jumlahBarisPerHalaman)),
            ],
            footer: (context) => buildFooter(),
          ));
        }
      }
    }

    //
    // pdf.addPage(MultiPage(
    //   pageFormat: PdfPageFormat.a4,
    //   build: (context) => [
    //     buildHeader(image1),
    //     SizedBox(height: 0.275 * PdfPageFormat.cm),
    //     buildTitle(tglAwal, tglAkhir),
    //     buildTable(list.sublist(0, 8)),
    //     SizedBox(height: 2.25 * PdfPageFormat.mm),
    //     buildHasilOrder(jumlahHarga, list.length),
    //   ],
    //   footer: (context) => buildFooter(),
    // ));
    return await Printing.layoutPdf(
      onLayout: (format) => pdf.save(),
    );
  }

  static Widget buildTableOrder(List<Order> list) {
    final styleJudul = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
    final styleBiasa = TextStyle(fontSize: 10);
    return Container(
      width: double.infinity,
      child: Table(
          columnWidths: const <int, TableColumnWidth>{
            0: FractionColumnWidth(0.2),
            1: FractionColumnWidth(0.29),
            2: FractionColumnWidth(0.1785),
            3: FractionColumnWidth(0.15),
            4: FractionColumnWidth(0.175),
          },
          border: TableBorder.all(
            width: 2,
          ),
          children: [
            TableRow(
              children: [
                Container(
                  color: PdfColors.blueAccent100,
                  height: 26,
                  child: Center(child: Text("ID Order", style: styleJudul)),
                ),
                Container(
                    color: PdfColors.blueAccent100,
                    height: 26,
                    child: Text("Email Pengguna", style: styleJudul)),
                Container(
                  color: PdfColors.blueAccent100,
                  height: 26,
                  child: Center(child: Text("Tanggal", style: styleJudul)),
                ),
                Container(
                  color: PdfColors.blueAccent100,
                  height: 26,
                  child: Center(
                    child: Center(child: Text("Persenan", style: styleJudul)),
                  ),
                ),
                Container(
                  height: 26,
                  color: PdfColors.blueAccent100,
                  child: Center(child: Text("Total", style: styleJudul)),
                ),
              ],
            ),
            ...generateTableRowOrder(list, styleBiasa)
          ]),
    );
  }

  static List<TableRow> generateTableRowOrder(
      List<Order> list, TextStyle style) {
    List<TableRow> temp = [];
    for (var element in list) {
      temp.add(TableRow(children: [
        Container(
          height: 26,
          padding: const EdgeInsets.all(4.5),
          child: Text(
            element.idOrder,
            style: style,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(4.5),
          child: Text(element.emailUser, style: style),
        ),
        Container(
            padding: const EdgeInsets.all(4.5),
            child: Text(
              '${DateFormat('dd-MMMM-yyyy').format(element.tanggalPenerbitan)}',
              style: style,
            )),
        Container(
            padding: const EdgeInsets.all(4.5),
            child: Text(
              "${element.persenan.toString()} %",
              style: style,
            )),
        Container(
          padding: const EdgeInsets.all(4.5),
          child: Text(
            CurrencyFormat.convertToIdr(element.totalHarga, 2),
            style: style,
          ),
        ),
      ]));
    }
    return temp;
  }

  static Widget buildTable(List<SurveiData> list) {
    final styleJudul = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
    final styleBiasa = TextStyle(fontSize: 10);
    return Container(
      width: double.infinity,
      child: Table(
          columnWidths: const <int, TableColumnWidth>{
            0: FractionColumnWidth(0.41),
            1: FractionColumnWidth(0.18),
            2: FractionColumnWidth(0.16),
            3: FractionColumnWidth(0.075),
            4: FractionColumnWidth(0.175),
          },
          border: TableBorder.all(
            width: 2,
          ),
          children: [
            TableRow(
              children: [
                Container(
                  color: PdfColors.blueAccent100,
                  height: 26,
                  child: Center(child: Text("Judul", style: styleJudul)),
                ),
                Container(
                  color: PdfColors.blueAccent100,
                  height: 26,
                  child: Center(child: Text("Penerbit", style: styleJudul)),
                ),
                Container(
                  color: PdfColors.blueAccent100,
                  height: 26,
                  child: Center(child: Text("Tanggal", style: styleJudul)),
                ),
                Container(
                  color: PdfColors.blueAccent100,
                  height: 26,
                  child: Center(
                    child: Center(child: Text("Org", style: styleJudul)),
                  ),
                ),
                Container(
                  height: 26,
                  color: PdfColors.blueAccent100,
                  child: Center(child: Text("Biaya", style: styleJudul)),
                ),
              ],
            ),
            ...generateTableRow(list, styleBiasa)
          ]),
    );
  }

  static List<TableRow> generateTableRow(
      List<SurveiData> list, TextStyle style) {
    List<TableRow> temp = [];
    for (var element in list) {
      temp.add(TableRow(children: [
        Container(
          height: 26,
          padding: const EdgeInsets.all(3),
          child: Text(
            element.judul,
            style: style,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(3),
          child: Text(element.emailUser, style: style),
        ),
        Container(
            padding: const EdgeInsets.all(3),
            child: Text(
              '${DateFormat('dd-MMMM-yyyy').format(element.tanggalPenerbitan)}',
              style: style,
            )),
        Container(
            padding: const EdgeInsets.all(3),
            child: Text(
              "${element.batasPartisipan}",
              style: style,
            )),
        // Container(
        //     child: Text(
        //   "${element.jumlahPartisipan} / ${element.batasPartisipan}",
        //   style: style,
        // )),
        // Container(
        //     child: Text(
        //   (element.isKlasik) ? "Klasik" : "Kartu",
        //   style: style,
        // )),
        Container(
            padding: const EdgeInsets.all(3),
            child: Text(CurrencyFormat.convertToIdr(element.harga, 2),
                style: style)),
      ]));
    }
    return temp;
  }

  static Widget buildTitle(String tglAwal, String tglAkhir) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Laporan Penerbitan Survei',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      SizedBox(height: 0.08 * PdfPageFormat.cm),
      Text("$tglAwal   sampai   $tglAkhir"),
      SizedBox(height: 0.225 * PdfPageFormat.cm),
      Center(
        child: Text('Daftar Survei',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      SizedBox(height: 0.125 * PdfPageFormat.cm),
    ]);
  }

  static Widget buildTitleOrder(String tglAwal, String tglAkhir) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Laporan Pembelian Survei',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      SizedBox(height: 0.08 * PdfPageFormat.cm),
      Text("$tglAwal   sampai   $tglAkhir"),
      SizedBox(height: 0.225 * PdfPageFormat.cm),
      Center(
        child: Text('Daftar Transaksi',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      SizedBox(height: 0.125 * PdfPageFormat.cm),
    ]);
  }

  static Widget buildHasil(int total, int jumlahSurvei) {
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                    title: 'Jumlah Survei',
                    value: "$jumlahSurvei Survei",
                    unite: true),
                Divider(),
                buildText(
                  title: "Jumlah Keuntungan",
                  value: CurrencyFormat.convertToIdr(total, 2),
                  titleStyle:
                      TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildHasilOrder(int total, int jumlahSurvei) {
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                    title: 'Jumlah Transaksi',
                    value: "$jumlahSurvei Transaksi",
                    unite: true),
                Divider(),
                buildText(
                  title: "Jumlah Keuntungan",
                  value: CurrencyFormat.convertToIdr(total, 2),
                  titleStyle:
                      TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter() =>
      Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Divider(),
        SizedBox(height: 2 * PdfPageFormat.mm),
        buildSimpleText(title: 'Aplikasi Hei Survei', value: ""),
        SizedBox(height: 1 * PdfPageFormat.mm),
        buildSimpleText(title: 'Surabaya - 2024', value: '')
      ]);

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);
    return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(title, style: style),
          SizedBox(width: 2 * PdfPageFormat.mm),
          Text(value),
        ]);
  }

  static Widget buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);
    return Container(
        width: width,
        child: Row(children: [
          Expanded(
            child: Text(title, style: style),
          ),
          Text(value, style: unite ? style : TextStyle(fontSize: 12))
        ]));
  }

  static Widget buildHeader(Image image) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      SizedBox(height: 1 * PdfPageFormat.cm),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildJudulAtas(),
          Container(
            alignment: Alignment.center,
            height: 2.5 * PdfPageFormat.cm,
            child: image,
          ),
        ],
      ),
      SizedBox(height: 4 * PdfPageFormat.mm),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildAdminProfile(),
          buildReportInfo(),
        ],
      ),
    ]);
  }

  static Widget buildReportInfo() {
    final title = ['ID Laporan', 'Tanggal Terbit', 'Versi Aplikasi'];
    final value = [
      'LP - ${const Uuid().v4().substring(0, 8)}',
      '${DateFormat('dd-MMMM-yyyy').format(DateTime.now())}',
      '1.3',
    ];
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
            title.length,
            (index) => Container(
                margin: const EdgeInsets.only(bottom: (1 * PdfPageFormat.mm)),
                width: 6.5 * PdfPageFormat.cm,
                child: Row(children: [
                  Expanded(
                    child: Text(title[index],
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Text(value[index], style: TextStyle(fontSize: 11.5))
                ]))));
  }

  static Widget buildAdminProfile() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Admin-1", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("kennylisa5@gmail.com")
        ],
      );

  static Widget buildJudulAtas() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Administrasi Hei Survei",
              style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      );
}
