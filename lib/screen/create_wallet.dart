import 'package:aptos/aptos_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:gm/aptos/wallet/key_manager.dart';
import 'package:gm/common/app_theme.dart';
import 'package:gm/data/db/storage_manager.dart';
import 'package:gm/generated/l10n.dart';
import 'package:gm/route/routes.dart';
import 'package:gm/util/image_utils.dart';
import 'package:gm/util/screen_util.dart';
import 'package:gm/widgets/gm_textfield.dart';
import 'package:gm/widgets/line_button.dart';

class CreateWalletPage extends StatefulWidget {
  @override
  _ImportWalletState createState() => _ImportWalletState();
}

class _ImportWalletState extends State<CreateWalletPage> {
  var _password1 = '';
  var _password2 = '';
  var _errorText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: List.of([
            AppTheme.colorBtnGradientStart,
            AppTheme.colorBtnGradientEnd,
          ]),
        ),
      ),
      child: KeyboardDismissOnTap(
        child: KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
          return Stack(
            children: [
              Positioned(
                top: 0.w,
                child: _title(),
              ),
              Positioned(
                bottom: 0.w,
                top: 94.w,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 27.w),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 120.w),
                            imageUtils(
                              'aptos.svg',
                              width: 70.w,
                              height: 70.w,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 10.w,
                                bottom: 28.w,
                              ),
                              child: Text(
                                'APTOS Wallet',
                                style: TextStyle(
                                  color: AppTheme.colorFontGM,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                            _subTitle(
                                'Create new password to unlock your wallet'),
                            _itemPassword(1),
                            SizedBox(height: 20.w),
                            _itemPassword(2),
                            SizedBox(height: 20.w),
                            Text(
                              _errorText,
                              style: TextStyle(
                                color: AppTheme.colorRed,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    isKeyboardVisible
                        ? SizedBox()
                        : Padding(
                            padding: EdgeInsets.only(bottom: 38.w),
                            child: LineButton(
                              text: 'Create',
                              onTap: () {
                                _createWallet();
                              },
                            ),
                          ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    ));
  }

  _title() {
    return Container(
      width: 375.w,
      height: 94.w,
      padding: EdgeInsets.only(top: 55.w),
      alignment: Alignment.topCenter,
      child: Text(
        S.current.import_wallet,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppTheme.colorFontGM,
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  _subTitle(text) {
    return Container(
      padding: EdgeInsets.only(top: 30.w, bottom: 15.w),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          color: AppTheme.colorFontGM,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  _itemPassword(type) {
    return GMTextField(
      hintText: type == 1 ? S.current.new_password1 : S.current.new_password2,
      hintColor: AppTheme.colorHint,
      borderRadius: 8.w,
      style: TextStyle(
        color: AppTheme.colorFontOne,
        fontSize: ScreenUtil.fontSize15,
        fontWeight: FontWeight.w500,
      ),
      padding: EdgeInsets.only(left: 15.w),
      showPassword: true,
      isPassword: true,
      height: 56.w,
      text: type == 1 ? _password1 : _password2,
      leftIcon: 'assets/svgs/password.svg',
      onChange: (value) {
        type == 1 ? _password1 = value : _password2 = value;
        setState(() {
          _errorText = '';
        });
      },
    );
  }

  _createWallet() async {
    if (_password1.length < 6 || _password1.length < 6) {
      setState(() {
        _errorText = S.current.limit_characters;
      });
    } else if (_password1 != _password2) {
      setState(() {
        _errorText = S.current.enter_same_password;
      });
    } else {
      try {
        EasyLoading.show();
        final mnemonics = AptosAccount.generateMnemonic();
        await KeyManager.setMnemonic(mnemonics, _password1);
        final localMnemonic = await KeyManager.getMnemonic(_password1);
        if (mnemonics == localMnemonic) {
          await KeyManager.setPassword(_password1);
          await KeyManager.setMnemonic(mnemonics, _password1);
          var account = AptosAccount.generateAccount(mnemonics);
          await StorageManager.setAddress(account.accountAddress.hex());
        }
        EasyLoading.dismiss();
        route.navigateTo(context, Routes.root, clearStack: true);
      } catch (e) {
        EasyLoading.dismiss();
        setState(() {
          _errorText = e.toString();
        });
      }
    }
  }
}
