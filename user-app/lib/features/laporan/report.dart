import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:survei_aplikasi/features/form_klasik/widgets/halaman_terima_kasih.dart';
import 'package:survei_aplikasi/features/laporan/laporan_controller.dart';

class ReportPage extends StatefulWidget {
  ReportPage({
    super.key,
    required this.idSurvei,
    required this.email,
    required this.judulSurvei,
  });
  String idSurvei;
  String email;
  String judulSurvei;
  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  bool isSelesai = false;
  bool isLoading = false;
  int keluhan = 1;
  List<String> listKata = [
    "Terdapat Kata - kata tidak pantas dalam form survei",
    "Terdapat Gambar - gambar tidak pantas dalam form survei",
    "Waktu yang dibutuhkan untuk menyelesaikan survei lebih lama",
    "Ada gangguan teknis / bug di aplikasi saat mengisi form",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Keluhan",
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        backgroundColor: Colors.blue.shade400,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
            onPressed: () {
              try {
                context.pop();
              } catch (e) {}
            },
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        child:
            // TerimaKasihPengisianForm(insentif: 800),
            (isSelesai)
                ? const HalamanTerimaKasih()
                : HalamanLaporan(
                    email: widget.email,
                    idSurvei: widget.idSurvei,
                    judulSurvei: widget.judulSurvei,
                    isLoading: isLoading,
                    onPressed: () async {
                      if (!isLoading) {
                        setState(() {
                          isLoading = true;
                        });
                        final hasil =
                            await LaporanController().pengajuanPencairan(
                          laporan: listKata[keluhan - 1],
                          idSurvei: widget.idSurvei,
                          email: widget.email,
                          judulSurvei: widget.judulSurvei,
                        );
                        setState(() {
                          if (hasil) {
                            isSelesai = true;
                          }
                          isLoading = false;
                        });
                      }
                    },
                  ),
      ),
    );
  }
}

class HalamanLaporan extends StatefulWidget {
  HalamanLaporan({
    super.key,
    required this.email,
    required this.idSurvei,
    required this.judulSurvei,
    required this.onPressed,
    required this.isLoading,
  });
  String idSurvei;
  String email;
  String judulSurvei;
  Function() onPressed;
  bool isLoading;
  @override
  State<HalamanLaporan> createState() => _HalamanLaporanState();
}

class _HalamanLaporanState extends State<HalamanLaporan> {
  int keluhan = 1;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          "Mohon maaf atas",
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 32,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          "Ketidaknyamanan ini",
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 32,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.indigo.shade200.withOpacity(0.5),
          ),
          child: Image.asset(
            'assets/logo-maaf.png',
            height: 150,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "Alasan pelaporan : ",
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 24,
                color: Colors.black,
              ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: InputDecorator(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(4.0))),
                contentPadding: EdgeInsets.all(10)),
            child: DropdownButtonHideUnderline(
                child: DropdownButton(
              value: keluhan,
              isDense: true,
              isExpanded: true,
              items: [
                DropdownMenuItem(
                    child: Text(
                        "Terdapat Kata - kata tidak pantas dalam form survei"),
                    value: 1),
                DropdownMenuItem(
                    child: Text(
                        "Terdapat Gambar - gambar tidak pantas dalam form survei"),
                    value: 2),
                DropdownMenuItem(
                    child: Text(
                        "Waktu yang dibutuhkan untuk menyelesaikan survei lebih lama"),
                    value: 3),
                DropdownMenuItem(
                    child: Text(
                        "Ada gangguan teknis / bug di aplikasi saat mengisi form"),
                    value: 4),
              ],
              onChanged: (value) {
                keluhan = value!;
              },
            )),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          height: 55,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 40),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black),
            borderRadius: BorderRadius.circular(8),
            color: Colors.blue,
          ),
          child: TextButton(
              onPressed: (widget.isLoading) ? null : widget.onPressed,
              child: (widget.isLoading)
                  ? const CircularProgressIndicator()
                  : Text(
                      "Laporkan",
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1),
                    )),
        ),
      ],
    );
  }
}

