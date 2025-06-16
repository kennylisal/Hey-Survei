import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:survei_aplikasi/features/app/app.dart';
import 'package:survei_aplikasi/features/app/router/router_constant.dart';
import 'package:survei_aplikasi/features/form_klasik/state/controller_form.dart';
import 'package:survei_aplikasi/features/form_klasik/state/state_form.dart';
import 'package:survei_aplikasi/features/form_klasik/utility/data_form_controller.dart';
import 'package:survei_aplikasi/features/form_klasik/widgets/halaman_terima_kasih.dart';
import 'package:survei_aplikasi/features/form_klasik/widgets_atas_form/judul_soal_polos.dart';
import 'package:survei_aplikasi/utils/loading_biasa.dart';

class ContainerFormKlasik extends ConsumerStatefulWidget {
  ContainerFormKlasik({
    super.key,
    required this.idForm,
    required this.idSurvei,
  });
  String idForm;
  String idSurvei;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ContainerFormKlasikZState();
}

class _ContainerFormKlasikZState extends ConsumerState<ContainerFormKlasik> {
  FormController? formController;
  String? emailPenjawab;
  @override
  void initState() {
    super.initState();
    try {
      persiapanData();
      emailPenjawab = ref.read(authProvider).user.email;
    } catch (e) {
      context.goNamed(RouteConstant.auth);
    }
  }

  persiapanData() async {
    formController = await DataFormController().setUpFormKlasik(widget.idForm);
    setState(() {});
    print(formController!.pembagianSoal);
  }

  Widget contentGenerator(double widthSize) {
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
      return FormKlasikXY(
        formController: formController!,
        emailUser: emailPenjawab!,
        idForm: widget.idForm,
        idSurvei: widget.idSurvei,
        widthSize: widthSize,
      );
    }
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
            child: contentGenerator(screenSize.width)),
      ),
    );
  }
}

class FormKlasikXY extends ConsumerStatefulWidget {
  FormKlasikXY({
    super.key,
    required this.formController,
    required this.emailUser,
    required this.idForm,
    required this.idSurvei,
    required this.widthSize,
  });
  FormController formController;
  String idForm;
  String idSurvei;
  String emailUser;
  double widthSize;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FormKlasikState();
}

class _FormKlasikState extends ConsumerState<FormKlasikXY> {
  late StateNotifierProvider<FormController, FormStateX> provider;
  @override
  void initState() {
    provider = StateNotifierProvider((ref) => widget.formController);
    super.initState();
  }

  Widget generateJudulSoal() {
    return JudulFormPolos(judul: widget.formController.getJudul());
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
        ...widget.formController.generateKonten(
          context,
          widget.idSurvei,
          widget.emailUser,
          generateJudulSoal(),
          widget.widthSize,
        )
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final temp = ref.watch(provider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [...contentGenerator()],
    );
  }
}

class ContainerKlasikPercobaan extends StatefulWidget {
  ContainerKlasikPercobaan({
    super.key,
    required this.idForm,
    required this.idSurvei,
  });
  String idForm;
  String idSurvei;

  @override
  State<ContainerKlasikPercobaan> createState() =>
      _ContainerKlasikPercobaanState();
}

class _ContainerKlasikPercobaanState extends State<ContainerKlasikPercobaan> {
  FormController? formController;
  String? emailPenjawab;
  @override
  void initState() {
    super.initState();
    try {
      persiapanData();
      emailPenjawab = "Kenny Handy Lisal@gmail";
    } catch (e) {
      context.goNamed(RouteConstant.auth);
    }
  }

  persiapanData() async {
    formController = await DataFormController().setUpFormKlasik(widget.idForm);
    setState(() {});
    print(formController!.pembagianSoal);
  }

  Widget contentGenerator(double widthSize) {
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
      return FormKlasikXY(
        formController: formController!,
        emailUser: emailPenjawab!,
        idForm: widget.idForm,
        idSurvei: widget.idSurvei,
        widthSize: widthSize,
      );
    }
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
            child: contentGenerator(screenSize.width)),
      ),
    );
  }
}

// class ContainerFormKlasik extends StatefulWidget {
//   ContainerFormKlasik({
//     super.key,
//     required this.idForm,
//     required this.idSurvei,
//   });
//   String idForm;
//   String idSurvei;
//   @override
//   State<ContainerFormKlasik> createState() => _ContainerFormKlasikState();
// }

// class _ContainerFormKlasikState extends State<ContainerFormKlasik> {
//   FormController? formController;
//   String? emailPenjawab;
//   @override
//   void initState() {
//     persiapanData();
//     emailPenjawab = ref.read(authProvider).user.email;
//     super.initState();
//   }

//   persiapanData() async {
//     formController =
//         await DataFormController().setUpFormKlasik("percobaan pembatas");
//     setState(() {});
//     print(formController!.pembagianSoal);
//   }

//   Widget contentGenerator() {
//     if (formController == null) {
//       return SizedBox(
//         width: double.infinity,
//         child: Column(
//           children: [
//             LoadingBiasa(
//               textLoading: "Loading Soal",
//             )
//           ],
//         ),
//       );
//     } else {
//       return FormKlasikXY(formController: formController!);
//     }
//   }

//   handleClick(int item) {
//     switch (item) {
//       case 0:
//         context.pop();
//         break;
//       case 1:
//         context.pushNamed(RouteConstant.laporSurvei, pathParameters: {
//           'email': emailPenjawab!,
//           'idSurvei': widget.idSurvei,
//         });
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var screenSize = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.lightBlue.shade600,
//         title: Text(
//           "Pengisian Form",
//           style: Theme.of(context).textTheme.displaySmall!.copyWith(
//                 fontSize: 19,
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//               ),
//         ),
//         actions: [
//           PopupMenuButton<int>(
//             itemBuilder: (context) => [
//               PopupMenuItem<int>(value: 0, child: Text('Kembali')),
//               PopupMenuItem<int>(value: 1, child: Text('Lapor')),
//             ],
//             onSelected: (value) => handleClick(value),
//           )
//         ],
//       ),
//       body: Container(
//         height: screenSize.height,
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         color: Theme.of(context).colorScheme.primaryContainer,
//         child: SingleChildScrollView(
//             scrollDirection: Axis.vertical, child: contentGenerator()),
//       ),
//     );
//   }
// }