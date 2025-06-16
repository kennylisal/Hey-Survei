import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 90,
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 28),
        decoration: BoxDecoration(
          color: Colors.blueAccent.shade700,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(36),
            bottomRight: Radius.circular(36),
          ),
        ),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat Datang di',
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                ),
                Text(
                  'Hey Survei',
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/logo-app.png',
                height: 50,
              ),
            ),
          ],
        ));
  }
}
    // Container(
    //   height: 190,
    //   child: Stack(
    //     children: [
    //       Container(
    //           height: 165,
    //           padding: const EdgeInsets.only(
    //             left: 20,
    //             right: 24,
    //             bottom: 18,
    //           ),
    //           decoration: BoxDecoration(
    //             color: kPrimaryColor,
    //             borderRadius: BorderRadius.only(
    //               bottomLeft: Radius.circular(36),
    //               bottomRight: Radius.circular(36),
    //             ),
    //           ),
    //           child: Row(
    //             children: [
    //               Text(
    //                 'Selamat Datang',
    //                 style: Theme.of(context).textTheme.displayMedium!.copyWith(
    //                       fontSize: 20,
    //                       color: Colors.white,
    //                       fontWeight: FontWeight.bold,
    //                     ),
    //               ),
    //               Spacer(),
    //               Container(
    //                 height: 50,
    //                 width: 50,
    //                 color: Colors.white,
    //               ),
    //             ],
    //           )),
    //     ],
    //   ),
    // );

// Container(
//       margin: const EdgeInsets.only(bottom: 20),
      
//       height: 190,
//       child: Stack(
//         children: [
//           Container(
//               height: 165,
//               padding: const EdgeInsets.only(
//                 left: 20,
//                 right: 24,
//                 bottom: 18,
//               ),
//               decoration: BoxDecoration(
//                 color: kPrimaryColor,
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(36),
//                   bottomRight: Radius.circular(36),
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   Text(
//                     'Selamat Datang',
//                     style: Theme.of(context).textTheme.displayMedium!.copyWith(
//                           fontSize: 20,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                   ),
//                   Spacer(),
//                   Container(
//                     height: 50,
//                     width: 50,
//                     color: Colors.white,
//                   ),
//                 ],
//               )),
//           // Positioned(
//           //   bottom: 0,
//           //   left: 0,
//           //   right: 0,
//           //   child: Container(
//           //     alignment: Alignment.center,
//           //     margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
//           //     padding: EdgeInsets.only(left: 20),
//           //     height: 54,
//           //     decoration: BoxDecoration(
//           //       color: Colors.white,
//           //       borderRadius: BorderRadius.circular(20),
//           //       boxShadow: [
//           //         BoxShadow(
//           //           offset: Offset(0, 10),
//           //           blurRadius: 50,
//           //           color: kPrimaryColor.withOpacity(0.4),
//           //         ),
//           //       ],
//           //     ),
//           //     child: Row(
//           //       children: [
//           //         Expanded(
//           //           child: TextField(
//           //             decoration: InputDecoration.collapsed(
//           //               hintText: "Cari Survei",
//           //               hintStyle:
//           //                   Theme.of(context).textTheme.displayMedium!.copyWith(
//           //                         fontSize: 18,
//           //                         color: Colors.blue.withOpacity(0.35),
//           //                       ),
//           //             ),
//           //           ),
//           //         ),
//           //         InkWell(
//           //           onTap: () {},
//           //           child: Container(
//           //             height: 54,
//           //             width: 60,
//           //             decoration: BoxDecoration(
//           //                 color: Colors.blue,
//           //                 borderRadius: BorderRadius.only(
//           //                     topRight: Radius.circular(20),
//           //                     bottomRight: Radius.circular(20))),
//           //             child: Icon(
//           //               Icons.search,
//           //               color: Colors.white,
//           //               size: 36,
//           //             ),
//           //           ),
//           //         ),
//           //       ],
//           //     ),
//           //   ),
//           // )
//         ],
//       ),
//     );