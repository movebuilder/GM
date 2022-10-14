import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:gm/screen/create_wallet.dart';
import 'package:gm/screen/home_screen.dart';
import 'package:gm/screen/import_wallet.dart';
import 'package:gm/screen/register_page.dart';
import 'package:gm/screen/welcome_screen.dart';

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
