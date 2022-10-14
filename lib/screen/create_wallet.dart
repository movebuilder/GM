import 'package:flutter/material.dart';
import 'package:gm/aptos/wallet/key_manager.dart';
import 'package:gm/common/app_theme.dart';
import 'package:gm/generated/l10n.dart';
import 'package:gm/util/screen_util.dart';
import 'package:gm/widgets/gm_textfield.dart';
import 'package:gm/widgets/line_button.dart';

class CreateWalletPage extends StatefulWidget {
  @override
  _ImportWalletState createState() => _ImportWalletState();
}

class _ImportWalletState extends State<CreateWalletPage> {
  var mnemonic = '';
  var password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.fromLTRB(27.w, 55.w, 27.w, 38.w),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _title(),
          _subTitle('Create new password to unlock your wallet'),
          _itemPassword(),
          SizedBox(height: 20.w),
          _itemPassword(),
          Expanded(
              child: Container(
            height: 30.w,
          )),
          LineButton(
            text: 'Create',
            left: 10.5,
            onTap: () async {
              final mnemonic = KeyManager.generateMnemonic();
              await KeyManager.setMnemonic(mnemonic, password);
              final localMnemonic = await KeyManager.getMnemonic(password);
              if (mnemonic == localMnemonic) {

              }
            },
          ),
        ],
      ),
    ));
  }

  _title() {
    return Container(
      width: 375.w,
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
      padding: EdgeInsets.only(top: 30.w, bottom: 15.w),
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

  _itemPassword() {
    return GMTextField(
      hintText: 'New password',
      borderRadius: 8.w,
      style: TextStyle(
          color: AppTheme.colorFontOne,
          fontSize: ScreenUtil.fontSize15,
          fontWeight: FontWeight.w500),
      padding: EdgeInsets.only(left: 15.w),
      showPassword: true,
      isPassword: true,
      height: 56.w,
      text: password,
      leftIcon: 'assets/svgs/password.svg',
      onChange: (value) {
        password = value;
      },
    );
  }
}
