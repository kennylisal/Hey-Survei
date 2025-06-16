import 'package:aplikasi_admin/features/master_reward/reward_controller.dart';
import 'package:aplikasi_admin/utils/currency_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HalamanReward extends StatefulWidget {
  HalamanReward({
    super.key,
    required this.constraints,
  });
  BoxConstraints constraints;
  @override
  State<HalamanReward> createState() => _HalamanRewardState();
}

class _HalamanRewardState extends State<HalamanReward> {
  int hargapPerSurvei = -1;
  int hargaPerPartisipan = -1;
  int hargaSpecial = -1;
  @override
  void initState() {
    Future(() async {
      Map<String, int>? map = await RewardController().getHargaReward(context);
      setState(() {
        if (map != null) {
          hargapPerSurvei = map['hargapPerSurvei']!;
          hargaPerPartisipan = map['hargaPerPartisipan']!;
          hargaSpecial = map['hargaSpecial']!;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 36),
            child: Row(
              children: [
                Spacer(flex: 1),
                if (widget.constraints.maxWidth > 1315)
                  Text(
                    "Master Reward",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                Spacer(flex: 1),
                InkWell(
                  onTap: () {},
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.grey.shade100,
                    child: Icon(
                      Icons.restart_alt,
                      size: 40,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 500,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(width: 1)),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 18),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Biaya Per Partisipan biasa",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge!
                                        .copyWith(
                                          color: Colors.black,
                                          fontSize: 28,
                                        ),
                                  ),
                                  const SizedBox(height: 32),
                                  (hargapPerSurvei == -1)
                                      ? LoadingLingkaran(
                                          height: 35,
                                          width: 35,
                                          strokeWidth: 8,
                                        )
                                      : RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                              text: CurrencyFormat.convertToIdr(
                                                  hargapPerSurvei, 2),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayLarge!
                                                  .copyWith(
                                                    color: Colors.black,
                                                    fontSize: 40,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ]),
                                        ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await RewardController().perbaruiHarga(
                                        context,
                                        hargapPerSurvei,
                                        hargaPerPartisipan,
                                        hargaSpecial,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      height: 50,
                                      width: 150,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6),
                                      child: Center(
                                        child: Text(
                                          "Perbarui Harga",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall!
                                              .copyWith(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        Expanded(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton.filled(
                                    onPressed: () {
                                      setState(() {
                                        hargapPerSurvei += 100;
                                      });
                                    },
                                    icon: Icon(Icons.add),
                                  ),
                                  SizedBox(
                                    height: 32,
                                  ),
                                  IconButton.filled(
                                    onPressed: () {
                                      setState(() {
                                        hargapPerSurvei -= 100;
                                      });
                                    },
                                    icon: Icon(Icons.remove),
                                  )
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "* Harga kelipatan Rp.100",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "* ini adalah biaya yang akan dipungut oleh aplikasi",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 500,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(width: 1)),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 18),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Biaya Per Partisipan demografi",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge!
                                        .copyWith(
                                          color: Colors.black,
                                          fontSize: 23,
                                        ),
                                  ),
                                  const SizedBox(height: 32),
                                  (hargapPerSurvei == -1)
                                      ? LoadingLingkaran(
                                          height: 35,
                                          width: 35,
                                          strokeWidth: 8,
                                        )
                                      : RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                              text: CurrencyFormat.convertToIdr(
                                                  hargaSpecial, 2),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayLarge!
                                                  .copyWith(
                                                    color: Colors.black,
                                                    fontSize: 40,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ]),
                                        ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      height: 50,
                                      width: 150,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6),
                                      child: Center(
                                        child: Text(
                                          "Perbarui Harga",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall!
                                              .copyWith(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        Expanded(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton.filled(
                                    onPressed: () {
                                      setState(() {
                                        hargaSpecial += 100;
                                      });
                                    },
                                    icon: Icon(Icons.add),
                                  ),
                                  SizedBox(
                                    height: 32,
                                  ),
                                  IconButton.filled(
                                    onPressed: () {
                                      setState(() {
                                        hargaSpecial -= 100;
                                      });
                                    },
                                    icon: Icon(Icons.remove),
                                  )
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "* Harga kelipatan Rp.100",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "* Biaya per partisipan untuk fitur demografi",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 50),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 500,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(width: 1)),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 18),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Insentif Per Partisipan",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .copyWith(
                                        color: Colors.black,
                                        fontSize: 28,
                                      ),
                                ),
                                const SizedBox(height: 32),
                                (hargapPerSurvei == -1)
                                    ? LoadingLingkaran(
                                        height: 35,
                                        width: 35,
                                        strokeWidth: 8,
                                      )
                                    : RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                            text: CurrencyFormat.convertToIdr(
                                                hargaPerPartisipan, 2),
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayLarge!
                                                .copyWith(
                                                  color: Colors.black,
                                                  fontSize: 40,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ]),
                                      ),
                                SizedBox(
                                  height: 40,
                                ),
                                ElevatedButton(
                                  onPressed: () async {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    height: 50,
                                    width: 150,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    child: Center(
                                      child: Text(
                                        "Perbarui Harga",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .copyWith(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton.filled(
                                  onPressed: () {
                                    setState(() {
                                      hargaPerPartisipan += 100;
                                    });
                                  },
                                  icon: Icon(Icons.add),
                                ),
                                SizedBox(
                                  height: 32,
                                ),
                                IconButton.filled(
                                  onPressed: () {
                                    setState(() {
                                      hargaPerPartisipan -= 100;
                                    });
                                  },
                                  icon: Icon(Icons.remove),
                                )
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "* Harga kelipatan Rp.100",
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  "* Insentif yang akan didapat pengisi survey",
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Container(
            //       //height: 160,
            //       width: 420,
            //       decoration: BoxDecoration(
            //           color: Colors.grey.shade200,
            //           border: Border.all(
            //             color: Colors.black,
            //             width: 2,
            //           ),
            //           borderRadius: BorderRadius.circular(20)),
            //       child: Row(
            //         children: [
            //           Expanded(
            //               flex: 4,
            //               child: Container(
            //                 padding: const EdgeInsets.symmetric(
            //                     horizontal: 4, vertical: 18),
            //                 child: Column(
            //                   mainAxisAlignment: MainAxisAlignment.start,
            //                   children: [
            //                     Text(
            //                       "Insentif tiap Partisipan",
            //                       style: Theme.of(context)
            //                           .textTheme
            //                           .displayLarge!
            //                           .copyWith(
            //                             color: Colors.black,
            //                             fontSize: 28,
            //                           ),
            //                     ),
            //                     const SizedBox(height: 32),
            //                     (hargapPerSurvei == -1)
            //                         ? LoadingLingkaran(
            //                             height: 35,
            //                             width: 35,
            //                             strokeWidth: 8,
            //                           )
            //                         : RichText(
            //                             text: TextSpan(children: [
            //                               TextSpan(
            //                                 text: CurrencyFormat.convertToIdr(
            //                                     hargaPerPartisipan, 2),
            //                                 style: Theme.of(context)
            //                                     .textTheme
            //                                     .displayLarge!
            //                                     .copyWith(
            //                                       color: Colors.black,
            //                                       fontSize: 40,
            //                                       fontWeight: FontWeight.bold,
            //                                     ),
            //                               ),
            //                             ]),
            //                           ),
            //                     SizedBox(height: 30),
            //                     ElevatedButton(
            //                       onPressed: () async {},
            //                       style: ElevatedButton.styleFrom(
            //                         backgroundColor: Colors.blueAccent,
            //                       ),
            //                       child: Container(
            //                         margin: const EdgeInsets.symmetric(
            //                             horizontal: 20),
            //                         height: 50,
            //                         width: 150,
            //                         padding:
            //                             const EdgeInsets.symmetric(vertical: 6),
            //                         child: Center(
            //                           child: Text(
            //                             "Perbarui Harga",
            //                             style: Theme.of(context)
            //                                 .textTheme
            //                                 .labelSmall!
            //                                 .copyWith(
            //                                   fontSize: 17,
            //                                   fontWeight: FontWeight.bold,
            //                                   color: Colors.white,
            //                                 ),
            //                           ),
            //                         ),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               )),
            //           Expanded(
            //               flex: 1,
            //               child: Container(
            //                 padding: const EdgeInsets.symmetric(vertical: 16),
            //                 child: Column(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: [
            //                     IconButton.filled(
            //                       onPressed: () {
            //                         setState(() {
            //                           hargaPerPartisipan += 100;
            //                         });
            //                       },
            //                       icon: Icon(Icons.add),
            //                     ),
            //                     IconButton.filled(
            //                       onPressed: () {
            //                         setState(() {
            //                           hargaPerPartisipan -= 100;
            //                         });
            //                       },
            //                       icon: Icon(Icons.remove),
            //                     )
            //                   ],
            //                 ),
            //               )),
            //         ],
            //       ),
            //     ),
            //     const SizedBox(
            //       height: 8,
            //     ),
            //     const Text("* Harga kelipatan Rp.100"),
            //     const Text(
            //         "* Ini adalah insentif yang akan diterima oleh partisipan"),
            //   ],
            // ),
          ),
          SizedBox(
            height: 300,
          )
        ],
      ),
    );
  }
}

// class CurrencyFormat {
//   static String convertToIdr(dynamic number, int decimalDigit) {
//     NumberFormat currencyFormatter = NumberFormat.currency(
//       locale: 'id',
//       symbol: 'Rp ',
//       decimalDigits: decimalDigit,
//     );
//     return currencyFormatter.format(number);
//   }
// }

class LoadingLingkaran extends StatelessWidget {
  LoadingLingkaran(
      {super.key, this.height = 100, this.width = 100, this.strokeWidth = 14});
  double height;
  double width;
  double strokeWidth;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: height,
      width: width,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
      ),
    );
  }
}
