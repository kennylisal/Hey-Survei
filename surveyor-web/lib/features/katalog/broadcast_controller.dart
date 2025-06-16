import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hei_survei/utils/backend.dart';

class BroadcastController {
  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  Future<bool> pengecekanBroadcast(
      String idSurvei, BuildContext context) async {
    try {
      bool hasil = false;
      final surveiRef = FirebaseFirestore.instance
          .collection('broadcast')
          .where('idSurvei', isEqualTo: idSurvei);

      await surveiRef.get().then((value) async {
        if (value.size == 0) {
          //pertama kali || belum ada catatan
          bool hasilBuat = await buatTandaBroadcast(idSurvei, "");
          if (!context.mounted) return false;
          if (hasilBuat) {
            // ScaffoldMessenger.of(context)
            //     .showSnackBar(const SnackBar(content: Text("Sukses")));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("gagal mencatata pebaruan")));
          }
          hasil = hasilBuat;
        } else {
          final data = value.docs[0];
          Timestamp tglTerakhir = data['tanggal'];
          var d1 = tglTerakhir.toDate();
          var d2 = DateTime.now();
          final diff = daysBetween(d1, d2);
          if (diff > 0) {
            buatTandaBroadcast(idSurvei, data.id);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Setiap Hari Broadcast Hanya bisa sekali")));
          }
          hasil = diff > 0;
        }
      });
      return hasil;
    } catch (e) {
      return false;
    }
  }

  Future<bool> buatTandaBroadcast(String idSurvei, String idDoc) async {
    try {
      if (idDoc == "") {
        final surveiRef = FirebaseFirestore.instance.collection('broadcast');
        surveiRef.add({"idSurvei": idSurvei, "tanggal": Timestamp.now()});
        return true;
      } else {
        final surveiRef =
            FirebaseFirestore.instance.collection('broadcast').doc(idDoc);
        await surveiRef.update({"tanggal": Timestamp.now()});
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<String>> ambilUser() async {
    try {
      List<String> listUser = [];
      final userRef = FirebaseFirestore.instance.collection('Users-survei');
      await userRef.get().then((value) {
        final data = value.docs;
        for (var element in data) {
          listUser.add(element['email']);
        }
      });
      return listUser;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<bool> broadcastSurvei(String judul, String link, List<String> email,
      BuildContext context) async {
    try {
      List<String> list = await ambilUser();
      String request = """
query BroadcastPengerjaanSurvei(\$listEmail: [String]!, \$judul: String!, \$link: String!) {
  broadcastPengerjaanSurvei(listEmail: \$listEmail, judul: \$judul, link: \$link) {
    code,data,status
  }
}
      """;
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: request, mapVariable: {
        'judul': judul,
        'link': link,
        'listEmail': list,
      });
      if (data!['broadcastPengerjaanSurvei']['code'] == 200) {
        if (!context.mounted) return false;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Berhasil Broadcast Message')));
        return true;
      } else {
        if (!context.mounted) return false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Terjadi Kesalahan Program')));
        return false;
      }
    } catch (e) {
      print(e);
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Terjadi Kesalahan Server")));
      return false;
    }
  }
}
