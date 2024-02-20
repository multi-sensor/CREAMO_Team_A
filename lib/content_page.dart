import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'puzzle_page.dart'; // Importing PuzzlePage
import 'package:carousel_slider/carousel_slider.dart';

class ContentPage extends StatefulWidget {
  const ContentPage({Key? key}) : super(key: key);

  @override
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  final List<String> images = [
    'images/slider/1.jpg',
    'images/slider/2.jpg',
    'images/slider/3.jpg',
    'images/slider/4.jpg',
    'images/slider/5.jpg',
    'images/slider/1.jpg',
    'images/slider/2.jpg',
    'images/slider/3.jpg',
    'images/slider/4.jpg',
    // Add more image paths as needed
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);//status 바 숨김 기능
    return Scaffold(
      body: Stack(
        children: [
          // Background Image (Assuming you want to keep this part)
          Image.asset(
            'images/background.png',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          // Slider Container
          Positioned(
            left: 250,
            top: 90,
            child: Container(
              width: 850,
              height: 200,
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
          ),
        ],
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
            MaterialPageRoute(builder: (context) => PuzzlePage(imagePath: imagePath)),
          );
        },
        child: Image.asset(imagePath, width: 200, height: 200),
      ),
    );
  }
}

