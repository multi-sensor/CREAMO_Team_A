import 'package:flutter/material.dart';
import 'bluetooth_helper.dart';

class PuzzlePage extends StatefulWidget {
  final String imagePath;

  const PuzzlePage({Key? key, required this.imagePath}) : super(key: key);

  @override
  _PuzzlePageState createState() => _PuzzlePageState();
}

class _PuzzlePageState extends State<PuzzlePage> {
  List<DraggableImage> droppedImages = [];

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Puzzle Page'),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.bluetooth_searching),
            tooltip: 'Connect to Bluetooth',
            onPressed: () {
              BluetoothHelper.startBluetoothScan(context);
            },
          ),
        ],
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
                    feedback: Image.asset(
                        'images/puzzle/puzzle${index + 1}.png',
                        width: 50,
                        height: 50),
                    child: Image.asset(
                        'images/puzzle/puzzle${index + 1}.png',
                        width: 100,
                        height: 100),
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
                    children: droppedImages
                        .asMap()
                        .entries
                        .map((entry) {
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
