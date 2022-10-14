import 'package:flutter/material.dart';
import 'package:gm/common/app_theme.dart';
import 'package:gm/util/screen_util.dart';
import 'package:gm/widgets/line_button.dart';

class SelectNftPage extends StatefulWidget {
  @override
  _SelectNftPageState createState() => _SelectNftPageState();
}

class _SelectNftPageState extends State<SelectNftPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Select NFT',
            style: TextStyle(
              color: AppTheme.colorFontOne,
              fontSize: 18.sp,
            ),
          ),
        ),
        body: Container(
          width: 375.w,
          //padding: EdgeInsets.only(top: 190.w),
          padding: EdgeInsets.only(
              top: ((ScreenUtil.screenHeight - ScreenUtil.statusBarHeight) *
                  0.077)),
          child: Column(
            children: <Widget>[
              Image.asset('assets/select.png', height: 96.w),
              Padding(
                padding: EdgeInsets.only(top: 22.w, bottom: 27.w),
                child: Text(
                  'You haven’t NFT\non your address',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.2,
                    fontSize: 18.sp,
                    color: Colors.black,
                  ),
                ),
              ),
              LineButton(
                text: 'Choose your photo',
                left: 10.5,
                onTap: () {
                  _choosePhoto();
                },
              ),
            ],
          ),
        ));
  }

  _choosePhoto(){

  }
}
