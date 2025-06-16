import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hei_survei/app/routing/route_constant.dart';
import 'package:hei_survei/features/draft/draft_controller.dart';
import 'package:hei_survei/features/draft/widgets/kotak_form_draft.dart';
import 'package:hei_survei/features/publish_survei/model/data_form.dart';
import 'package:hei_survei/utils/kriptografi.dart';
import 'package:hei_survei/utils/loading_biasa.dart';

class DraftForm extends ConsumerStatefulWidget {
  DraftForm({
    super.key,
    required this.constraints,
  });
  BoxConstraints constraints;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DraftFormState();
}

class _DraftFormState extends ConsumerState<DraftForm> {
  List<Widget> widgetTampilan = [];
  List<DataForm>? listForm;

  showAlertKembali(bool isKlasik, String idForm) {
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
          "Hapus",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
        ),
        onPressed: () async {
          await hapusDraft(isKlasik, idForm);
          Navigator.pop(context, 'Hapus');
        });

    AlertDialog alert = AlertDialog(
      title: Text(
        "Peringatan",
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(fontSize: 32, fontWeight: FontWeight.bold),
      ),
      content: Text(
        "Yakin Mau Menghapus Form?",
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

  hapusDraft(bool isKlasik, String idForm) async {
    final hasil =
        await DraftController().hapusDraft(isKlasik: isKlasik, idForm: idForm);
    if (!context.mounted) return;
    if (hasil) {
      listForm!.removeWhere((element) => element.id == idForm);
      widgetTampilan = List.generate(
        listForm!.length,
        (index) => KotakFormDraft(
          dataForm: listForm![index],
          onTap: () {
            if (listForm![index].isKlasik) {
              context.goNamed(RouteConstant.formKlasik, pathParameters: {
                // 'idForm': listForm![index].id,
                'idForm': Kriptografi.encrypt(listForm![index].id),
              });
            } else {
              context.pushNamed(RouteConstant.formKartu, pathParameters: {
                // 'idForm': listForm![index].id,
                'idForm': Kriptografi.encrypt(listForm![index].id),
              });
            }
          },
          onTapHapus: () async =>
              hapusDraft(listForm![index].isKlasik, listForm![index].id),
        ),
      );
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: SnackBar(content: Text("Gagal hapus Draft"))));
    }
  }

  @override
  initState() {
    super.initState();
    Future(() async {
      listForm = await DraftController().ambilForm();

      widgetTampilan = List.generate(
        listForm!.length,
        (index) => KotakFormDraft(
          dataForm: listForm![index],
          onTap: () {
            if (listForm![index].isKlasik) {
              context.goNamed(RouteConstant.formKlasik, pathParameters: {
                // 'idForm': listForm![index].id,
                'idForm': Kriptografi.encrypt(listForm![index].id),
              });
            } else {
              context.pushNamed(RouteConstant.formKartu, pathParameters: {
                // 'idForm': listForm![index].id,
                'idForm': Kriptografi.encrypt(listForm![index].id),
              });
            }
          },
          onTapHapus: () async =>
              showAlertKembali(listForm![index].isKlasik, listForm![index].id),
        ),
      );
      setState(() {});
    });
  }

  contentGenerator() {
    if (listForm == null) {
      return LoadingBiasa(
        text: "Memuat form",
        pakaiKembali: false,
      );
    } else if (listForm!.isEmpty) {
      return const TidakAdaDraft();
    } else {
      return Column(
          children: rowGenerator(
              context,
              (widget.constraints.maxWidth > 1800)
                  ? 4
                  : (widget.constraints.maxWidth > 1500)
                      ? 3
                      : (widget.constraints.maxWidth > 890)
                          ? 2
                          : 1));
    }
  }

  List<Widget> rowGenerator(BuildContext context, int pembagi) {
    int indexInduk = -1;

    List<Widget> listWidget = widgetTampilan;
    List<Widget> hasil =
        List.generate(listWidget.length ~/ pembagi + 1, (index) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(pembagi, (index) {
            if (indexInduk < listWidget.length - 1) {
              indexInduk++;
              return listWidget[indexInduk];
            } else
              return SizedBox(
                width: 275,
              );
          }));
    });

    return hasil;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            "Draft Form",
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontWeight: FontWeight.bold, fontSize: 48, color: Colors.black),
          ),
          const SizedBox(height: 12),
          Text(
            "Lanjutkan pembutan form untuk survei",
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(fontSize: 24, color: Colors.black),
          ),
          const SizedBox(height: 6),
          Text(
            "yang akan anda publikasikan",
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(fontSize: 24, color: Colors.black),
          ),
          const SizedBox(height: 32),
          contentGenerator(),
        ],
      ),
    );
  }
}

class TidakAdaDraft extends StatelessWidget {
  const TidakAdaDraft({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 32),
        Center(
          child: Image.asset(
            'assets/no-draft.png',
            height: 360,
          ),
        ),
        Text(
          "Anda Belum Menciptakan Form",
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(fontSize: 33, color: Colors.black),
        ),
        Text(
          "Form yang anda buat akan tampil disisini",
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(fontSize: 18, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
