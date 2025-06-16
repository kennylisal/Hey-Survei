// ignore_for_file: public_member_api_docs, sort_constructors_first
class DataError {
  String idSoal;
  bool isError;
  DataError({
    required this.idSoal,
    required this.isError,
  });

  @override
  String toString() => 'DataError(idSoal: $idSoal, isError: $isError)';
}
