import 'package:flutter/material.dart';

class SearchLaporan extends StatelessWidget {
  SearchLaporan({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onSubmitted,
    required this.onTapSearch,
  });
  TextEditingController controller;
  String hintText;
  Function()? onTapSearch;
  Function(String?)? onSubmitted;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: 375,
      padding: EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(width: 1.75, color: Colors.black),
        borderRadius: BorderRadius.circular(21),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontSize: 18,
                    color: Colors.black,
                  ),
              controller: controller,
              onSubmitted: (value) {},
              decoration: InputDecoration.collapsed(
                hintText: hintText,
                hintStyle: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontSize: 18,
                      color: Colors.black.withOpacity(0.5),
                    ),
              ),
            ),
          ),
          InkWell(
            onTap: onTapSearch,
            child: Container(
              height: 52,
              width: 62,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: Icon(
                Icons.search,
                color: Colors.white,
                size: 31.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
