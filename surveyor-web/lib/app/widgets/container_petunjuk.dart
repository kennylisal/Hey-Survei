import 'package:flutter/material.dart';

class ContainerPetunjukAtas extends StatelessWidget {
  ContainerPetunjukAtas({
    super.key,
    required this.text,
  });
  String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.only(bottom: 28),
      decoration: BoxDecoration(
        color: Colors.amber.shade100.withOpacity(0.6),
        border: Border(
          bottom: BorderSide(
            width: 2,
            color: Colors.grey.shade400,
          ),
        ),
      ),
      child: Center(
        child: Text(
          text,
          // "Petunjuk : Pilih salah satu draft untuk melanjutkan pembuatan form",
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(fontSize: 20, color: Colors.deepPurple),
        ),
      ),
    );
  }
}
