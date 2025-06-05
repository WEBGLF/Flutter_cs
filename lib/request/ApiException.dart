import 'package:dio/dio.dart';
import 'package:Rupee_Rush/store/index.dart';
import 'package:get/get.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  // 处理 Dio 异常
  static void handle(DioException e) {
    if (e.response != null) {
      final statusCode = e.response!.statusCode;

      if (statusCode == 401) {
        _handle401Error();
        return;
      }

      var jsonData = e.response?.data;
      print("Response Data: $jsonData");

      String errorMessage = "未知错误";

      if (jsonData == null) {
        errorMessage = "服务器无响应";
      } else if (jsonData is String) {
        errorMessage = jsonData;
      } else if (jsonData is Map<String, dynamic>) {
        errorMessage = jsonData["message"]?.toString() ?? jsonData.toString();
      } else {
        errorMessage = "响应格式异常";
      }
      Get.snackbar('错误', errorMessage.toString());
    } else {
      // 网络问题或请求未发送成功
      Get.snackbar("网络错误", "请检查连接");
    }
  }

  static void _handle401Error() async {
    // 可选：清除本地 Token 或用户信息
    await Storage.to.clearAll();
    // 提示用户并跳转登录页
    Get.snackbar("登录已过期", "请重新登录");
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAllNamed('/login'); // 替换为你项目的登录页面路由
    });
  }
}
