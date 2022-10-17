import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gm/common/app_theme.dart';
import 'package:gm/util/image_utils.dart';
import 'package:gm/util/precision_input_formatter.dart';
import 'package:gm/util/screen_util.dart';

class ChatTextField extends StatefulWidget {
  final bool isKeyboardVisible;
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final Function() sendMsg;
  final Function(String) transfer;

  const ChatTextField({
    Key? key,
    required this.isKeyboardVisible,
    required this.textEditingController,
    required this.focusNode,
    required this.sendMsg,
    required this.transfer,
  }) : super(key: key);

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  bool _showSendMessageIcon = false;
  bool _showTransferIcon = false;
  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = widget.textEditingController;
    textEditingController.addListener(() {
      if (!_showTransferIcon) {
        if (!_showSendMessageIcon && textEditingController.text.length > 0) {
          _showSendMessageIcon = true;
          setState(() {});
        } else if (_showSendMessageIcon &&
            textEditingController.text.length < 1) {
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
        : 10.w + (paddingBottom < 20.w ? 20.w - paddingBottom : 0);
    return Container(
      width: 375.w,
      decoration: BoxDecoration(
        color: AppTheme.colorWhite,
        border: new Border.all(
          color: AppTheme.colorHint.withOpacity(0.1),
          width: 1.w,
        ),
      ),
      padding: EdgeInsets.fromLTRB(15.w, 10.w, 0, bottom),
      child: Row(
        children: [
          _buildSendMessage(),
          Expanded(
            child: _showTransferIcon ? _buildTransferBtn() : _buildMessageBtn(),
          ),
        ],
      ),
    );
  }

  _buildSendMessage() {
    return Container(
      width: 300.w,
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
                'aptos.svg',
                width: 20.w,
              ),
            ),
          if (_showTransferIcon) SizedBox(width: 10.w),
          Expanded(
            child: TextField(
              controller: textEditingController,
              textInputAction: TextInputAction.send,
              cursorColor: AppTheme.colorRed,
              onChanged: (s) {},
              inputFormatters: _showTransferIcon
                  ? [PrecisionInputFormatter()]
                  : null,
              keyboardType: _showTransferIcon
                  ? TextInputType.numberWithOptions(decimal: true)
                  : TextInputType.text,
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
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.all(5.w),
        child: InkWell(
          child: imageUtils(
            _showSendMessageIcon ? "send.svg" : "transfer.svg",
            width: 30.w,
            height: 30.w,
          ),
          onTap: () {
            if (_showSendMessageIcon) {
              if (textEditingController.text.trim().length > 0) {
                widget.sendMsg();
              }
            } else {
              setState(() {
                _showTransferIcon = !_showTransferIcon;
              });
            }
          },
        ),
      ),
    );
  }

  _buildTransferBtn() {
    return Container(
      alignment: Alignment.center,
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.all(5.w),
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
          var text = textEditingController.text;
          if (_showTransferIcon && text.length > 0) {
            if (text != '0.') {
              widget.transfer(text);
            }
          } else {
            textEditingController.text = '';
            setState(() {
              _showTransferIcon = !_showTransferIcon;
            });
          }
        },
      ),
    );
  }
}
