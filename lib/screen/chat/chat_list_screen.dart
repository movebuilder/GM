import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:gm/aptos/transaction/tx_builder.dart';
import 'package:gm/common/app_theme.dart';
import 'package:gm/data/db/storage_manager.dart';
import 'package:gm/modal/chat_list.dart';
import 'package:gm/util/image_utils.dart';
import 'package:gm/util/screen_util.dart';
import 'package:gm/widgets/chat_list_item.dart';
import 'package:gm/widgets/gm_top.dart';

class ChatListScreen extends StatefulWidget {
  final _chatListScreenState = _ChatListScreenState();

  @override
  _ChatListScreenState createState() => _chatListScreenState;

  void setBalance(balance) => _chatListScreenState.setBalance(balance);

  void updateLocalList() => _chatListScreenState.updateLocalList();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<ChatList> _list = [];
  Decimal _balance = Decimal.zero;
  var _myAddress;

  void setBalance(balance) async {
    if (mounted)
      setState(() {
        _balance = balance;
      });
  }

  void updateLocalList() {
    if (mounted)
      setState(() {
        _list = StorageManager.getChatShortList();
      });
  }

  @override
  void initState() {
    super.initState();
    _balance = StorageManager.getBalance();
    _myAddress = StorageManager.getAddress();
    _list = StorageManager.getChatShortList();
    // _getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            GmTop(
              title: 'Chat',
              balance: _balance,
              lineWidth: 60,
            ),
            Expanded(
              child: _list.isEmpty
                  ? _emptyShow()
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(top: 0),
                      controller: ScrollController(),
                      itemCount: _list.length,
                      itemBuilder: (context, index) {
                        return ChatListItem(
                          _list[index],
                          index,
                          index == _list.length - 1,
                          (index) async {
                            var l = StorageManager.getChatMatchAddress();
                            l.remove(_list[index].address);
                            await StorageManager.setChatMatchAddress(l);
                            _list.remove(_list[index]);
                            await StorageManager.setChatShortList(_list);
                            setState(() {});
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  _emptyShow() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          imageUtils('no_match.svg', width: 80.w),
          SizedBox(height: 17.w),
          Text(
            'No match',
            style: TextStyle(
                color: AppTheme.colorGreyTwo,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  _getList() async {
    try {
      final txBuilder = TxBuilder();
      final chatEnabled = await txBuilder.checkChatEnabled(_myAddress);
      if (!chatEnabled) {
        return;
      }

      List<ChatList> l = [];
      List<String> accounts = [];
      var list = await txBuilder.getMessages(_myAddress, "otherAddress");
      list.forEach((element) {
        var addr = element.info.sender;
        if (addr != _myAddress) {
          if (accounts.contains(addr)) {
            for (var i = 0; i < l.length; i++) {
              if (l[i].timestamp.compareTo(element.info.timestamp) < 0) {
                l[i] = ChatList(
                    address: addr,
                    timestamp: element.info.timestamp,
                    content: element.content);
                break;
              }
            }
          } else {
            accounts.add(addr);
            l.add(ChatList(
                address: addr,
                timestamp: element.info.timestamp,
                content: element.content));
          }
        }
      });
      if (l.isNotEmpty) {
        await StorageManager.setChatShortList(l);
      }
      setState(() {
        _list = l;
      });
    } catch (e) {
      print('_getList error: $e');
    }
  }
}
