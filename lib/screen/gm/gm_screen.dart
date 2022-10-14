import 'package:flutter/material.dart';
import 'package:gm/widgets/gm_top.dart';

class GmScreen extends StatefulWidget {
  @override
  _GmScreenState createState() => _GmScreenState();
}

class _GmScreenState extends State<GmScreen> {
  var _balance = '--';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [GmTop(title: 'GM', balance: _balance)],
      ),
    );
  }
}
