import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:gm/aptos/transaction/tx_builder.dart';
import 'package:gm/data/db/storage_manager.dart';
import 'package:gm/screen/chat/chat_list_screen.dart';
import 'package:gm/screen/gm/gm_screen.dart';
import 'package:gm/util/screen_util.dart';
import 'package:gm/widgets/gm_tab.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final gm = GmScreen();
  final chat = ChatListScreen();
  var activeTab = AppTab.gm;
  late TxBuilder builder;

  @override
  void initState() {
    super.initState();
    builder = TxBuilder();
  }

  void getBalance() async {
    try {
      final result =
          await builder.getBalanceByAddress(StorageManager.getAddress());
      StorageManager.setBalance(result);
      gm.setBalance(result);
      chat.setBalance(result);
    } catch (e) {
      print('getBalance error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.getInstance()
      ..width = 375
      ..height = 812
      ..init(context);
    return Scaffold(
      body: FocusDetector(
        onFocusGained: () {
          getBalance();
        },
        child: IndexedStack(
          children: <Widget>[gm, chat],
          index: AppTab.values.indexOf(activeTab),
        ),
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
