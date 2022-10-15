import 'package:flutter/material.dart';
import 'package:gm/common/app_theme.dart';
import 'package:gm/data/db/storage_manager.dart';
import 'package:gm/generated/l10n.dart';
import 'package:gm/util/common_util.dart';
import 'package:gm/util/image_utils.dart';
import 'package:gm/util/screen_util.dart';
import 'package:gm/widgets/line_button.dart';

class ApproveScreen extends StatefulWidget {
  @override
  _ApproveScreenState createState() => _ApproveScreenState();
}

class _ApproveScreenState extends State<ApproveScreen> {
  var _address = '';
  var _message = '';

  @override
  void initState() {
    super.initState();
    _address = StorageManager.getAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 62.w),
      child: Column(
        children: [
          _buildTitle(),
          SizedBox(height: 76.w),
          imageUtils('gm_circle.svg', width: 65.w, height: 65.w),
          SizedBox(height: 20.w),
          Text(
            S.current.approve_request,
            style: TextStyle(
              color: AppTheme.colorFontGM,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6.w),
          Text(
            'https://gm.xyz',
            style: TextStyle(
              color: AppTheme.colorGreyTwo,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 100.w),
          _buildMessage(),
          SizedBox(height: 20.w),
          LineButton(
            text: S.current.approve,
            width: 320,
          ),
          SizedBox(height: 15.w),
          LineButton(
            text: S.current.cancel,
            width: 320,
            borderColor: Colors.transparent,
          ),
        ],
      ),
    );
  }

  _buildTitle() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 9.w),
      decoration: BoxDecoration(
        color: AppTheme.colorGreyThree,
        borderRadius: BorderRadius.all(Radius.circular(5.w)),
      ),
      child: Text(
        'Account1 (${interceptFormat(_address,length: 4)})',
        style: TextStyle(
          color: AppTheme.colorFontGM,
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  _buildMessage() {
    return Container(
      width: 320.w,
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: AppTheme.colorGreyThree,
        borderRadius: BorderRadius.all(Radius.circular(5.w)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _getListWidget(),
      ),
    );
  }

  _getListWidget() {
    List<Widget> list = [];
    list.add(Text(
      _message.isEmpty ? S.current.details : S.current.message,
      style: TextStyle(
        color: AppTheme.colorFontGM,
        fontSize: 14.sp,
        height: 1,
        fontWeight: FontWeight.w500,
      ),
    ));
    list.add(SizedBox(height: 9.w));
    if (_message.isNotEmpty) {
      list.add(
        Text(
          _message,
          style: TextStyle(
            color: AppTheme.colorHint,
            fontSize: 14.sp,
            height: 1.4,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    } else {
      list.add(_itemTransaction(S.current.tokens, '--', top: 0));
      list.add(_itemTransaction(S.current.gas_fee, '--'));
      list.add(_itemTransaction(S.current.address, '--'));
      list.add(_itemTransaction(S.current.function, '--'));
    }
    return list;
  }

  _itemTransaction(text1, text2, {int top = 5}) {
    return Padding(
      padding: EdgeInsets.only(top: top.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text1,
            style: TextStyle(
                color: AppTheme.colorGreyTwo,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500),
          ),
          Text(
            text2,
            style: TextStyle(
              color: AppTheme.colorHint,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
