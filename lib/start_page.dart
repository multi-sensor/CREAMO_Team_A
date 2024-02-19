import 'package:flutter/material.dart';
import 'content_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: StartPage(),
    );
  }
}

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                    color : Color(0xFFFFF6EB),
                  child: Image.asset('images/start/creamo_logo.png'),// 첫 번째 상자의 색상

                ),
              ),
              Expanded(
                flex: 8,
                child: Container(
                  color: Color(0xFFFAB75D),// 두 번째 상자의 색상
                ),
              ),
            ],
          ),
        ),
      ),


      body: Stack(
        children: [
          // 배경 이미지
          Positioned(
            bottom: 0,  // 하단에 위치시킵니다.
            child: Image.asset('images/start/start_background.png'),

          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Positioned(
                  top: 307, // 원하는 위치로 조정
                  left: 240, // 원하는 위치로 조정
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ContentPage()),
                      );
                    },
                    child: Image.asset('images/start/start_button.png', width: 294, height: 470),
                  ),
                ),
                SizedBox(width: 20),  // 두 이미지 사이에 간격을 줍니다.
                Positioned(
                  top: 307, // 원하는 위치로 조정
                  left: 721, // 원하는 위치로 조정
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ContentPage()),
                      );
                    },
                    child: Image.asset('images/start/use_button.png', width: 486, height: 399),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}