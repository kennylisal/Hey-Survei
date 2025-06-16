import 'package:flutter/material.dart';

class FieldContainer extends StatelessWidget {
  FieldContainer({
    super.key,
    required this.controller,
    required this.hint,
    required this.judul,
    required this.validator,
    required this.iconData,
  });
  TextEditingController controller;
  String hint;
  String judul;
  String? Function(String?) validator;
  IconData iconData;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Text(
            //"ID FAQ",
            judul,
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(
            vertical: 7,
            horizontal: 14,
          ),
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(
                width: 1,
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(10)),
          child: TextFormField(
            enabled: true,
            controller: controller,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 17,
                ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              prefixIcon: Icon(iconData),
            ),
            validator: validator,
          ),
        )
      ],
    );
  }
}
