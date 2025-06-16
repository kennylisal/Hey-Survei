// ignore_for_file: public_member_api_docs, sort_constructors_first
class AppUser {
  final String id;
  final String urlGambar;
  final String email;
  final bool isVerified;
  final int poin;

  AppUser(
      {required this.id,
      required this.urlGambar,
      required this.email,
      required this.isVerified,
      required this.poin});

  AppUser copyWith({
    String? id,
    String? urlGambar,
    String? email,
    bool? isVerified,
    int? poin,
  }) {
    return AppUser(
      id: id ?? this.id,
      urlGambar: urlGambar ?? this.urlGambar,
      email: email ?? this.email,
      isVerified: isVerified ?? this.isVerified,
      poin: poin ?? this.poin,
    );
  }
}
