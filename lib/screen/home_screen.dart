import 'package:flutter/material.dart';
import 'package:gm/screen/chat/chat_screen.dart';
import 'package:gm/screen/gm/gm_screen.dart';
import 'package:gm/util/screen_util.dart';
import 'package:gm/widgets/gm_tab.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final gm = GmScreen();
  final chat = ChatScreen();
  var activeTab = AppTab.gm;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.getInstance()
      ..width = 375
      ..height = 812
      ..init(context);
    return Scaffold(
      body: IndexedStack(
        children: <Widget>[gm, chat],
        index: AppTab.values.indexOf(activeTab),
      ),
      bottomNavigationBar: GmTab(
          activeTab: activeTab,
          unRead: 10,
          onTabSelected: (tab) {
            setState(() {
              activeTab = tab;
            });
          }),
    );
  }
}
