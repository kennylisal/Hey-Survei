import 'package:aplikasi_admin/app/widget_component/navbar.dart';
import 'package:aplikasi_admin/features/master_reward/halaman_reward.dart';
import 'package:aplikasi_admin/features/master_reward/reward_controller.dart';
import 'package:aplikasi_admin/utils/currency_format.dart';
import 'package:flutter/material.dart';

class MasterReward extends StatefulWidget {
  const MasterReward({super.key});

  @override
  State<MasterReward> createState() => _MasterRewardState();
}

class _MasterRewardState extends State<MasterReward> {
  int hargapPerSurvei = -1;
  int hargaPerPartisipan = -1;
  @override
  void initState() {
    Future(() async {
      Map<String, int>? map = await RewardController().getHargaReward(context);
      setState(() {
        if (map != null) {
          hargapPerSurvei = map['hargapPerSurvei']!;
          hargaPerPartisipan = map['hargaPerPartisipan']!;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: getNavBar(context),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  "Master Reward",
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Colors.black,
                      fontSize: 48,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                width: 875,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 500,
                          decoration: BoxDecoration(
                              color: Colors.white,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Biaya Per Partisipan",
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
                                                    text: CurrencyFormat
                                                        .convertToIdr(
                                                            hargapPerSurvei, 2),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayLarge!
                                                        .copyWith(
                                                          color: Colors.black,
                                                          fontSize: 40,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                ]),
                                              )
                                      ],
                                    ),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
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
                        const SizedBox(
                          height: 8,
                        ),
                        const Text("* Harga kelipatan Rp.100"),
                        const Text(
                            "* ini adalah biaya yang akan dipungut oleh aplikasi"),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 160,
                            width: 420,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 4,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 18),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Insentif tiap Partisipan",
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
                                                      text: CurrencyFormat
                                                          .convertToIdr(
                                                              hargaPerPartisipan,
                                                              2),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .displayLarge!
                                                          .copyWith(
                                                            color: Colors.black,
                                                            fontSize: 40,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                  ]),
                                                )
                                        ],
                                      ),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton.filled(
                                            onPressed: () {
                                              setState(() {
                                                hargaPerPartisipan += 100;
                                              });
                                            },
                                            icon: Icon(Icons.add),
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
                          const SizedBox(
                            height: 8,
                          ),
                          const Text("* Harga kelipatan Rp.100"),
                          const Text(
                              "* Ini adalah insentif yang akan diterima oleh partisipan"),
                        ]),
                    const SizedBox(height: 24),
                    (hargapPerSurvei == -1)
                        ? LoadingLingkaran()
                        : ElevatedButton(
                            onPressed: () async {
                              if (hargaPerPartisipan != -1) {
                                // await RewardController().perbaruiHarga(context,
                                //     hargapPerSurvei, hargaPerPartisipan, );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent.shade700,
                            ),
                            child: Container(
                              height: 55,
                              width: 135,
                              child: Center(
                                child: Text(
                                  "Perbarui Harga",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(
                                        fontSize: 17,
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
