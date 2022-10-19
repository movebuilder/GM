import 'package:flutter/material.dart';
import 'package:gm/aptos/transaction/chat_message.dart';
import 'package:gm/common/app_theme.dart';
import 'package:gm/data/db/storage_manager.dart';
import 'package:gm/util/image_utils.dart';
import 'package:gm/util/screen_util.dart';

class ChatItem extends StatelessWidget {
  final ChatMessage message;
  final String nft;
  final String myNft;

  String get address => StorageManager.getAddress();

  ChatItem({
    Key? key,
    required this.message,
    required this.nft,
    required this.myNft,
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
    var url = isMine ? myNft : nft;
    return Container(
      width: 50.w,
      height: 42.w,
      padding: isMine ? EdgeInsets.only(left: 8.w) : null,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(21.w),
            child: (url.isEmpty ||
                    url.endsWith('.png') ||
                    url.endsWith('.jpg') ||
                    url.endsWith('.svg'))
                ? imageNetworkUtils(
                    url,
                    width: 42.w,
                    height: 42.w,
                    placeholder: 'avatar.png',
                  )
                : Image.network(
                    url,
                    width: 42.w,
                    height: 42.w,
                  ),
          ),
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
            message.transferNum.isNotEmpty
                ? 'I sent ${message.transferNum} APT to you '
                : message.content,
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
              message.status == 1
                  ? "Sending..."
                  : message.status == 2
                      ? "delivered"
                      : "failed",
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
