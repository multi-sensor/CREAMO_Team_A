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
        automaticallyImplyLeading: false,
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
                  color: Color(0xFFFAB75D), // 두 번째 상자의 색상
                  child: Row( // 가로로 위젯을 배치하는 위젯
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // 각각의 아이템을 양 끝으로 배치
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20.0), // 왼쪽으로 20.0만큼 띄우기
                        child: InkWell( // InkWell 위젯을 사용하여 이미지에 버튼 기능 추가
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => StartPage()),
                            );
                          },
                          child: Image.asset('images/home.png'), // home button
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20.0), // 오른쪽으로 20.0만큼 띄우기
                        child: InkWell( // InkWell 위젯을 사용하여 이미지에 버튼 기능 추가
                          onTap: () {
                            // 여기에 버튼을 눌렀을 때 수행할 작업을 추가하세요.
                          },
                          child: Image.asset('images/poweroff.png'), // 우측에 추가할 이미지
                        ),
                      ),
                    ],
                  ),
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
                Padding(
                  padding: EdgeInsets.only(top: 50.0), // 패딩으로 위치 조정
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
                SizedBox(width: 50),  // 두 이미지 사이에 간격을 줍니다.
                Padding(
                  padding: EdgeInsets.only(top: 50.0), // 패딩으로 위치 조정
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