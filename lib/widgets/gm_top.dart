import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gm/common/app_theme.dart';
import 'package:gm/route/routes.dart';
import 'package:gm/util/image_utils.dart';
import 'package:gm/util/screen_util.dart';
import 'package:gm/util/common_util.dart';

class GmTop extends StatelessWidget {
  final String title;
  final Decimal? balance;
  final bool showBalance;
  final int lineWidth;
  final int height;

  GmTop({
    Key? key,
    required this.title,
    this.balance,
    this.showBalance = true,
    this.lineWidth = 48,
    this.height = 94,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375.w,
      height: height.w,
      color: Colors.white,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(left: 32.w, top: 72.w),
            width: lineWidth.w,
            height: 9.w,
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
          ),
          Positioned(
            left: 32.w,
            top: 52.w,
            child: Text(
              title,
              style: TextStyle(
                color: AppTheme.colorFontOne,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (showBalance)
            Positioned(
              right: 10.w,
              top: 47.w,
              child: InkWell(
                onTap: () {
                  route.navigateTo(context, Routes.account);
                },
                child: Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Row(
                    children: [
                      imageUtils(
                        'atpos.svg',
                        width: 18.w,
                        height: 18.w,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 7.5.w),
                        child: Text(
                          '${balance?.showBalance} APT',
                          style: TextStyle(
                            color: AppTheme.colorFontGM,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      imageUtils(
                        'arrow-right.svg',
                        width: 6.w,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (!showBalance)
            Positioned(
              right: 10.w,
              top: 46.w,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: EdgeInsets.all(10.w),
                  child: Icon(
                    Icons.close,
                    size: 22.w,
                    color: AppTheme.colorFontFour,
                  ),
                ),
              ),
            ),
          if (!showBalance)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Color(0x19A5AC5D),
                height: 1.w,
              ),
            )
        ],
      ),
    );
  }
}
