import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hei_survei/utils/backend.dart';
import 'package:hei_survei/app/routing/route_constant.dart';
import 'package:hei_survei/constants.dart';
import 'package:hei_survei/features/auth/controller/auth_state.dart';
import 'package:hei_survei/features/auth/user.dart';
import 'package:hei_survei/utils/shared_pref.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AuthController extends StateNotifier<AuthState> {
  AuthController()
      : super(
          AuthState(
            isLoggedIn: false,
            pesanSup: "",
            pesanSin: "",
            statusSup: "normal",
            statusSin: "normal",
            user: User(
                id: "", userName: "", email: "", password: "", urlGambar: ""),
          ),
        );

  void gantiStatusDaftar(String status) {
    state = state.copyWith(statusSup: status);
  }

  void gantiPesanSup(String pesan) {
    state = state.copyWith(pesanSup: pesan);
  }

  void gantiPesanSin(String pesan) {
    state = state.copyWith(pesanSin: pesan);
  }

  String getEmailuser() => state.user.email;

  void signUpUser(
      {required String email,
      required String password,
      required String username}) async {
    print("mencoba sign up");
    try {
      state = state.copyWith(statusSup: "loading", pesanSup: "sedang Loading");
      HttpLink link = HttpLink(linkGraphql);
      GraphQLClient qlClient = GraphQLClient(
        link: link,
        cache: GraphQLCache(store: HiveStore()),
      );

      String request = """ 
        mutation Mutation(\$user: AddUserInput!) {
          registerUser(user: \$user) {
            code,data,status
          }
        }
    """;
      final idBaru = const Uuid().v4().substring(0, 8);
      QueryResult query =
          await qlClient.query(QueryOptions(document: gql(request), variables: {
        "user": {
          "username": username,
          "email": email,
          "password": password,
          "verified": 0,
          'idUser': idBaru,
        }
      }));
      print(query);
      if (query.data!["registerUser"]["code"] == 200) {
        await pengirimanVerifikasi(email, idBaru);

        state = state.copyWith(
            statusSup: "sukses",
            pesanSup: "Berhasil, Verifikasi email sebelum Login");
      } else {
        //print(query.data!["addUser"]["data"]);
        state = state.copyWith(
          statusSup: "normal",
          pesanSup: query.data!["registerUser"]["data"],
        );
      }
    } catch (e) {
      print(e);
      state = state.copyWith(
        statusSup: "normal",
        pesanSup: "Terjadi Kesalahan Server",
      );
    }
  }

  Future<void> pengirimanVerifikasi(String email, String idUser) async {
    try {
      String query = """ 
query KirimEmail(\$email: String!, \$idUser: String!) {
  kirimEmail(email: \$email, idUser: \$idUser) {
  code,data,status  
  }
}
    """;

      final varibles = {
        'email': email,
        'idUser': idUser,
      };

      await Backend().serverConnection(query: query, mapVariable: varibles);
    } catch (e) {
      print(e);
    }
  }

  Future<bool> masukUser({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(statusSin: "loading", pesanSin: "");
    try {
      String request = """
          query masukUser(\$email: String!,\$password: String!) {
            masukUser(email: \$email, password: \$password) {
              code,id,pesan
            }
          }
        """;

      final data =
          await Backend().serverConnection(query: request, mapVariable: {
        "email": email,
        "password": password,
      });
      print(data);
      if (data!["masukUser"]["code"] == 200) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(prefUserId, data["masukUser"]["id"]);

        // await SharedPrefs.instance
        //     .setString("idUser", query.data!["masukUser"]["id"]);
        state = state.copyWith(
          pesanSin: "berhasil masuk",
          statusSin: "normal",
        );
        return true;
      } else if (data["masukUser"]["code"] == 400) {
        String pesan = data["masukUser"]["pesan"];
        state = state.copyWith(
          pesanSin: pesan,
          statusSin: "normal",
        );
        return false;
      } else {
        state = state.copyWith(
          pesanSin: "Email atau Password tidak sesuai",
          statusSin: "normal",
        );
        return false;
        //print(query.data!["addUser"]["data"]);
      }
    } catch (e) {
      state = state.copyWith(
        pesanSin: "Terjadi kesalahan server",
        statusSin: "normal",
      );
      return false;
    }
  }

  Future<bool> masukUserGoogle({
    required String email,
    required String urlGambar,
    required String username,
  }) async {
    state = state.copyWith(statusSin: "loading", pesanSin: "");
    try {
      String request = """
query MasukUserGoogle(\$email: String!, \$urlGambar: String!, \$username: String) {
  masukUserGoogle(email: \$email, urlGambar: \$urlGambar, username: \$username) {
    code
    id
    pesan
  }
}
""";
      final data =
          await Backend().serverConnection(query: request, mapVariable: {
        "email": email,
        "urlGambar": urlGambar,
        "username": username,
      });
      if (data!["masukUserGoogle"]["code"] == 200) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(prefUserId, data["masukUserGoogle"]["id"]);
        state = state.copyWith(
          pesanSin: "berhasil masuk",
          statusSin: "normal",
        );
        return true;
      } else {
        String pesan = data["masukUserGoogle"]["pesan"];
        state = state.copyWith(
          pesanSin: pesan,
          statusSin: "normal",
        );
        return false;
      }
    } catch (e) {
      log(e.toString());
      state = state.copyWith(
        pesanSin: "Terjadi kesalahan server",
        statusSin: "normal",
      );
      return false;
    }
  }

  Future<void> getDataUserAndSettingState(String idUser) async {
    print("ini yg dijalankan");
    try {
      String request = """
query UserData(\$idUser: String!) {
  userData(idUser: \$idUser) {
      code,status,data {
    email,idUser,password,username,verified,waktu_pendaftaran,urlGambar
  }
  }
}
""";

      String idUserSekarang = SharedPrefs.getString(prefUserId) ?? "70fc9a56";
      final query = await Backend().serverConnection(
          query: request, mapVariable: {"idUser": idUserSekarang});

      final userRes = User(
        id: idUserSekarang,
        userName: query!["userData"]['data']["username"],
        email: query["userData"]['data']["email"],
        urlGambar: query["userData"]['data']["urlGambar"],
        password: "",
      );

      state = state.copyWith(
        user: userRes,
        pesanSin: "berhasil masuk",
        statusSin: "normal",
        isLoggedIn: true,
      );
      print("berhasil login remember me");
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOut(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(prefUserId);
    state = state.copyWith(
      user: User(id: "", userName: "", email: "", password: "", urlGambar: ""),
      pesanSin: "",
      statusSin: "normal",
      isLoggedIn: false,
      pesanSup: "",
      statusSup: "normal",
    );
    if (!context.mounted) return;
    context.pushNamed(RouteConstant.halamanAuth);
  }
}


//   Future<User> getDataUser(String idUser) async {
//     try {
//       HttpLink link = HttpLink(linkGraphql);
//       GraphQLClient qlClient = GraphQLClient(
//         link: link,
//         cache: GraphQLCache(store: HiveStore()),
//       );
//       String request = """
// query UserData(\$userDataId: String!) {
//   userData(id: \$userDataId) {
//     email,
//     id_user,
//     username
//   }
// }
// """;
//       QueryResult query = await qlClient.query(QueryOptions(
//         document: gql(request),
//         variables: {
//           "userDataId": idUser,
//         },
//       ));
//       return User(
//           id: query.data!["userData"]["id_user"],
//           userName: query.data!["userData"]["username"],
//           email: query.data!["userData"]["email"],
//           password: "");
//     } catch (e) {
//       return User(id: "", userName: "", email: "", password: "");
//     }
//   }