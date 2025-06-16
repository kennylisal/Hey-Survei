// import 'package:flutter/material.dart';

// class ProfilePage extends StatefulWidget {
//   ProfilePage({super.key, required this.constraints});
//   BoxConstraints constraints;
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   final controllerEmail = TextEditingController();
//   final controllerUsername = TextEditingController();
//   final controllerPassword = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Container(
//           width: double.infinity,
//           padding: EdgeInsets.symmetric(
//             horizontal: 30,
//             vertical: 15,
//           ),
//           decoration: BoxDecoration(
//             color: Colors.lightGreenAccent,
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(20),
//               bottomRight: Radius.circular(20),
//             ),
//           ),
//           child: Text(
//             "Halaman Profil",
//             style: Theme.of(context).textTheme.displaySmall!.copyWith(
//                 fontWeight: FontWeight.bold, fontSize: 36, color: Colors.black),
//           ),
//         ),
//         const SizedBox(height: 20),
//         Container(
//           width: 205,
//           height: 205,
//           decoration:
//               BoxDecoration(shape: BoxShape.circle, color: Colors.green),
//         ),
//         const SizedBox(height: 16),
//         FieldContainerProfile(
//           controller: controllerEmail,
//           hint: "",
//           judul: "Email Pengguna",
//           iconData: Icons.email,
//           enabled: false,
//         ),
//         SizedBox(height: 16),
//         FieldContainerProfile(
//           controller: controllerUsername,
//           hint: "",
//           judul: "Username Pengguna",
//           iconData: Icons.person,
//           enabled: true,
//         ),
//         SizedBox(height: 16),
//         PasswordContainerProfile(
//           controller: controllerPassword,
//           hint: "",
//           judul: "Sandi",
//         ),
//         SizedBox(height: 16),
//         Container(
//             width: 240,
//             height: 60,
//             margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             child: ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.amber.shade700,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: Text(
//                   "Buat Form",
//                   style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                         color: Colors.white,
//                         fontSize: 17,
//                         fontWeight: FontWeight.bold,
//                       ),
//                 ))),
//       ],
//     );
//   }
// }

// class PasswordContainerProfile extends StatelessWidget {
//   PasswordContainerProfile({
//     super.key,
//     required this.controller,
//     required this.hint,
//     required this.judul,
//   });
//   TextEditingController controller;
//   String hint;
//   String judul;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 190),
//           child: Text(
//             judul,
//             style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                   color: Colors.black,
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold,
//                 ),
//           ),
//         ),
//         Container(
//           margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 170),
//           padding: const EdgeInsets.symmetric(
//             vertical: 7,
//             horizontal: 14,
//           ),
//           decoration: BoxDecoration(
//               color: Colors.grey.shade200,
//               border: Border.all(
//                 width: 1,
//                 color: Colors.black,
//               ),
//               borderRadius: BorderRadius.circular(10)),
//           child: TextField(
//             obscureText: true,
//             enabled: true,
//             controller: controller,
//             style: Theme.of(context).textTheme.labelLarge!.copyWith(
//                   color: Colors.black,
//                   fontSize: 17,
//                 ),
//             decoration: InputDecoration(
//               border: InputBorder.none,
//               hintText: hint,
//               prefixIcon: Icon(Icons.lock),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class FieldContainerProfile extends StatelessWidget {
//   FieldContainerProfile({
//     super.key,
//     required this.controller,
//     required this.hint,
//     required this.judul,
//     required this.iconData,
//     required this.enabled,
//   });
//   TextEditingController controller;
//   String hint;
//   String judul;
//   IconData iconData;
//   bool enabled;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 190),
//           child: Text(
//             //"ID FAQ",
//             judul,
//             style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                   color: Colors.black,
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold,
//                 ),
//           ),
//         ),
//         Container(
//           margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 170),
//           padding: const EdgeInsets.symmetric(
//             vertical: 7,
//             horizontal: 14,
//           ),
//           decoration: BoxDecoration(
//               color: Colors.grey.shade100,
//               border: Border.all(
//                 width: 1,
//                 color: Colors.black,
//               ),
//               borderRadius: BorderRadius.circular(10)),
//           child: TextField(
//             enabled: enabled,
//             controller: controller,
//             style: Theme.of(context).textTheme.labelLarge!.copyWith(
//                   color: Colors.black,
//                   fontSize: 17,
//                 ),
//             decoration: InputDecoration(
//               border: InputBorder.none,
//               hintText: hint,
//               prefixIcon: Icon(iconData),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }
