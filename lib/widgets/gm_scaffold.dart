import 'package:flutter/material.dart';
import 'package:gm/util/screen_util.dart';

import 'gm_appbar.dart';

class GmScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Color background;

  GmScaffold({
    Key? key,
    required this.title,
    required this.body,
    this.background = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          Positioned.fill(
            top: 94.w,
            child: body,
          ),
          Positioned(
            child: GmAppBar(title: title),
            top: 0,
          ),
        ],
      ),
    );
  }
}
