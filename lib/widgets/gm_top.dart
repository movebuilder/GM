import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gm/common/app_theme.dart';
import 'package:gm/util/image_utils.dart';
import 'package:gm/util/screen_util.dart';

class GmTop extends StatelessWidget {
  final String title;
  final String balance;
  final int lineWidth;

  GmTop({
    Key? key,
    required this.title,
    required this.balance,
    this.lineWidth = 48,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375.w,
      height: 88.w,
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
          Positioned(
            right: 10.w,
            top: 47.w,
            child: InkWell(
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
                        '$balance APT',
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
          )
        ],
      ),
    );
  }
}
