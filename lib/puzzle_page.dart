import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class PuzzlePage extends StatefulWidget {
  final String imagePath;

  const PuzzlePage({Key? key, required this.imagePath}) : super(key: key);

  @override
  _PuzzlePageState createState() => _PuzzlePageState();
}

class _PuzzlePageState extends State<PuzzlePage> {
  final GlobalKey _targetKey = GlobalKey();
  List<DraggableImage> droppedImages = [];
  int startFlag = 0; // 시작 플래그 추가
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> devices = [];

  Future<Size> _getImageSize(Image image) async {
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
                itemCount: startFlag == 0 ? 3 : 2,
                itemBuilder: (context, index) {
                  final imageIdx = startFlag == 0 ? index + 1 : index + 2;
                  final image = Image.asset('images/puzzle/block${imageIdx}.png');
                  return FutureBuilder<Size>(
                    future: _getImageSize(image),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Draggable<DraggableImage>(
                          data: DraggableImage(
                            name: 'images/puzzle/block${imageIdx}',
                            path: 'images/puzzle/block${imageIdx}.png',
                            position: Offset.zero,
                            size: snapshot.data!,
                            blockIndex: imageIdx, // 블록의 인덱스 추가
                          ),
                          feedback: image,
                          child: image,
                          onDragEnd: (details) {
                            final RenderBox targetBox =
                            _targetKey.currentContext!.findRenderObject() as RenderBox;
                            final targetPosition = targetBox.globalToLocal(details.offset);
                            if (imageIdx == 1){
                              setState((){startFlag = 1;});
                            }

                            setState(() {
                              final newImage = DraggableImage(
                                name: 'images/puzzle/block${imageIdx}',
                                path: 'images/puzzle/block${imageIdx}.png',
                                position: targetPosition,
                                size: snapshot.data!,
                                blockIndex: imageIdx, // 블록의 인덱스 추가
                              );

                              // 현재 드랍한 블록과 가장 근접한 기존 블록 찾기
                              DraggableImage? nearestImage = getNearestImage(newImage);

                              // 근접한 블록이 있다면 스냅 포인트에 따라 위치 조절
                              if (nearestImage != null) {
                                newImage.position = getSnappedPosition(
                                  targetPosition,
                                  nearestImage,
                                );
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
                        child: Draggable(
                          data: draggableImage,
                          feedback: Image.asset(
                            draggableImage.path,
                            width: draggableImage.size.width,
                            height: draggableImage.size.height,
                          ),
                          child: Image.asset(
                            draggableImage.path,
                            width: draggableImage.size.width,
                            height: draggableImage.size.height,
                          ),
                          onDraggableCanceled: (_, __) {
                            // 드래그 취소 시에 호출되는 함수
                            setState(() {
                              if(draggableImage.blockIndex == 1)
                                startFlag = 0;
                              droppedImages.remove(draggableImage);
                            });
                          },
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

  Offset getSnappedPosition(Offset targetPosition, DraggableImage newImage) {
    final snapPoints = {
      1: {'left': Offset(16, 50), 'right': Offset(116, 50)},
      2: {'left': Offset(16, 50), 'right': Offset(232, 50)},
      3: {'left': Offset(16, 50), 'right': Offset(116, 50)},
    };

    Offset nearestSnapPoint = targetPosition;
    double minDistance = double.infinity;

    // 새로운 블록의 왼쪽 스냅포인트
    final newImageLeftSnapPoint = snapPoints[newImage.blockIndex]!['left']! + targetPosition;

    for (var droppedImage in droppedImages) { // droppedImages는 모든 드랍된 이미지들의 리스트를 참조해야 합니다.
      // 기존 드랍된 블록의 오른쪽 스냅포인트
      final droppedImageRightSnapPoint = snapPoints[droppedImage.blockIndex]!['right']! + droppedImage.position;

      // 거리 계산
      final distance = (newImageLeftSnapPoint - droppedImageRightSnapPoint).distance;

      // 가장 가까운 스냅포인트 찾기
      if (distance < 30.0 && distance < minDistance) {
        nearestSnapPoint = droppedImageRightSnapPoint - snapPoints[newImage.blockIndex]!['left']!;
        minDistance = distance;
      }
    }

    return nearestSnapPoint;
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