import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hei_survei/constants.dart';
import 'package:hei_survei/features/publish_survei/model/respon_midtrans.dart';
import 'package:hei_survei/features/publish_survei/survei_controller.dart';
import 'package:hei_survei/utils/shared_pref.dart';
import 'package:uuid/uuid.dart';

class CobaPublish extends StatelessWidget {
  CobaPublish({super.key});
  Future<ResponMidtrans?> buatMidTrans(int hargaPembuatan) async {
    ResponMidtrans? hasil = await SurveiController().buatMidTrans(
        idTrans: const Uuid().v4().substring(0, 6),
        jumlahPembayaran: hargaPembuatan);
    return hasil;
  }

  Future<bool> pembuatanTagihan(
      ResponMidtrans midTrans, int hargaPembuatan, String idSurvei) async {
    //realtime database
    final userId = SharedPrefs.getString(prefUserId) ?? "";
    if (userId != "") {
      try {
        DatabaseReference dbRef =
            FirebaseDatabase.instance.ref('tagihan/$userId');
        DatabaseReference dbRefDetail =
            FirebaseDatabase.instance.ref('authTagihan/${midTrans.idOrder}');
        await dbRef.set({
          // "judul": "Survei pertama lewat aplikasi",
          "judul": "judul midtrans semetnara",
          "totalPembayaran": hargaPembuatan,
          "namaBank": midTrans.bank,
          "nomorVA": midTrans.nomorVA,
          'idOrder': midTrans.idOrder
        });

        await dbRefDetail.set({
          "idUser": SharedPrefs.getString(prefUserId) ?? "70fc9a56",
          "idSurvei": idSurvei,
          "tipe": "survei"
        });
        return true;
      } catch (e) {
        print(e);
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () async {
                print("eyeee");
                final hasil = await buatMidTrans(90000);
                if (hasil != null) {
                  pembuatanTagihan(hasil, 90000, "Survei percobaan");
                }
              },
              child: Text("Ladeis"))
        ],
      ),
    );
  }
}
