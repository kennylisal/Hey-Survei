import 'package:aplikasi_admin/app/routing/route_constant.dart';
import 'package:aplikasi_admin/utils/hover_builder.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

PreferredSize getNavBar(BuildContext context) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(80.0),
    child: Container(
      height: 55,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Colors.blueAccent.shade400,
            Colors.blue.shade300,
          ],
        ),
      ),
      child: Row(
        children: [
          const JudulAdmin(),
          const Spacer(),
          NavItem(
            text: "Master FAQ",
            onTap: () {
              context.pushNamed(RouterConstant.masterFaq);
            },
            showDivider: true,
          ),
          NavItem(
            text: "Master Kategori",
            showDivider: true,
            onTap: () {
              context.pushNamed(RouterConstant.masterKategori);
            },
          ),
          NavItem(
            text: "Master Reward",
            showDivider: true,
            onTap: () {
              context.pushNamed(RouterConstant.masterReward);
            },
          ),
          NavItem(
            text: "Master Report",
            showDivider: false,
            onTap: () {
              //context.pushNamed(Routecon)
            },
          ),
        ],
      ),
    ),
  );
}

// PreferredSize navBarAtas = PreferredSize(
//   preferredSize: const Size.fromHeight(80.0),
//   child: Container(
//     height: 55,
//     decoration: BoxDecoration(
//       gradient: LinearGradient(
//         colors: <Color>[
//           Colors.blueAccent.shade400,
//           Colors.blue.shade300,
//         ],
//       ),
//     ),
//     child: Row(
//       children: [
//         const JudulAdmin(),
//         const Spacer(),
//         const VerticalDivider(
//           width: 2,
//           thickness: 2,
//           color: Colors.black,
//         ),
//         NavItem(
//           text: "Master FAQ",
//           onTap: () {},
//           showDivider: true,
//         ),
//         NavItem(
//           text: "Master Kategori",
//           showDivider: true,
//           onTap: () {},
//         ),
//         NavItem(
//           text: "Master Reward",
//           showDivider: true,
//           onTap: () {},
//         ),
//         NavItem(
//           text: "Master Report",
//           showDivider: false,
//           onTap: () {},
//         ),
//       ],
//     ),
//   ),
// );

class JudulAdmin extends StatelessWidget {
  const JudulAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(RouterConstant.home);
      },
      child: Container(
        padding: const EdgeInsets.only(left: 20.0),
        child: Text(
          "Admin Hei, Survei",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.grey.shade100,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  NavItem({
    Key? key,
    required this.text,
    required this.showDivider,
    required this.onTap,
  }) : super(key: key);
  final String text;
  Function() onTap;
  bool showDivider;
  @override
  Widget build(BuildContext context) {
    return HoverBuilder(
      builder: (isHovered) => InkWell(
        onTap: onTap,
        child: Container(
          height: 55,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Center(
            child: Text(
              text,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: (isHovered) ? Colors.white : Colors.black,
                    fontSize: 19,
                  ),
            ),
          ),
        ),
      ),
    );
    // Row(
    //   children: [
    //     HoverBuilder(
    //       builder: (isHovered) => InkWell(
    //         onTap: onTap,
    //         child: Container(
    //           height: 55,
    //           padding: const EdgeInsets.symmetric(horizontal: 10),
    //           child: Center(
    //             child: Text(
    //               text,
    //               style: Theme.of(context).textTheme.labelLarge!.copyWith(
    //                     color: (isHovered) ? Colors.white : Colors.black,
    //                     fontSize: 19,
    //                   ),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //     // (showDivider)
    //     //     ? const VerticalDivider(
    //     //         width: 2,
    //     //         thickness: 2,
    //     //         color: Colors.black,
    //     //       )
    //     //     : const SizedBox(),
    //   ],
    // );
  }
}
