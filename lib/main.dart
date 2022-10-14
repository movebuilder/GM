import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gm/common/app_theme.dart';
import 'package:gm/data/db/storage_manager.dart';
import 'package:gm/route/routes.dart';
import 'package:gm/screen/home_screen.dart';
import 'package:gm/screen/welcome_screen.dart';
import 'package:oktoast/oktoast.dart';

import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Routes.configureRoutes(route);
  await StorageManager.init();
  runApp(const MyApp());
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  EasyLoading.instance
    ..userInteractions = false
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorType = EasyLoadingIndicatorType.ring;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GM',
      theme: AppTheme.themeData,
      home: StorageManager.login() ? HomeScreen() : WelcomeScreen(),
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: Locale('en', ''),
      localeListResolutionCallback: (locales, supportedLocales) {
        print('current locale: $locales');
        return;
      },
      onGenerateRoute: route.generator,
      builder: (context, child) {
        return OKToast(
          child: FlutterEasyLoading(child: child),
        );
      },
    );
  }
}
