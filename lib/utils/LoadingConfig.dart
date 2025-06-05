import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoadingConfig {
  static void init() {
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.pulse
      ..loadingStyle = EasyLoadingStyle.dark
      ..animationStyle = EasyLoadingAnimationStyle.scale;
  }
}
