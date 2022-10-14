import 'package:flutter/material.dart';
import 'package:gm/common/app_theme.dart';
import 'package:gm/generated/l10n.dart';
import 'package:gm/util/screen_util.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.getInstance()
      ..width = 375
      ..height = 812
      ..init(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          S.current.show,
          style: TextStyle(
            color: AppTheme.colorFontOne,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: Container(),
    );
  }
}
