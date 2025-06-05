import 'dart:async';

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
      color: AppMethod.hexToColor("#000000").withAlpha(128),
      iconColor: Colors.white,
      textColor: Colors.white,
    );
  }
//弹窗函数
  final isZh = true.obs;

  Map<String, Map<String, String>> langMap = {
    'zh': {
      'title': '安全提示',
      'body_top': 'GAID是您账户安全的重要凭据，仅用于本账户的身份验证。为保障您的权益，请注意以下事项：',
      'item1': '1.切勿随意泄露',
      'item2': '2.切勿随意泄露',
      'item3': '3.切勿随意泄露',
      'desc': 'GAID与您的设备及账户直接关联，不可通过社交媒体、邮件或短信提供给他人，避免被不法分子用于非法操作。',
      'button': 'English'
    },
    'en': {
      'title': 'Security Tip',
      'body_top':
      'GAID is an important credential for your account security, used solely for identity verification of this account. Please note the following to protect your rights:',
      'item1': '1.Do not disclose it casually',
      'item2': '2.Do not disclose it casually',
      'item3': '3.Do not disclose it casually',
      'desc':
      'GAID is directly linked to your device and account. Do not provide it to others via social media, email, or SMS to prevent misuse by malicious actors.',
      'button': '中文'
    }
  };
  void toggleLang() {
    isZh.value = !isZh.value;
  }

  void showCustomDialog(BuildContext context) {
    if (isInviteCodeVisible.value) {
      toggleInviteCodeVisibility();
    } else {
      final count = 6.obs;
      late Timer timer;
      bool canPop = false;

      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (count.value > 0) {
          count.value--;
          if (count.value == 0) {
            canPop = true;
            timer.cancel();
          }
        }
      });
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => WillPopScope(
          onWillPop: () async => canPop,
          child: CustomDialog(
            width: 300.w,
            header: Obx(() => Container( // 使用 Obx 动态更新
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              decoration: BoxDecoration(
                color: AppMethod.hexToColor('#FF7810'),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    langMap[isZh.value ? 'zh' : 'en']!['title']!,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppMethod.hexToColor('#FFFFFF'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      toggleLang(); // 切换语言
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1.0),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        langMap[isZh.value ? 'zh' : 'en']!['button']!,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            )),
            body: Obx(() => Column( // 使用 Obx 更新 body 文案
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  langMap[isZh.value ? 'zh' : 'en']!['body_top']!,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppMethod.hexToColor('#1A1A1A'),
                  ),
                ),
                SizedBox(height: 20.h),
                Container(
                  decoration: BoxDecoration(
                    color: AppMethod.hexToColor('#000000'),
                    borderRadius: BorderRadius.circular(4.w),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  child: Text(
                    langMap[isZh.value ? 'zh' : 'en']!['item1']!,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppMethod.hexToColor('#FFFFFF'),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  langMap[isZh.value ? 'zh' : 'en']!['desc']!,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppMethod.hexToColor('#666666'),
                  ),
                ),
                SizedBox(height: 20.h),
                Container(
                  decoration: BoxDecoration(
                    color: AppMethod.hexToColor('#000000'),
                    borderRadius: BorderRadius.circular(4.w),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  child: Text(
                    langMap[isZh.value ? 'zh' : 'en']!['item2']!,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppMethod.hexToColor('#FFFFFF'),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  langMap[isZh.value ? 'zh' : 'en']!['desc']!,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppMethod.hexToColor('#666666'),
                  ),
                ),
                SizedBox(height: 20.h),
                Container(
                  decoration: BoxDecoration(
                    color: AppMethod.hexToColor('#000000'),
                    borderRadius: BorderRadius.circular(4.w),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  child: Text(
                    langMap[isZh.value ? 'zh' : 'en']!['item3']!,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppMethod.hexToColor('#FFFFFF'),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  langMap[isZh.value ? 'zh' : 'en']!['desc']!,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppMethod.hexToColor('#666666'),
                  ),
                ),
              ],
            )),
            footer: Obx(() {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppMethod.hexToColor('#000000').withAlpha(25),
                      offset: Offset(0, -1),
                      blurRadius: 6,
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          '取消',
                          style: TextStyle(
                              color: AppMethod.hexToColor("#666666")),
                        ),
                      ),
                    ),
                    Container(
                      width: 1.w,
                      height: 24.h,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: canPop
                            ? () {
                          Navigator.of(context).pop();
                          toggleInviteCodeVisibility();
                        }
                            : null,
                        child: Text(
                          canPop
                              ? '去完成'
                              : '去完成(${count.value})',
                          style: TextStyle(
                              color: canPop
                                  ? AppMethod.hexToColor('#3C59FF')
                                  : Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ).then((_) {
        timer.cancel();
      });
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
            show: false,
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
