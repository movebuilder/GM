import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class ToastUtil {
  static ToastFuture show(String? message) {
    hideAll();
    return showToast(message ?? "",
        duration: Duration(seconds: 3),
        textPadding: EdgeInsets.all(10),
        radius: 5,
        position: ToastPosition.bottom,
        dismissOtherToast: false);
  }

  static void hide(ToastFuture toast, {bool animate = false}) {
    toast.dismiss(showAnim: animate);
  }

  static void hideAll({bool animate = false}) {
    dismissAllToast(showAnim: animate);
  }
}
