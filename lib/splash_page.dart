import 'package:flutter/material.dart';
import 'start_page.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(  // GestureDetector 위젯을 사용하여 클릭 이벤트를 처리합니다.
      onTap: () {
        Navigator.push(  // 클릭하면 start_page.dart로 이동합니다.
          context,
          MaterialPageRoute(builder: (context) => StartPage()),
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/backgrounds/splash_background.png"),  // 배경 이미지를 설정합니다.
            fit: BoxFit.cover,  // 이미지가 화면에 꽉 차게 설정합니다.
          ),
        ),
      ),
    );
  }
}

