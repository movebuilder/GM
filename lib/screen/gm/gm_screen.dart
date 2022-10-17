import 'package:decimal/decimal.dart';
import 'package:drag_like/drag_like.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:gm/common/app_theme.dart';
import 'package:gm/data/db/storage_manager.dart';
import 'package:gm/util/image_utils.dart';
import 'package:gm/util/screen_util.dart';
import 'package:gm/widgets/drag.dart';
import 'package:gm/widgets/gm_top.dart';

class GmScreen extends StatefulWidget {
  final _gmScreenState = _GmScreenState();

  @override
  _GmScreenState createState() => _gmScreenState;

  void setBalance(balance) => _gmScreenState.setBalance(balance);
}

class _GmScreenState extends State<GmScreen> {
  Decimal _balance = Decimal.zero;

  DragController _dragController = DragController();
  List data = [
    'https://scpic2.chinaz.net/files/default/imgs/2022-10-08/ed217ec122a67134_s.jpg',
    'https://scpic2.chinaz.net/files/default/imgs/2022-10-12/bd7da34f0534db82_s.jpg'
  ];
  var tips = [
    "Good Morning",
    "Glad to message to you",
    "Good to match with you",
    "We All Gonna Make It",
  ];

  double rightStart = 0;
  double leftStart = 0;

  double y = 0;
  double scare1 = 1;
  double scare2 = 1;

  List imageList = [];

  var firstInstall = false;

  void loadData() async {
    await Future.delayed(Duration(milliseconds: 100));
    imageList.addAll(data);

    if (StorageManager.getFirstInstall()) {
      firstInstall = true;
      StorageManager.setFirstInstall(false);
    }
    setState(() {});
  }

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
    rightStart = 375.w;
    leftStart = -66.w;
    y = 304.5.w;
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          GmTop(title: 'GM', balance: _balance),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  _buildContent() {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.w),
          child: DragLike(
            dragController: _dragController,
            duration: Duration(milliseconds: 520),
            child: imageList.length <= 0
                ? _buildBackground()
                : _buildImage(imageList[0], firstInstall),
            secondChild: imageList.length <= 1
                ? _buildBackground()
                : _buildImage(imageList[1], false),
            screenWidth: 375.w,
            outValue: 0.8,
            dragSpeed: 1000,
            onChangeDragDistance: (distance) {
              var d = distance['distanceProgress'];
              if (distance['distance'] < 0) {
                scare1 = 1;
                scare2 = 1 + 1.7 * d;
                rightStart = 375.w;
                leftStart = -33.w + 175.w * d;
              } else {
                scare2 = 1;
                scare1 = 1 + 1.7 * d;
                leftStart = -33.w;
                rightStart = 375.w - 175.w * d;
              }
              firstInstall = false;
              setState(() {});
            },
            onOutComplete: (type) {
              print(type);
            },
            onScaleComplete: () {
              imageList.remove(imageList[0]);
              if (imageList.length == 0) {
                loadData();
              }
            },
            onPointerUp: () {
              setState(() {
                rightStart = 375.w;
                leftStart = -33.w;
                scare1 = 1;
                scare2 = 1;
              });
            },
          ),
        ),
        Transform.translate(
          offset: Offset(rightStart, y),
          child: Transform.scale(
            scale: scare1,
            child: imageUtils('yes.svg', width: 33.w, height: 33.w),
          ),
        ),
        Transform.translate(
          offset: Offset(leftStart, y),
          child: Transform.scale(
            scale: scare2,
            child: imageUtils('skip.svg', width: 33.w, height: 33.w),
          ),
        ),
      ],
    );
  }

  _buildImage(src, firstInstall) {
    return Stack(
      children: [
        _buildBackground(),
        ClipRRect(
          borderRadius: BorderRadius.circular(16.w),
          child: Drag(
            src: src,
            firstInstall: firstInstall,
          ),
        ),
      ],
    );
  }

  _buildBackground() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.w),
        color: AppTheme.colorWhite,
        border: Border.all(
          width: 2.w,
          color: AppTheme.colorGreyTwo.withOpacity(0.2),
        ),
      ),
      child: Container(
        height: 30.w,
        child: Swiper(
          itemBuilder: (context, index) {
            return Text(
              tips[index],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.colorGreyTwo,
                fontSize: 26.sp,
                fontWeight: FontWeight.bold,
              ),
            );
          },
          autoplay: true,
          duration: 500,
          itemCount: tips.length,
          scrollDirection: Axis.vertical,
          pagination: null,
        ),
      ),
    );
  }
}
