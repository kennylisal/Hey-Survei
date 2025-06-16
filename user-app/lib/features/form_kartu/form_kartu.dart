import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:survei_aplikasi/features/app/app.dart';
import 'package:survei_aplikasi/features/app/router/router_constant.dart';
import 'package:survei_aplikasi/features/form_kartu/state/controller_form_kartu.dart';
import 'package:survei_aplikasi/features/form_kartu/state/state_form_kartu.dart';
import 'package:survei_aplikasi/features/form_klasik/utility/data_form_controller.dart';
import 'package:survei_aplikasi/features/form_klasik/widgets/halaman_terima_kasih.dart';
import 'package:survei_aplikasi/utils/loading_biasa.dart';

class ContainerFormKartu extends ConsumerStatefulWidget {
  ContainerFormKartu({
    super.key,
    required this.idForm,
    required this.idSurvei,
  });
  String idForm;
  String idSurvei;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ContainerFormKartuState();
}

class _ContainerFormKartuState extends ConsumerState<ContainerFormKartu> {
  FormKartuController? formController;
  String? emailPenjawab;

  @override
  void initState() {
    super.initState();
    try {
      emailPenjawab = ref.read(authProvider).user.email;
      persiapanData();
    } catch (e) {
      context.goNamed(RouteConstant.auth);
    }
  }

  persiapanData() async {
    formController = await DataFormController().setUpFormKartu(widget.idForm);
    setState(() {});
  }

  handleClick(int item) {
    switch (item) {
      case 0:
        context.goNamed(RouteConstant.auth);
        break;
      case 1:
        context.pushNamed(RouteConstant.laporSurvei, pathParameters: {
          'email': emailPenjawab!,
          'idSurvei': widget.idSurvei,
          'judulSurvei': formController!.getJudul(),
        });
        break;
    }
  }

  Widget contentGenerator() {
    if (formController == null) {
      return SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            LoadingBiasa(
              textLoading: "Loading Soal",
            )
          ],
        ),
      );
    } else {
      return FormKartuXYZ(
        emailUser: emailPenjawab!,
        idForm: widget.idForm,
        idSurvei: widget.idSurvei,
        formController: formController!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade600,
        title: Text(
          "Pengisian Survei",
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontSize: 19,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem<int>(value: 0, child: Text('Kembali')),
              PopupMenuItem<int>(value: 1, child: Text('Lapor')),
            ],
            onSelected: (value) => handleClick(value),
          )
        ],
      ),
      body: Container(
        height: screenSize.height,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        color: Theme.of(context).colorScheme.primaryContainer,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: contentGenerator(),
        ),
      ),
    );
  }
}

class FormKartuXYZ extends ConsumerStatefulWidget {
  FormKartuXYZ({
    super.key,
    required this.emailUser,
    required this.idForm,
    required this.idSurvei,
    required this.formController,
  });
  FormKartuController formController;
  String idForm;
  String idSurvei;
  String emailUser;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FormKartuXYZState();
}

class _FormKartuXYZState extends ConsumerState<FormKartuXYZ> {
  late StateNotifierProvider<FormKartuController, FormKartuState> provider;
  @override
  void initState() {
    provider = StateNotifierProvider((ref) => widget.formController);
    super.initState();
  }

  List<Widget> contentGenerator() {
    if (widget.formController.isSelesai) {
      return [
        TerimaKasihPengisianForm(
          insentif: widget.formController.insentifSurvei,
          emailUser: widget.emailUser,
          idSurvei: widget.idSurvei,
        )
      ];
    } else {
      return [
        ...widget.formController
            .generateKonten(context, widget.idSurvei, widget.emailUser)
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final temp = ref.watch(provider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: contentGenerator(),
    );
  }
}

class ContainerKartuPercobaan extends StatefulWidget {
  ContainerKartuPercobaan({
    super.key,
    required this.idForm,
    required this.idSurvei,
  });
  String idForm;
  String idSurvei;

  @override
  State<ContainerKartuPercobaan> createState() =>
      _ContainerKartuPercobaanState();
}

class _ContainerKartuPercobaanState extends State<ContainerKartuPercobaan> {
  FormKartuController? formController;
  String? emailPenjawab;

  @override
  void initState() {
    super.initState();
    try {
      emailPenjawab = "kenny Lisal";
      persiapanData();
    } catch (e) {
      context.goNamed(RouteConstant.auth);
    }
  }

  persiapanData() async {
    formController = await DataFormController().setUpFormKartu(widget.idForm);
    setState(() {});
  }

  handleClick(int item) {
    switch (item) {
      case 0:
        context.goNamed(RouteConstant.auth);
        break;
      case 1:
        context.pushNamed(RouteConstant.laporSurvei, pathParameters: {
          'email': emailPenjawab!,
          'idSurvei': widget.idSurvei,
          'judulSurvei': formController!.getJudul(),
        });
        break;
    }
  }

  Widget contentGenerator() {
    if (formController == null) {
      return SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            LoadingBiasa(
              textLoading: "Loading Soal",
            )
          ],
        ),
      );
    } else {
      return FormKartuXYZ(
        emailUser: emailPenjawab!,
        idForm: widget.idForm,
        idSurvei: widget.idSurvei,
        formController: formController!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade600,
        title: Text(
          "Pengisian Survei",
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontSize: 19,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem<int>(value: 0, child: Text('Kembali')),
              PopupMenuItem<int>(value: 1, child: Text('Lapor')),
            ],
            onSelected: (value) => handleClick(value),
          )
        ],
      ),
      body: Container(
        height: screenSize.height,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        color: Theme.of(context).colorScheme.primaryContainer,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: contentGenerator(),
        ),
      ),
    );
  }
}
