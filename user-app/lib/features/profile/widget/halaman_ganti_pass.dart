import 'package:flutter/material.dart';

class ContainerUpdatePassword extends StatelessWidget {
  ContainerUpdatePassword({
    super.key,
    required this.passBaru,
    required this.passLama,
    required this.onPressed,
  });
  TextEditingController passLama;
  TextEditingController passBaru;
  Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 60),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border.all(width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          SizedBox(height: 20),
          ContainerTeksField(
            iconData: Icons.password,
            judul: "Password Lama",
            controller: passLama,
            hint: "Rahasia",
          ),
          ContainerTeksField(
            iconData: Icons.password,
            judul: "Password Baru",
            controller: passBaru,
            hint: "Rahasia",
          ),
          Container(
            child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding:
                        EdgeInsets.symmetric(vertical: 20, horizontal: 24)),
                child: Text(
                  "Ganti Password",
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                )),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class ContainerTeksField extends StatelessWidget {
  ContainerTeksField({
    super.key,
    required this.iconData,
    required this.judul,
    required this.controller,
    required this.hint,
  });
  final IconData iconData;
  final String judul;
  final TextEditingController controller;
  final String hint;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 34),
          child: Text(
            judul,
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(height: 5),
        TeksField(hint: hint, iconData: iconData, controller: controller)
      ],
    );
  }
}

class KotakTampilan extends StatelessWidget {
  const KotakTampilan({
    super.key,
    required this.text,
    required this.iconData,
    required this.warnaTeks,
  });
  final String text;
  final IconData iconData;
  final Color warnaTeks;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 32, right: 32, bottom: 20),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2, color: Colors.black),
          color: Colors.blueGrey.shade50),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Icon(iconData),
            const SizedBox(width: 20),
            Text(
              overflow: TextOverflow.ellipsis,
              text,
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontSize: 19,
                    color: warnaTeks,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class TeksField extends StatefulWidget {
  TeksField({
    super.key,
    required this.hint,
    required this.iconData,
    required this.controller,
  });
  final String hint;
  final IconData iconData;
  final TextEditingController controller;

  @override
  State<TeksField> createState() => _TeksFieldState();
}

class _TeksFieldState extends State<TeksField> {
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      margin: const EdgeInsets.only(left: 32, right: 32, bottom: 20),
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 9),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2, color: Colors.black),
          color: Colors.blueGrey.shade50),
      child: TextField(
        obscureText: isObscure,
        controller: widget.controller,
        style: Theme.of(context).textTheme.labelLarge!.copyWith(
              color: Colors.black,
              fontSize: 17,
            ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.hint,
          prefixIcon: Icon(widget.iconData),
          prefixIconColor: Colors.black,
          suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  isObscure = !isObscure;
                });
              },
              icon: Icon(Icons.remove_red_eye)),
        ),
      ),
      // Row(
      //   children: [
      //     Icon(iconData),
      //     const SizedBox(width: 20),
      //     TextField(
      //       controller: controller,
      //       style: Theme.of(context).textTheme.labelLarge!.copyWith(
      //             color: Colors.black,
      //             fontSize: 17,
      //           ),
      //       decoration:
      //           InputDecoration(border: InputBorder.none, hintText: hint),
      //     ),
      //   ],
      // ),
    );
  }
}
