import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
class ToastUtils {
  static void showLoading({String status = 'Loading...'}) {
    EasyLoading.show(status: status );
  }

  static void hideLoading() {
    EasyLoading.dismiss();
  }

  static void showSuccess(String message, {Duration? duration}) {
    EasyLoading.showSuccess(message,
        duration: duration ?? const Duration(seconds: 2));
  }

  static void showError(String message, {Duration? duration}) {
    EasyLoading.showError(message,
        duration: duration ?? const Duration(seconds: 3));
  }

  static void showInfo(String message, {Duration? duration}) {
    EasyLoading.showInfo(message,
        duration: duration ?? const Duration(seconds: 2));
  }
  static void showToast(String message, {Duration? duration}) {
    EasyLoading.showToast(message,
        duration: duration ?? const Duration(seconds: 2));
  }
  static void showProgress(double progress, {String? status}) {
    EasyLoading.showProgress(progress, status: status);
  }
  static void showPageLoading() {
    EasyLoading.show(status: ''); // 不显示文字
  }

  static void showDelightToast({
    required BuildContext context,
    required String message,
    bool show = true,
    IconData icon = CupertinoIcons.bell_fill,
    bool autoDismiss = true,//是否自动关闭
    int duration = 2000,//显示时长 ,
    Widget? subtitle,
    Color  color = Colors.white,
    Color   iconColor = Colors.black,
    Color  textColor = Colors.black,
  }) {
     if(show)showLoading();hideLoading();
    DelightToastBar(
      builder: (context) => ToastCard(
        leading: Icon(icon, size: 28,  color:iconColor),
        title: Text(
          message,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14,  color: textColor),
        ),
        subtitle:subtitle,
        color : color,
      ),
      autoDismiss: autoDismiss,
      snackbarDuration :Duration(milliseconds: duration),
      position: DelightSnackbarPosition.top,
    ).show(context);
  }

}
