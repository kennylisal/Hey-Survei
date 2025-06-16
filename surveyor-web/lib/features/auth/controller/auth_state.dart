import 'package:hei_survei/features/auth/user.dart';

class AuthState {
  bool isLoggedIn;
  String pesanSup;
  String pesanSin;
  String statusSup;
  String statusSin;

  User user;
  AuthState({
    required this.isLoggedIn,
    required this.pesanSup,
    required this.pesanSin,
    required this.statusSup,
    required this.statusSin,
    required this.user,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    String? pesanSup,
    String? pesanSin,
    String? statusSup,
    String? statusSin,
    User? user,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      pesanSup: pesanSup ?? this.pesanSup,
      pesanSin: pesanSin ?? this.pesanSin,
      statusSup: statusSup ?? this.statusSup,
      statusSin: statusSin ?? this.statusSin,
      user: user ?? this.user,
    );
  }
}
