import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserDetail {
  String email;
  // String username;
  UserDetail({
    required this.email,
    // required this.username,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      // 'username': username,
    };
  }

  factory UserDetail.fromMap(Map<String, dynamic> map) {
    return UserDetail(
      email: map['email'] as String,
      // username: map['username'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserDetail.fromJson(String source) =>
      UserDetail.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UserDetail(email: $email';
}
