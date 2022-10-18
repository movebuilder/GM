import 'package:aptos/aptos.dart';
import 'package:aptos/aptos_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:gm/aptos/wallet/key_manager.dart';
import 'package:gm/common/app_theme.dart';
import 'package:gm/data/db/storage_manager.dart';
import 'package:gm/generated/l10n.dart';
import 'package:gm/route/routes.dart';
import 'package:gm/util/screen_util.dart';
import 'package:gm/util/toast_util.dart';
import 'package:gm/widgets/gm_textfield.dart';
import 'package:gm/widgets/line_button.dart';

class ImportWalletPage extends StatefulWidget {
  @override
  _ImportWalletState createState() => _ImportWalletState();
}

class _ImportWalletState extends State<ImportWalletPage> {
  var _mnemonic = '';
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
          child:
              KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
            return Column(
              children: [
                _title(),
                Expanded(child: _buildTop()),
                isKeyboardVisible ? SizedBox() : _buildBottomButton(),
              ],
            );
          }),
        ),
      ),
    );
  }

  _title() {
    return Container(
      width: 375.w,
      padding: EdgeInsets.only(top: 54.w, bottom: 13.w),
      alignment: Alignment.center,
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
    return Padding(
      padding: EdgeInsets.only(top: 30.w, bottom: 15.w, left: 2.w),
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

  _itemPassword(type, hintText) {
    return GMTextField(
      hintText: hintText,
      hintColor: AppTheme.colorHint,
      borderRadius: 8.w,
      style: TextStyle(
          color: AppTheme.colorFontOne,
          fontSize: ScreenUtil.fontSize15,
          fontWeight: FontWeight.w500),
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

  _buildTop() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 27.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _subTitle(S.current.import_sub1),
          GMTextField(
            hintText: S.current.import_hint,
            hintColor: AppTheme.colorHint,
            borderRadius: 8.w,
            maxLines: 4,
            showClear: false,
            style: TextStyle(
                color: AppTheme.colorFontOne,
                fontSize: ScreenUtil.fontSize15,
                fontWeight: FontWeight.w500),
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            height: 100.w,
            text: _mnemonic,
            onChange: (value) {
              _mnemonic = value;
              setState(() {
                _errorText = '';
              });
            },
          ),
          _subTitle(S.current.import_sub2),
          _itemPassword(1, S.current.new_password1),
          SizedBox(height: 20.w),
          _itemPassword(2, S.current.new_password2),
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
    );
  }

  _buildBottomButton() {
    return Padding(
      padding: EdgeInsets.only(top: 20.w, bottom: 38.w),
      child: LineButton(
        text: S.current.import,
        left: 10.5,
        onTap: () {
          if (_mnemonic.isEmpty) {
            ToastUtil.show(S.current.import_hint);
          } else if (_password1.isEmpty) {
            ToastUtil.show(S.current.new_password1);
          } else if (_password2.isEmpty) {
            ToastUtil.show(S.current.new_password2);
          } else if (_password1.length < 6 || _password1.length < 6) {
            setState(() {
              _errorText = S.current.limit_characters;
            });
          } else if (_password1 != _password2) {
            setState(() {
              _errorText = S.current.enter_same_password;
            });
          } else {
            _import();
          }
        },
      ),
    );
  }

  _import() async {
    try {
      EasyLoading.show();
      if (AptosAccount.isValidMnemonics(_mnemonic)) {
        var account = AptosAccount.generateAccount(_mnemonic);
        await KeyManager.setMnemonic(_mnemonic, _password1);
        final localMnemonic = await KeyManager.getMnemonic(_password1);
        if (_mnemonic == localMnemonic) {
          await KeyManager.setPassword(_password1);
          await StorageManager.setAddress(account.address);
        }
      } else {
        var privateKey = _mnemonic;
        var account = AptosAccount.fromPrivateKey(privateKey);
        await KeyManager.setPrivateKey(privateKey, _password1);
        final localPrivateKey = await KeyManager.getPrivateKey(_password1);
        if (privateKey == localPrivateKey) {
          await KeyManager.setPassword(_password1);
          await StorageManager.setAddress(account.address);
        }
      }
      EasyLoading.dismiss();
      route.navigateTo(context, Routes.root, replace: true);
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
      if (e is ArgumentError) {
        _errorText = e.message;
      } else {
        _errorText = e.toString();
      }
      setState(() {});
    }
  }
}
