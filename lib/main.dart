import 'package:Rupee_Rush/theme/light.dart';
import 'package:Rupee_Rush/utils/Method.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Rupee_Rush/request/Https.dart';
import 'package:Rupee_Rush/router/index.dart';
import 'package:Rupee_Rush/store/index.dart';
import 'package:Rupee_Rush/store/main.dart';
import 'package:Rupee_Rush/utils/Config.dart';
import 'package:Rupee_Rush/utils/EventBusService.dart';
import 'package:Rupee_Rush/utils/LoadingConfig.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'generated/l10n.dart';

Future<void> main() async {
  // ⚙️ 保持 runApp 前的操作尽可能轻量
  WidgetsFlutterBinding.ensureInitialized();
  // 🧠 初始化前配置
  await _setupApp();
  // 🔐 可选：异步判断登录状态后再决定 initialRoute
  final String initialRoute = await AppMethod.determineInitialRoute();
  // 🚀 运行 App
  runApp(MyApp(initialRoute: initialRoute));
}

// ✅ 拆分初始化逻辑到单独方法中
Future<void> _setupApp() async {
  try {
    // 🔌 初始化网络请求服务
    await Http.init();
    // 🗃️ 初始化本地存储
    await Get.putAsync(() => Storage.registerWithKey(Utils.storageKey));
    // 初始化 GetX Service
    await Get.putAsync(() async => EventBusService());
    // 初始化全局 controller
    Get.put(AppDataController());

    // 💫 初始化 Loading 组件
    LoadingConfig.init();
    // 📵 锁定竖屏方向（可选）
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  } catch (e, stackTrace) {
    // 🛡️ 捕获并上报初始化错误
    _handleError(e, stackTrace);
  }
}

// ✅ 全局异常捕获
void _handleError(Object error, StackTrace stackTrace) {}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Flutter Demo',
          theme: LightTheme.theme,
          debugShowCheckedModeBanner: false,
          locale: const Locale('en', 'US'), // 设置应用语言为英文
          fallbackLocale: const Locale('en', 'US'), // 默认回退语言
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          initialRoute: initialRoute,
          getPages: AppRoutes.routes,
          builder: EasyLoading.init(),
        );
      },
    );
  }
}
