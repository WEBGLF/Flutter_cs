import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';

class LoadingConfig {
  static void init() {
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.pulse
      ..loadingStyle = EasyLoadingStyle.dark
      ..animationStyle = EasyLoadingAnimationStyle.scale;
  }
}
