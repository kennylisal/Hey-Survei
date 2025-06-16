import 'package:flutter/material.dart';
import 'package:hei_survei/features/katalog/model/survei_data.dart';
import 'package:hei_survei/utils/hover_builder.dart';
import 'package:intl/intl.dart';

// class KartuSurveiku extends StatelessWidget {
//   KartuSurveiku({
//     super.key,
//     required this.dataKartu,
//     required this.onTap,
//     required this.isTerbitan,
//   });
//   SurveiData dataKartu;
//   Function() onTap;
//   bool isTerbitan;
//   @override
//   Widget build(BuildContext context) {
//     return HoverBuilder(
//       builder: (isHovered) => InkWell(
//         onTap: onTap,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                   color:
//                       (isTerbitan) ? Colors.lightBlue.shade400 : Colors.green,
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(12),
//                       topRight: Radius.circular(12))),
//               margin: const EdgeInsets.only(left: 18),
//               padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
//               child: Text(
//                 (isTerbitan) ? "Terbitan" : "Terbeli",
//                 style: Theme.of(context)
//                     .textTheme
//                     .displaySmall!
//                     .copyWith(fontSize: 19, color: Colors.black),
//               ),
//             ),
//             AnimatedContainer(
//               duration: const Duration(milliseconds: 400),
//               width: 406,
//               margin: const EdgeInsets.only(bottom: 16),
//               padding: EdgeInsets.only(
//                 top: 9,
//               ),
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(21),
//                 border: Border.all(width: 3, color: Colors.black),
//                 boxShadow: [
//                   BoxShadow(
//                     color: (isHovered) ? Colors.grey : Colors.transparent,
//                     spreadRadius: 6,
//                     blurRadius: 3,
//                     offset: Offset(0, 6), // changes position of shadow
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: Text(
//                       dataKartu.judul,
//                       style: Theme.of(context).textTheme.displaySmall!.copyWith(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18,
//                           color: Colors.black),
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: Row(
//                       children: [
//                         Icon(Icons.timelapse),
//                         SizedBox(width: 4),
//                         Text(
//                           "${dataKartu.durasi} menit",
//                           style: Theme.of(context)
//                               .textTheme
//                               .displaySmall!
//                               .copyWith(
//                                 fontSize: 16,
//                                 color: Colors.black,
//                               ),
//                         ),
//                         Spacer(),
//                         StatusForm(status: dataKartu.status),
//                       ],
//                     ),
//                   ),
//                   Divider(color: Colors.grey.shade800, height: 12),
//                   Container(
//                     height: 125,
//                     child: Row(
//                       children: [
//                         (dataKartu.isKlasik)
//                             ? const FotoKlasik()
//                             : const FotoKartu(),
//                         SingleChildScrollView(
//                           child: Container(
//                             padding: const EdgeInsets.only(right: 0),
//                             width: 215,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 SizedBox(height: 4),
//                                 Text(
//                                   dataKartu.deskripsi,
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .displaySmall!
//                                       .copyWith(
//                                           fontSize: 13,
//                                           color: Colors.black,
//                                           letterSpacing: 1.25,
//                                           height: 1.6),
//                                 )
//                               ],
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   Divider(color: Colors.grey.shade800),
//                   Container(
//                     padding: const EdgeInsets.only(
//                         left: 18, right: 18, top: 0, bottom: 6),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         JumlahPartisipan(
//                           batasPartisipan: dataKartu.batasPartisipan.toString(),
//                           jumlahPartisipan:
//                               dataKartu.jumlahPartisipan.toString(),
//                         ),
//                         Text(
//                           DateFormat('dd-MMMM-yyyy')
//                               .format(dataKartu.tanggalPenerbitan),
//                           style: Theme.of(context)
//                               .textTheme
//                               .displaySmall!
//                               .copyWith(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                   color: Colors.black),
//                         )
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class FotoKartu extends StatelessWidget {
  const FotoKartu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 148,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 5,
            color: Colors.greenAccent,
          ),
          image: const DecorationImage(
            image: AssetImage('assets/logo-kartu.png'),
            fit: BoxFit.fill,
          )),
    );
  }
}

class FotoKlasik extends StatelessWidget {
  const FotoKlasik({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 148,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 5,
            color: Colors.redAccent,
          ),
          image: DecorationImage(
            image: const AssetImage('assets/logo-klasik.png'),
            fit: BoxFit.fill,
          )),
    );
  }
}

class StatusForm extends StatelessWidget {
  StatusForm({
    super.key,
    required this.status,
  });
  String status;

  @override
  Widget build(BuildContext context) {
    Color warnaPilihan = Colors.black;
    if (status == "aktif") {
      warnaPilihan = Colors.red;
    } else if (status == "selesai") {
      warnaPilihan = Colors.blue;
    } else if (status == "banned") {
      warnaPilihan = Colors.yellow;
    }
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration:
              BoxDecoration(color: warnaPilihan, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          status,
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontWeight: FontWeight.bold, fontSize: 17.5, color: Colors.black),
        ),
      ],
    );
  }
}

class JumlahPartisipan extends StatelessWidget {
  JumlahPartisipan({
    super.key,
    required this.jumlahPartisipan,
    required this.batasPartisipan,
  });
  String jumlahPartisipan;
  String batasPartisipan;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.person),
        const SizedBox(width: 2),
        RichText(
            text: TextSpan(
                text: jumlahPartisipan,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black),
                children: [
              TextSpan(text: ' / '),
              TextSpan(text: batasPartisipan)
            ]))
      ],
    );
  }
}
