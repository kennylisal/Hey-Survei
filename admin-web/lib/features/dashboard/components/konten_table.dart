import 'package:aplikasi_admin/features/master_survei/survei.dart';
import 'package:aplikasi_admin/utils/currency_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KontenTableDashboard extends StatelessWidget {
  KontenTableDashboard({
    super.key,
    required this.listSurvei,
  });
  List<SurveiData> listSurvei;
  double widthContainer = 1200;
  double fontJudul = 19;
  double fontData = 15;
  List<DataRow> listRow = [];
  @override
  Widget build(BuildContext context) {
    //disini olah data listSurvei
    for (var survei in listSurvei) {
      listRow.add(DataRow(cells: [
        DataCell(Text(survei.judul)),
        DataCell(Text(CurrencyFormat.convertToIdr(survei.harga, 2))),
        DataCell(Text(survei.batasPartisipan.toString())),
        DataCell(
            Text(DateFormat('dd-MMMM-yyyy').format(survei.tanggalPenerbitan))),
        // DataCell(Text(survei.emailUser)),
        DataCell(Container(
          height: 20,
          child: Text(
            (survei.isKlasik) ? "Klasik" : "Kartu",
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                color: (survei.isKlasik) ? Colors.green : Colors.blue,
                fontSize: 17,
                fontWeight: FontWeight.bold),
          ),
        )),
      ]));
    }
    //

    //
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        width: widthContainer,
        color: Colors.grey.shade50,
        child: DataTable(
          horizontalMargin: 20,
          columnSpacing: 24,
          dataTextStyle: Theme.of(context).textTheme.displayLarge!.copyWith(
              color: Colors.black,
              fontSize: fontData,
              overflow: TextOverflow.ellipsis),
          headingTextStyle: Theme.of(context).textTheme.displayLarge!.copyWith(
              color: Colors.black,
              fontSize: fontJudul,
              fontWeight: FontWeight.bold),
          border: TableBorder.all(
            width: 1,
            borderRadius: BorderRadius.circular(10),
            color: Colors.black,
          ),
          columns: [
            DataColumn(
              label: Text('Judul Survei           '),
            ),
            DataColumn(
              label: Text('Biaya'),
            ),
            DataColumn(
              label: Text('Partisipan'),
            ),
            DataColumn(
              label: Text('Tgl Penerbitan'),
            ),
            // DataColumn(
            //   label: Text('Penerbit'),
            // ),
            DataColumn(
              label: Text('Jenis'),
            ),
          ],
          rows: listRow,
        ),
      ),
    );
  }
}
