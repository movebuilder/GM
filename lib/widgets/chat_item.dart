import 'package:flutter/material.dart';
import 'package:gm/common/app_theme.dart';
import 'package:gm/util/image_utils.dart';
import 'package:gm/util/screen_util.dart';

class ChatItem extends StatefulWidget {
  bool isMine;
  String message;

  ChatItem({
    Key? key,
    required this.isMine,
    required this.message,
  }) : super(key: key);

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 15.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.isMine
            ? [
                Expanded(child: Container()),
                _buildMessage(),
                _buildAvatar(widget.isMine),
              ]
            : [
                _buildAvatar(widget.isMine),
                _buildFromMessage(),
              ],
      ),
    );
  }

  _buildAvatar(isMine) {
    return Container(
      width: 50.w,
      height: 42.w,
      padding: isMine ? EdgeInsets.only(left: 8.w) : null,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppTheme.colorRed.withOpacity(0.5),
              borderRadius: BorderRadius.all(Radius.circular(21.w)),
            ),
            width: 42.w,
            height: 42.w,
          ),
          // imageUtils(''),
          if (!isMine)
            Positioned(
              left: 28.w,
              top: 24.w,
              child: imageUtils(
                'aptos2.svg',
                width: 18.w,
                height: 18.w,
              ),
            )
        ],
      ),
    );
  }

  _buildMessage() {
    return Container(
      padding: EdgeInsets.all(12.w),
      constraints: BoxConstraints(
        maxWidth: 245.w,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14.w),
          topRight: Radius.circular(4.w),
          bottomLeft: Radius.circular(14.w),
          bottomRight: Radius.circular(14.w),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: List.of([
            Color(0xFFDBFF00),
            Color(0xFFFAFF00),
          ]),
        ),
      ),
      child: Text(
        widget.message,
        style: TextStyle(
          color: AppTheme.colorFontGM,
          fontSize: 16.sp,
          height: 1.37,
        ),
      ),
    );
  }

  _buildFromMessage() {
    return Container(
      padding: EdgeInsets.all(12.w),
      constraints: BoxConstraints(
        maxWidth: 245.w,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFF9FAF2),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4.w),
          topRight: Radius.circular(14.w),
          bottomLeft: Radius.circular(14.w),
          bottomRight: Radius.circular(14.w),
        ),
      ),
      child: Text(
        widget.message,
        style: TextStyle(
          color: AppTheme.colorFontGM,
          fontSize: 16.sp,
          height: 1.37,
        ),
      ),
    );
  }
}
