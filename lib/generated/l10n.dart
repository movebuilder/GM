// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Select NFT`
  String get select_nft {
    return Intl.message(
      'Select NFT',
      name: 'select_nft',
      desc: '',
      args: [],
    );
  }

  /// `You haven’t NFT\non your address`
  String get select_tip {
    return Intl.message(
      'You haven’t NFT\non your address',
      name: 'select_tip',
      desc: '',
      args: [],
    );
  }

  /// `Show me`
  String get show {
    return Intl.message(
      'Show me',
      name: 'show',
      desc: '',
      args: [],
    );
  }

  /// `Select my NFT or photoes to show me`
  String get show_tip {
    return Intl.message(
      'Select my NFT or photoes to show me',
      name: 'show_tip',
      desc: '',
      args: [],
    );
  }

  /// `Import`
  String get import {
    return Intl.message(
      'Import',
      name: 'import',
      desc: '',
      args: [],
    );
  }

  /// `Import Wallet`
  String get import_wallet {
    return Intl.message(
      'Import Wallet',
      name: 'import_wallet',
      desc: '',
      args: [],
    );
  }

  /// `Your secret phrase`
  String get import_sub1 {
    return Intl.message(
      'Your secret phrase',
      name: 'import_sub1',
      desc: '',
      args: [],
    );
  }

  /// `Create new password to unlock your wallet`
  String get import_sub2 {
    return Intl.message(
      'Create new password to unlock your wallet',
      name: 'import_sub2',
      desc: '',
      args: [],
    );
  }

  /// `Enter secret phrase`
  String get import_hint {
    return Intl.message(
      'Enter secret phrase',
      name: 'import_hint',
      desc: '',
      args: [],
    );
  }

  /// `New password`
  String get new_password1 {
    return Intl.message(
      'New password',
      name: 'new_password1',
      desc: '',
      args: [],
    );
  }

  /// `Confirm the password`
  String get new_password2 {
    return Intl.message(
      'Confirm the password',
      name: 'new_password2',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
