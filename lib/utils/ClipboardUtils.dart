import 'package:flutter/services.dart';

class ClipboardUtils {
  // 复制文本到剪贴板
  static Future<void> copyText(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }
  // 从剪贴板获取文本
  static Future<String?> getClipboardText() async {
    var data = await Clipboard.getData(Clipboard.kTextPlain);
    return data?.text;
  }
}
