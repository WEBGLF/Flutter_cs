import 'package:Rupee_Rush/utils/Method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavigationBarWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState
    extends State<BottomNavigationBarWidget> with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;

  @override
  void initState() {
    super.initState();
    // 初始化每个 item 的动画控制器
    _animationControllers = List.generate(
      5,
          (index) => AnimationController(
        duration: const Duration(milliseconds: 150),
        vsync: this,
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(brightness: Brightness.light),
      child: BottomAppBar(
        color: Colors.white,
        height: 60,
       // shape: const CircularNotchedRectangle(),
        notchMargin: 10.0,
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildItem(0),
              _buildItem(1),
            //  const SizedBox(), // 凹槽占位
              _buildItem(2),
              _buildItem(3),
              _buildItem(4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(int index) {
    final item = items[index];
    final isActive = index == widget.currentIndex;

    return GestureDetector(
      onTap: () async {
        // 先播放缩小动画
        await _animationControllers[index].forward();
        // 再播放放大动画
        await _animationControllers[index].reverse();
        // 通知外部更新状态
        widget.onTap(index);
      },
      child: AnimatedBuilder(
        animation: _animationControllers[index],
        builder: (context, child) {
          double scale = 1.0 - (0.2 * _animationControllers[index].value);
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              isActive ? item.activeIcon : item.inactiveIcon,
              width: 22.w,
              height: 22.w,
            ),
            Text(
              item.label,
              style: isActive ? TextStyle(
                fontSize: 10.sp,
                color: AppMethod.hexToColor('#1A1A1A'),
                fontWeight: FontWeight.bold,
              ) : TextStyle(
                fontSize: 10.sp,
                color: AppMethod.hexToColor('#777777'),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  final List<BottomNavItem> items = [
    BottomNavItem(
      activeIcon: 'assets/barIcon/Home_active.png',
      inactiveIcon: 'assets/barIcon/Home.png',
      label: 'Home',
    ),
    BottomNavItem(
      activeIcon: 'assets/barIcon/BuyRp_active.png',
      inactiveIcon: 'assets/barIcon/BuyRp.png',
      label: 'Buy Rp',
    ),
    BottomNavItem(
      activeIcon: 'assets/barIcon/Offline_active.png',
      inactiveIcon: 'assets/barIcon/Offline.png',
      label: 'Offline',
    ),
    BottomNavItem(
      activeIcon: 'assets/barIcon/SellRp_active.png',
      inactiveIcon: 'assets/barIcon/SellRp.png',
      label: 'Sell Rp',
    ),
    BottomNavItem(
      activeIcon: 'assets/barIcon/Mine_active.png',
      inactiveIcon: 'assets/barIcon/Mine.png',
      label: 'Mine',
    ),
  ];
}

class BottomNavItem {
  final String activeIcon;
  final String inactiveIcon;
  final String label;

  BottomNavItem({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
  });
}
