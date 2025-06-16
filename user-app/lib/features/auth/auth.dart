import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:survei_aplikasi/features/app/app.dart';
import 'package:survei_aplikasi/utils/loading_biasa.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  @override
  void initState() {
    Future(() {
      ref.read(authProvider.notifier).initAuth(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: LoadingBiasa(textLoading: "Sedang Autentikasi")));
  }
}
//bikin loading dengan logo