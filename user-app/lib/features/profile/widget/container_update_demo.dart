import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContainerUpdateDemografi extends StatelessWidget {
  ContainerUpdateDemografi({
    super.key,
    required this.kotaPilihan,
    required this.listInterest,
    required this.listKota,
    required this.onChangedInterest,
    required this.onChangedKota,
    required this.onPressedGantiTanggal,
    required this.pilihanInterest,
    required this.tglLahir,
    required this.onSubmit,
  });
  List<String> listKota = [];
  List<String> listInterest = [];
  List<String> pilihanInterest;
  DateTime? tglLahir;
  String kotaPilihan;
  Function(List<String?>)? onChangedInterest;
  Function(String?)? onChangedKota;
  Function()? onPressedGantiTanggal;
  Function()? onSubmit;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      margin: const EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border.all(width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            "Data Demografi",
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (tglLahir != null)
            Text(
              //"${dataTanggal.date!.day} : ${dataTanggal.date!.month} : ${dataTanggal.date!.year} ",
              DateFormat("dd / MMMM / yyyy").format(tglLahir!),
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          const SizedBox(height: 9),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: onPressedGantiTanggal,
              child: Text("Pilih Tanggal Lahir",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white))),
          const SizedBox(height: 16),
          Text(
            "Kota Tempat Tinggal",
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 45, vertical: 5),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(26)),
            child: DropdownSearch(
              items: listKota,
              popupProps: PopupPropsMultiSelection.menu(
                showSearchBox: true,
                showSelectedItems: true,
                disabledItemFn: (String s) => s.startsWith('Ix'),
              ),
              dropdownButtonProps: DropdownButtonProps(
                color: Colors.blue,
                icon: Icon(Icons.arrow_circle_down_rounded),
                iconSize: 40,
              ),
              dropdownDecoratorProps: DropDownDecoratorProps(
                textAlignVertical: TextAlignVertical.center,
                dropdownSearchDecoration: InputDecoration(
                    border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                )),
              ),
              onChanged: onChangedKota,
              selectedItem: kotaPilihan,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Pilih Ketertarikan",
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 45, vertical: 5),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(26)),
            child: DropdownSearch.multiSelection(
              items: listInterest,
              popupProps: PopupPropsMultiSelection.menu(
                showSearchBox: true,
                showSelectedItems: true,
                disabledItemFn: (String s) => s.startsWith('Ix'),
              ),
              dropdownButtonProps: DropdownButtonProps(
                color: Colors.blue,
                icon: Icon(Icons.arrow_circle_down_rounded),
                iconSize: 40,
              ),
              dropdownDecoratorProps: DropDownDecoratorProps(
                textAlignVertical: TextAlignVertical.center,
                dropdownSearchDecoration: InputDecoration(
                    border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                )),
              ),
              onChanged: onChangedInterest,
              selectedItems: pilihanInterest,
            ),
          ),
          SizedBox(height: 12),
          ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreenAccent.shade400,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24)),
              child: Text(
                "perbarui Data",
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              )),
        ],
      ),
    );
  }
}
