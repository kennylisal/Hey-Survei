// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserData {
  String email;
  String username;
  String urlGambar;
  int poin;
  UserData({
    required this.email,
    required this.username,
    required this.urlGambar,
    required this.poin,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'username': username,
      'urlGambar': urlGambar,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      email: map['email'] as String,
      username: '',
      urlGambar: map['urlGambar'] as String,
      poin: map['poin'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserData.fromJson(String source) =>
      UserData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'UserData(email: $email, username: $username, urlGambar: $urlGambar)';
}
