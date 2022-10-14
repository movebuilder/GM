import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gm/common/app_theme.dart';
import 'package:gm/generated/l10n.dart';
import 'package:gm/util/screen_util.dart';
import 'package:gm/util/toast_util.dart';
import 'package:gm/widgets/gm_appbar.dart';
import 'package:gm/widgets/line_button.dart';

class SecretPhraseScreen extends StatefulWidget {
  final String mnemonic;

  SecretPhraseScreen({
    required this.mnemonic,
  });

  @override
  _SecretPhraseScreenState createState() => _SecretPhraseScreenState();
}

class _SecretPhraseScreenState extends State<SecretPhraseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
            GmAppBar(title: S.current.secret_phrase),
            Container(
              width: 375.w,
              padding: EdgeInsets.fromLTRB(29.w, 65.w, 0, 15.w),
              child: Text(
                S.current.import_sub1,
              ),
            ),
            Container(
              width: 320.w,
              padding: EdgeInsets.all(20.w),
              constraints: BoxConstraints(
                minHeight: 150.w,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.w)),
                border: Border.all(
                  width: 1.5.w,
                  color: AppTheme.colorFontGM,
                ),
              ),
              child: Text(
                widget.mnemonic,
                style: TextStyle(
                  height: 1.2,
                  fontSize: 16.sp,
                  color: AppTheme.colorFontGM,
                ),
              ),
            ),
            Container(
              width: 320.w,
              margin: EdgeInsets.only(top: 22.w, bottom: 58.w),
              child: Text(
                S.current.tip,
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1.3,
                  fontSize: 16.sp,
                ),
              ),
            ),
            LineButton(
              text: S.current.copy,
              width: 320,
              onTap: () {
                Clipboard.setData(ClipboardData(text: widget.mnemonic))
                    .then((val) {
                  ToastUtil.show(S.current.copied);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
