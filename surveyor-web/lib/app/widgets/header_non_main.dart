import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hei_survei/app/app.dart';
import 'package:hei_survei/app/routing/route_constant.dart';
import 'package:hei_survei/app/widgets/item_navigasi_atas.dart';

// class HeaderNonMain extends ConsumerWidget {
//   const HeaderNonMain({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//      int jumlahKeranjang = 0;
//   bool adaOrder = false;
//     showAlertKembali(BuildContext context) {
//       Widget cancelButton = TextButton(
//         child: Text(
//           "Batal",
//           style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                 fontSize: 17,
//                 fontWeight: FontWeight.bold,
//               ),
//         ),
//         onPressed: () {
//           Navigator.pop(context, 'Cancel');
//         },
//       );
//       Widget continueButton = TextButton(
//         child: Text(
//           "Lanjut",
//           style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                 fontSize: 17,
//                 fontWeight: FontWeight.bold,
//               ),
//         ),
//         onPressed: () {
//           Navigator.pop(context);
//           context.goNamed(RouteConstant.home);
//         },
//       );

//       AlertDialog alert = AlertDialog(
//         title: Text(
//           "Peringatan",
//           style: Theme.of(context)
//               .textTheme
//               .titleLarge!
//               .copyWith(fontSize: 32, fontWeight: FontWeight.bold),
//         ),
//         content: Text(
//           "Yakin Kembali Ke halaman Utama ?",
//           style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20),
//         ),
//         actions: [cancelButton, continueButton],
//       );

//       showDialog(
//           context: context,
//           builder: (context) {
//             return alert;
//           });
//     }

//     gantiHalaman(int index) {
//       try {
//         ref.read(indexUtamaProvider.notifier).update((state) => index);

//         if (index == 8) {
//           ref.read(dataUtamaProvider.notifier).gantiWarnaBg(Colors.grey);
//         } else {
//           ref.read(dataUtamaProvider.notifier).gantiWarnaBg(Colors.white);
//         }
//         showAlertKembali(context);
//       } catch (e) {}
//     }

//     return Container(
//       color: Color.fromARGB(255, 27, 110, 179),
//       padding: const EdgeInsets.symmetric(horizontal: 50),
//       width: double.infinity,
//       height: 66,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Text(
//             "Hei Survei",
//             style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                   color: Colors.white,
//                   fontSize: 35,
//                   fontWeight: FontWeight.bold,
//                 ),
//           ),
//           const Spacer(),
//           ItemNavigasiAtas(
//               onTap: () {
//                 gantiHalaman(0);
//               },
//               text: "Surveiku"),
//           const SizedBox(width: 30),
//           ItemNavigasiAtasBadges(
//             onTap: () {
//               gantiHalaman(7);
//             },
//             text: "Keranjang",
//             kontenBadge: jumlahKeranjang.toString(),
//             badgeColor: Colors.green,
//             showBadge: true,
//             padding: 10,
//           ),
//           const SizedBox(width: 30),
//           ItemNavigasiAtasBadges(
//             onTap: () {
//               gantiHalaman(8);
//             },
//             text: "Pesanan",
//             kontenBadge: (adaOrder) ? "!" : "",
//             badgeColor: Colors.red,
//             showBadge: adaOrder,
//             padding: 16,
//           ),
//           const SizedBox(width: 32),
//           InkWell(
//             onTap: () {
//               gantiHalaman(9);
//             },
//             child: CircleAvatar(
//               backgroundColor: Colors.green,
//               radius: 24,
//               child: CachedNetworkImage(
//                 filterQuality: FilterQuality.medium,
//                 imageUrl: ref.read(authProvider).user.urlGambar,
//                 imageBuilder: (context, imageProvider) {
//                   return Container(
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image: imageProvider,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   );
//                 },
//                 progressIndicatorBuilder: (context, url, downloadProgress) =>
//                     CircularProgressIndicator(value: downloadProgress.progress),
//                 errorWidget: (context, url, error) {
//                   return const Icon(
//                     Icons.error,
//                     size: 48,
//                     color: Colors.red,
//                   );
//                 },
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

class HeaderNonMain extends ConsumerStatefulWidget {
  const HeaderNonMain({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HeaderNonMainBaruState();
}

class _HeaderNonMainBaruState extends ConsumerState<HeaderNonMain> {
  int jumlahKeranjang = 0;
  bool adaOrder = false;
  showAlertKembali(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text(
        "Batal",
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
      ),
      onPressed: () {
        Navigator.pop(context, 'Cancel');
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Lanjut",
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
      ),
      onPressed: () {
        Navigator.pop(context);
        context.goNamed(RouteConstant.home);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Peringatan",
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(fontSize: 32, fontWeight: FontWeight.bold),
      ),
      content: Text(
        "Yakin Kembali Ke halaman Utama ?",
        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20),
      ),
      actions: [cancelButton, continueButton],
    );

    showDialog(
        context: context,
        builder: (context) {
          return alert;
        });
  }

  gantiHalaman(int index) {
    try {
      ref.read(indexUtamaProvider.notifier).update((state) => index);

      if (index == 8) {
        ref.read(dataUtamaProvider.notifier).gantiWarnaBg(Colors.grey);
      } else {
        ref.read(dataUtamaProvider.notifier).gantiWarnaBg(Colors.white);
      }
      showAlertKembali(context);
    } catch (e) {}
  }

  @override
  void initState() {
    jumlahKeranjang = ref.read(jumlahKeranjangProvider);
    adaOrder = ref.read(adaOrderProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ref.listen<int>(jumlahKeranjangProvider, ((previous, next) {
    //   if (previous != next) {
    //     setState(() {
    //       jumlahKeranjang = next;
    //     });
    //   }
    // }));
    // ref.listen<bool>(adaOrderProvider, ((previous, next) {
    //   if (previous != next) {
    //     setState(() {
    //       adaOrder = next;
    //     });
    //   }
    // }));
    return Container(
      color: const Color.fromARGB(255, 27, 110, 179),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      width: double.infinity,
      height: 66,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              gantiHalaman(0);
            },
            child: Text(
              "Hey Survei",
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const Spacer(),
          ItemNavigasiAtas(
              onTap: () {
                gantiHalaman(0);
              },
              text: "Surveiku"),
          const SizedBox(width: 30),
          ItemNavigasiAtasBadges(
            onTap: () {
              gantiHalaman(7);
            },
            text: "Keranjang",
            kontenBadge:
                (jumlahKeranjang == -1) ? "" : jumlahKeranjang.toString(),
            badgeColor: Colors.green,
            showBadge: true,
            padding: 10,
          ),
          const SizedBox(width: 30),
          ItemNavigasiAtasBadges(
            onTap: () {
              gantiHalaman(8);
            },
            text: "Pesanan",
            kontenBadge: (adaOrder) ? "!" : "",
            badgeColor: Colors.red,
            showBadge: adaOrder,
            padding: 16,
          ),
          const SizedBox(width: 32),
          InkWell(
            onTap: () {
              gantiHalaman(9);
            },
            child: CircleAvatar(
              backgroundColor: Colors.green,
              radius: 24,
              child: CachedNetworkImage(
                filterQuality: FilterQuality.medium,
                imageUrl: ref.read(authProvider).user.urlGambar,
                imageBuilder: (context, imageProvider) {
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) {
                  return const Icon(
                    Icons.error,
                    size: 48,
                    color: Colors.red,
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
