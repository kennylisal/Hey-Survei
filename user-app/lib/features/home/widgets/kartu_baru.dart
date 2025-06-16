// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:survei_aplikasi/features/app/app.dart';
import 'package:survei_aplikasi/features/app/router/router_constant.dart';
import 'package:survei_aplikasi/features/home/widgets/gambar_kartu_survei.dart';

import 'package:survei_aplikasi/features/search/model/h_survei.dart';
import 'package:survei_aplikasi/utils/currency_formatter.dart';

class KartuKatalog extends ConsumerWidget {
  KartuKatalog({
    super.key,
    required this.dataKatalog,
    required this.constraints,
  });
  HSurvei dataKatalog;
  BoxConstraints constraints;
  String pemotongan(String text) {
    if (text.length < 11) {
      return text;
    } else {
      return text.substring(0, 10);
    }
  }

  Widget generateGambar() {
    if (constraints.maxWidth < 392) {
      return SizedBox();
    } else {
      // if (dataKatalog.gambarSurvei == "") {
      if (dataKatalog.gambarSurvei == "") {
        if (!dataKatalog.isKlasik) {
          return Container(
            width: 85,
            decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.red),
                borderRadius: BorderRadius.circular(8)),
            child: Image.asset('assets/logo-kartu.png',
                height: 90, fit: BoxFit.fill),
          );
        } else {
          return Container(
            width: 85,
            decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.green),
                borderRadius: BorderRadius.circular(8)),
            child: Image.asset('assets/logo-klasik.png',
                height: 90, fit: BoxFit.fill),
          );
        }
      } else {
        return Container(
          width: 85,
          decoration: BoxDecoration(
              border: Border.all(
                  width: 2,
                  color: (!dataKatalog.isKlasik) ? Colors.red : Colors.green),
              borderRadius: BorderRadius.circular(8)),
          child: GambarSurvei(urlGamabr: dataKatalog.gambarSurvei),
          // child: GambarSurvei(
          //     urlGamabr:
          //         'https://firebasestorage.googleapis.com/v0/b/hei-survei-v1.appspot.com/o/form%2F3350554f-22?alt=media&token=e7e240b0-9daf-4800-ba8c-23ec56480b97'),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        print("masuk disni");
        ref.read(idKatalogProvider.notifier).state = dataKatalog.id_survei;
        context.pushNamed(RouteConstant.detail);
      },
      child: Container(
          height: 112,
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              generateGambar(),
              const SizedBox(width: 7),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dataKatalog.judul,
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style:
                          Theme.of(context).textTheme.displayMedium!.copyWith(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 4.5),
                    Text(
                      dataKatalog.deskripsi,
                      maxLines: 3,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style:
                          Theme.of(context).textTheme.displayMedium!.copyWith(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                    ),
                  ],
                ),
              ),
              // const Spacer(),
              const SizedBox(width: 5),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    CurrencyFormat.convertToIdr(dataKatalog.insentif, 2),
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.timelapse,
                        size: 24,
                      ),
                      Text(
                        '${dataKatalog.durasi}m',
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                      )
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.shade300),
                    child: Text(
                      pemotongan(dataKatalog.kategori),
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              fontSize: 13.5,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
