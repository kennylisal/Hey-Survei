import 'package:flutter/material.dart';

class JudulFormKartuTeks extends StatefulWidget {
  JudulFormKartuTeks({
    super.key,
    required this.judul,
    required this.petunjuk,
  });
  String judul;
  String petunjuk;
  @override
  State<JudulFormKartuTeks> createState() => _JudulFormKartuTeksState();
}

class _JudulFormKartuTeksState extends State<JudulFormKartuTeks> {
  bool isDetail = true;
  Widget generateBawah() {
    return Column(
      children: [
        const SizedBox(height: 10.5),
        Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Petunjuk ",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 4),
              Text(
                widget.petunjuk,
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(fontSize: 16, overflow: TextOverflow.ellipsis),
                maxLines: 6,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() {
        isDetail = !isDetail;
        print(isDetail);
      }),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 13.5, horizontal: 42),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Text(
                widget.judul,
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 27,
                      overflow: TextOverflow.ellipsis,
                    ),
                textAlign: TextAlign.center,
                maxLines: 3,
              ),
            ),
            if (isDetail) generateBawah(),
          ],
        ),
      ),
    );
  }
}

class JudulFormKartuTeksFalse extends StatefulWidget {
  JudulFormKartuTeksFalse({
    super.key,
    required this.judul,
    required this.petunjuk,
  });
  String judul;
  String petunjuk;

  @override
  State<JudulFormKartuTeksFalse> createState() =>
      _JudulFormKartuTeksFalseState();
}

class _JudulFormKartuTeksFalseState extends State<JudulFormKartuTeksFalse> {
  bool isDetail = false;
  Widget generateBawah() {
    return Column(
      children: [
        const SizedBox(height: 10.5),
        Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Petunjuk ",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 4),
              Text(
                widget.petunjuk,
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(fontSize: 16, overflow: TextOverflow.ellipsis),
                maxLines: 6,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() {
        isDetail = !isDetail;
        print('asfsdf');
      }),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 13.5, horizontal: 42),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Text(
                widget.judul,
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 27,
                      overflow: TextOverflow.ellipsis,
                    ),
                textAlign: TextAlign.center,
                maxLines: 3,
              ),
            ),
            if (isDetail) generateBawah(),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class JudulFormKartuTeks extends StatefulWidget {
//   JudulFormKartuTeks({
//     super.key,
//     required this.judul,
//     required this.petunjuk,
//   });
//   String judul;
//   String petunjuk;
//   @override
//   State<JudulFormKartuTeks> createState() => _JudulFormKartuTeksState();
// }

// class _JudulFormKartuTeksState extends State<JudulFormKartuTeks> {
//   bool isDetail = true;
//   Widget generateBawah() {
//     if (isDetail) {
//       return Column(
//         children: [
//           const SizedBox(height: 10.5),
//           Align(
//             alignment: Alignment.centerLeft,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Petunjuk ",
//                   style: Theme.of(context)
//                       .textTheme
//                       .headlineMedium!
//                       .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   widget.petunjuk,
//                   style: Theme.of(context)
//                       .textTheme
//                       .displayMedium!
//                       .copyWith(fontSize: 16, overflow: TextOverflow.ellipsis),
//                   maxLines: 3,
//                   textAlign: TextAlign.start,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 5),
//           Align(
//             alignment: Alignment.centerRight,
//             child: CircleAvatar(
//               radius: 15,
//               backgroundColor: Colors.white,
//               child: IconButton(
//                 icon: Icon(
//                   Icons.arrow_upward,
//                   color: Colors.black,
//                   size: 15,
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     isDetail = !isDetail;
//                   });
//                 },
//               ),
//             ),
//           ),
//         ],
//       );
//     } else {
//       return Column(
//         children: [
//           Align(
//             alignment: Alignment.centerRight,
//             child: CircleAvatar(
//               radius: 15,
//               backgroundColor: Colors.white,
//               child: IconButton(
//                 icon: Icon(
//                   Icons.arrow_downward,
//                   color: Colors.black,
//                   size: 15,
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     isDetail = !isDetail;
//                   });
//                 },
//               ),
//             ),
//           ),
//         ],
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.symmetric(vertical: 13.5, horizontal: 42),
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Center(
//             child: Text(
//               widget.judul,
//               style: Theme.of(context).textTheme.displayMedium!.copyWith(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 27,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//               textAlign: TextAlign.center,
//               maxLines: 2,
//             ),
//           ),
//           generateBawah(),
//         ],
//       ),
//     );
//   }
// }

// class JudulFormKartuTeksFalse extends StatefulWidget {
//   JudulFormKartuTeksFalse({
//     super.key,
//     required this.judul,
//     required this.petunjuk,
//   });
//   String judul;
//   String petunjuk;

//   @override
//   State<JudulFormKartuTeksFalse> createState() =>
//       _JudulFormKartuTeksFalseState();
// }

// class _JudulFormKartuTeksFalseState extends State<JudulFormKartuTeksFalse> {
//   bool isDetail = true;
//   Widget generateBawah() {
//     if (isDetail) {
//       return Column(
//         children: [
//           const SizedBox(height: 10.5),
//           Align(
//             alignment: Alignment.centerLeft,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Petunjuk ",
//                   style: Theme.of(context)
//                       .textTheme
//                       .headlineMedium!
//                       .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   widget.petunjuk,
//                   style: Theme.of(context)
//                       .textTheme
//                       .displayMedium!
//                       .copyWith(fontSize: 16, overflow: TextOverflow.ellipsis),
//                   maxLines: 3,
//                   textAlign: TextAlign.start,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 5),
//           Align(
//             alignment: Alignment.centerRight,
//             child: CircleAvatar(
//               radius: 15,
//               backgroundColor: Colors.white,
//               child: IconButton(
//                 icon: Icon(
//                   Icons.arrow_upward,
//                   color: Colors.black,
//                   size: 15,
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     isDetail = !isDetail;
//                   });
//                 },
//               ),
//             ),
//           ),
//         ],
//       );
//     } else {
//       return Column(
//         children: [
//           const SizedBox(height: 2.5),
//           Align(
//             alignment: Alignment.centerRight,
//             child: CircleAvatar(
//               radius: 15,
//               backgroundColor: Colors.white,
//               child: IconButton(
//                 icon: Icon(
//                   Icons.arrow_downward,
//                   color: Colors.black,
//                   size: 15,
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     isDetail = !isDetail;
//                   });
//                 },
//               ),
//             ),
//           ),
//         ],
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.symmetric(vertical: 13.5, horizontal: 42),
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Center(
//             child: Text(
//               widget.judul,
//               style: Theme.of(context).textTheme.displayMedium!.copyWith(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 27,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//               textAlign: TextAlign.center,
//               maxLines: 2,
//             ),
//           ),
//           generateBawah(),
//         ],
//       ),
//     );
//   }
// }
