import 'package:flutter/material.dart';

class FieldContainer extends StatelessWidget {
  FieldContainer({
    super.key,
    required this.controller,
    required this.textJudul,
    required this.minLines,
    required this.hintText,
    required this.enabled,
  });
  TextEditingController controller;
  String textJudul;
  int minLines;
  String hintText;
  bool enabled;
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
            textJudul,
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 24,
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 1,
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(24)),
          child: TextField(
            enabled: enabled,
            controller: controller,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 17,
                ),
            //kunci untuk textfield besar adalah maxline - nya
            decoration: InputDecoration.collapsed(
              hintText: hintText,
            ),
            minLines: minLines,
            maxLines: null,
          ),
        )
      ],
    );
  }
}
