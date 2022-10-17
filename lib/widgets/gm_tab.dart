import 'package:flutter/material.dart';
import 'package:gm/util/image_utils.dart';
import 'package:gm/util/screen_util.dart';

class GmTab extends StatelessWidget {
  final int? unRead;
  final AppTab activeTab;
  final Function(AppTab) onTabSelected;

  GmTab({
    Key? key,
    required this.activeTab,
    required this.onTabSelected,
    this.unRead,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 70.w,
      padding: EdgeInsets.only(top: 4.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTab(1),
          SizedBox(width: 20.w),
          _buildTab(2),
        ],
      ),
    );
  }

  _buildTab(type) {
    return InkWell(
      onTap: () {
        if (type == 1) {
          onTabSelected(AppTab.gm);
        } else {
          onTabSelected(AppTab.chat);
        }
      },
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: imageUtils(
          type == 1
              ? activeTab == AppTab.gm
                  ? "gm2.svg"
                  : "gm1.svg"
              : activeTab == AppTab.chat
                  ? "chat2.svg"
                  : "chat1.svg",
          width: 31.w,
          height: 31.w,
        ),
      ),
    );
  }
}

enum AppTab {
  gm,
  chat,
}
