
 import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:Rupee_Rush/store/index.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:intl/intl.dart';
import 'package:pointycastle/asymmetric/api.dart';

import 'Config.dart';
class AppMethod {
 // ✅ 判断初始路由（可延迟加载）
  static Future<String> determineInitialRoute() async {
 final token = Storage.to.getToken();
 return token != null ? '/' : '/start';
 }
  //Hex颜色转换
  static  Color hexToColor(String rgbString) {
   // 确保字符串以 '#' 开头
   if (rgbString.startsWith('#')) {
    rgbString = rgbString.substring(1);
   }

   // 如果是6位的RGB格式，加上不透明度（FF）
   if (rgbString.length == 6) {
    rgbString = 'FF$rgbString';
   }
   // 将字符串解析为整数
   int colorValue = int.parse(rgbString, radix: 16);

   return Color(colorValue);
  }
// 时间转为MM.dd格式的
 static String formatDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString).toLocal();
  DateFormat outputFormat = DateFormat('MM.dd');
  String formattedDate = outputFormat.format(dateTime);
  return formattedDate;
 }

 // 时间转为yyyy-MM-dd HH:mm:ss格式的
 static String formatDateToMMSS(String dateString) {
  DateTime dateTime = DateTime.parse(dateString).toLocal();
  DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  String formattedDate = dateFormat.format(dateTime);
  return formattedDate;
 }

 ///删除base 64 前缀
 static String removePrefixBase64(String base64String) {
  const prefix = 'data:image/png;base64,';
  if (base64String.startsWith(prefix)) {
   return base64String.substring(prefix.length);
  }
  return base64String;
 }

 ///防抖
 static Timer? _debounceTimer;

 static Future<T> debounce<T>(Future<T> Function() func, [int delay = 1000]) {
  final completer = Completer<T>();

  if (_debounceTimer != null) {
   _debounceTimer?.cancel();
  }
  _debounceTimer = Timer(Duration(milliseconds: delay), () async {
   try {
    final result = await func();
    completer.complete(result);
   } catch (error) {
    completer.completeError(error);
   } finally {
    _debounceTimer = null;
   }
  });
  return completer.future;
 }

 ///节流  节流是防止函数在短时间内被频繁调用，只允许在指定的时间间隔内执行一次。
 static DateTime? _lastExecutionTime;
 static const _throttleDuration = Duration(milliseconds: 1000);

 static Future<T> throttle<T>(Future<T> Function() func) {
  final currentTime = DateTime.now();
  if (_lastExecutionTime == null ||
      currentTime.difference(_lastExecutionTime!) >= _throttleDuration) {
   _lastExecutionTime = currentTime;
   return func();
  } else {
   return Future.value(null) as Future<T>;
  }
 }

 static const bool inProduction = bool.fromEnvironment("dart.vm.product");

 static String getBaseUrl() {
  if (inProduction) {
   return Utils.productionUrl;
  } else {
   return Utils.developUrl;
  }
 }

 /// 数据加密 密钥
 String encrypt(String text) {
  const publicKeyBase64 = Utils.publicKey;
  const publicKeyPem =
      '-----BEGIN PUBLIC KEY-----\n$publicKeyBase64\n-----END PUBLIC KEY-----';
  final parser = RSAKeyParser();
  final RSAPublicKey publicKey = parser.parse(publicKeyPem) as RSAPublicKey;

  final encrypter = Encrypter(RSA(publicKey: publicKey));
  final encrypted = encrypter.encrypt(text);
  return base64.encode(encrypted.bytes);
 }

 static String extractFilename(String url) {
  int lastSlashIndex = url.lastIndexOf('/');
  int lastDotIndex = url.lastIndexOf('.');
  if (lastSlashIndex != -1 &&
      lastDotIndex != -1 &&
      lastDotIndex > lastSlashIndex) {
   return url.substring(lastSlashIndex + 1, lastDotIndex);
  }
  return ""; // 如果 URL 格式不正确，返回空字符串
 }

 static String md5Enc(String text) {
  var bytes = utf8.encode(text); // 将输入字符串转换为字节数组
  var digest = md5.convert(bytes); // 计算 MD5 哈希值
  return digest.toString(); // 将哈希值转换为字符串并返回
 }

}