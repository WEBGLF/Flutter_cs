//抽离路由 和组件 使用Getx管理
import 'package:Rupee_Rush/WebView/WebViewPage.dart';
import 'package:Rupee_Rush/page/Home/PageHome.dart';
import 'package:Rupee_Rush/page/Login/Login.dart';
import 'package:Rupee_Rush/page/Login/login_binding.dart';
import 'package:Rupee_Rush/page/Start/StartPage.dart';
import 'package:get/get.dart';

class AppRoutes {
  static final List<GetPage> routes = [
    GetPage(name: '/', page: () => MyHomePage()),
    GetPage(name: '/start', page: () => StartPage()),
    GetPage(
      name: '/login',
      page: () => LoginPage(),
      binding: LoginBinding(),
    ), //纯Getx页面
    GetPage(name: '/web_view', page: () => WebViewPage()),
  ];
}
