import 'package:flutter/material.dart';
import 'content_page.dart';
import 'puzzle_page.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  void _navigateToContentPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ContentPage()),
    );
  }

  void _navigateToPuzzlePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PuzzlePage(imagePath: 'images/start/start_button_1.png')),
    );
  }



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
                  child: Image.asset('images/start/creamo_logo.png'),
                ),
              ),
              Expanded(
                flex: 8,
                child: Container(
                  color: Color(0xFFFAB75D),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => StartPage()),
                            );
                          },
                          child: Image.asset('images/button/home.png'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: InkWell(
                          onTap: () {
                            // 여기에 버튼을 눌렀을 때 수행할 작업을 추가하세요.
                          },
                          child: Image.asset('images/button/poweroff.png'),
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
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/start/start_background.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),

          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: InkWell(
                    onTap: () => _navigateToPuzzlePage(context),
                    child: Image.asset('images/start/start_button_1.png', width: 300, height: 340),
                  ),
                ),
                SizedBox(width: 50),
                Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: InkWell(
                    onTap: () => _navigateToContentPage(context),
                    child: Image.asset('images/start/use_button_1.png', width: 300, height: 340),
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
