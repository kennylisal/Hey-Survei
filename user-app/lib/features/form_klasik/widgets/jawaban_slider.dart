import 'package:flutter/material.dart';
import 'package:survei_aplikasi/features/form_klasik/models/data_pertanyaan.dart';
import 'package:survei_aplikasi/features/form_klasik/state/controller_pertanyaan.dart';

class JawabanSliderZ extends StatefulWidget {
  JawabanSliderZ({
    super.key,
    required this.controller,
    required this.dataSlider,
  });
  DataSlider dataSlider;
  PertanyaanController controller;
  @override
  State<JawabanSliderZ> createState() => _JawabanSliderZState();
}

class _JawabanSliderZState extends State<JawabanSliderZ> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Slider(
            value: widget.dataSlider.nilai,
            min: widget.dataSlider.min + 0.0,
            max: widget.dataSlider.max + 0.0,
            label: "${widget.dataSlider.nilai}",
            divisions:
                widget.dataSlider.max + ((widget.dataSlider.min == 0) ? 0 : -1),
            onChanged: (value) {
              setState(() {
                widget.controller.gantiNilaiSlider(value);
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.dataSlider.labelMin,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                widget.dataSlider.labelMax,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }
}
