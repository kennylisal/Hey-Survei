import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:survei_aplikasi/features/app/router/router_constant.dart';
import 'package:survei_aplikasi/features/laporan/laporan_controller.dart';

class HalamanPenilaian extends StatefulWidget {
  HalamanPenilaian({
    super.key,
    required this.email,
    required this.idSurvei,
  });
  String email;
  String idSurvei;

  @override
  State<HalamanPenilaian> createState() => _HalamanPenilaianState();
}

class _HalamanPenilaianState extends State<HalamanPenilaian> {
  bool isLoading = false;
  bool jawabanTerkirim = false;
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double nilai = 3;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Penilaian Survei",
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        backgroundColor: Colors.blue.shade400,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
            onPressed: () => context.pop(),
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              "Penilaian Survei",
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontSize: 32,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            RatingBar.builder(
              itemSize: 64,
              initialRating: nilai,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                nilai = rating;
              },
            ),
            const SizedBox(height: 26),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Text(
                  "Pesan : ",
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 2, color: Colors.blue)),
              child: TextField(
                controller: controller,
                decoration: InputDecoration.collapsed(
                  hintText: "Opsional",
                ),
                minLines: 4,
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (!jawabanTerkirim)
                  Container(
                    height: 55,
                    width: 125,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.greenAccent.shade700,
                    ),
                    child: TextButton(
                        onPressed: () async {
                          if (!isLoading) {
                            setState(() {
                              isLoading = true;
                            });
                            final hasil =
                                await LaporanController().kirimPenilaianSurvei(
                              email: widget.email,
                              pesan: controller.text,
                              idSurvei: widget.idSurvei,
                              emailUser: widget.email,
                              nilai: nilai.toInt(),
                            );
                            if (hasil) {
                              jawabanTerkirim = true;
                            } else {
                              isLoading = false;
                            }
                          }
                          setState(() {});
                        },
                        child: (isLoading)
                            ? const CircularProgressIndicator()
                            : Text(
                                "Kirim",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                        fontSize: 25,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1),
                              )),
                  ),
                Container(
                  height: 55,
                  width: 125,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.blue,
                  ),
                  child: TextButton(
                      onPressed: () => context.pushNamed(RouteConstant.home),
                      child: Text(
                        (!jawabanTerkirim) ? "Kembali" : "Lewati",
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1),
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
