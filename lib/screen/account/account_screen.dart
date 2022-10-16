import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gm/common/app_theme.dart';
import 'package:gm/data/db/storage_manager.dart';
import 'package:gm/generated/l10n.dart';
import 'package:gm/route/routes.dart';
import 'package:gm/util/common_util.dart';
import 'package:gm/util/image_utils.dart';
import 'package:gm/util/screen_util.dart';
import 'package:gm/util/toast_util.dart';
import 'package:gm/widgets/gm_top.dart';
import 'package:gm/widgets/line_button.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  Decimal _balance = Decimal.zero;
  var _address = '';

  @override
  void initState() {
    super.initState();
    _balance = StorageManager.getBalance();
    _address = StorageManager.getAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          GmTop(
            title: 'Wallet',
            showBalance: false,
            height: 94,
            lineWidth: 80,
          ),
          _buildInfo(),
          _buildBalance(),
          _buildBtn(),
          _buildAsset(),
        ],
      ),
    );
  }

  _buildInfo() {
    return Container(
      margin: EdgeInsets.fromLTRB(24.w, 23.w, 0, 23.w),
      child: Row(
        children: [
          Container(
            width: 70.w,
            height: 70.w,
            margin: EdgeInsets.only(right: 15.w),
            decoration: BoxDecoration(
              color: AppTheme.colorFontGM,
              borderRadius: BorderRadius.all(Radius.circular(8.w)),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40.w,
                padding: EdgeInsets.only(top: 3.w),
                child: Text(
                  "Account",
                  style: TextStyle(
                    color: AppTheme.colorFontGM,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (_address.isNotEmpty) {
                    Clipboard.setData(ClipboardData(text: _address))
                        .then((val) {
                      ToastUtil.show(S.current.copied);
                    });
                  }
                },
                child: Container(
                  height: 30.w,
                  padding: EdgeInsets.symmetric(horizontal: 11.w),
                  decoration: BoxDecoration(
                    color: AppTheme.colorGreyThree,
                    borderRadius: BorderRadius.all(Radius.circular(5.w)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        interceptFormat(_address),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.w),
                        child: imageUtils('copy.svg', width: 11.w),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  _buildBalance() {
    return Container(
      margin: EdgeInsets.fromLTRB(28.w, 25.w, 0, 50.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _balance.showBalance,
            style: TextStyle(
              color: AppTheme.colorFontGM,
              fontWeight: FontWeight.bold,
              fontSize: 40.sp,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w, bottom: 5.w),
            child: Text(
              'APT',
              style: TextStyle(
                color: AppTheme.colorGreyTwo,
                fontSize: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildBtn() {
    return Container(
      margin: EdgeInsets.fromLTRB(27.w, 0, 27.w, 30.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LineButton(
            text: S.current.airdrop,
            width: 150,
            fontSize: 17,
          ),
          LineButton(
            text: S.current.secret_phrase,
            width: 150,
            fontSize: 17,
            onTap: () {
              Routes.navigateToInFormRight(context, Routes.security);
            },
          ),
        ],
      ),
    );
  }

  _buildAsset() {
    return Container(
      height: 70.w,
      margin: EdgeInsets.symmetric(horizontal: 27.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.w)),
        border: Border.all(
          width: 1.w,
          color: AppTheme.colorGreyOne,
        ),
      ),
      child: Row(
        children: [
          imageUtils('aptos.svg', width: 34.w),
          SizedBox(width: 12.w),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "APTOS",
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
              SizedBox(height: 5.w),
              Text(
                "APT",
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: AppTheme.colorGreyTwo,
                  fontSize: 12.sp,
                  height: 1,
                ),
              ),
            ],
          ),
          Expanded(
            child: Text(
              "${_balance.showBalance} APT",
              textAlign: TextAlign.end,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
