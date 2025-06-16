import 'package:aplikasi_admin/app/routing/route_constant.dart';
import 'package:aplikasi_admin/features/draft/draft_controller.dart';
import 'package:aplikasi_admin/features/draft/widgets/kotak_form_draft.dart';
import 'package:aplikasi_admin/features/formV2/widget/loading_form.dart';
import 'package:aplikasi_admin/features/survei/models/data_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DraftForm extends ConsumerStatefulWidget {
  DraftForm({
    super.key,
    required this.constraints,
  });
  BoxConstraints constraints;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DraftFormState();
}

class _DraftFormState extends ConsumerState<DraftForm>
    with AutomaticKeepAliveClientMixin<DraftForm> {
  List<Widget> widgetTampilan = [];
  List<DataForm>? listForm;

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
                    context.goNamed(RouterConstant.formKlasik, pathParameters: {
                      'idForm': listForm![index].id,
                    });
                  } else {
                    context.goNamed(RouterConstant.formKartu, pathParameters: {
                      'idForm': listForm![index].id,
                    });
                  }
                },
              ));
      setState(() {});
    });
  }

  contentGenerator() {
    if (listForm == null) {
      return LoadingBiasa(text: "Memuat form");
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
    super.build(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // ContainerPetunjukAtas(
        //     text:
        //         "Petunjuk : Pilih salah satu draft untuk melanjutkan pembuatan form"),
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
    );
  }

  @override
  // bool get wantKeepAlive => (baseUri == Uri.base.toString());
  bool get wantKeepAlive => true;
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
