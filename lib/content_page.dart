import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'puzzle_page.dart'; // Importing PuzzlePage
import 'package:carousel_slider/carousel_slider.dart';
import 'start_page.dart';

enum ContainerState {
  Initial,
  Middle,
  Hard,
}

class ContentPage extends StatefulWidget {
  const ContentPage({Key? key}) : super(key: key);

  @override
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  ContainerState containerState = ContainerState.Initial;
  // 각각의 컨테이너에 대한 이미지 리스트
  final List<String> initialImages = [
    'images/slider_initial/1.png',
    'images/slider_initial/2.png',
    'images/slider_initial/3.png',
    // Add more images as needed
  ];

  final List<String> middleImages = [
    'images/slider_middle/1.png',
    'images/slider_middle/2.png',
    'images/slider_middle/3.png',
    // Add more images as needed
  ];

  final List<String> hardImages = [
    'images/slider_hard/1.png',
    'images/slider_hard/2.png',
    'images/slider_hard/3.png',
    // Add more images as needed
  ];

  @override
  Widget build(BuildContext context) {


    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual, overlays: []); //status 바 숨김 기능
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
                            setState(() {
                              containerState = ContainerState.Initial;
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
                            setState(() {
                              containerState = ContainerState.Middle;
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
                        ), // Replace with your image
                        onPressed: () {
                          setState(() {
                            containerState = ContainerState.Hard;
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
                  child: _buildContainer(),
                ),
              ),
            ],
          ),
        ],
      ),
    );

  }

  // 각각의 컨테이너에 대한 슬라이더 반환
  Widget _buildContainer() {
    switch (containerState) {
      case ContainerState.Initial:
        return _buildCarouselSlider(initialImages); // initialImages 사용
      case ContainerState.Middle:
        return _buildCarouselSlider(middleImages); // middleImages 사용
      case ContainerState.Hard:
        return _buildCarouselSlider(hardImages); // hardImages 사용
      default:
        return Container(); // 기본값으로 빈 컨테이너 반환
    }
  }

  // 슬라이더 생성 및 반환
  Widget _buildCarouselSlider(List<String> images) { // 이미지 리스트 파라미터 추가
    return Positioned(
      left: 150,
      top: (MediaQuery.of(context).size.height - 500) / 2,
      child: Container(
        width: 950,
        height: 500,
        child: CarouselSlider.builder(
          itemCount: images.length ~/ 3,
          options: CarouselOptions(
            aspectRatio: 16 / 9,
            viewportFraction: 1,
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
            return Row(
              children: [
                _buildImageWithPadding(images[index * 3], index * 3),
                _buildImageWithPadding(images[index * 3 + 1], index * 3 + 1),
                _buildImageWithPadding(images[index * 3 + 2], index * 3 + 2),
              ],
            );
          },
        ),
      ),
    );
  }


  Widget _buildImageWithPadding(String imagePath, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PuzzlePage(imagePath: imagePath)),
          );
        },
        child: Image.asset(imagePath, width: 280, height: 296),
      ),
    );
  }



}
