import 'package:flutter/material.dart';

class ContainerTextAdmin extends StatelessWidget {
  const ContainerTextAdmin({
    super.key,
    required this.child,
  });
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
