import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:gm/widgets/chat_list_item.dart';
import 'package:gm/widgets/gm_top.dart';

class ChatListScreen extends StatefulWidget {

  final _chatListScreenState = _ChatListScreenState();

  @override
  _ChatListScreenState createState() => _chatListScreenState;

  void setBalance(balance) => _chatListScreenState.setBalance(balance);

}

class _ChatListScreenState extends State<ChatListScreen> {

  var list = ['1', '2', '3', '4', '5', '6', '7'];

  Decimal _balance = Decimal.zero;

  void setBalance(balance) async {
    setState(() {
      _balance = balance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          GmTop(
            title: 'Chat',
            balance: _balance.toString(),
            lineWidth: 60,
          ),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 0),
            physics: AlwaysScrollableScrollPhysics(),
            controller: ScrollController(),
            itemCount: list.length,
            itemBuilder: (context, index) {
              return ChatListItem(index, index == 0, index == list.length - 1);
            },
          )
        ],
      ),
    );
  }
}
