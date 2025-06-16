import 'package:flutter/material.dart';

class _ClearButton extends StatelessWidget {
  const _ClearButton({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => controller.clear(),
      );
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.controller,
    required this.textPassword,
    required this.isConfirm,
  });
  final TextEditingController controller;
  final String textPassword;
  final bool isConfirm;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: isObscure,
      validator: (value) {
        if (value!.isEmpty) {
          return "Masukkan Password";
        } else if (value.length < 8) {
          return "Password minimal 8 karakter";
        }
        // else if (value != widget.textPassword && widget.isConfirm) {
        //   print(widget.textPassword);
        //   return "Confirm Password harus sesuai";
        // }
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                isObscure = !isObscure;
              });
            },
            icon: Icon(
              isObscure ? Icons.visibility_off : Icons.visibility,
            )),
        hintText: 'Password',
        border: const OutlineInputBorder(),
      ),
    );
  }
}
