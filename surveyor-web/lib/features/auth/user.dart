// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  final String id;
  final String userName;
  final String email;
  final String urlGambar;

  final String password;
  User({
    required this.id,
    required this.userName,
    required this.email,
    required this.password,
    required this.urlGambar,
  });

  User copyWith(
      {String? id,
      String? userName,
      String? email,
      String? token,
      String? password,
      String? urlGambar}) {
    return User(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      password: password ?? this.password,
      urlGambar: urlGambar ?? this.urlGambar,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userName': userName,
      'email': email,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      userName: map['userName'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      urlGambar: map['urlGambar'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, userName: $userName, email: $email, urlGambar: $urlGambar, password: $password)';
  }
}
