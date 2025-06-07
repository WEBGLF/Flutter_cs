import 'dart:async';

import 'package:Rupee_Rush/components/OtpDialog.dart';
import 'package:Rupee_Rush/utils/ToastUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../components/CustomDialog.dart';
import '../../utils/Method.dart';

class RegisterController extends GetxController {
  // 输入字段
  final username = '1993916520'.obs; //用户名
  final verificationCode = ''.obs; //验证码
  final inviteCode = ''.obs; //邀请码
  final password = ''.obs; //密码
  final confirmPassword = ''.obs; //确认密码
  //控制器默认值
  late final usernameController = TextEditingController(text: username.value);
  // 错误信息
  final usernameError = Rx<String?>(null); //用户名错误
  final verificationCodeError = Rx<String?>(null); //验证码错误
  final inviteCodeError = Rx<String?>(null); //邀请码错误
  final passwordError = Rx<String?>(null); //密码错误
  final confirmPasswordError = Rx<String?>(null); //确认密码错误

  // 控制按钮状态
  final canRegister = false.obs;

  // 是否显示密码
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    // 监听输入变化以更新按钮状态
    ever(username, (_) => updateRegisterButton());
    ever(verificationCode, (_) => updateRegisterButton());
    ever(inviteCode, (_) => updateRegisterButton());
    ever(password, (_) => updateRegisterButton());
    ever(confirmPassword, (_) => updateRegisterButton());

    updateRegisterButton();
  }

  void updateRegisterButton() {
    canRegister.value =
        username.value.isNotEmpty &&
        verificationCode.value.isNotEmpty &&
        inviteCode.value.isNotEmpty &&
        password.value.isNotEmpty &&
        confirmPassword.value.isNotEmpty &&
        password.value == confirmPassword.value;
  }

  void setUsername(String value) {
    username.value = value;
    if (usernameError.value != null && usernameError.value!.isNotEmpty) {
      usernameError.value = null;
    }
  }

  void setVerificationCode(String value) {
    verificationCode.value = value;
    if (verificationCodeError.value != null &&
        verificationCodeError.value!.isNotEmpty) {
      verificationCodeError.value = null;
    }
  }

  void setInviteCode(String value) {
    inviteCode.value = value;
    if (inviteCodeError.value != null && inviteCodeError.value!.isNotEmpty) {
      inviteCodeError.value = null;
    }
  }

  void setPassword(String value) {
    password.value = value;
    if (passwordError.value != null && passwordError.value!.isNotEmpty) {
      passwordError.value = null;
    }
    // 检查确认密码是否匹配
    if (confirmPassword.value.isNotEmpty) {
      checkConfirmPassword(confirmPassword.value);
    }
  }

  void setConfirmPassword(String value) {
    confirmPassword.value = value;
    checkConfirmPassword(value);
  }

  void checkConfirmPassword(String value) {
    if (value != password.value) {
      confirmPasswordError.value = '两次密码不一致';
    } else {
      confirmPasswordError.value = null;
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // 倒计时控制
  final otp = ''.obs; //短信验证码
  final otpError = ''.obs;//错误提示
  final isCounting = false.obs;
  final countdownSeconds = 120.obs;
  Timer? _countdownTimer;
  // 启动倒计时
  void startResendCountdown() {
    if (isCounting.value) return; // 防止重复启动
    otpError.value = '';
    isCounting.value = true;
    countdownSeconds.value = 120;
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      countdownSeconds.value--;
      if (countdownSeconds.value <= 0) {
        stopResendCountdown();
      }
    });
  }
// 停止倒计时
  void stopResendCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    isCounting.value = false;
  }

  //显示OTP弹框
  void showOTPDialog(BuildContext context) {
    // 弹窗关闭时释放资源
    void disposeControllersAndFocusNodes() {
      otpError.value = '';
      // 这里可以添加清理逻辑（如果有）
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            viewInsets: EdgeInsets.zero, // 清除键盘带来的 insets
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return CustomDialog(
                body: OtpDialog(
                  phoneNumber: username.value,
                  countdownSeconds: countdownSeconds,
                  isCounting: isCounting,
                  errorText: otpError,
                  onResendPressed: startResendCountdown,
                  onOtpCompleted: (value) {
                    otp.value = value;
                    if (value == '352000') {
                      Navigator.of(context).pop();
                    }else {
                      otpError.value = 'Validation error';
                    }
                  },
                ),
              );
            },
          ),
        );
      },
    ).then((_) {
      disposeControllersAndFocusNodes();
    });
  }

  //节流登录
  Future<void> throttleRegister(BuildContext context) =>
      AppMethod.throttle(() async => await register(context));
  Future<void> register(BuildContext context) async {
    // 清空旧错误
    usernameError.value = null;
    verificationCodeError.value = null;
    inviteCodeError.value = null;
    passwordError.value = null;
    confirmPasswordError.value = null;
    bool hasError = false;
    if (username.value.isEmpty) {
      usernameError.value = '请输入用户名';
      hasError = true;
    }
    if (verificationCode.value.length < 4) {
      verificationCodeError.value = '请输入正确的验证码';
      hasError = true;
    }
    if (inviteCode.value.isEmpty) {
      inviteCodeError.value = '请输入邀请码';
      hasError = true;
    }
    if (password.value.length < 6) {
      passwordError.value = '密码至少6位';
      hasError = true;
    }
    if (password.value != confirmPassword.value) {
      confirmPasswordError.value = '两次密码不一致';
      hasError = true;
    }
    if (hasError) return;
    //成功 验证短信
    showOTPDialog(context);
  }
}
