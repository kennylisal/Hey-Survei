import 'package:flutter/material.dart';

class TombolAtasPublish extends StatelessWidget {
  TombolAtasPublish({
    super.key,
    required this.onTapDemografi,
    required this.onTapDetail,
  });
  Function() onTapDetail;
  Function() onTapDemografi;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 90),
        ElevatedButton(
            onPressed: onTapDetail,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 17.5, horizontal: 25),
              backgroundColor: Colors.blueAccent.shade400,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              "Form Detail",
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
            )),
        const SizedBox(width: 30),
        ElevatedButton(
            onPressed: onTapDemografi,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 17.5, horizontal: 25),
              backgroundColor: Colors.indigo,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              "Form Demografi",
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
            )),
      ],
    );
  }
}

// Row(
//                       children: [
//                         const SizedBox(width: 90),
//                         ElevatedButton(
//                             onPressed: () {
//                               setState(() {
//                                 isModeDetail = true;
//                               });
//                             },
//                             style: ElevatedButton.styleFrom(
//                               padding: EdgeInsets.symmetric(
//                                   vertical: 20, horizontal: 30),
//                               backgroundColor: Colors.blueAccent.shade400,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                             ),
//                             child: Text(
//                               "Form Detail",
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .displayLarge!
//                                   .copyWith(
//                                     color: Colors.white,
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                             )),
//                         const SizedBox(width: 30),
//                         ElevatedButton(
//                             onPressed: () {
//                               setState(() {
//                                 isModeDetail = false;
//                               });
//                             },
//                             style: ElevatedButton.styleFrom(
//                               padding: EdgeInsets.symmetric(
//                                   vertical: 20, horizontal: 30),
//                               backgroundColor: Colors.indigo,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                             ),
//                             child: Text(
//                               "Form Demografi",
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .displayLarge!
//                                   .copyWith(
//                                     color: Colors.white,
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                             )),
//                       ],
//                     ),