import 'package:flutter/material.dart';
import 'package:gm/common/app_theme.dart';
import 'package:gm/util/image_utils.dart';
import 'package:gm/util/screen_util.dart';

class ChatTextField extends StatefulWidget {
  final bool isKeyboardVisible;
  final TextEditingController textEditingController;
  final ScrollController scrollController;
  final Function() callBack;

  const ChatTextField({
    Key? key,
    required this.isKeyboardVisible,
    required this.textEditingController,
    required this.scrollController,
    required this.callBack,
  }) : super(key: key);

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  bool _showSendMessageIcon = false;
  bool _showTransferIcon = false;

  @override
  void initState() {
    super.initState();
    widget.textEditingController.addListener(() {
      if (!_showTransferIcon) {
        if (!_showSendMessageIcon &&
            widget.textEditingController.text.length > 0) {
          _showSendMessageIcon = true;
          setState(() {});
        } else if (_showSendMessageIcon &&
            widget.textEditingController.text.length < 1) {
          _showSendMessageIcon = false;
          setState(() {});
        }
      } else {
        setState(() {
          _showSendMessageIcon = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var paddingBottom = MediaQuery.of(context).padding.bottom;
    double bottom = widget.isKeyboardVisible
        ? 10.w
        : 10.w + (paddingBottom < 20.w ? 20.w : 0);
    return Container(
      color: AppTheme.colorWhite,
      width: 375.w,
      padding: EdgeInsets.fromLTRB(15.w, 10.w, 0, bottom),
      child: Row(
        children: [
          _buildSendMessage(),
          SizedBox(width: 14.w),
          if (_showTransferIcon) _buildTransferBtn(),
          if (_showTransferIcon) SizedBox(width: 14.w),
          _buildMessageBtn(),
        ],
      ),
    );
  }

  _buildSendMessage() {
    return Container(
      width: _showTransferIcon ? 248.w : 302.w,
      constraints: BoxConstraints(
        minHeight: 40.w,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.w),
        border: Border.all(
          width: .5,
          color: AppTheme.colorGreyOne,
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 15.w),
          if (_showTransferIcon)
            Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: imageUtils(
                'atpos.svg',
                width: 20.w,
              ),
            ),
          Expanded(
            child: TextField(
              maxLines: null,
              onTap: () {
                widget.callBack();
              },
              controller: widget.textEditingController,
              textInputAction: TextInputAction.send,
              cursorColor: AppTheme.colorRed,
              onSubmitted: (s) {},
              decoration: InputDecoration(
                hintText: _showTransferIcon ? '0.00' : 'New Message',
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 20.w - 12),
                hintStyle: TextStyle(
                  color: AppTheme.colorFontFour,
                  fontSize: ScreenUtil.fontSize16,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          if (_showTransferIcon)
            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Text(
                'APT',
                style: TextStyle(
                  color: AppTheme.colorFontGM,
                  fontSize: ScreenUtil.fontSize16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          SizedBox(width: 15.w),
        ],
      ),
    );
  }

  _buildMessageBtn() {
    return InkWell(
      child: imageUtils(
        _showSendMessageIcon ? "send.png" : "transfer.svg",
        width: 30.w,
        height: 30.w,
      ),
      onTap: () {
        if (_showSendMessageIcon) {
        } else {
          setState(() {
            _showTransferIcon = !_showTransferIcon;
          });
        }
      },
    );
  }

  _buildTransferBtn() {
    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.w),
        child: Text(
          'Send',
          style: TextStyle(
            color: AppTheme.colorFontGM,
            fontSize: ScreenUtil.fontSize16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      onTap: () {
        if (_showSendMessageIcon) {
        } else {
          setState(() {
            _showTransferIcon = !_showTransferIcon;
          });
        }
      },
    );
  }
}
