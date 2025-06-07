// 文件路径：lib/components/OtpDialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../utils/ToastUtils.dart';
import '../utils/Method.dart';

class OtpDialog extends StatelessWidget {
  final String phoneNumber; // 手机号
  final RxInt countdownSeconds; // 倒计时秒数（RxInt）
  final RxBool isCounting; // 是否正在倒计时（RxBool）
  final VoidCallback onResendPressed; // 重新发送验证码
  final RxString errorText; // 错误提示（RxString）
  final ValueChanged<String> onOtpCompleted; // 验证码输入完成回调

  // 新增：可选样式参数
  final double? fieldHeight;
  final double? fieldWidth;
  final Color? inactiveColor;
  final Color? activeColor;
  final Color? selectedColor;
  final Color? inactiveFillColor;
  final Color? selectedFillColor;
  final Color? activeFillColor;

  const OtpDialog({
    super.key,
    required this.phoneNumber,
    required this.countdownSeconds,
    required this.isCounting,
    required this.onResendPressed,
    required this.errorText,
    required this.onOtpCompleted,

    // 默认值
    this.fieldHeight = 40,
    this.fieldWidth = 38,
    this.inactiveColor,
    this.activeColor = const Color(0xFF3C59FF),
    this.selectedColor = const Color(0xFF3C59FF),
    this.inactiveFillColor,
    this.selectedFillColor,
    this.activeFillColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Please enter OTP',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'OTP sent to',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppMethod.hexToColor("#B3B3B3"),
              ),
            ),
            SizedBox(width: 5.w),
            Text(
              AppMethod.maskPhoneNumber(phoneNumber),
              style: TextStyle(
                fontSize: 14.sp,
                color: AppMethod.hexToColor("#1A1A1A"),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 30.h),
        PinCodeTextField(
          appContext: context,
          length: 6,
          keyboardType: TextInputType.number,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(6.w),
            fieldHeight: fieldHeight!.h,
            fieldWidth: fieldWidth!.w,
            borderWidth: 0.1,
            inactiveColor: inactiveColor ?? AppMethod.hexToColor("#EDEDED"),
            activeColor: activeColor!,
            selectedColor: selectedColor!,
            inactiveFillColor: inactiveFillColor ?? AppMethod.hexToColor("#EDEDED"),
            selectedFillColor: selectedFillColor ?? AppMethod.hexToColor("#EDEDED"),
            activeFillColor: activeFillColor ?? AppMethod.hexToColor("#EDEDED"),
            fieldOuterPadding: EdgeInsets.symmetric(horizontal: 0.1.w),
          ),
          onChanged: (_) {},
          onCompleted: onOtpCompleted,
          textStyle: TextStyle(
            fontSize: 20.sp,
            color: Colors.black,
          ),
          animationType: AnimationType.scale,
          animationDuration: Duration(milliseconds: 300),
          backgroundColor: Colors.transparent,
          enableActiveFill: true,
          cursorHeight: 20.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() => Text(
              errorText.value,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppMethod.hexToColor("#DB0000"),
                fontWeight: FontWeight.bold,
              ),
            )),
            Obx(() => InkWell(
              onTap: isCounting.value
                  ? null
                  : () {
                onResendPressed();
                ToastUtils.showDelightToast(
                  context: context,
                  message: '已发送验证码',
                  duration: 2000,
                );
              },
              child: Text(
                isCounting.value
                    ? 'Resend in (${countdownSeconds.value} s)'
                    : 'ReSend OTP',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isCounting.value
                      ? AppMethod.hexToColor("#B3B3B3")
                      : AppMethod.hexToColor("#3C59FF"),
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
          ],
        )
      ],
    );
  }
}

