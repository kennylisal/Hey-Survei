import 'package:flutter/material.dart';

class SearchFieldEmail extends StatelessWidget {
  SearchFieldEmail({
    super.key,
    required this.onSubmitted,
  });
  Function(String)? onSubmitted;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(14)),
      child: TextField(
        onSubmitted: onSubmitted,
        decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Email Responded",
            suffixIcon: Icon(Icons.search)),
      ),
    );
  }
}
