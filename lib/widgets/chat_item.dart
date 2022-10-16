import 'package:flutter/material.dart';
import 'package:gm/aptos/transaction/chat_message.dart';
import 'package:gm/common/app_theme.dart';
import 'package:gm/data/db/storage_manager.dart';
import 'package:gm/util/image_utils.dart';
import 'package:gm/util/screen_util.dart';

class ChatItem extends StatelessWidget {
  final ChatMessage message;

  String get address => StorageManager.getAddress();

  ChatItem({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 15.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: message.info.sender == address
            ? [
                Expanded(child: Container()),
                _buildMessage(true),
                _buildAvatar(true),
              ]
            : [
                _buildAvatar(false),
                _buildMessage(false),
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

  _buildMessage(isMine) {
    return Column(
      crossAxisAlignment:
          isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          constraints: BoxConstraints(
            maxWidth: 245.w,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isMine ? 14.w : 4.w),
              topRight: Radius.circular(isMine ? 4.w : 14.w),
              bottomLeft: Radius.circular(14.w),
              bottomRight: Radius.circular(14.w),
            ),
            color: isMine ? null : Color(0xFFF9FAF2),
            gradient: isMine
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: List.of([
                      Color(0xFFDBFF00),
                      Color(0xFFFAFF00),
                    ]))
                : null,
          ),
          child: Text(
            message.content,
            style: TextStyle(
              color: AppTheme.colorFontGM,
              fontSize: 16.sp,
              height: 1.37,
            ),
          ),
        ),
        if (message.status > 0)
          Container(
            height: 24.w,
            alignment: Alignment.center,
            child: Text(
              message.status == 1 ? "Sending..." : "delivered",
              style: TextStyle(
                color: AppTheme.colorGreyTwo,
                fontSize: 14.sp,
              ),
            ),
          )
      ],
    );
  }
}
