import 'package:flutter/material.dart';
import 'package:hei_survei/features/katalog/model/survei_data.dart';
import 'package:hei_survei/features/katalog/widgets/gambar_survei_kartu.dart';
import 'package:hei_survei/utils/currency.dart';

class TidakAdaCart extends StatelessWidget {
  const TidakAdaCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Center(
        child: Text(
          "Belum Ada Survei di Keranjang",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}

class KotakCart extends StatelessWidget {
  KotakCart({
    super.key,
    required this.isCentang,
    required this.onChanged,
    required this.data,
    required this.onTapHapus,
  });
  Function(bool?) onChanged;
  bool isCentang;
  SurveiData data;
  Function() onTapHapus;
  DecorationImage gambarKlasik = const DecorationImage(
    image: AssetImage('assets/logo-klasik.png'),
    fit: BoxFit.fill,
  );

  DecorationImage gambarKartu = const DecorationImage(
    image: AssetImage('assets/logo-kartu.png'),
    fit: BoxFit.fill,
  );

  Widget generateFoto() {
    if (data.gambarSurvei == "") {
      return Container(
        height: 80,
        width: 100,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 2.75,
            color: (data.isKlasik) ? Colors.redAccent : Colors.greenAccent,
          ),
          image: (data.isKlasik) ? gambarKlasik : gambarKartu,
        ),
      );
    } else {
      return Container(
        height: 80,
        width: 100,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 2.75,
            color: Colors.black,
          ),
        ),
        child: GambarSurveiKartu(urlGamabr: data.gambarSurvei),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 17.5),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1.5),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.judul,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
          ),
          Row(
            children: [
              generateFoto(),
              const SizedBox(width: 12),
              Container(
                height: 90,
                width: 215,
                child: Text(
                  data.deskripsi,
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        fontSize: 14,
                      ),
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.fade,
                ),
              ),
              Spacer(),
              Checkbox(
                fillColor:
                    MaterialStateColor.resolveWith((states) => Colors.white),
                checkColor: Colors.green,
                value: isCentang,
                onChanged: onChanged,
              )
            ],
          ),
          SizedBox(
            height: 7,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                CurrencyFormat.convertToIdr(data.harga, 2),
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black),
              ),
              SizedBox(
                height: 36,
                width: 36,
                child: IconButton(
                    onPressed: onTapHapus,
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 22,
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }
}
