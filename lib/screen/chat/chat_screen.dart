import 'package:flutter/material.dart';
import 'package:gm/widgets/gm_top.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          GmTop(
            title: 'Chat',
            lineWidth: 60,
          ),
        ],
      ),
    );
  }
}
