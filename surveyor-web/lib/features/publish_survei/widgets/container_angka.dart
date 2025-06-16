import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContainerAngkaPublish extends StatelessWidget {
  ContainerAngkaPublish({
    super.key,
    required this.textJudul,
    required this.iconData,
    required this.controller,
    this.enabled = true,
    required this.validator,
  });
  String textJudul;
  IconData iconData;
  TextEditingController controller;
  bool enabled;
  String? Function(String?) validator;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            //"Perkiraan Waktu (m)",
            textJudul,
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Container(
          width: 265,
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 250, 250, 250),
              border: Border.all(
                width: 1,
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(10)),
          child: TextFormField(
            validator: validator,
            enabled: enabled,
            controller: controller,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 19.5,
                ),
            decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(
                  iconData,
                  // Icons.timer_rounded,
                  size: 30,
                )),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
        )
      ],
    );
  }
}
