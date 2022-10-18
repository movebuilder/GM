import 'package:decimal/decimal.dart';
import 'package:drag_like/drag_like.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:gm/common/app_theme.dart';
import 'package:gm/data/db/storage_manager.dart';
import 'package:gm/modal/account_nft_list.dart';
import 'package:gm/modal/chat_list.dart';
import 'package:gm/util/common_util.dart';
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
  ScrollController _scrollController = ScrollController();

  List<AccountNftList> data = [];
  var tips = [
    "Good Morning",
    "Glad to message you",
    "Good to match with you",
    "We All Gonna Make It",
  ];

  double rightStart = 0;
  double leftStart = 0;

  double y = 0;
  double scare1 = 1;
  double scare2 = 1;

  var firstInstall = false;

  void _getList() async {
    await Future.delayed(Duration(milliseconds: 2000));
    data = await getAccountNftList();
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
    _getList();

    // var a = '0xc0670a06df6afced1cf66c5d8e198af4117e0eb2cee123a8bcac40a3866ea9df';
    // var list = StorageManager.getChatShortList();
    // list.add(
    //   ChatList(
    //     address: a,
    //     nftImg:  "",
    //     newMatch: true,
    //   ),
    // );
    // StorageManager.addChatMatchAddress(a);
    // StorageManager.setChatShortList(list);
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
          child: data.length <= 0
              ? _buildBackground()
              : DragLike(
                  dragController: _dragController,
                  duration: Duration(milliseconds: 520),
                  child: data.length <= 0
                      ? _buildBackground()
                      : Drag(
                          list: data[0].nft ?? [],
                          firstInstall: firstInstall,
                          scrollController: _scrollController,
                        ),
                  secondChild: data.length <= 1
                      ? _buildBackground()
                      : Drag(
                          list: data[1].nft ?? [],
                          firstInstall: false,
                        ),
                  screenWidth: 375,
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
                    if (type == "right") {
                      var list = StorageManager.getChatShortList();
                      list.add(
                        ChatList(
                          address: data[0].address ?? "",
                          nftImg: data[0].nft![0].tokenUri ?? "",
                          newMatch: true,
                        ),
                      );
                      StorageManager.addChatMatchAddress(data[0].address ?? "");
                      StorageManager.setChatShortList(list);
                    } else {
                      StorageManager.addUnChatMatchAddress(data[0].address ?? "");
                    }
                  },
                  onScaleComplete: () {
                    data.remove(data[0]);
                    if (data.length == 0) {
                      _getList();
                    }
                    setState(() {});
                  },
                  onPointerUp: () {
                    setState(() {
                      rightStart = 375.w;
                      leftStart = -33.w;
                      scare1 = 1;
                      scare2 = 1;
                    });
                    _scrollController.animateTo(.0,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.ease);
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

  _buildBackground() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.all(0.8.w),
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
