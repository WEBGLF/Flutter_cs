import 'package:Rupee_Rush/page/Tabs/main.dart';
import 'package:flutter/material.dart';
import 'package:Rupee_Rush/event/ImageClickEvent.dart';
import 'package:Rupee_Rush/generated/l10n.dart';
import 'package:Rupee_Rush/utils/ClipboardUtils.dart';
import 'package:Rupee_Rush/utils/EventBusService.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  RxString flag = 'zh'.obs;
  RxInt _counter = 0.obs;
  final RxInt _selectedIndex = 0.obs;
  void _incrementCounter() {
    _counter++;
    flag.value = flag.value == 'zh' ? 'en' : 'zh';
    S.load(Locale(flag.value, ''));
    Get.updateLocale(Locale(flag.value, ''));
  }
  void _onItemTapped(int index) {
    debugPrint('You have clicked the item at index $index');
      _selectedIndex.value = index;
  }
  _webView() async {
    await Get.toNamed('/web_view', arguments: {"url": 'https://www.baidu.com'});
  }

  void shareTextAndLink() {
    SharePlus.instance.share(ShareParams(text: "这是我拍的照片"));
  }

  @override
  void initState() {
    super.initState();
    // 监听 ImageClickEvent 事件
    EventBusService.to.on<ImageClickEvent>((event) {
      //出现弹框
      Get.snackbar(event.index.toString(), '背电极');
    });
  }

  @override
  void dispose() {
    // 可选：移除监听（建议在页面关闭时调用）
    EventBusService.to.off<ImageClickEvent>((event) {
      // 这里可以空实现或保留用于清理
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(S().title),
      ),
      body: Center(
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Obx(() => Text('$flag')),
                Obx(
                  () => Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                Container(
                  width: 200.w,
                  height: 100.h,
                  padding: EdgeInsets.all(10.w),
                  child: Text('Hello World', style: TextStyle(fontSize: 32.sp)),
                ),
                SizedBox(height: 10.h),
                ElevatedButton(onPressed: _webView, child: Text('外部网站')),
                ElevatedButton(
                  onPressed: () async {
                    await ClipboardUtils.copyText("https://your-url.com");
                    Get.snackbar("提示", "已复制链接");
                  },
                  child: const Text("复制链接"),
                ),

                ElevatedButton(
                  onPressed: () async {
                    String? text = await ClipboardUtils.getClipboardText();
                    if (text != null && text.isNotEmpty) {
                      Get.snackbar("粘贴内容", text);
                    }
                    shareTextAndLink();
                  },
                  child: const Text("粘贴"),
                ),
                SizedBox(height: 10.h),
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/swiper');
                  },
                  child: Text('轮播图'),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar:Obx(()=> BottomNavigationBarWidget(
        currentIndex: _selectedIndex.value,
        onTap: _onItemTapped,
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: CircleBorder(),          // 明确设置为圆形
        elevation: 6.0,
        child: ClipOval(
          child: Image.asset(
            'assets/barIcon/share.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
