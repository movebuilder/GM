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

  List<ChatMessage> _waitMessages = [];
  var _isSending = false;
  var _isTransfer = false;
  var _isHashing = false;

  var lastSendTime = '';

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
    if (!_myChatEnable) _checkChatEnable(_myAddress);
    if (!_sendChatEnable) _checkChatEnable(_chatAddress);

    Future.delayed(Duration(seconds: 2), _updateList);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  Future<void> _getAccount() async {
    final password = await KeyManager.getPassword();
    if (await KeyManager.isExistMnemonic()) {
      final mnemonics = await KeyManager.getMnemonic(password);
      account = AptosAccount.generateAccount(mnemonics);
    } else {
      final privateKey = await KeyManager.getPrivateKey(password);
      account = AptosAccount.fromPrivateKey(privateKey);
    }
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
              top: 94.w,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
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
                        var chat = ChatMessage(
                          msg,
                          MessageInfo(
                            _myAddress,
                            DateTime.now().microsecondsSinceEpoch.toString(),
                          ),
                          status: 1,
                        );
                        _messages.add(chat);
                        _waitMessages.add(chat);
                        _textEditingController.text = '';
                        setState(() {});
                        _sendMessage();
                      },
                      transfer: (amount) {
                        var chat = ChatMessage(
                          '',
                          MessageInfo(
                            _myAddress,
                            DateTime.now().microsecondsSinceEpoch.toString(),
                          ),
                          status: 1,
                          transferNum: amount,
                        );
                        _messages.add(chat);
                        _waitMessages.add(chat);
                        _textEditingController.text = '';
                        setState(() {});
                        _transfer();
                      },
                    ),
                  ],
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
                        myNft: '',
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
    var list = await txBuilder.getMessages(_myAddress, _chatAddress);
    if (list.isNotEmpty) {
      ChatUtil.updateChatList(list[list.length - 1], _chatAddress);
      lastSendTime = list[list.length - 1].info.timestamp;
    }
    setState(() {
      _messages = list;
    });
  }

  Future<bool> _checkEnables() async {
    try {
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
      if (!enable) {
        setState(() {
          _messages[_messages.length - 1].status = 3;
        });
        return false;
      } else {
        return true;
      }
    } catch (e) {
      setState(() {
        _messages[_messages.length - 1].status = 3;
      });
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }

  _sendMessage() async {
    if (!_isSending) {
      _isSending = true;
      for (var i = 0; i < _waitMessages.length; i++) {
        var element = _waitMessages[i];
        if (element.content.isNotEmpty) {
          try {
            var enable = await _checkEnables();
            if (!enable) return;
            var m = await txBuilder.sendMessage(
                account!, _chatAddress, element.content);
            if (m['hash'].toString().length > 0) {
              _hashes.add(m['hash']);
              _messages[_messages.length - 1].hash = m['hash'];
            }
            _updateMessage(element, 2);
            _hashStatus();
          } catch (e) {
            setState(() {});
            _updateMessage(element, 3);
          } finally {
            _isSending = false;
            _waitMessages.removeWhere((e) =>
                e.content == element.content &&
                e.info.timestamp == element.info.timestamp);
            if (_waitMessages
                .where((element) => element.content.isNotEmpty)
                .toList()
                .isNotEmpty) {
              Future.delayed(Duration(milliseconds: 1000), _sendMessage);
            }
          }
        }
        break;
      }
    }
  }

  Future<void> _transfer() async {
    if (!_isTransfer) {
      _isTransfer = true;
      for (var i = 0; i < _waitMessages.length; i++) {
        var element = _waitMessages[i];
        if (element.transferNum.isNotEmpty) {
          try {
            if (account == null) {
              await _getAccount();
            }
            final result = await txBuilder.getBalanceByAddress(_myAddress);
            StorageManager.setBalance(result);
            var num = Decimal.parse(element.transferNum);
            if (num + Decimal.parse('0.000512') > result) {
              ToastUtil.show('Insufficient balance');
              _updateMessage(element, 3);
            } else {
              var a = (num * Decimal.fromInt(10).pow(8)).toString();
              var m = await txBuilder.transferAptos(account!, _chatAddress, a);
              setState(() {
                _textEditingController.text = '';
              });
              print("result $m");
              _updateMessage(element, 2);
            }
          } catch (e) {
            _updateMessage(element, 3);
          } finally {
            _isTransfer = false;
            _waitMessages.removeWhere((e) =>
                e.transferNum == element.transferNum &&
                e.info.timestamp == element.info.timestamp);
            if (_waitMessages
                .where((element) => element.transferNum.isNotEmpty)
                .toList()
                .isNotEmpty) {
              Future.delayed(Duration(milliseconds: 2000), _transfer);
            }
          }
          break;
        }
      }
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

  _hashStatus() async {
    if (_hashes.isEmpty && !_isHashing) {
      try {
        _isHashing = true;
        var hash = _hashes[0];
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
        }
        _isHashing = false;
        _hashStatus();
      } catch (e) {
        _isHashing = false;
        _hashStatus();
      }
    }
  }

  _updateMessage(ChatMessage message, int status) {
    for (var i = _messages.length - 1; i > -1; i--) {
      if (_messages[i].info.timestamp == message.info.timestamp &&
          _messages[i].content == message.content &&
          _messages[i].transferNum == message.transferNum) {
        _messages[i].status = status;
        setState(() {});
        break;
      }
    }
  }

  _updateList() async {
    _timer = Timer.periodic(Duration(seconds: 1), (val) async {
      val.cancel();
      if (_sendEnableChecked && !_sendChatEnable) return;
      var list = await txBuilder.getMessages(_myAddress, _chatAddress);
      var update = false;
      list.forEach((element) {
        if (element.info.sender == _chatAddress &&
            element.info.timestamp.compareTo(lastSendTime) > 0) {
          update = true;
          if (_messages.isEmpty ||
              element.info.timestamp.compareTo(
                      _messages[_messages.length - 1].info.timestamp) >
                  0) {
            ChatUtil.updateChatList(element, _chatAddress);
          }
          _messages.add(element);
          lastSendTime = element.info.timestamp;
        }
      });
      if (mounted) {
        if (update) {
          setState(() {});
        }
        _updateList();
      }
    });
  }
}
