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
   final double?  bodyHeight;

  CustomDialog({
    super.key,
    this.header,
    required this.body,
    this.footer,
    this.contentPadding = const EdgeInsets.all(20),
    this.backgroundColor,
    this.bodyHeight,
    this.shape = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16))),
    double? width,
  }) : width = width ?? 295.0.w;


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
            // 判断 body 是否为 ScrollView 类型
            if (body is ScrollView || body is ListView || body is GridView)
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: bodyHeight ?? 320.h),
                child: Padding(
                  padding: contentPadding,
                  child: body,
                ),
              )
            else
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: bodyHeight ?? 320.h),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Padding(
                    padding: contentPadding,
                    child: body,
                  ),
                ),
              ),

            if (footer != null) footer!,
          ],
        ),
      ),
    );
  }
}
