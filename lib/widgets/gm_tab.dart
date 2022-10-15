import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gm/common/app_theme.dart';
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
    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: Container(
            width: 155.w,
            margin: EdgeInsets.symmetric(horizontal: 110.w),
            child: BottomNavigationBar(
              elevation: 0,
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              currentIndex: AppTab.values.indexOf(activeTab),
              onTap: (index) => onTabSelected(AppTab.values[index]),
              items: AppTab.values.map((tab) {
                return BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: 9.w),
                    child: imageUtils(
                      tab == AppTab.gm ? "gm1.svg" : "chat1.svg",
                      width: 31.w,
                    ),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.only(top: 9.w),
                    child: imageUtils(
                      tab == AppTab.gm ? "gm2.png" : "chat2.png",
                      width: 31.w,
                    ),
                  ),
                  label: '',
                );
              }).toList(),
            ),
          ),
        ),
        if (unRead != null && unRead! > 0)
          Positioned(
            top: 6.5.w,
            left: 242.w,
            child: Container(
              height: 18.w,
              constraints: BoxConstraints(
                minWidth: 24.w,
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.w),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: List.of([
                    AppTheme.colorBtnGradientStart,
                    AppTheme.colorBtnGradientEnd,
                  ]),
                ),
              ),
              child: Text(
                unRead.toString(),
                style: TextStyle(
                  color: AppTheme.colorFontGM,
                  fontSize: 12.sp,
                ),
              ),
            ),
          )
      ],
    );
  }
}

enum AppTab {
  gm,
  chat,
}
