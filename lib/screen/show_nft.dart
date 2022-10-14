import 'package:flutter/material.dart';
import 'package:gm/common/app_theme.dart';
import 'package:gm/generated/l10n.dart';
import 'package:gm/util/screen_util.dart';
import 'package:gm/widgets/line_button.dart';
import 'package:gm/widgets/nft_item.dart';

class ShowNftPage extends StatefulWidget {
  @override
  _ShowNftPageState createState() => _ShowNftPageState();
}

class _ShowNftPageState extends State<ShowNftPage> {
  @override
  Widget build(BuildContext context) {
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
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 108.w,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _subTile(),
                  GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 31.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 21.w,
                      crossAxisSpacing: 21.w,
                      childAspectRatio: 146 / 173,
                    ),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return NftItem();
                    },
                  ),
                ],
              ),
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  _subTile() {
    return Padding(
      padding: EdgeInsets.only(top: 30.w, bottom: 24.w, left: 31.w),
      child: Text(
        S.current.show_tip,
        style: TextStyle(
          color: AppTheme.colorFontGM,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  _buildBottomButton() {
    return Positioned(
      bottom: 0,
      left: 37.5.w,
      child: Padding(
        padding: EdgeInsets.only(top: 20.w, bottom: 38.w),
        child: LineButton(
          text: S.current.confirm,
          onTap: () {},
        ),
      ),
    );
  }
}
