//test
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
//import 'package:fluttertoast/fluttertoast.dart';

class PuzzlePage extends StatefulWidget {
  final String imagePath;

  const PuzzlePage({Key? key, required this.imagePath}) : super(key: key);

  @override
  _PuzzlePageState createState() => _PuzzlePageState();
}

class _PuzzlePageState extends State<PuzzlePage> {
  final GlobalKey _targetKey = GlobalKey();
  List<DraggableImage> droppedImages = [];
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> devices = [];


  Future<Size> _getImageSize(Image image) async {
    // 이미지의 크기를 비동기적으로 가져오는 함수
    final Completer<Size> completer = Completer<Size>();
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
            (ImageInfo info, bool _) => completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        )),
      ),
    );
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puzzle Page'),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.bluetooth_searching),
            tooltip: 'Connect to Bluetooth',
            onPressed: startBluetoothScan,
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
                itemCount: 3,
                itemBuilder: (context, index) {
                  final image = Image.asset('images/puzzle/block${index + 1}.png');
                  return FutureBuilder<Size>(
                    future: _getImageSize(image),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Draggable<DraggableImage>(
                          data: DraggableImage(
                            name: 'images/puzzle/block${index + 1}',
                            path: 'images/puzzle/block${index + 1}.png',
                            position: Offset.zero,
                            size: snapshot.data!,
                            blockIndex: index + 1,
                          ),
                          feedback: image,
                          child: image,
                          onDragEnd: (details) {
                            final RenderBox targetBox = _targetKey.currentContext!.findRenderObject() as RenderBox;
                            final targetPosition = targetBox.globalToLocal(details.offset);

                            setState(() {
                              final newImage = DraggableImage(
                                name: 'images/puzzle/block${index + 1}',
                                path: 'images/puzzle/block${index + 1}.png',
                                position: targetPosition,
                                size: snapshot.data!,
                                blockIndex: index + 1,
                              );

                              // 첫 번째 블록이 드랍되지 않은 경우 위치를 조정
                              if (droppedImages.isEmpty) {
                                newImage.position = Offset(
                                  targetPosition.dx - snapshot.data!.width / 2,
                                  targetPosition.dy - snapshot.data!.height / 2,
                                );
                              } else {
                                // 첫 번째 블록 이후의 블록은 가장 가까운 스냅 포인트에 맞춰 붙도록 설정
                                final nearestImage = getNearestImage(newImage);
                                if (nearestImage != null) {
                                  final snappedPosition = getSnappedPosition(newImage, nearestImage);
                                  newImage.position = snappedPosition;
                                }
                              }

                              droppedImages.add(newImage);
                            });
                          },
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: DragTarget<DraggableImage>(
              key: _targetKey,
              builder: (context, candidateData, rejectedData) {
                return Container(
                  color: Colors.green,
                  child: Stack(
                    children: droppedImages.map((draggableImage) {
                      return Positioned(
                        left: draggableImage.position.dx,
                        top: draggableImage.position.dy,
                        child: Image.asset(
                          draggableImage.path,
                          width: draggableImage.size.width,
                          height: draggableImage.size.height,
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
              onWillAccept: (data) => true,
              onAccept: (data) {},
            ),
          ),
        ],
      ),
    );
  }

  DraggableImage? getNearestImage(DraggableImage newImage) {
    DraggableImage? nearestImage;

    double minDistance = double.infinity;

    for (var droppedImage in droppedImages) {
      final distance = (newImage.position - droppedImage.position).distance;
      if (distance < minDistance) {
        minDistance = distance;
        nearestImage = droppedImage;
      }
    }

    return nearestImage;
  }

  Offset getSnappedPosition(DraggableImage newImage, DraggableImage nearestImage) {
    final snapPoints = {
      1: {'left': Offset(0, 50), 'right': Offset(116, 50)},
      2: {'left': Offset(116, 50), 'right': Offset(216, 50)},
      3: {'left': Offset(216, 50), 'right': Offset(316, 50)},
    };

    final leftSnapPoint = snapPoints[nearestImage.blockIndex]!['left']!;
    final rightSnapPoint = snapPoints[nearestImage.blockIndex]!['right']!;

    final newImageCenter =
    Offset(newImage.position.dx + newImage.size.width / 2,
        newImage.position.dy + newImage.size.height / 2);

    final nearestImageCenter =
    Offset(nearestImage.position.dx + nearestImage.size.width / 2,
        nearestImage.position.dy + nearestImage.size.height / 2);

    final leftDistance = (newImageCenter - leftSnapPoint).distance;
    final rightDistance = (newImageCenter - rightSnapPoint).distance;

    final snappedPoint =
    leftDistance < rightDistance ? leftSnapPoint : rightSnapPoint;

    return Offset(
      snappedPoint.dx - newImage.size.width / 2,
      snappedPoint.dy - newImage.size.height / 2,
    );
  }


  void startBluetoothScan() {
    flutterBlue.startScan(timeout: Duration(seconds: 10));

    flutterBlue.scanResults.listen((results) {
      for (ScanResult r in results) {
        setState(() {
          devices.add(r.device);
        });
      }
    });

    Future.delayed(Duration(seconds: 10)).then((_) {
      flutterBlue.stopScan();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Bluetooth Devices'),
            content: Container(
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(devices[index].name),
                    subtitle: Text(devices[index].id.toString()),
                    onTap: () {
                      devices[index].connect().then((_) {
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Connection Successful'),
                              content: Text(
                                  "Connected to ${devices[index].name}"),
                              actions: <Widget>[
                                TextButton(
                                  child: Text("Close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      });
                    },
                  );
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }
}

class DraggableImage {
  final String name;
  final String path;
  Offset position;
  Size size;
  int blockIndex; // 블록의 인덱스 추가

  DraggableImage({
    required this.name,
    required this.path,
    required this.position,
    required this.size,
    required this.blockIndex,
  });
}