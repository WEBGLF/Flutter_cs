import 'package:Rupee_Rush/utils/Method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomInput extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;
  final TextEditingController? controller;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onToggleObscure;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLength; // 新增：最大输入长度
  final String? errorText; // 新增：错误提示文本

  const CustomInput({
    Key? key,
    required this.hintText,
    required this.onChanged,
    this.controller,
    this.isPassword = false,
    this.obscureText = false,
    this.onToggleObscure,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLength, // 初始化新属性
    this.errorText, // 初始化错误提示
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      obscureText: isPassword ? obscureText : false,
      keyboardType: keyboardType,
      maxLength: maxLength,
      style: TextStyle(
        color: Colors.black,       // 输入文字颜色
        fontSize: 22.sp,           // 输入文字大小
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        // 设置背景颜色
        filled: true,
        fillColor:AppMethod.hexToColor('#FFFFFF'),
        // 提示文本
        hintText: hintText,
        hintStyle: TextStyle(color:AppMethod.hexToColor('#B3B3B3'), fontSize: 16.sp,fontWeight: FontWeight.w400),

        // 前缀图标
        prefixIcon: prefixIcon ?? Icon(Icons.phone_android, color: Colors.black),

        // 边框样式
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none, // 移除边框线
        ),
        // 内容填充
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        // 密码显示/隐藏按钮
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: Colors.black,
          ),
          onPressed: onToggleObscure,

        )
            : suffixIcon,
        errorText: errorText, // 显示错误提示
      ),
    );
  }
}
