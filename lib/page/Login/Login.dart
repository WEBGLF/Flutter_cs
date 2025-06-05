import 'package:Rupee_Rush/utils/Method.dart';
import 'package:flutter/cupertino.dart';
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
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              buildHeader(),
              SizedBox(height: 26.h),
              buildUsernameInput(),
              SizedBox(height: 10.h),
              buildPasswordInput(),
              SizedBox(height: 30.h),
              buildLoginButton(context),
              SizedBox(height: 30.h),
              buildsSrvice(),
              SizedBox(height: 17.h),
              buildInviteCode(context),
              SizedBox(height: 60.h),
              Image(
                image: AssetImage('assets/public/login_logo.png'),
                width: 227.w,
              ),
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
    return Obx(
      () => CustomInput(
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
      ),
    );
  }

  /// 密码输入框
  Widget buildPasswordInput() {
    return Obx(
      () => CustomInput(
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
      ),
    );
  }

  /// 登录按钮
  Widget buildLoginButton(context) {
    return Obx(() {
      return Material(
        color:
            controller.canLogin.value
                ? AppMethod.hexToColor('#3C59FF')
                : AppMethod.hexToColor('#3C59FF').withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.w),
        elevation: 0,
        child: InkWell(
          onTap:
              controller.canLogin.value
                  ? () => controller.throttleLogin(context)
                  : null,
          borderRadius: BorderRadius.circular(12.w),
          splashColor: Colors.white.withOpacity(0.5),
          highlightColor: Colors.transparent,
          child: Container(
            width: double.infinity,
            height: 57.h,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12.w),
              boxShadow: [
                BoxShadow(
                  color: AppMethod.hexToColor('#3C59FF').withOpacity(0.24),
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

  // 邀请码提示
  Widget buildInviteCode(context) {
    return Obx(() {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 16.w, horizontal: 15.w),
        decoration: BoxDecoration(
          color: AppMethod.hexToColor('#DDDDDD'),
          borderRadius: BorderRadius.circular(12.w),
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!controller.isInviteCodeVisible.value)
                    SizedBox(width: 42.w),
                  Text(
                    controller.isInviteCodeVisible.value
                        ? 'd558efef-71f7-4720-b8d2-e66de21e8b2a'
                        : '**** **** **** **** ****',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppMethod.hexToColor('#1A1A1A'),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                if (controller.isInviteCodeVisible.value)
                  GestureDetector(
                    onTap: (){
                      controller.copyInviteCode(context);
                    },
                    child: Icon(
                      Icons.copy_all_sharp,
                      size: 24.sp,
                      color: AppMethod.hexToColor('#3C59FF'),
                    ),
                  ),

                SizedBox(width: 8.w), // 可选：添加一点间距

                GestureDetector(
                  onTap: () {
                    controller.showCustomDialog(context);
                  },
                  child: Icon(
                    controller.isInviteCodeVisible.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 24.sp,
                    color: AppMethod.hexToColor('#1A1A1A'),
                  ),
                ),
              ],
            )


          ],
        ),
      );
    });
  }
  //弹窗
}