class HalamanTerimaKasih extends StatelessWidget {
  const HalamanTerimaKasih({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          "Terima Kasih atas",
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 32,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          "Laporannya",
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 36,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/logo-app.png',
                height: 125,
              ),
            ),
            const SizedBox(width: 22),
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/rekomendasi.png',
                height: 125,
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Container(
          height: 55,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 40),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black),
            borderRadius: BorderRadius.circular(8),
            color: Colors.blue,
          ),
          child: TextButton(
              onPressed: () => context.pop(),
              child: Text(
                "Ke Halaman utama",
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1),
              )),
        ),
      ],
    );
  }
}

// Column(
        //   children: [
        //     const SizedBox(height: 20),
        //     Text(
        //       "Mohon maaf atas",
        //       style: Theme.of(context).textTheme.displayMedium!.copyWith(
        //             fontSize: 32,
        //             color: Colors.black,
        //             fontWeight: FontWeight.bold,
        //           ),
        //     ),
        //     Text(
        //       "Ketidaknyamanan ini",
        //       style: Theme.of(context).textTheme.displayMedium!.copyWith(
        //             fontSize: 32,
        //             color: Colors.black,
        //             fontWeight: FontWeight.bold,
        //           ),
        //     ),
        //     SizedBox(height: 16),
        //     Container(
        //       padding: const EdgeInsets.all(7),
        //       decoration: BoxDecoration(
        //         shape: BoxShape.circle,
        //         color: Colors.indigo.shade200.withOpacity(0.5),
        //       ),
        //       child: Image.asset(
        //         'assets/logo-maaf.png',
        //         height: 150,
        //       ),
        //     ),
        //     const SizedBox(height: 20),
        //     Text(
        //       "Alasan pelaporan : ",
        //       style: Theme.of(context).textTheme.displayMedium!.copyWith(
        //             fontSize: 24,
        //             color: Colors.black,
        //           ),
        //     ),
        //     const SizedBox(height: 16),
        //     Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 24),
        //       child: InputDecorator(
        //         decoration: InputDecoration(
        //             border: OutlineInputBorder(
        //                 borderRadius:
        //                     const BorderRadius.all(Radius.circular(4.0))),
        //             contentPadding: EdgeInsets.all(10)),
        //         child: DropdownButtonHideUnderline(
        //             child: DropdownButton(
        //           value: keluhan,
        //           isDense: true,
        //           isExpanded: true,
        //           items: [
        //             DropdownMenuItem(
        //                 child: Text(
        //                     "Terdapat Kata - kata tidak pantas dalam form survei"),
        //                 value: 1),
        //             DropdownMenuItem(
        //                 child: Text(
        //                     "Terdapat Gambar - gambar tidak pantas dalam form survei"),
        //                 value: 2),
        //             DropdownMenuItem(
        //                 child: Text(
        //                     "Waktu yang dibutuhkan untuk menyelesaikan survei lebih lama"),
        //                 value: 3),
        //             DropdownMenuItem(
        //                 child: Text(
        //                     "Ada gangguan teknis / bug di aplikasi saat mengisi form"),
        //                 value: 4),
        //           ],
        //           onChanged: (value) {
        //             keluhan = value!;
        //           },
        //         )),
        //       ),
        //     ),
        //     const SizedBox(height: 20),
        //     Container(
        //       height: 55,
        //       width: double.infinity,
        //       margin: const EdgeInsets.symmetric(horizontal: 40),
        //       decoration: BoxDecoration(
        //         border: Border.all(width: 1, color: Colors.black),
        //         borderRadius: BorderRadius.circular(8),
        //         color: Colors.blue,
        //       ),
        //       child: TextButton(
        //           onPressed: () async {
        //             if (!isLoading) {
        //               setState(() {
        //                 isLoading = true;
        //               });
        //               final hasil = LaporanController().pengajuanPencairan(
        //                   laporan: listKata[keluhan - 1],
        //                   idSurvei: widget.idSurvei,
        //                   email: "");
        //               setState(() {
        //                 isLoading = false;
        //               });
        //             }
        //           },
        //           child: (isLoading)
        //               ? const CircularProgressIndicator()
        //               : Text(
        //                   "Laporkan",
        //                   style: Theme.of(context)
        //                       .textTheme
        //                       .displayMedium!
        //                       .copyWith(
        //                           fontSize: 18,
        //                           color: Colors.white,
        //                           fontWeight: FontWeight.bold,
        //                           letterSpacing: 1),
        //                 )),
        //     ),
        //   ],
        // )