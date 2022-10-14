import 'package:flutter/material.dart';
import 'package:gm/common/app_theme.dart';
import 'package:gm/util/image_utils.dart';
import 'package:gm/util/screen_util.dart';

class GmAppBar extends StatelessWidget {
  final String title;

  GmAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375.w,
      height: 94.w,
      color: Colors.white,
      child: Stack(
        children: [
          Positioned(
            left: 0.w,
            bottom: 2.5.w,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: EdgeInsets.all(17.w),
                child: imageUtils(
                  'back.svg',
                  width: 8.w,
                  height: 15.w,
                ),
              ),
            ),
          ),
          Positioned(
            left: 100.w,
            right: 100.w,
            bottom: 1.w,
            child: Container(
              height: 54.w,
              alignment: Alignment.center,
              child: Text(
                title,
                style: TextStyle(
                  color: AppTheme.colorFontOne,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
            ),
          ),
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
