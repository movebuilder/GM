import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:gm/common/app_theme.dart';
import 'package:gm/route/routes.dart';
import 'package:gm/util/screen_util.dart';
import 'package:gm/widgets/line_button.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  var tips = [
    "Good\nMorning",
    "Glad to message to you",
    "Good to match with you",
    "We All Gonna Make It",
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.getInstance()
      ..width = 375
      ..height = 812
      ..init(context);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(36.w, 160.w, 36.w, 38.w),
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
            Container(
              height: 100.w,
              margin: EdgeInsets.only(top: 24.w),
              child: Swiper(
                itemBuilder: (context, index) {
                  return Text(
                    tips[index],
                    style: TextStyle(
                      color: AppTheme.colorFontGM,
                      fontSize: 40.sp,
                      height: 1.2,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
                autoplay: true,
                duration: 500,
                itemCount: tips.length,
                scrollDirection: Axis.vertical,
                pagination: null,
              ),
            ),
            Expanded(child: Container()),
            LineButton(
              text: 'GM NOW',
              left: 1.5,
              onTap: () {
                Routes.navigateToInFormRight(context, Routes.register,
                    replace: true);
              },
            ),
          ],
        ),
      ),
    );
  }
}
