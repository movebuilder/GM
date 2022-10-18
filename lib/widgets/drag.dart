import 'package:flutter/material.dart';
import 'package:gm/common/app_theme.dart';
import 'package:gm/modal/account_nft_list.dart';
import 'package:gm/util/image_utils.dart';
import 'package:gm/util/screen_util.dart';

class Drag extends StatefulWidget {
  final List<Nft> list;
  final bool firstInstall;
  final ScrollController? scrollController;

  const Drag({
    Key? key,
    required this.list,
    required this.firstInstall,
    this.scrollController,
  }) : super(key: key);

  @override
  _DragState createState() => _DragState();
}

class _DragState extends State<Drag> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.w),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppTheme.backgroundColor,
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                controller: widget.scrollController,
                child: Column(
                  children: _buildImageList(),
                ),
              ),
            ),
            if (widget.firstInstall)
              Positioned(
                top: 0,
                bottom: 0,
                left: 171.w,
                right: 171.w,
                child: imageUtils('line.svg'),
              ),
            if (widget.firstInstall)
              Positioned(
                top: 0,
                bottom: 0,
                left: 52.w,
                child: _buildChoose('skip.svg', 'Skip'),
              ),
            if (widget.firstInstall)
              Positioned(
                top: 0,
                bottom: 0,
                right: 52.w,
                child: _buildChoose('yes.svg', 'Match'),
              ),
          ],
        ),
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

  List<Widget> _buildImageList() {
    List<Widget> list = [];
    widget.list.forEach((element) {
      if (list.length < 6) {
        list.add(_itemImage(element.tokenUri ?? "", element.tokenName ?? ""));
      }
    });
    return list;
  }

  _itemImage(url, name) {
    return Container(
      width: 345.w,
      height: 345.w,
      child: Stack(
        children: [
          (url.endsWith('.png') || url.endsWith('.jpg') || url.endsWith('.svg'))
              ? imageNetworkUtils(
                  url,
                  width: 345.w,
                  height: 345.w,
                  fit: BoxFit.fill,
                )
              : Image.network(
                  url,
                  width: 345.w,
                  height: 345.w,
                  fit: BoxFit.fill,
                ),
          Positioned(
            right: 14.w,
            bottom: 14.w,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.w),
                color: AppTheme.colorFontGM.withOpacity(0.2),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.w),
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
