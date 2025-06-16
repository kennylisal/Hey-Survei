import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfUtils {
  Future<Uint8List> _generatePdf(PdfPageFormat format, String content) async {
    final pdf = pw.Document();

    final img = await rootBundle.load('assets/logo-app.png');
    final imageBytes = img.buffer.asUint8List();
    pw.Image image1 = pw.Image(pw.MemoryImage(imageBytes));
    final hasil = pw.Container(
        width: double.infinity,
        height: double.infinity,
        padding: pw.EdgeInsets.symmetric(horizontal: 10),
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.BarcodeWidget(
                    data: content,
                    width: 205,
                    height: 205,
                    barcode: pw.Barcode.qrCode(),
                    color: PdfColor.fromHex("#000000"),
                  ),
                  pw.SizedBox(width: 26),
                  pw.Container(
                    alignment: pw.Alignment.center,
                    height: 90,
                    child: image1,
                  ),
                  pw.SizedBox(width: 11),
                ]),
            pw.SizedBox(height: 17.5),
            pw.Text(
              "Scan Barcode ini Di Aplikasi Hei-Survei",
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(width: 8),
          ],
        ));
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) => hasil,
    ));

    return pdf.save();
  }

  Future<bool> displayPdf(String content) async {
    return await Printing.layoutPdf(
      onLayout: (format) => _generatePdf(format, content),
    );
  }
}
