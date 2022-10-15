import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gm/common/app_theme.dart';
import 'package:gm/util/screen_util.dart';

class LineButton extends StatefulWidget {
  final String text;
  final int width;
  final int height;
  final num left;
  final num fontSize;
  final Color borderColor;
  final Function? onTap;

  LineButton({
    Key? key,
    required this.text,
    this.width = 300,
    this.height = 50,
    this.left = 0,
    this.fontSize = 18,
    this.borderColor = AppTheme.colorFontGM,
    this.onTap,
  }) : super(key: key);

  @override
  _LineButtonState createState() => _LineButtonState();
}

class _LineButtonState extends State<LineButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: widget.left.w),
      width: widget.width.w,
      height: widget.height.w,
      child: OutlinedButton(
        onPressed: () {
          if (widget.onTap != null) {
            widget.onTap!();
          }
        },
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.w),
          ),
          shadowColor: Colors.black87,
          side: BorderSide(width: 1.5.w, color: widget.borderColor),
        ),
        child: Container(
          width: 300.w,
          height: 50.w,
          alignment: Alignment.center,
          child: Text(
            widget.text,
            style: TextStyle(
              color: AppTheme.colorFontGM,
              fontSize: widget.fontSize.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
