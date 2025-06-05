import 'package:Rupee_Rush/utils/Method.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final List<Map<String, String>> _pageListCont = [
    {
      "title": 'Mobile Wallet',
      "subTitle": 'One App for all your money matters',
      "image": "assets/start/start_1.png",
    },
    {
      "title": 'Mobile Wallet',
      "subTitle": 'One App for all your money matters',
      "image": "assets/start/start_2.png",
    },
    {
      "title": 'Mobile Wallet',
      "subTitle": 'One App for all your money matters',
      "image": "assets/start/start_3.png",
    },
  ];
  final SwiperController _controller = SwiperController();
  int _currentIndex = 0; // 用于保存当前页索引
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: PopScope(
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) {
              SystemNavigator.pop();
            }
          },
          child: SafeArea(child: Column(
        children: [
          Expanded(
            child: Swiper(
              loop: false,
              itemCount: _pageListCont.length,
              controller: _controller,
              onIndexChanged: (index) {
                setState(() {
                  _currentIndex = index; // 更新当前页索引
                });
              },
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _pageListCont[index]['title']!,
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      _pageListCont[index]['subTitle']!,
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: AppMethod.hexToColor('#666666'),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Image.asset(
                      _pageListCont[index]['image']!,
                      width:300.w,
                    ),
                    SizedBox(height: 157.h),
                    _buildBottom()
                  ],
                );
              },
              pagination: SwiperPagination(
                alignment: Alignment(0.0, 0.5),
                builder: DotSwiperPaginationBuilder(
                  color:AppMethod.hexToColor('#EFF0F5'),
                  activeColor: AppMethod.hexToColor('#3C59FF'),
                  size: 8.0,
                  activeSize: 10.0,
                ),
              ),
            ),
          ),

        ],
      ),))
    );
  }

  //底部
  Widget _buildBottom() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 始终保留两个按钮的结构，通过 Opacity 控制显示
          Expanded(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SizeTransition(sizeFactor: animation, child: child),
                );
              },
              child: _currentIndex == _pageListCont.length - 1
                  ? Row(
                key: const ValueKey('registerLoginButtons'),
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppMethod.hexToColor('#3C59FF'),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: AppMethod.hexToColor('#3C59FF')),
                          borderRadius: BorderRadius.circular(12.w),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                        minimumSize: Size(150.w, 49.h),
                      ),
                      onPressed: () {},
                      child: Text('Register', style: TextStyle(fontSize: 22.sp, color: AppMethod.hexToColor('#3C59FF'))),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppMethod.hexToColor('#3C59FF'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.w),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                        minimumSize: Size(150.w, 49.h),
                      ),
                      onPressed: ()=>Get.toNamed('/login'),
                      child: Text('Login', style: TextStyle(fontSize: 22.sp, color: Colors.white)),
                    ),
                  ),
                ],
              )
                  : Opacity(
                key: const ValueKey('nextButton'),
                opacity: 1.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppMethod.hexToColor('#3C59FF'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.w),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    minimumSize: Size(double.infinity, 49.h),
                  ),
                  onPressed: () => _controller.next(
                  ),
                  child: Text('Next', style: TextStyle(fontSize: 22.sp, color: Colors.white)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


}
