import 'package:flutter/material.dart';

class FieldContainerText extends StatelessWidget {
  FieldContainerText({
    super.key,
    required this.controller,
    required this.textJudul,
    required this.hintText,
    required this.isObscure,
  });
  TextEditingController controller;
  String textJudul;

  String hintText;
  bool isObscure;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
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
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 24,
          ),
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 250, 250, 250),
              border: Border.all(
                width: 2,
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(10)),
          child: TextFormField(
            obscureText: isObscure,
            controller: controller,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 17,
                ),
            //kunci untuk textfield besar adalah maxline - nya
            decoration: InputDecoration.collapsed(
              hintText: hintText,
            ),
          ),
        )
      ],
    );
  }
}

class FieldText extends StatelessWidget {
  FieldText({
    super.key,
    required this.textJudul,
    required this.text,
  });
  String textJudul;
  String text;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
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
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 24,
          ),
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 250, 250, 250),
              border: Border.all(
                width: 2,
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(10)),
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 17,
                ),
            //kunci untuk textfield besar adalah maxline - nya
          ),
        )
      ],
    );
  }
}
