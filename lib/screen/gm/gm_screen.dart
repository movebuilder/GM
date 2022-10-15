import 'package:drag_like/drag_like.dart';
import 'package:flutter/material.dart';
import 'package:gm/data/db/storage_manager.dart';
import 'package:gm/util/image_utils.dart';
import 'package:gm/util/screen_util.dart';
import 'package:gm/widgets/gm_top.dart';

class GmScreen extends StatefulWidget {
  @override
  _GmScreenState createState() => _GmScreenState();
}

class _GmScreenState extends State<GmScreen> {
  var _balance = '--';

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
          GmTop(title: 'GM', balance: _balance),
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
                if(!showLine){
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

class Drag extends StatefulWidget {
  final String src;
  final bool showLine;

  const Drag({
    Key? key,
    required this.src,
    required this.showLine,
  }) : super(key: key);

  @override
  _DragState createState() => _DragState();
}

class _DragState extends State<Drag> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey,
      child: Stack(
        children: [
          Positioned.fill(
            child: imageNetworkUtils(widget.src),
          ),
          if (widget.showLine)
            Positioned(
              top: 0,
              bottom: 0,
              left: 171.w,
              right: 171.w,
              child: imageUtils('line.svg'),
            ),
          if (widget.showLine)
            Positioned(
              top: 0,
              bottom: 0,
              left: 52.w,
              child: _buildChoose('skip.svg', 'Skip'),
            ),
          if (widget.showLine)
            Positioned(
              top: 0,
              bottom: 0,
              right: 52.w,
              child: _buildChoose('yes.svg', 'Match'),
            ),
        ],
      ),
    );
  }

  _buildChoose(svg, text) {
    return Container(
      width: 67.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 52.w),
          imageUtils(svg, width: 66.w),
          Container(
            height: 52.w,
            padding: EdgeInsets.only(top: 14.w),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
