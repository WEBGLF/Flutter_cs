import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDialog extends StatelessWidget {
  final Widget? header; // 可自定义头部
  final Widget body; // 必须的内容主体
  final Widget? footer; // 可自定义底部
  final EdgeInsets contentPadding; // 内容区域 padding
  final ShapeBorder shape; // 弹窗形状
  final double? width; // 弹窗宽度
  final Color? backgroundColor;


  CustomDialog({
    super.key,
    this.header,
    required this.body,
    this.footer,
    this.contentPadding = const EdgeInsets.fromLTRB(24, 20, 24, 24),
    this.backgroundColor,
    this.shape = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16))),
    double? width,
  }) : width = width ?? 295.0.w; // 运行时设置默认值为适配后的宽度

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: shape,
      backgroundColor: backgroundColor ?? Colors.white,
      child: SizedBox(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (header != null) header!,
            Padding(
              padding: contentPadding,
              child: body,
            ),
            if (footer != null) footer!,
          ],
        ),
      ),
    );
  }
}
