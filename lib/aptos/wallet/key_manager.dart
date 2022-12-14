import 'package:aptos/aptos.dart';
import 'package:aptos/aptos_account.dart';
import 'package:gm/aptos/wallet/aes_cbc.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:gm/aptos/wallet/key_chain.dart';

class KeyManager {

  static String generateMnemonic() {
    return AptosAccount.generateMnemonic();
  }

  static Future<bool> setMnemonic(String mnemonic, String password) async {
    if (!bip39.validateMnemonic(mnemonic)) return false;
    String cipher = AesCbc.encrypt(password, mnemonic);
    return await Keychain.shared.setMnemonic(cipher);
  }
  
  static Future<bool> isExistMnemonic() async {
    String cipher = await Keychain.shared.getMnemonic();
    return cipher.isNotEmpty;
  }

  static Future<String> getMnemonic(String password) async {
    String cipher = await Keychain.shared.getMnemonic();
    String mnemonic = AesCbc.decrypt(password, cipher);
    return mnemonic;
  }

  static Future<bool> setPrivateKey(String privateKey, String password) async {
    String cipher = AesCbc.encrypt(password, privateKey);
    return await Keychain.shared.setPrivateKey(cipher);
  }

  static Future<String> getPrivateKey(String password) async {
    String cipher = await Keychain.shared.getPrivateKey();
    String privateKey = AesCbc.decrypt(password, cipher);
    return privateKey;
  }

  static Future<bool> setPassword(String password) async {
    bool success = await Keychain.shared.setPasswordKey(password);
    return success;
  }

  static Future<String> getPassword() async {
    String password = await Keychain.shared.getPasswordKey();
    return password;
  }

  static AptosAccount getAccount(String mnemonic, {int addressIndex = 0}) {
    return AptosAccount.generateAccount(mnemonic);
  }

}