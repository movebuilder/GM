import 'package:flutter/material.dart';
import 'package:gm/common/app_theme.dart';
import 'package:gm/util/screen_util.dart';

class NftItem extends StatefulWidget {
  final Function()? onItemClickCallback;

  NftItem({
    Key? key,
    this.onItemClickCallback,
  }) : super(key: key);

  @override
  _NftItemState createState() => _NftItemState();
}

class _NftItemState extends State<NftItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onItemClickCallback?.call();
      },
      child: Container(
        decoration: BoxDecoration(
          border: new Border.all(
            color: AppTheme.colorFontGM,
            width: 1.5.w,
          ),
          borderRadius: BorderRadius.circular(8.w),
        ),
        width: 146.w,
        height: 173.w,
        child: Icon(
          Icons.add_circle,
          size: 30.w,
        ),
      ),
    );
  }
}
