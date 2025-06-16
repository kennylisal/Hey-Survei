import 'package:aplikasi_admin/app/routing/route_constant.dart';
import 'package:aplikasi_admin/features/formV2/state/form_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PreviewSidebarKlasik extends ConsumerStatefulWidget {
  PreviewSidebarKlasik({
    super.key,
    required this.formController,
  });
  FormController formController;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PreviewSidebarKlasikState();
}

class _PreviewSidebarKlasikState extends ConsumerState<PreviewSidebarKlasik> {
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
        "Kembali",
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
      ),
      onPressed: () {
        Navigator.pop(context);
        context.goNamed(RouterConstant.home);
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
        "Pastikan anda sudah menyimpan data form",
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                    child: Center(
                      child: InkWell(
                        onTap: () => showAlertKembali(context),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blue.shade700,
                              child: Icon(
                                Icons.chevron_left,
                                color: Colors.white,
                                size: 35,
                              ),
                            ),
                            const SizedBox(width: 16),
                            (constraints.maxWidth > 225)
                                ? Text(
                                    "Kembali",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(fontSize: 18),
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Kontrol Form",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Center(
                    child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        width: 250,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              widget.formController.gantiListDitampilkan();
                            });
                          },
                          icon: const Icon(
                            Icons.save,
                            color: Colors.white,
                            size: 27,
                          ),
                          label: Text(
                            "Ganti View",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontSize: 20),
                            overflow: TextOverflow.ellipsis,
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigoAccent),
                        )),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
