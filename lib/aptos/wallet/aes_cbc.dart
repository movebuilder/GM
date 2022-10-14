
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';

class AesCbc {

  static const separator = "::";

  static Uint8List getRandomBytes(int length) {
    final secureRandom = FortunaRandom();
    final seedSource = Random.secure();
    final seeds = <int>[];
    for (int i = 0; i < 32; i++) {
      seeds.add(seedSource.nextInt(255));
    }
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));
    return secureRandom.nextBytes(length);
  }

  static Uint8List deriveKey(String password, Uint8List salt) {
    final scrypt = Scrypt()..init(ScryptParameters(1024, 8, 16, 32, salt));
    Uint8List bytes = scrypt.process(Uint8List.fromList(utf8.encode(password)));
    return bytes;
  }

  static String encrypt(String password, String plainText) {
    Uint8List salt = getRandomBytes(16);
    Uint8List key = deriveKey(password, salt);
    Uint8List unpadData = Uint8List.fromList(utf8.encode(plainText));
    int remainder = unpadData.length % 16;
    int totalLength = unpadData.length + (16 - remainder);
    var paddedData = Uint8List(totalLength)..setAll(0, unpadData);
    int _ = PKCS7Padding().addPadding(paddedData, unpadData.length);
    Uint8List cipherText = aesCbcEncrypt(key, key.sublist(0, 16), paddedData);
    String cipherStr = base64.encode(cipherText);
    String saltStr = base64.encode(salt);
    return "$cipherStr$separator$saltStr";
  }

  static String decrypt(String password, String cipher) {
    List<String> cipherWithSalt = cipher.split(separator);
    Uint8List cipherText = base64.decode(cipherWithSalt[0]);
    Uint8List salt = base64.decode(cipherWithSalt[1]);
    Uint8List key = deriveKey(password, salt);
    Uint8List decryptData = aesCbcDecrypt(key, key.sublist(0, 16), cipherText);
    int padCount = PKCS7Padding().padCount(decryptData);
    Uint8List textData = decryptData.sublist(0, decryptData.length - padCount);
    return String.fromCharCodes(textData);
  }

  static Uint8List aesCbcEncrypt(
      Uint8List key, Uint8List iv, Uint8List paddedPlaintext) {
    assert([128, 192, 256].contains(key.length * 8));
    assert(128 == iv.length * 8);

    final cbc = CBCBlockCipher(AESEngine())
      ..init(true, ParametersWithIV(KeyParameter(key), iv));

    final cipherText = Uint8List(paddedPlaintext.length);

    var offset = 0;
    while (offset < paddedPlaintext.length) {
      offset += cbc.processBlock(paddedPlaintext, offset, cipherText, offset);
    }
    assert(offset == paddedPlaintext.length);

    return cipherText;
  }

  static Uint8List aesCbcDecrypt(Uint8List key, Uint8List iv, Uint8List cipherText) {
    assert([128, 192, 256].contains(key.length * 8));
    assert(128 == iv.length * 8);

    final cbc = CBCBlockCipher(AESEngine())
      ..init(false, ParametersWithIV(KeyParameter(key), iv));

    final paddedPlainText = Uint8List(cipherText.length);

    var offset = 0;
    while (offset < cipherText.length) {
      offset += cbc.processBlock(cipherText, offset, paddedPlainText, offset);
    }
    assert(offset == cipherText.length);

    return paddedPlainText;
  }

}