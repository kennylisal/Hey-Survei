import 'package:flutter/material.dart';

class RoundedPaaswordField extends StatelessWidget {
  const RoundedPaaswordField({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Password",
        prefixIcon: Icon(
          Icons.lock,
          color: Colors.blueAccent,
        ),
        suffixIcon: Icon(
          Icons.visibility,
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}
