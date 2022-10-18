import 'dart:async';

import 'package:aptos/aptos.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:gm/aptos/transaction/chat_message.dart';
import 'package:gm/aptos/transaction/tx_builder.dart';
import 'package:gm/aptos/wallet/key_manager.dart';
import 'package:gm/common/app_theme.dart';
import 'package:gm/data/db/storage_manager.dart';
import 'package:gm/util/chat_util.dart';
import 'package:gm/util/common_util.dart';
import 'package:gm/util/screen_util.dart';
import 'package:gm/util/toast_util.dart';
import 'package:gm/widgets/chat_item.dart';
import 'package:gm/widgets/chat_textfield.dart';
import 'package:gm/widgets/expanded_viewport.dart';
import 'package:gm/widgets/gm_appbar.dart';

class ChatScreen extends StatefulWidget {
  final String chatAddress;
  final String nft;

  ChatScreen({
    required this.chatAddress,
    required this.nft,
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

  late FocusNode _focusNode;

  late Map<String, bool> _chatEnable;
  bool _myChatEnable = false;
  bool _sendChatEnable = false;
  bool _sendEnableChecked = false;

  Timer? _timer;
  List<String> _hashes = [];

  @override
  void initState() {
    super.initState();
    _chatAddress = widget.chatAddress;
    _myAddress = StorageManager.getAddress();
    _focusNode = FocusNode();
    _chatEnable = StorageManager.getChatEnable();
    _myChatEnable = _chatEnable[_myAddress] ?? false;
    _sendChatEnable = _chatEnable[_chatAddress] ?? false;
    _getList();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
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
                        focusNode: _focusNode,
                        sendMsg: () {
                          _scrollController.jumpTo(0.0);
                          var msg = _textEditingController.text;
                          _messages.add(ChatMessage(
                            msg,
                            MessageInfo(
                              _myAddress,
                              DateTime.now().microsecondsSinceEpoch.toString(),
                            ),
                            status: 1,
                          ));
                          _textEditingController.text = '';
                          setState(() {});
                          _sendMessage(msg);
                        },
                        transfer: (amount) {
                          _transfer(amount);
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
                        nft: widget.nft,
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
    var list = await txBuilder.getMessagesBySender(_myAddress, _chatAddress);
    setState(() {
      _messages = list;
    });
  }

  _sendMessage(message) async {
    try {
      EasyLoading.show();
      if (account == null) {
        await _getAccount();
      }
      if (!_myChatEnable) {
        var enable = await txBuilder.checkChatEnabled(_myAddress);
        if (enable) {
          _myChatEnable = true;
          _chatEnable[_myAddress] = true;
          await StorageManager.setChatEnable(_chatEnable);
        } else {
          await txBuilder.enableChat(account!);
          _myChatEnable = true;
          _chatEnable[_myAddress] = true;
          await StorageManager.setChatEnable(_chatEnable);
        }
      }
      await _checkChatEnable(_myAddress);
      var enable = await _checkChatEnable(_chatAddress);
      if (enable) {
        var m = await txBuilder.sendMessage(account!, _chatAddress, message);
        if (m['hash'].toString().length > 0) {
          _hashes.add(m['hash']);
          _messages[_messages.length - 1].hash = m['hash'];
        }
        _hashStatus();
      } else {
        setState(() {
          _messages[_messages.length - 1].status = 2;
        });
      }
    } catch (e) {
      setState(() {
        _messages[_messages.length - 1].status = 2;
      });
      ToastUtil.show('Transfer Error');
    } finally {
      EasyLoading.dismiss();
    }
  }

  _transfer(String amount) async {
    try {
      EasyLoading.show();
      if (account == null) {
        await _getAccount();
      }
      final result = await txBuilder.getBalanceByAddress(_myAddress);
      StorageManager.setBalance(result);
      var num = Decimal.parse(amount);
      if (num + Decimal.parse('0.000512') > result) {
        ToastUtil.show('Insufficient balance');
      } else {
        var a = (num * Decimal.fromInt(10).pow(8)).toString();
        var m = await txBuilder.transferAptos(account!, _chatAddress, a);
        setState(() {
          _textEditingController.text = '';
        });
        print("result $m");
        ToastUtil.show('Transfer Success');
      }
    } catch (e) {
      ToastUtil.show('Transfer Error');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<bool> _checkChatEnable(address) async {
    if (address == _myAddress) {
      if (!_myChatEnable) {
        var enable = await txBuilder.checkChatEnabled(_myAddress);
        if (enable) {
          _myChatEnable = true;
          _chatEnable[_myAddress] = true;
          await StorageManager.setChatEnable(_chatEnable);
        } else {
          await txBuilder.enableChat(account!);
          _myChatEnable = true;
          _chatEnable[_myAddress] = true;
          await StorageManager.setChatEnable(_chatEnable);
        }
      }
      return true;
    } else {
      if (!_sendChatEnable) {
        if (!_sendEnableChecked) {
          var enable = await txBuilder.checkChatEnabled(_chatAddress);
          _sendEnableChecked = true;
          if (enable) {
            _sendChatEnable = true;
            _chatEnable[_chatAddress] = true;
            await StorageManager.setChatEnable(_chatEnable);
          } else {
            ToastUtil.show('${interceptFormat(_chatAddress, length: 5)} '
                'does not have open session permissions');
            return false;
          }
        } else {
          ToastUtil.show('${interceptFormat(_chatAddress, length: 5)} '
              'does not have open session permissions');
          return false;
        }
      }
    }
    return true;
  }

  _hashStatus() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
    _timer = Timer.periodic(Duration(seconds: 1), (val) {
      if (_hashes.isEmpty) {
        _timer?.cancel();
        _timer = null;
      } else {
        _hashes.forEach((element) {
          _getHashStatus(element);
        });
      }
    });
  }

  _getHashStatus(hash) async {
    var pending = await txBuilder.isPending(hash);
    if (!pending) {
      _hashes.remove(hash);
      for (var i = _messages.length - 1; i > -1; i--) {
        if (_messages[i].hash == hash) {
          _messages[i].status = 2;
          await ChatUtil.updateChatList(_messages[i], _chatAddress);
          break;
        }
      }
      setState(() {});
    } else {
      _hashStatus();
    }
  }
}
