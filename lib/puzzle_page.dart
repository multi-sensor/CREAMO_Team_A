import 'dart:async';
import 'package:flutter/material.dart';
import 'bluetooth_helper.dart';
import 'package:flutter/services.dart';

class PuzzlePage extends StatefulWidget {
  final String imagePath;

  const PuzzlePage({Key? key, required this.imagePath}) : super(key: key);

  @override
  _PuzzlePageState createState() => _PuzzlePageState();
}

class _PuzzlePageState extends State<PuzzlePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _targetKey = GlobalKey();
  List<DraggableImage> droppedImages = [];
  int startFlag = 0; // 시작 플래그 추가

  Future<Size> _getImageSize(Image image) async {
    final Completer<Size> completer = Completer<Size>();
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
            (ImageInfo info, bool _) =>
            completer.complete(Size(
              info.image.width.toDouble(),
              info.image.height.toDouble(),
            )),
      ),
    );
    return completer.future;
  }

  void _resetImages() {
    setState(() {
      droppedImages.clear();
      startFlag = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []); //status 바 숨김 기능
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
        flex: 2,
        child: Container(
          color: Colors.red,
          child: Scrollbar(
            controller: _scrollController,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: startFlag == 0 ? 13 : 12,
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
                          blockIndex: imageIdx,
                        ),
                        feedback: image,
                        child: image,
                        onDragEnd: (details) {
                          final RenderBox targetBox =
                          _targetKey.currentContext!
                              .findRenderObject() as RenderBox;
                          final targetPosition =
                          targetBox.globalToLocal(details.offset);
                          if (imageIdx == 1) {
                            setState(() {
                              startFlag = 1;
                            });
                          }

                          setState(() {
                            final newImage = DraggableImage(
                              name: 'images/puzzle/block${imageIdx}',
                              path: 'images/puzzle/block${imageIdx}.png',
                              position: targetPosition,
                              size: snapshot.data!,
                              blockIndex: imageIdx,
                            );

                            // 현재 드랍한 블록과 가장 근접한 기존 블록 찾기
                            DraggableImage? nearestImage =
                            getNearestImage(newImage);

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
      ),

          Expanded(
            flex: 8,
            child: Stack(
              children: <Widget>[
                DragTarget<DraggableImage>(
                  key: _targetKey,
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      color: Colors.green,
                      child: Stack(
                        children: droppedImages.map((draggableImage) {
                          return Positioned(
                            left: draggableImage.position.dx,
                            top: draggableImage.position.dy,
                            child: Draggable<DraggableImage>(
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

                              onDragEnd: (details) {
                                // 쓰레기통의 범위를 정의합니다.
                                final trashCanRange = Offset(MediaQuery
                                    .of(context).size.width - 300, MediaQuery.of(context).size.height - 300);

                                // 쓰레기통의 범위 내에 블록이 있는지 확인합니다.
                                if (details.offset.dx >= trashCanRange.dx &&
                                    details.offset.dy >= trashCanRange.dy) {
                                  // 블록이 쓰레기통의 범위 내에 있다면 블록을 제거합니다.
                                  setState(() {
                                    droppedImages.remove(draggableImage);
                                  });
                                }
                              },
                              onDraggableCanceled: (_, __) {
                                // 드래그 취소 시에 호출되는 함수
                                setState(() {
                                  if (draggableImage.blockIndex == 1)
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
                // Reset button
                Positioned(
                  bottom: 16,
                  right: 120,
                  child: ElevatedButton(
                    onPressed: _resetImages,
                    child: Text('Reset'),
                  ),
                ),
                // 쓰레기통
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: DragTarget<DraggableImage>(
                    builder: (context, candidateData, rejectedData) {
                      return Container(
                        width: 50,
                        height: 50,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: CircleBorder(),
                        ),
                        child: Icon(
                          Icons.delete,
                          size: 25,
                        ),
                      );
                    },
                    onWillAccept: (data) => true,
                    onAccept: (data) {
                      setState(() {
                        droppedImages.remove(data);
                      });
                    },
                  ),
                ),
              ],
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
      2: {'left': Offset(16, 50), 'right': Offset(284, 50)},
      3: {'left': Offset(16, 50), 'right': Offset(116, 50)},
      4: {'left': Offset(16, 50), 'right': Offset(132, 50)},
      5: {'left': Offset(16, 50), 'right': Offset(132, 50)},
      6: {'left': Offset(16, 50), 'right': Offset(132, 50)},
      7: {'left': Offset(16, 50), 'right': Offset(132, 50)},
      8: {'left': Offset(16, 50), 'right': Offset(132, 50)},
      9: {'left': Offset(16, 50), 'right': Offset(132, 50)},
      10: {'left': Offset(16, 50), 'right': Offset(132, 50)},
      11: {'left': Offset(16, 50), 'right': Offset(132, 50)},
      12: {'left': Offset(16, 50), 'right': Offset(132, 50)},
      13: {'left': Offset(16, 50), 'right': Offset(132, 50)},
    };

    Offset nearestSnapPoint = targetPosition;
    double minDistance = double.infinity;

    final newImageLeftSnapPoint = snapPoints[newImage.blockIndex]!['left']! + targetPosition;
    final newImageRightSnapPoint = snapPoints[newImage.blockIndex]!['right']! + targetPosition;

    for (var droppedImage in droppedImages) {
      final droppedImageLeftSnapPoint = snapPoints[droppedImage.blockIndex]!['left']! + droppedImage.position;
      final droppedImageRightSnapPoint = snapPoints[droppedImage.blockIndex]!['right']! + droppedImage.position;

      final distanceLeft = (newImageRightSnapPoint - droppedImageLeftSnapPoint).distance;
      final distanceRight = (newImageLeftSnapPoint - droppedImageRightSnapPoint).distance;

      if (distanceLeft < 30.0 && distanceLeft < minDistance) {
        nearestSnapPoint = droppedImageLeftSnapPoint - snapPoints[newImage.blockIndex]!['right']!;
        minDistance = distanceLeft;
      }

      if (distanceRight < 30.0 && distanceRight < minDistance) {
        nearestSnapPoint = droppedImageRightSnapPoint - snapPoints[newImage.blockIndex]!['left']!;
        minDistance = distanceRight;
      }
    }

    return nearestSnapPoint;
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
