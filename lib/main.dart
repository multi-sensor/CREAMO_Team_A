import 'package:flutter/material.dart';
import 'splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ADDI CODING',  // 앱의 제목을 설정합니다.
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashPage(),  // SplashPage를 시작 페이지로 설정합니다.
    );
  }
}