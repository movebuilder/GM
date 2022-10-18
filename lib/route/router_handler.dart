import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:gm/screen/account/account_screen.dart';
import 'package:gm/screen/account/apporve_screen.dart';
import 'package:gm/screen/account/secret_phrase_screen.dart';
import 'package:gm/screen/account/security_screen.dart';
import 'package:gm/screen/chat/chat_screen.dart';
import 'package:gm/screen/create_wallet.dart';
import 'package:gm/screen/home_screen.dart';
import 'package:gm/screen/import_wallet.dart';
import 'package:gm/screen/register_page.dart';
import 'package:gm/screen/welcome_screen.dart';
import 'package:gm/util/fluro_convert_util.dart';

var mainHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return HomeScreen();
  },
);

var welcomeScreenHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return WelcomeScreen();
});

var registerHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return RegisterPage();
  },
);

var createHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return CreateWalletPage();
  },
);

var importHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return ImportWalletPage();
  },
);

var accountHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return AccountScreen();
  },
);

var securityHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return SecurityScreen();
  },
);

var secretPhraseHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    final String mnemonic = params["mnemonic"]?.first ?? '';
    return SecretPhraseScreen(mnemonic: mnemonic);
  },
);

var chatHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    final String chatAddress = params["chatAddress"]?.first ?? '';
    String nft = params["nft"]?.first ?? '';
    if (nft.isNotEmpty) {
      nft = FluroConvertUtils.fluroCnParamsDecode(nft);
    }
    return ChatScreen(chatAddress: chatAddress, nft: nft);
  },
);

var approveHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return ApproveScreen();
  },
);
