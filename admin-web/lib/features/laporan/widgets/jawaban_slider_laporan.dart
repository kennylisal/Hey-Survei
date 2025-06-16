import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class JawabanSliderLaporan extends StatelessWidget {
  JawabanSliderLaporan({
    super.key,
    required this.nilaiJawaban,
    required this.teksMax,
    required this.teksMin,
    required this.maximal,
    required this.minimal,
  });
  int nilaiJawaban;
  String teksMin;
  String teksMax;
  int minimal;
  int maximal;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 12),
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
      width: double.infinity,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RichText(
              text: TextSpan(
                  text: 'Nilai : ',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 20,
                        color: Colors.black,
                        wordSpacing: 1.25,
                      ),
                  children: [
                TextSpan(
                  text: nilaiJawaban.toString(),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 23,
                        color: Colors.black,
                        wordSpacing: 1.25,
                        fontWeight: FontWeight.bold,
                      ),
                )
              ])),
          Spacer(),
          Row(
            children: [
              Text(
                "Minimal",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 13,
                      color: Colors.black,
                      wordSpacing: 1.25,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: 125,
                width: 270,
                child: SfSlider(
                  min: minimal,
                  max: maximal,
                  value: nilaiJawaban,
                  interval: 1,
                  // showTicks: true,
                  showLabels: true,
                  enableTooltip: true,
                  minorTicksPerInterval: 1,
                  onChanged: (dynamic value) {},
                ),
              ),
              Text(
                "Minimal",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 13,
                      color: Colors.black,
                      wordSpacing: 1.25,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }
}
