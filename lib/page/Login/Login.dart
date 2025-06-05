import 'package:Rupee_Rush/utils/Method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../components/CustomAppBar.dart';
import '../../components/CustomInput.dart';
import '../../generated/l10n.dart';
import 'login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              buildHeader(),
              SizedBox(height: 26.w),
              buildUsernameInput(),
              const SizedBox(height: 20),
              buildPasswordInput(),
              const SizedBox(height: 20),
              buildLoginButton(context),
              const SizedBox(height: 30),
              buildsSrvice(),
            ],
          ),
        ),
      ),
    );
  }

  // ====== 模块组件定义 ======

  /// 页面头部：登录标题
  Widget buildHeader() {
    return Text(
      S().login_title,
      style: TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.w600,
        color: AppMethod.hexToColor('#1A1A1A'),
      ),
    );
  }

  /// 用户名输入框
  Widget buildUsernameInput() {
    return Obx(() => CustomInput(
      hintText: '请输入手机号/账号',
      maxLength: 10,
      prefixIcon: Padding(
        padding: EdgeInsets.all(10.w),
        child: Image(
          image: const AssetImage("assets/public/login_phone.png"),
          width: 24.w,
          height: 24.w,
        ),
      ),
      onChanged: controller.setUsername,
      errorText: controller.usernameError.value,
    ));
  }

  /// 密码输入框
  Widget buildPasswordInput() {
    return Obx(() => CustomInput(
      hintText: '请输入6-12位密码',
      prefixIcon: Padding(
        padding: EdgeInsets.all(10.w),
        child: Image(
          image: const AssetImage("assets/public/login_password.png"),
          width: 24.w,
          height: 24.w,
        ),
      ),
      onChanged: controller.setPassword,
      isPassword: true,
      obscureText: !controller.isPasswordVisible.value,
      onToggleObscure: controller.togglePasswordVisibility,
      errorText: controller.passwordError.value,
    ));
  }

  /// 登录按钮
  Widget buildLoginButton(context) {
    return Obx(() {
      return Material(
        color: controller.canLogin.value
            ? AppMethod.hexToColor('#3C59FF')
            : AppMethod.hexToColor('#3C59FF').withOpacity(0.4),
        borderRadius: BorderRadius.circular(12.w),
        elevation: 0,
        child: InkWell(
          onTap: controller.canLogin.value
              ? () => controller.throttleLogin(context)
              : null,
          borderRadius: BorderRadius.circular(12.w),
          splashColor: Colors.white.withOpacity(0.3),
          highlightColor: Colors.transparent,
          child: Container(
            width: double.infinity,
            height: 57.h,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12.w),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromRGBO(4, 11, 126, 0.24),
                  offset: const Offset(0, 6),
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Center(
              child: Text(
                '登录',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  /// 页面联系客服
  Widget buildsSrvice() {
    return Text(
      '联系客服',
      style: TextStyle(
        fontSize: 14.sp,
        color: AppMethod.hexToColor('#1A1A1A'),
        decoration: TextDecoration.underline,
      ),
    );
  }
}
