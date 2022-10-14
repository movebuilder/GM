import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gm/common/app_theme.dart';
import 'package:gm/screen/create_wallet.dart';
import 'package:gm/screen/import_wallet.dart';
import 'package:gm/util/image_utils.dart';
import 'package:gm/util/screen_util.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(27.w, 160.w, 27.w, 0),
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
            Text(
              'GM',
              style: TextStyle(
                color: AppTheme.colorFontGM,
                fontSize: 64.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            _subTile('Create a new Aptos wallet'),
            _itemRegister('atpos.svg', 'Create Aptos Wallet'),
            _subTile('Import an existing Wallet'),
            _itemRegister('mnemonic.svg', 'Import Wallet'),
          ],
        ),
      ),
    );
  }

  _subTile(text) {
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

  _itemRegister(img, text) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return text == 'Import Wallet'
                  ? ImportWalletPage()
                  : CreateWalletPage();
            },
          ),
        );
      },
      child: Container(
        height: 60.w,
        width: 320.w,
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.colorFontGM, width: 1.5.w),
          borderRadius: BorderRadius.all(Radius.circular(8.w)),
        ),
        padding: EdgeInsets.only(left: 15.w, right: 25.w),
        child: Row(
          children: [
            imageUtils(
              img,
              width: 30.w,
              height: 30.w,
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: AppTheme.colorFontGM,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            imageUtils(
              'arrow-right.svg',
              width: 8.w,
            ),
          ],
        ),
      ),
    );
  }
}
