import 'package:Rupee_Rush/utils/Method.dart';
import 'package:dio/dio.dart';
import 'package:Rupee_Rush/request/Https.dart';
import 'package:Rupee_Rush/store/index.dart';
import 'package:Rupee_Rush/utils/ToastUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../components/CustomDialog.dart';
import '../../utils/ClipboardUtils.dart';

class LoginController extends GetxController {
  final username = ''.obs;
  final password = ''.obs;
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final canLogin = false.obs;
// 错误信息
  final usernameError = Rx<String?>(null);
  final passwordError = Rx<String?>(null);
  // 邀请码显示状态
  final RxBool isInviteCodeVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    username.listen((_) => updateCanLogin());
    password.listen((_) => updateCanLogin());
    updateCanLogin();
  }
  void updateCanLogin() {
    canLogin.value = username.value.length >= 10 && password.value.length >= 6;
  }


  void setUsername(String value) {
    username.value = value;
    if (usernameError.value != null && usernameError.value!.isNotEmpty) {
      usernameError.value = null; // 清空旧错误
    }
  }

  void setPassword(String value) {
    password.value = value;
    if (passwordError.value != null && passwordError.value!.isNotEmpty) {
      passwordError.value = null; // 清空旧错误
    }
  }

  // 切换邀请码显示状态
  void toggleInviteCodeVisibility() {
    isInviteCodeVisible.value = !isInviteCodeVisible.value;
  }
  void copyInviteCode( context)  {
     ClipboardUtils.copyText('d558efef-71f7-4720-b8d2-e66de21e8b2a');
    // 复制完成后立即显示 Toast
    ToastUtils.showDelightToast(
      context: context,
      message: "邀请码已复制",
      // 0.5 透明度 = 128 (0x80)
      color: AppMethod.hexToColor("#000000").withAlpha(128),
      iconColor: Colors.white,
      textColor: Colors.white,
    );
  }
//弹窗函数
  void showCustomDialog(BuildContext context) {
  //是否是显示
    if(isInviteCodeVisible.value){
      toggleInviteCodeVisibility();
    }else{
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => CustomDialog(
          body: Text('这是一个自定义弹窗'),
          width: 300.w,
          header: Text('标题'),
          footer: InkWell(
            onTap: () {
              Navigator.of(context).pop(); // 关闭弹窗
            },
            child: Text('确定'),
          ),
        ),
      );
    }

  }

  @override
  void onReady() {
    super.onReady();
    print('加载完毕');
  }

  @override
  void onClose() {
    super.onClose();
    print('卸载');
    Http.to.cancelAllRequests();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  //节流登录
  Future<void> throttleLogin(BuildContext context) => AppMethod.throttle(() async=>  await login(context));
  Future<void> login(BuildContext context) async {
    // 先清空所有错误
    usernameError.value = null;
    passwordError.value = null;
    bool hasError = false;
    if (username.value.isEmpty || username.value.length < 10) {
      usernameError.value = '请输入有效的手机号/账号';
      hasError = true;
    }
    if (password.value.isEmpty || password.value.length < 6) {
      passwordError.value = '请输入6位以上密码';
      hasError = true;
    }

    if (hasError) return; // 停止执行，不发起请求
    try {
      // 显示加载中提示
      ToastUtils.showLoading(status: '正在登录...');

      // 模拟网络请求（这里替换为真实的请求）
      // final response = await Http.to.post('/login', data: {
      //   'username': username.value,
      //   'password': password.value,
      // });

      // 假设登录成功
      if (password == '123456') {
        Storage.to.setToken('123456');
        Get.offAllNamed('/'); // 跳转到首页
      } else {
          ToastUtils.showDelightToast(
            context: context,
            message: "密码错误",
            color: AppMethod.hexToColor("#FF5266"),
            icon: CupertinoIcons.exclamationmark_triangle_fill,
            iconColor: Colors.white,
            textColor: Colors.white,
          );
        }

    } catch (e) {
      // 错误提示
      ToastUtils.showError(e.toString());
    } finally {
      // 隐藏加载框
      ToastUtils.hideLoading();
      isLoading(false);
    }
  }

}
