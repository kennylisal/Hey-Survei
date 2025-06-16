import 'package:aplikasi_admin/features/auth/auth_controller.dart';
import 'package:aplikasi_admin/features/auth/component/container_textfield_admin.dart';
import 'package:flutter/material.dart';

class AdminLogin extends StatelessWidget {
  AdminLogin({super.key});

  TextEditingController controllerUsername = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: PreferredSize(
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
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "Admin Hei, Survei",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.grey.shade100,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              )
            ],
          ),
        ),
      ),
      body: Center(
        child: Container(
          width: 700,
          height: 350,
          padding: const EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(width: 2, color: Colors.black),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "LOGIN ADMIN",
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ContainerTextAdmin(
                child: TextFormField(
                  controller: controllerUsername,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: 'Username',
                      border: InputBorder.none),
                ),
              ),
              ContainerTextAdmin(
                child: TextFormField(
                  controller: controllerPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      hintText: 'Password',
                      border: InputBorder.none),
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  AuthController().loginAdmin(context, controllerUsername.text,
                      controllerPassword.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(26, 63, 60, 58),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Container(
                  height: 50,
                  width: 90,
                  child: Center(
                    child: Text(
                      "Masuk",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
