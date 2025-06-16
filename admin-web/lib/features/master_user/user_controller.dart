import 'dart:convert';

import 'package:aplikasi_admin/utils/backend.dart';
import 'package:aplikasi_admin/features/master_user/user.dart';
import 'package:flutter/material.dart';

class UserController {
  Future<List<UserModel>> getAllUser(BuildContext context) async {
    try {
      String query = """ 
        query Query {
          getAllUserAdmin {
          code,data {
            email,idUser,isBanned,tgl,verified
          }  
          }
        }
    """;

      Map<String, dynamic>? data = await Backend().serverConnection(
        query: query,
        mapVariable: {},
      );

      if (!context.mounted) return [];
      if (data!['getAllUserAdmin']['code'] == 200) {
        List<Object?> dataUser = data['getAllUserAdmin']['data'];
        List<UserModel> temp = List.generate(dataUser.length,
            (index) => UserModel.fromJson(json.encode(dataUser[index])));
        print(temp);
        return temp;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<bool> setUserStatus(
      BuildContext context, String idUser, bool status) async {
    try {
      String query = """ 
      mutation BanUser(\$status: Boolean!, \$idUser: String!) {
        banUser(status: \$status, idUser: \$idUser) {
        code,data,status  
        }
      }
    """;
      Map<String, dynamic> map = {"idUser": idUser, "status": status};

      Map<String, dynamic>? data =
          await Backend().serverConnection(query: query, mapVariable: map);

      if (!context.mounted) return false;

      if (data!['banUser']['code'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Status user telah diUpdate")));
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Terjadi Kesalahan Server")));
        return false;
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Terjadi Kesalahan Program")));
      return false;
    }
  }
}
