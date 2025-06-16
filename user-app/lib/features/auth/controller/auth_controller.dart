import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:survei_aplikasi/constants.dart';
import 'package:survei_aplikasi/features/app/router/router_constant.dart';
import 'package:survei_aplikasi/features/auth/state/auth_state.dart';
import 'package:survei_aplikasi/features/auth/state/user.dart';
import 'package:survei_aplikasi/features/profile/user_data.dart';
import 'package:survei_aplikasi/utils/graphql_db.dart';
import 'package:survei_aplikasi/utils/shared_pref.dart';

class AuthController extends StateNotifier<AuthState> {
  AuthController()
      : super(
          AuthState(
            isLoggedIn: false,
            pesanSup: "",
            pesanSin: "",
            statusSup: "normal",
            statusSin: "normal",
            user: AppUser(
              id: "",
              urlGambar:
                  "https://firebasestorage.googleapis.com/v0/b/hei-survei-v1.appspot.com/o/images%2Ffoto%20profil%20kosong.jpeg?alt=media&token=6be0619a-508e-44d8-857f-08c316ec3aeb",
              email: "",
              isVerified: false,
              poin: -1,
            ),
          ),
        );

  Future<UserData?> getUserData(String idUser) async {
    try {
      String request = """
query GetDataUser(\$idUser: String!) {
  getDataUser(idUser: \$idUser) {
    code,pesan,data {
      email,id_user,interest,kota,poin,url_gambar,waktu_pendaftaran
    }
  }
}
      """;
      Map<String, dynamic>? data = await BackendConnection()
          .serverConnection(query: request, mapVariable: {
        'idUser': idUser,
      });
      if (data!['getDataUser']['code'] == 200) {
        Object? result = data['getDataUser']['data'];
        UserData hasil = UserData.fromJson(json.encode(result));
        return hasil;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    try {
      final googleAccount = await GoogleSignIn().signIn();

      final googleAuth = await googleAccount?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      //dari sini dapat data user userCredential.user

      if (userCredential.user != null && mounted) {
        String query = """ 
      mutation Mutation(\$email: String!, \$urlGambar: String!) {
        registerUserGoogle(email: \$email, urlGambar: \$urlGambar) {
        code,data,pesan,status  
        }
      }
    """;
        Map<String, dynamic>? data = await BackendConnection()
            .serverConnection(query: query, mapVariable: {
          'email': userCredential.user!.email,
          'urlGambar': userCredential.user!.photoURL,
        });
        if (data!['registerUserGoogle']['code'] == 200) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString(prefUserid, data['registerUserGoogle']['data']);

          if (!context.mounted) return;
          state = state.copyWith(statusSin: "normal", pesanSin: "");
          context.pushNamed(RouteConstant.auth);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
            "Akun google tidak kredibel",
          )));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          "Terjadi Kesalahan Server",
        )));
      }
    } on FirebaseAuthException catch (error) {
      print(error.message);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        error.message ?? "Terjadi Error",
      )));
    } catch (error) {
      // print(error);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
          // error.toString(),
          "Sign in Google gagal")));
    }
  }

  Future<void> daftarUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = state.copyWith(statusSup: "loading", pesanSup: "");
    try {
      print("masuk registernya");
      String query = """
        mutation Mutation(\$email: String!, \$password: String!) {
  registerUser(email: \$email, password: \$password) {
  code,pesan,status
  }
}
    """;
      Map<String, dynamic>? data = await BackendConnection().serverConnection(
        query: query,
        mapVariable: {
          'email': email,
          'password': password,
        },
      );
      print(data);
      if (data!['registerUser']['code'] == 200) {
        state = state.copyWith(
            statusSup: "normal", pesanSup: data['registerUser']['pesan']);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Silahkan pindah ke halaman login")));
      } else {
        state = state.copyWith(
            statusSup: "normal", pesanSup: data['registerUser']['pesan']);
      }
    } catch (e) {
      print(e);
      state = state.copyWith(
          statusSup: "normal", pesanSup: "Terjadi Kesalahan Server");
    }
  }

  void tampilkanPesan(String pesan) {
    state = state.copyWith(statusSin: "normal", pesanSin: pesan);
  }

  Future<void> masukUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    //ingat pindahkan ke halaman Auth
    state = state.copyWith(statusSin: "loading", pesanSin: "");
    try {
      String query = """ 
query Query(\$email: String!, \$password: String!) {
  loginUser(email: \$email, password: \$password) {
  code,data,pesan,status  
  }
}
    """;
      Map<String, dynamic>? data = await BackendConnection()
          .serverConnection(query: query, mapVariable: {
        'email': email,
        'password': password,
      });
      print(data);
      if (data!['loginUser']['code'] == 200) {
        //disini jika sukses
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(prefUserid, data['loginUser']['data']);

        if (!context.mounted) return;
        state = state.copyWith(statusSin: "normal", pesanSin: "");
        context.pushNamed(RouteConstant.auth);
      } else {
        state = state.copyWith(
            statusSin: "normal", pesanSin: data['loginUser']['pesan']);
      }
    } catch (e) {
      state = state.copyWith(statusSin: "normal", pesanSin: "Error :(");
      print(e);
    }
  }

  Future<void> initAuth(BuildContext context) async {
    final idUser = SharedPrefs.getString(prefUserid);
    if (!context.mounted) return;

    if (idUser == null) {
      context.goNamed(RouteConstant.login);
    } else {
      try {
        String query = """ 
query GetDataUser(\$idUser: String!) {
  getDataUser(idUser: \$idUser) {
    code,pesan,data {
      email,verified,url_gambar,poin
    }
  }
}
    """;

        Map<String, dynamic>? data = await BackendConnection()
            .serverConnection(query: query, mapVariable: {
          'idUser': idUser,
        });
        print("ini hasil ambil data -> $data");
        if (!context.mounted) return;

        if (data![getDataUser]['code'] == 200) {
          final userData = AppUser(
            id: idUser,
            urlGambar: data[getDataUser]['data']['url_gambar'],
            email: data[getDataUser]['data']['email'],
            isVerified: data[getDataUser]['data']['verified'] as bool,
            poin: data[getDataUser]['data']['poin'] as int,
          );
          state = state.copyWith(
            isLoggedIn: true,
            pesanSin: "",
            pesanSup: "",
            statusSin: "noraml",
            statusSup: "normal",
            user: userData,
          );
          context.goNamed(RouteConstant.home);
        } else {
          state = state.copyWith(
            isLoggedIn: false,
            pesanSin: data[getDataUser]['pesan'],
            pesanSup: "",
            statusSin: "noraml",
            statusSup: "normal",
          );
          context.goNamed(RouteConstant.login);
        }
      } catch (e) {
        print(e.toString() + "ayay error ki");
        context.goNamed(RouteConstant.login);
      }
    }
  }

  Future<void> signOut(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(prefUserid);
    state = state.copyWith(
      user: null,
      pesanSin: "",
      statusSin: "normal",
      isLoggedIn: false,
      pesanSup: "",
      statusSup: "normal",
    );
    if (!context.mounted) return;
    context.goNamed(RouteConstant.login);
  }
}
