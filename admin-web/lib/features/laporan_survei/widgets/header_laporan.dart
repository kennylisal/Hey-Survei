import 'package:flutter/material.dart';

class HeaderLaporan extends StatelessWidget {
  HeaderLaporan({
    super.key,
    required this.constraints,
    required this.controller,
    required this.hintText,
    required this.onSubmitted,
    required this.onTap,
    required this.textJudul,
    required this.onTapReset,
  });
  BoxConstraints constraints;
  TextEditingController controller;
  String textJudul;
  String hintText;
  Function(String) onSubmitted;
  Function() onTap;
  Function() onTapReset;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.indigo.shade600,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 36),
      child: Row(
        children: [
          if (constraints.maxWidth > 1315)
            Text(
              textJudul,
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: Colors.white,
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          Spacer(flex: 1),
          // Container(
          //   height: 65,
          //   width: 575,
          //   padding: EdgeInsets.only(left: 16),
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     border: Border.all(width: 1),
          //     borderRadius: BorderRadius.circular(21),
          //   ),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: TextField(
          //           style: Theme.of(context).textTheme.displayMedium!.copyWith(
          //                 fontSize: 19,
          //                 color: Colors.black,
          //               ),
          //           controller: controller,
          //           onSubmitted: onSubmitted,
          //           decoration: InputDecoration.collapsed(
          //             hintText: hintText,
          //             hintStyle:
          //                 Theme.of(context).textTheme.displayMedium!.copyWith(
          //                       fontSize: 20,
          //                       color: Colors.black.withOpacity(0.5),
          //                     ),
          //           ),
          //         ),
          //       ),
          //       InkWell(
          //         onTap: onTap,
          //         child: Container(
          //           height: 63,
          //           width: 62,
          //           decoration: BoxDecoration(
          //               color: Colors.blue,
          //               borderRadius: BorderRadius.only(
          //                   topRight: Radius.circular(20),
          //                   bottomRight: Radius.circular(20))),
          //           child: Icon(
          //             Icons.search,
          //             color: Colors.white,
          //             size: 36,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Spacer(flex: 2),
          InkWell(
            onTap: onTapReset,
            child: CircleAvatar(
              radius: 32,
              backgroundColor: Colors.grey.shade100,
              child: Icon(
                Icons.restart_alt,
                size: 40,
                color: Colors.blueAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
