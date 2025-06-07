import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../components/CustomAppBar.dart';
import '../../components/CustomInput.dart';
import '../../utils/Method.dart';
import 'Register_controller.dart';

class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SingleChildScrollView( // 添加滚动支持
            physics: const AlwaysScrollableScrollPhysics(), // 允许始终滚动
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 //顶部注册标题
                buildNavTitle(),
                SizedBox(height: 26.h),
                buildUsernameInput(),
                SizedBox(height: 10.h),
                buildVerificationCodeInput(),
                SizedBox(height: 20.h),
                buildInviteCodeInput(),
                SizedBox(height: 20.h),
                buildPasswordInput(),
                SizedBox(height: 20.h),
                buildConfirmPasswordInput(),
                SizedBox(height: 30.h),
                //底部按钮
                buildRegisterButton(context),
                //底部提示
                buildTips(),
              ],
            ),
          ),
        ),
      ),
    );
  }
 Widget buildNavTitle () {
   return Text(
     '注册',
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
            controller: controller.usernameController,
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

  //验证码输入框
  Widget buildVerificationCodeInput() {
    return Obx(
      () => CustomInput(
        hintText: '请输入验证码',
        prefixIcon: Padding(
          padding: EdgeInsets.all(10.w),
          child: Image(
            image: const AssetImage("assets/public/register_code.png"),
            width: 24.w,
            height: 24.w,
          ),
        ),
        suffixIcon: Padding(padding: EdgeInsets.only(right: 10.w),child: Image(
          image: const AssetImage("assets/public/register_code_img.png"),
          width: 108.w,
          height: 39.h,
        ),),
        onChanged: controller.setVerificationCode,
        errorText: controller.verificationCodeError.value,
      )
    );
  }

// 邀请码输入框
  Widget buildInviteCodeInput() {
    return Obx(
      () => CustomInput(
        hintText: '请输入邀请码',
        prefixIcon: Padding(
          padding: EdgeInsets.all(10.w),
          child: Image(
            image: const AssetImage("assets/public/register_invite.png"),
            width: 24.w,
            height: 24.w,
          ),
        ),
        onChanged: controller.setInviteCode,
        errorText: controller.inviteCodeError.value,
      )
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
//确认密码输入框
  Widget buildConfirmPasswordInput() {
    return Obx(
      () => CustomInput(
        hintText: '请再次输入密码',
        prefixIcon: Padding(
          padding: EdgeInsets.all(10.w),
          child: Image(
            image: const AssetImage("assets/public/login_password.png"),
            width: 24.w,
            height: 24.w,
          ),
        ),
        onChanged: controller.setConfirmPassword,
        isPassword: true,
        onToggleObscure: controller.toggleConfirmPasswordVisibility,
        obscureText: !controller.isConfirmPasswordVisible.value,
        errorText: controller.confirmPasswordError.value,
      )
    );
  }

  //底部按钮
  Widget buildRegisterButton(context) {
    return Obx(() {
      return Material(
        color:
        controller.canRegister.value
            ? AppMethod.hexToColor('#3C59FF')
            : AppMethod.hexToColor('#3C59FF').withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.w),
        elevation: 0,
        child: InkWell(
          onTap:
          controller.canRegister.value
              ? () => controller.throttleRegister(context)
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
                'Register',
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

  //底部提示
  Widget buildTips() {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outlined, size: 16.w, color: AppMethod.hexToColor('#EA1C1C')),
          SizedBox(width: 4.w), // 添加一些间距
          Expanded( // 使用 Expanded 包裹 Text，使其可以换行
            child: Text(
              '密码8-20位，需包含数字、大写字母、小写字母、特殊符号中的两类及以上。',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppMethod.hexToColor('#EA1C1C'),
              ),
              softWrap: true, // 允许文本自动换行
            ),
          ),
        ],
      ),
    );
  }

}
