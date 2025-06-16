import 'package:flutter/material.dart';

class FilterLaporan extends StatelessWidget {
  FilterLaporan({
    super.key,
    required this.onChanged,
    required this.pilihanFilter,
  });
  int pilihanFilter;
  Function(int?) onChanged;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: Colors.grey.shade100,
      margin: const EdgeInsets.only(left: 17.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Urutkan : "),
          InputDecorator(
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
                contentPadding: EdgeInsets.all(10)),
            child: DropdownButtonHideUnderline(
                child: DropdownButton(
              value: pilihanFilter,
              isDense: true,
              isExpanded: true,
              items: const [
                DropdownMenuItem(
                  value: 1,
                  child: Text("Biaya Tertinggi"),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text("Biaya Terendah"),
                ),
                DropdownMenuItem(
                  value: 3,
                  child: Text("Terbaru"),
                ),
                DropdownMenuItem(
                  value: 4,
                  child: Text("Terlama"),
                ),
              ],
              onChanged: onChanged,
            )),
          ),
        ],
      ),
    );
  }
}
