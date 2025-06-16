import 'package:encrypt/encrypt.dart' as enc;
import 'package:hei_survei/constants.dart';

class Kriptografi {
  // static String decrypt(String textEnkripsi) {
  //   final key = enc.Key.fromUtf8(keyCrypto);
  //   final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
  //   final initVector = enc.IV.fromUtf8(keyCrypto.substring(0, 16));
  //   enc.Encrypted encryptedData = enc.Encrypted.fromBase16(textEnkripsi);
  //   return encrypter.decrypt(encryptedData, iv: initVector);
  // }

  // enc.Encrypted encrypt(String plainText) {
  //   final key = enc.Key.fromUtf8(keyCrypto);
  //   final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
  //   final initVector = enc.IV.fromUtf8(keyCrypto.substring(0, 16));
  //   enc.Encrypted encryptedData = encrypter.encrypt(plainText, iv: initVector);
  //   return encryptedData;
  // }
  static String decrypt(String textEnkripsi) {
    try {
      final key = enc.Key.fromUtf8(keyCrypto);
      final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
      final initVector = enc.IV.fromUtf8(keyCrypto.substring(0, 16));
      enc.Encrypted encryptedData = enc.Encrypted.fromBase16(textEnkripsi);
      return encrypter.decrypt(encryptedData, iv: initVector);
    } catch (e) {
      return "-x-";
    }
  }

  static String encrypt(String plainText) {
    final key = enc.Key.fromUtf8(keyCrypto);
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    final initVector = enc.IV.fromUtf8(keyCrypto.substring(0, 16));
    enc.Encrypted encryptedData = encrypter.encrypt(plainText, iv: initVector);
    return encryptedData.base16;
  }
}
