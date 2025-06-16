import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  String email;
  String username;
  String tgl;
  bool isVerified;
  bool isBanned;
  String idUser;
  UserModel({
    required this.email,
    required this.username,
    required this.tgl,
    required this.isVerified,
    required this.isBanned,
    required this.idUser,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      // username: map['username'] as String,
      username: "",

      tgl: map['tgl'] as String,
      isVerified: map['verified'] as bool,
      isBanned: map['isBanned'] as bool,
      idUser: map['idUser'] as String,
    );
  }

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(email: $email, username: $username, tgl: $tgl, isVerified: $isVerified, isBanned: $isBanned, idUser: $idUser)';
  }
}
