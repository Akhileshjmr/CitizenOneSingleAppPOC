import 'package:encrypt/encrypt.dart';

class AesEncryption {
  static String key = 'Arig1234Arig1234';

  static String iv = 'RandomInitVector';

  static String encrypt(String plainText){

    final key1 = Key.fromUtf8(key);

    final iv1 = IV.fromUtf8(iv);

    final encrypter = Encrypter(AES(key1, mode: AESMode.cbc));


    final encrypted = encrypter.encrypt(plainText, iv: iv1);


    return encrypted.base64;

  }

  static String decrypt(String encrypted){

    final key1 = Key.fromUtf8(key);

    final iv1 = IV.fromUtf8(iv);

    final encrypter = Encrypter(AES(key1, mode: AESMode.cbc));

    final decrypted = encrypter.decrypt(Encrypted.fromBase64(encrypted), iv: iv1);

    return decrypted;

  }
}