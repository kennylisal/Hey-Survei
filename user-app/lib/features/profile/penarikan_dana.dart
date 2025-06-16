import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:survei_aplikasi/constants.dart';
import 'package:survei_aplikasi/features/profile/profile.dart';
import 'package:survei_aplikasi/features/profile/profile_controller.dart';
import 'package:survei_aplikasi/features/profile/sejarah_kontribusi.dart';
import 'package:survei_aplikasi/features/profile/sejarah_pencairan.dart';
import 'package:survei_aplikasi/utils/currency_formatter.dart';
import 'package:survei_aplikasi/utils/graphql_db.dart';
import 'package:survei_aplikasi/utils/shared_pref.dart';

class PenarikanDana extends StatefulWidget {
  PenarikanDana({
    super.key,
    required this.poin,
    required this.email,
  });
  int poin;
  String email;
  @override
  State<PenarikanDana> createState() => _PenarikanDanaState();
}

class _PenarikanDanaState extends State<PenarikanDana> {
  List<SejarahPencairan>? list;

  TextEditingController controllerAngka = TextEditingController();
  bool isLoading = false;
  Widget generateSejarah() {
    if (list == null) {
      return SizedBox(
          height: 100,
          width: 100,
          child: CircularProgressIndicator(
            color: Colors.blue.shade700,
            strokeWidth: 8,
          ));
    } else {
      if (list!.isEmpty) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Image.asset(
            'assets/no-data-katalog.png',
            height: 180,
            fit: BoxFit.contain,
          ),
        );
      } else {
        return Column(children: [for (var e in list!) KartuSejarah(data: e)]);
      }
    }
  }

  @override
  void initState() {
    iniData();
    super.initState();
  }

  iniData() async {
    list = await getAllSejarah();
    setState(() {});
  }

  Future<List<SejarahPencairan>?> getAllSejarah() async {
    try {
      String request = """
query Query(\$idUser: String!) {
  getSejarahPencairan(idUser: \$idUser) {
    code
    data {
      aktif,jumlahPoin,waktu_pengajuan
    }
  }
}
      """;
      final idUser = SharedPrefs.getString(prefUserid) ?? "8c6639a";
      Map<String, dynamic>? data = await BackendConnection()
          .serverConnection(query: request, mapVariable: {
        "idUser": idUser,
      });
      print(data);
      if (data!['getSejarahPencairan']['code'] == 200) {
        List<Object?> result = data['getSejarahPencairan']['data'];
        final hasil = List.generate(result.length,
            (index) => SejarahPencairan.fromJson(json.encode(result[index])));
        return hasil;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 14,
        ),
        Container(
          margin: EdgeInsets.only(bottom: 16, left: 24, right: 24),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.blue.shade400,
              borderRadius: BorderRadius.circular(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Poin Anda",
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                  ),
                  Icon(
                    Icons.monetization_on_rounded,
                    size: 30,
                    color: Colors.white,
                  )
                ],
              ),
              Text(
                CurrencyFormat.convertToIdr(widget.poin, 2),
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Penarikan minimal Rp.10.000",
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      vertical: 11.25, horizontal: 5),
                  // margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: TextField(
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          fontSize: 19,
                          color: Colors.black.withOpacity(0.5),
                        ),
                    controller: controllerAngka,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration.collapsed(
                      hintText: "Poin yang mau ditarik",
                      hintStyle:
                          Theme.of(context).textTheme.displayMedium!.copyWith(
                                fontSize: 19,
                                color: Colors.blue.withOpacity(0.5),
                              ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  controllerAngka.text = widget.poin.toString();
                },
                child: Container(
                  height: 54,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  child: Icon(
                    Icons.arrow_circle_up,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 55,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 80),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black),
            borderRadius: BorderRadius.circular(8),
            color: Colors.greenAccent.shade400,
          ),
          child: TextButton(
              onPressed: () async {
                if (!isLoading) {
                  setState(() {
                    isLoading = true;
                  });
                  if (controllerAngka.text.isNotEmpty) {
                    int angka = int.parse(controllerAngka.text);
                    if (angka > widget.poin) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Poin tidak sesuai")));
                    } else if (widget.poin < 10000) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Poin belum cukup")));
                    } else {
                      //jalankan perintah
                      final hasil = await ProfileController()
                          .pengajuanPencairan(
                              email: widget.email, jumlah: angka);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(hasil)));
                      setState(() {
                        iniData();
                      });
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Textfield kosong")));
                  }
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              child: (isLoading)
                  ? CircularProgressIndicator()
                  : Text(
                      "Ajukan Pencairan",
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
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: HeaderSejarah(judul: "Riwayat Pencairan"),
        ),
        generateSejarah(),
        const SizedBox(height: 8),
      ],
    );
  }
}

class KartuSejarah extends StatelessWidget {
  KartuSejarah({super.key, required this.data});
  SejarahPencairan data;
  Color warnaBg() {
    if (data.aktif == "Sukses") {
      return Colors.green;
    } else if (data.aktif == "Diproses") {
      return Colors.blue;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: Colors.blue.shade200),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              color: Colors.blue.shade200,
              spreadRadius: 2,
              blurRadius: 3,
            ),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            "Pencarian poin sebesar ${CurrencyFormat.convertToIdr(data.jumlahPoin, 2)}",
            maxLines: 2,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  fontSize: 16.5,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: warnaBg(),
                ),
                child: Text(
                  data.aktif,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const Spacer(),
              Text(
                DateFormat('dd-MMMM-yyyy').format(data.waktu_pengajuan),
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
