import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:gm/data/db/storage_manager.dart';
import 'package:gm/modal/chat_list.dart';
import 'package:gm/widgets/chat_list_item.dart';
import 'package:gm/widgets/gm_top.dart';

class ChatListScreen extends StatefulWidget {
  final _chatListScreenState = _ChatListScreenState();

  @override
  _ChatListScreenState createState() => _chatListScreenState;

  void setBalance(balance) => _chatListScreenState.setBalance(balance);
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<ChatList> _list = [];
  Decimal _balance = Decimal.zero;

  void setBalance(balance) async {
    if (mounted)
      setState(() {
        _balance = balance;
      });
  }

  @override
  void initState() {
    super.initState();
    _balance = StorageManager.getBalance();
    _list = StorageManager.getChatShortList();
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
              child: ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.only(top: 0),
                controller: ScrollController(),
                itemCount: _list.length,
                itemBuilder: (context, index) {
                  return ChatListItem(
                    _list[index],
                    index == 0,
                    index == _list.length - 1,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
