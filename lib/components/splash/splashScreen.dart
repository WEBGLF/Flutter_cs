import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

class SplashScreen extends StatelessWidget {
  final String animationPath; // Lottie 动画路径
  final Color backgroundColor; // 背景色
  final double splashIconSize; // 动画大小
  final Widget nextScreen; // 下一个页面
  final int durationInSeconds; // 动画持续时间
  const SplashScreen({
    super.key,
    required this.nextScreen,
    this.animationPath = 'assets/public/Lottie.json',
    this.backgroundColor = Colors.white,
    this.splashIconSize = 400,
    this.durationInSeconds = 3,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: LottieBuilder.asset(
              animationPath,
              width: splashIconSize,
              height: splashIconSize,
            ),
          ),
        ],
      ),
      nextScreen: nextScreen, // 接收外部传入的页面
      backgroundColor: backgroundColor,
      splashIconSize: splashIconSize,
      duration: durationInSeconds * 1000, // 转换为毫秒
    );
  }
}
