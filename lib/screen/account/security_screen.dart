import 'package:flutter/material.dart';
import 'package:gm/aptos/wallet/key_manager.dart';
import 'package:gm/generated/l10n.dart';
import 'package:gm/route/routes.dart';
import 'package:gm/util/image_utils.dart';
import 'package:gm/util/screen_util.dart';
import 'package:gm/util/toast_util.dart';
import 'package:gm/widgets/gm_appbar.dart';
import 'package:gm/widgets/gm_textfield.dart';
import 'package:gm/widgets/line_button.dart';

class SecurityScreen extends StatefulWidget {
  @override
  _SecurityScreenState createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  var _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 94.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  imageUtils('secret.svg', width: 80),
                  SizedBox(height: 54.w),
                  GMTextField(
                    hintText: S.current.current_password,
                    width: 320.w,
                    padding: EdgeInsets.only(left: 15.w),
                    showPassword: true,
                    isPassword: true,
                    height: 55.w,
                    text: _password,
                    leftIcon: 'assets/svgs/password.svg',
                    onChange: (value) {
                      _password = value;
                    },
                  ),
                  SizedBox(height: 23.w),
                  LineButton(
                    text: S.current.confirm,
                    width: 320,
                    onTap: () {
                      _decrypt();
                    },
                  )
                ],
              ),
            ),
          ),
          Positioned(
            child: GmAppBar(title: S.current.security),
            top: 0,
          ),
        ],
      ),
    );
  }

  _decrypt() async {
    try {
      String secretPhrase = "";
      bool existMnemonics = await KeyManager.isExistMnemonic();
      if (existMnemonics) {
        secretPhrase = await KeyManager.getMnemonic(_password);
      } else {
        secretPhrase = await KeyManager.getPrivateKey(_password);
      }
      var path = '${Routes.secretPhrase}?mnemonic=$secretPhrase';
      Routes.navigateToInFormRight(context, path, replace: true);
    } catch (e) {
      ToastUtil.show(S.current.invalid_password);
      debugPrint('Mnemonic decrypt error: $e');
    }
  }
}
