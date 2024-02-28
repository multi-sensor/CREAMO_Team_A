import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'puzzle_page.dart'; // PuzzlePage 임포트
import 'start_page.dart'; // StartPage 임포트

class ContentPage extends StatefulWidget {
  const ContentPage({Key? key}) : super(key: key);

  @override
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  List<List<String>> carouselImages = [
    [
      'images/slider/content1.png',
      'images/slider/content2.png',
      'images/slider/content3.png',
      'images/slider/content4.png',
      'images/slider/content5.png',
      'images/slider/content6.png',
      'images/slider/content7.png',
      'images/slider/content8.png',
      'images/slider/content9.png',
      'images/slider/content10.png',
      'images/slider/content11.png',
    ],
    [
      'images/slider/content12.png',
      'images/slider/content13.png',
      'images/slider/content14.png',
      'images/slider/content15.png',
      'images/slider/content16.png',
      'images/slider/content17.png',
    ],
    [
      'images/slider/content18.png',
      'images/slider/content19.png',
      'images/slider/content20.png',
      'images/slider/content21.png',
      'images/slider/content22.png',
      'images/slider/content23.png',
      'images/slider/content24.png',
      'images/slider/content25.png',
      'images/slider/content26.png',
    ],
    // Add more image paths as needed
  ];

  int selectedCarouselIndex = 0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: []); //status 바 숨김 기능
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
                  color: Color(0xFFFFF6EB),
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
                              MaterialPageRoute(
                                  builder: (context) => StartPage()),
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
          // Background color
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Color(0xFFFFF6EB),
          ),
          // Row for 2:8 division
          Column(
            children: [
              // This Expanded takes 2/10 of the available width
              Expanded(
                flex: 2,
                child: Container(
                  //color: Colors.amber,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 15.0, 0.0, 0.0),
                        child: IconButton(
                          icon: Image.asset(
                            'images/button/easy.png',
                            width: 126,
                            height: 62,
                          ),
                          onPressed: () {
                            // Do something when button is pressed
                            setState(() {
                              selectedCarouselIndex = 0;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 15.0, 0.0, 0.0),
                        child: IconButton(
                          icon: Image.asset(
                            'images/button/middle.png',
                            width: 126,
                            height: 62,
                          ),
                          onPressed: () {
                            // Do something when button is pressed
                            setState(() {
                              selectedCarouselIndex = 1;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 15.0, 0.0, 0.0),
                        child: IconButton(
                          icon: Image.asset(
                            'images/button/hard.png',
                            width: 126,
                            height: 62,
                          ),
                          onPressed: () {
                            // Do something when button is pressed
                            setState(() {
                              selectedCarouselIndex = 2;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // This Expanded takes 8/10 of the available width
              Expanded(
                flex: 8,
                child: Positioned(
                  left: 250,
                  top: 90,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: CarouselSlider.builder(
                      itemCount: carouselImages[selectedCarouselIndex].length,
                      options: CarouselOptions(
                        aspectRatio: 16 / 9,
                        viewportFraction: 1 / 3,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: false,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {},
                        scrollDirection: Axis.horizontal,
                      ),
                      itemBuilder: (context, index, realIndex) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PuzzlePage(imagePath: carouselImages[selectedCarouselIndex][index]),
                              ),
                            );
                          },
                          child: _buildImageWithPadding(carouselImages[selectedCarouselIndex][index], index),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageWithPadding(String imagePath, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Image.asset(imagePath, width: 450, height: 400),
    );
  }
}



