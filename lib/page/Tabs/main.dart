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
      4,
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
        shape: const CircularNotchedRectangle(),
        notchMargin: 10.0,
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildItem(0),
              _buildItem(1),
              const SizedBox(), // 凹槽占位
              _buildItem(2),
              _buildItem(3),
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
              width: 18,
              height: 18,
            ),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  final List<BottomNavItem> items = [
    BottomNavItem(
      activeIcon: 'assets/barIcon/home_active.png',
      inactiveIcon: 'assets/barIcon/home.png',
      label: '首页',
    ),
    BottomNavItem(
      activeIcon: 'assets/barIcon/hall_active.png',
      inactiveIcon: 'assets/barIcon/hall.png',
      label: '大厅',
    ),
    BottomNavItem(
      activeIcon: 'assets/barIcon/tuto_active.png',
      inactiveIcon: 'assets/barIcon/tuto.png',
      label: '教程',
    ),
    BottomNavItem(
      activeIcon: 'assets/barIcon/mine_active.png',
      inactiveIcon: 'assets/barIcon/mine.png',
      label: '我的',
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
