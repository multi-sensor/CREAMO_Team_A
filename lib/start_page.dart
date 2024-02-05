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
      appBar: AppBar(backgroundColor: Colors.blue),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(100, 50),
          ),
          child: const Text('Start', style: TextStyle(fontSize: 20)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ContentPage()),
            );
          },
        ),
      ),
    );
  }
}
