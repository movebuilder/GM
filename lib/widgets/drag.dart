import 'package:flutter/material.dart';
import 'package:gm/common/app_theme.dart';
import 'package:gm/util/image_utils.dart';
import 'package:gm/util/screen_util.dart';

class Drag extends StatefulWidget {
  final String src;
  final bool firstInstall;

  const Drag({
    Key? key,
    required this.src,
    required this.firstInstall,
  }) : super(key: key);

  @override
  _DragState createState() => _DragState();
}

class _DragState extends State<Drag> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.w),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppTheme.backgroundColor,
        child: Stack(
          children: [
            Positioned.fill(
              child: imageNetworkUtils(widget.src),
            ),
            if (widget.firstInstall)
              Positioned(
                top: 0,
                bottom: 0,
                left: 171.w,
                right: 171.w,
                child: imageUtils('line.svg'),
              ),
            if (widget.firstInstall)
              Positioned(
                top: 0,
                bottom: 0,
                left: 52.w,
                child: _buildChoose('skip.svg', 'Skip'),
              ),
            if (widget.firstInstall)
              Positioned(
                top: 0,
                bottom: 0,
                right: 52.w,
                child: _buildChoose('yes.svg', 'Match'),
              ),
          ],
        ),
      ),
    );
  }

  _buildChoose(svg, text) {
    return Container(
      width: 67.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 52.w),
          imageUtils(svg, width: 66.w),
          Container(
            height: 52.w,
            padding: EdgeInsets.only(top: 14.w),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
