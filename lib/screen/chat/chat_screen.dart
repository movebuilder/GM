import 'package:aptos/aptos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:gm/aptos/transaction/chat_message.dart';
import 'package:gm/aptos/transaction/tx_builder.dart';
import 'package:gm/aptos/wallet/key_manager.dart';
import 'package:gm/common/app_theme.dart';
import 'package:gm/data/db/storage_manager.dart';
import 'package:gm/util/common_util.dart';
import 'package:gm/util/screen_util.dart';
import 'package:gm/widgets/chat_item.dart';
import 'package:gm/widgets/chat_textfield.dart';
import 'package:gm/widgets/expanded_viewport.dart';
import 'package:gm/widgets/gm_appbar.dart';

class ChatScreen extends StatefulWidget {
  final String chatAddress;

  ChatScreen({
    required this.chatAddress,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ScrollController _scrollController = ScrollController();
  TextEditingController _textEditingController = TextEditingController();
  TxBuilder txBuilder = TxBuilder();

  List<ChatMessage> _messages = [];

  var _chatAddress;
  var _myAddress;

  AptosAccount? account;

  @override
  void initState() {
    super.initState();
    _chatAddress = widget.chatAddress;
    _myAddress = StorageManager.getAddress();
    // _getList();
    //_enableChat();
  }

  Future<void> _getAccount() async {
    var mnemonics =
        await KeyManager.getMnemonic(await KeyManager.getPassword());
    account = AptosAccount.generateAccount(mnemonics);
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
                title: interceptFormat(_chatAddress, length: 5),
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
                        sendMsg: () {
                          _scrollController.jumpTo(0.0);
                          var msg = _textEditingController.text;
                          _messages.add(ChatMessage(
                            msg,
                            MessageInfo(
                              _myAddress,
                              DateTime.now().microsecondsSinceEpoch.toString(),
                            ),
                            1,
                          ));
                          _textEditingController.text = '';
                          setState(() {});
                          //_sendMessage(msg);
                          //_enableChat();
                        },
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
              SliverExpanded(),
              SliverPadding(
                padding: EdgeInsets.only(top: 15.w),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (c, i) {
                      return ChatItem(
                        message: _messages[(_messages.length - 1) - i],
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

  _getList() async {
    print("_getList");

    var list = await txBuilder.getMessagesBySender(_myAddress, _chatAddress);
    print("list.length");
    setState(() {
      _messages = list;
    });
  }

  _enableChat() async {
    print("_enableChat");
    var m = await KeyManager.getMnemonic(await KeyManager.getPassword());
    var result = await txBuilder.enableChat(AptosAccount.generateAccount(m));
    print("result $result");
  }

  _sendMessage(message) async {
    if (account == null) {
      await _getAccount();
    }
    var m = await txBuilder.sendMessage(account!, _chatAddress, message);
    print("result $m");
  }
}
