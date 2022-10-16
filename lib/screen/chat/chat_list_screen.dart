import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:gm/data/db/storage_manager.dart';
import 'package:gm/widgets/chat_list_item.dart';
import 'package:gm/widgets/gm_top.dart';

class ChatListScreen extends StatefulWidget {
  final _chatListScreenState = _ChatListScreenState();

  @override
  _ChatListScreenState createState() => _chatListScreenState;

  void setBalance(balance) => _chatListScreenState.setBalance(balance);
}

class _ChatListScreenState extends State<ChatListScreen> {
  var list = ['1', '2', '3', '4', '5', '6', '7', '3', '4', '5', '6', '7'];

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
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return ChatListItem(
                      index, index == 0, index == list.length - 1);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
