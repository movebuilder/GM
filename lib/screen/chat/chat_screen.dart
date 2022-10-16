import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:gm/common/app_theme.dart';
import 'package:gm/util/screen_util.dart';
import 'package:gm/widgets/chat_item.dart';
import 'package:gm/widgets/chat_textfield.dart';
import 'package:gm/widgets/expanded_viewport.dart';
import 'package:gm/widgets/gm_appbar.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ScrollController _scrollController = ScrollController();
  TextEditingController _textEditingController = TextEditingController();
  late FocusNode _textFieldFocusNode;

  var _messages = ['1', '2', '3', '4', '5', '6', '7', '4', '5', '6', '7'];

  @override
  void initState() {
    _textFieldFocusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colorWhite,
      body: KeyboardDismissOnTap(child:
          KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
        return Stack(
          children: [
            Positioned(
              top: 0,
              child: GmAppBar(
                title: '0x13..0998',
              ),
            ),
            Positioned(
              top: 94.w - ScreenUtil.statusBarHeight,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                child: SafeArea(
                  child: Column(
                    children: <Widget>[
                      _buildMessages(),
                      ChatTextField(
                        isKeyboardVisible: isKeyboardVisible,
                        textEditingController: _textEditingController,
                        scrollController: _scrollController,
                        callBack: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      })),
    );
  }

  _buildMessages() {
    return Expanded(
      child: Scrollable(
        controller: _scrollController,
        axisDirection: AxisDirection.up,
        viewportBuilder: (context, offset) {
          return ExpandedViewport(
            offset: offset,
            axisDirection: AxisDirection.up,
            slivers: <Widget>[
              SliverPadding(
                padding: EdgeInsets.only(top: 15.w),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (c, i) {
                      return ChatItem(
                        isMine: i % 2 == 0,
                        message: "If it's not what you want, don't ask for it",
                      );
                    },
                    childCount: _messages.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
