import 'package:decimal/decimal.dart';
import 'package:drag_like/drag_like.dart';
import 'package:flutter/material.dart';
import 'package:gm/data/db/storage_manager.dart';
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

  List imageList = [];

  var showLine = false;

  void loadData() async {
    await Future.delayed(Duration(milliseconds: 100));
    imageList.addAll(data);
    if (StorageManager.getFirstInstall()) {
      showLine = true;
      StorageManager.setFirstInstall(false);
    }
    setState(() {});
  }

  void setBalance(balance) async {
    setState(() {
      _balance = balance;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          GmTop(title: 'GM', balance: _balance.toString()),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  _buildContent() {
    return Container(
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.w),
            child: DragLike(
              dragController: _dragController,
              duration: Duration(milliseconds: 520),
              child: imageList.length <= 0
                  ? Text('Loading...')
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8.w),
                      child: Drag(
                        src: imageList[0],
                        showLine: showLine,
                      ),
                    ),
              secondChild: imageList.length <= 1
                  ? Container()
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8.w),
                      child: Drag(
                        src: imageList[1],
                        showLine: false,
                      ),
                    ),
              screenWidth: 375,
              outValue: 0.8,
              dragSpeed: 1000,
              onChangeDragDistance: (distance) {
                if (!showLine) {
                  setState(() {
                    showLine = true;
                  });
                }
              },
              onOutComplete: (type) {
                /// left or right
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
                  showLine = false;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
