//승연 편집
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
              MaterialPageRoute(builder: (context) => const BackgroundPage()),
            );
          },
        ),
      ),
    );
  }
}

class BackgroundPage extends StatefulWidget {
  const BackgroundPage({Key? key}) : super(key: key);

  @override
  _BackgroundPageState createState() => _BackgroundPageState();
}

class _BackgroundPageState extends State<BackgroundPage> {
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
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
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
            MaterialPageRoute(builder: (context) => SecondScreen(imagePath: imagePath)),
          );
        },
        child: Image.asset(imagePath, width: 200, height: 200),
      ),
    );
  }
}

class SecondScreen extends StatefulWidget {
  final String imagePath;

  const SecondScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  List<DraggableImage> droppedImages = [];

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.red,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Draggable<DraggableImage>(
                    data: DraggableImage(
                        name: 'images/puzzle/puzzle${index + 1}',
                        path: 'images/puzzle/puzzle${index + 1}.png'),
                    feedback: Image.asset('images/puzzle/puzzle${index + 1}.png',
                        width: 50, height: 50),
                    child: Image.asset('images/puzzle/puzzle${index + 1}.png',
                        width: 80, height: 80),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: DragTarget<DraggableImage>(
              builder: (context, candidateData, rejectedData) {
                return Container(
                  color: Colors.green,
                  child: droppedImages.isNotEmpty
                      ? Stack(
                    children: droppedImages.asMap().entries.map((entry) {
                      int index = entry.key;
                      DraggableImage draggableImage = entry.value;

                      return Positioned(
                        left: index * 80.0,
                        child: Image.asset(draggableImage.path,
                            width: 100, height: 100),
                      );
                    }).toList(),
                  )
                      : const Center(child: Text('Drop the image here')),
                );
              },
              onWillAccept: (data) => true,
              onAccept: (data) {
                setState(() {
                  droppedImages = List.from(droppedImages)..add(data);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DraggableImage {
  final String name;
  final String path;

  DraggableImage({required this.name, required this.path});
}
