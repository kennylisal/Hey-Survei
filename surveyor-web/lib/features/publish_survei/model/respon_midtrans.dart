import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ResponMidtrans {
  String bank;
  String nomorVA;
  String idOrder;
  ResponMidtrans({
    required this.bank,
    required this.nomorVA,
    required this.idOrder,
  });

  factory ResponMidtrans.fromMap(Map<String, dynamic> map) {
    return ResponMidtrans(
      bank: map['bank'] as String,
      nomorVA: map['nomorVA'] as String,
      idOrder: map['idOrder'] as String,
    );
  }

  factory ResponMidtrans.fromJson(String source) =>
      ResponMidtrans.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ResponMidtrans(bank: $bank, nomorVA: $nomorVA)';
}
