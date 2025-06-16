import 'package:aplikasi_admin/app/routing/route_constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthController {
  void loginAdmin(BuildContext context, String username, String password) {
    if (username == "admin" && password == "masuk6622;") {
      context.goNamed(RouterConstant.home);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Kredensial Salah")));
    }
  }
}
