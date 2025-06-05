// lib/page/WebViewPage.dart

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late InAppWebViewController webViewController;
  late String url;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    url = args?['url'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("百度"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(url)),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onLoadStart: (controller, url) {
          print("开始加载: $url");
        },
        onLoadStop: (controller, url) {
          print("加载完成: $url");
        },
        onProgressChanged: (controller, progress) {
          print("加载进度: $progress%");
        },
        shouldOverrideUrlLoading: (controller, request) async {
          final uri = request.request.url;
          if (uri == null) {
            return NavigationActionPolicy.CANCEL;
          }
          final url = uri.toString();
          if (url.startsWith("https://")) {
            // 继续在当前 WebView 中加载
            return NavigationActionPolicy.ALLOW;
          }
          // 可选：跳转系统浏览器
          // await launchUrl(uri);
          return NavigationActionPolicy.CANCEL;
        },

        onConsoleMessage: (controller, consoleMessage) {
          print("控制台消息: ${consoleMessage.message}");
        },
      ),
    );
  }
}
