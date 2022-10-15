import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gm/common/app_theme.dart';
import 'package:gm/generated/l10n.dart';
import 'package:gm/util/screen_util.dart';

import 'gradient_text.dart';
import 'line_button.dart';

class ChatListItem extends StatelessWidget {
  const ChatListItem(this.index, this.isFirst, this.isLast);

  final int index;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(index),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {}),
        dragDismissible: false,
        children: [
          SlidableAction(
            onPressed: (context) {},
            backgroundColor: Color(0xFFFA4B55),
            foregroundColor: Colors.white,
            label: S.current.unmatch,
            padding: EdgeInsets.symmetric(horizontal: 15.w),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  if (index == 0) Container(height: 10.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    height: 80.w,
                    child: Row(
                      children: [
                        Container(
                          width: 57.w,
                          height: 80.w,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 19.w,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(21.w),
                                  child: Container(
                                    color: AppTheme.colorRed.withOpacity(0.5),
                                    width: 42.w,
                                    height: 42.w,
                                  ),
                                ),
                              ),
                              Positioned(
                                  top: 17.w,
                                  left: index % 2 == 0 ? 31.w : 28.w,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Container(
                                      height: 18.w,
                                      constraints: BoxConstraints(
                                        minWidth: 18.w,
                                      ),
                                      alignment: Alignment.center,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5.w),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.w),
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
                                        index % 2 == 0 ? '1' : '99',
                                        style: TextStyle(
                                          color: AppTheme.colorFontGM,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '0x2728...8916',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.sp,
                                  color: AppTheme.colorFontOne,
                                ),
                              ),
                              SizedBox(height: 5.w),
                              Container(
                                width: 187.w,
                                child: index % 2 == 0
                                    ? GradientText(
                                        S.current.new_match,
                                        style: TextStyle(fontSize: 14.sp),
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            AppTheme.colorBtnGradientStart,
                                            AppTheme.colorBtnGradientEnd,
                                          ],
                                        ),
                                      )
                                    : Text(
                                        'hhhh, why you are so happy',
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: AppTheme.colorFontThree,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                              )
                            ],
                          ),
                        ),
                        index % 2 == 0
                            ? LineButton(
                                text: S.current.gm_now,
                                width: 90,
                                height: 30,
                                fontSize: 12,
                              )
                            : Container(
                                height: 80.w,
                                padding: EdgeInsets.only(top: 20.w),
                                alignment: Alignment.topRight,
                                child: Text(
                                  '04/02/2022',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppTheme.colorFontThree,
                                  ),
                                ),
                              )
                      ],
                    ),
                  ),
                  if (!isLast)
                    Container(
                      height: 0.5.w,
                      margin: EdgeInsets.only(left: 72.w),
                      color: AppTheme.colorGreyOne,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
