import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart' hide Router;

import 'router_handler.dart';

final route = FluroRouter();

class Routes {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static String root = "/";

  static String createWallet = "/createWallet";

  static String importWallet = "/importWallet";

  static String register = "/register";

  static String welcome = "/welcome";

  static String account = "/account";

  static String security = "/security";

  static String secretPhrase = "/secretPhrase";

  static String chat = "/chat";

  static String approve = "/approve";

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = new Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return Text('ERRO====> ROUT WAS NOT FOUND');
    });
    router.printTree();
    router.define(root, handler: mainHandler);
    router.define(Routes.welcome, handler: welcomeScreenHandler);
    router.define(Routes.createWallet, handler: createHandler);
    router.define(Routes.importWallet, handler: importHandler);
    router.define(Routes.register, handler: registerHandler);
    router.define(Routes.account, handler: accountHandler);
    router.define(Routes.security, handler: securityHandler);
    router.define(Routes.secretPhrase, handler: secretPhraseHandler);
    router.define(Routes.chat, handler: chatHandler);
    router.define(Routes.approve, handler: approveHandler);
  }

  static Future<dynamic> navigateToInFormRight(
      BuildContext context, String path,
      {bool replace = false,
      bool clearStack = false,
      TransitionType? transition,
      Duration transitionDuration = const Duration(milliseconds: 250),
      RouteTransitionsBuilder? transitionBuilder}) {
    if (Platform.isAndroid) {
      return route.navigateTo(context, path,
          replace: replace,
          clearStack: clearStack,
          transition: TransitionType.inFromRight,
          transitionDuration: transitionDuration,
          transitionBuilder: transitionBuilder,
          routeSettings: RouteSettings(name: path.split('?').first));
    } else {
      return route.navigateTo(context, path,
          replace: replace,
          clearStack: clearStack,
          transition: TransitionType.native,
          transitionDuration: transitionDuration,
          transitionBuilder: transitionBuilder,
          routeSettings: RouteSettings(name: path.split('?').first));
    }
  }
}
