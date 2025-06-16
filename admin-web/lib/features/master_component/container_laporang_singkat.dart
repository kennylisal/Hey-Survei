import 'package:flutter/material.dart';

class DataLaporanSingkat {
  Color bgColor;
  Color borderColor;
  String lokasiFoto;
  DataLaporanSingkat({
    required this.bgColor,
    required this.borderColor,
    required this.lokasiFoto,
  });
}

class KotakLaporanSingkat extends StatelessWidget {
  KotakLaporanSingkat({
    super.key,
    required this.dataLaporanSingkat,
    this.isBesar = true,
    required this.text,
    required this.angka,
  });
  DataLaporanSingkat dataLaporanSingkat;
  bool isBesar;
  String text;
  int angka;
  @override
  Widget build(BuildContext context) {
    double jarakTulisan = (isBesar) ? 65 : 20;
    double besarTulisan = (isBesar) ? 28 : 15;
    return Container(
      width: (isBesar) ? 290 : 220,
      height: (isBesar) ? 175 : 150,
      // width: 290,
      // height: 175,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: dataLaporanSingkat.bgColor,
          // color: Colors.pink.shade100.withOpacity(0.6),
          border: Border(
            top: BorderSide(width: 10, color: dataLaporanSingkat.borderColor
                //color: Colors.pinkAccent.shade400,
                ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 4,
              blurRadius: 4,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    //color: Colors.pinkAccent.shade400,
                    color: dataLaporanSingkat.borderColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 2, color: Colors.black)),
                child: Image.asset(
                  //'assets/s-aktif.png',
                  dataLaporanSingkat.lokasiFoto,
                  color: Colors.black,
                  height: 65,
                ),
              ),
              SizedBox(width: jarakTulisan),
              Text(
                angka.toString(),
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Colors.black,
                      fontSize: 51,
                      fontWeight: FontWeight.bold,
                    ),
              )
            ],
          ),
          SizedBox(height: (isBesar) ? 30 : 19),
          Text(
            text,
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Colors.black,
                  fontSize: besarTulisan,
                  fontWeight: (isBesar) ? FontWeight.normal : FontWeight.bold,
                ),
          )
        ],
      ),
    );
  }
}
