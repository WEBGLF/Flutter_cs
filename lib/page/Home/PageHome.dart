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
  final RxInt _selectedIndex = 0.obs;

  void _onItemTapped(int index) {
    debugPrint('You have clicked the item at index $index');
      _selectedIndex.value = index;
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
        child: Column(
          children: [
            Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
      bottomNavigationBar:Obx(()=> BottomNavigationBarWidget(
        currentIndex: _selectedIndex.value,
        onTap: _onItemTapped,
      )),
   /*   floatingActionButton: FloatingActionButton(
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,*/
    );
  }
}
