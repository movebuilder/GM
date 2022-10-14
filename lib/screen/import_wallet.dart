import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:gm/common/app_theme.dart';
import 'package:gm/generated/l10n.dart';
import 'package:gm/util/screen_util.dart';
import 'package:gm/widgets/gm_textfield.dart';
import 'package:gm/widgets/line_button.dart';

class ImportWalletPage extends StatefulWidget {
  @override
  _ImportWalletState createState() => _ImportWalletState();
}

class _ImportWalletState extends State<ImportWalletPage> {
  var mnemonic = '';
  var password1 = '';
  var password2 = '';
  var password3 = '';
  var password4 = '';
  var password5 = '';

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
      borderRadius: 8.w,
      style: TextStyle(
          color: AppTheme.colorFontOne,
          fontSize: ScreenUtil.fontSize15,
          fontWeight: FontWeight.w500),
      padding: EdgeInsets.only(left: 15.w),
      showPassword: true,
      isPassword: true,
      height: 56.w,
      text: type == 1 ? password1 : password2,
      leftIcon: 'assets/svgs/password.svg',
      onChange: (value) {
        if (type == 1) {
          password1 = value;
        } else {
          password2 = value;
        }
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
            borderRadius: 8.w,
            maxLines: 4,
            style: TextStyle(
                color: AppTheme.colorFontOne,
                fontSize: ScreenUtil.fontSize15,
                fontWeight: FontWeight.w500),
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            height: 100.w,
            text: mnemonic,
            onChange: (value) {
              mnemonic = value;
            },
          ),
          _subTitle(S.current.import_sub2),
          _itemPassword(1, S.current.new_password1),
          SizedBox(height: 20.w),
          _itemPassword(2, S.current.new_password2),
          SizedBox(height: 20.w),
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
        onTap: () {},
      ),
    );
  }
}
