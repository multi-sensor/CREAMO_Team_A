import 'dart:async';
import 'package:flutter/material.dart';
import 'bluetooth_helper.dart'; // 블루투스 도우미 파일 임포트
import 'package:flutter/services.dart';

// 퍼즐 페이지 위젯
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
  int startFlag = 0; // 시작 플래그

  // 이미지 크기를 비동기적으로 가져오는 함수
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

  // 이미지들을 초기화하는 함수
  void _resetImages() {
    setState(() {
      droppedImages.clear();
      startFlag = 0;
    });
  }

  // 위젯 빌드 함수
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []); //status 바 숨김 기능

    return Scaffold(
      appBar: AppBar(
        title: const Text('Puzzle Page'),
        backgroundColor: Colors.lightBlueAccent,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.bluetooth_searching),
            tooltip: 'Connect to Bluetooth',
            onPressed: () {
              BluetoothHelper.startBluetoothScan(context); // 블루투스 스캔 시작
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.white,
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
                      color: Colors.black12,
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
                                setState(() {
                                  final RenderBox box = context.findRenderObject() as RenderBox;
                                  final droppedPosition = box.globalToLocal(details.offset);
                                  // getSnappedPosition 함수를 사용하여 스냅될 위치를 계산합니다.
                                  final snappedPosition = getSnappedPosition(droppedPosition, draggableImage);
                                  draggableImage.position = snappedPosition; // 스냅된 위치로 이미지를 이동합니다.
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
                  bottom: 40,
                  right: 125,
                  child: ElevatedButton(
                    onPressed: _resetImages,
                    child: Text('Reset'),
                  ),
                ),
//플레이버튼
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: InkWell(

                    onTap: () {
                      // '시작' 블록을 찾습니다.
                      DraggableImage startImage = droppedImages.firstWhere((image) => image.blockIndex == 1,
                          orElse: () => DraggableImage(
                            name: 'default',
                            path: 'default',
                            position: Offset.zero,
                            size: Size.zero,
                            blockIndex: 0,
                          ));

                      // '시작' 블록부터 시작하여 연결된 이미지들의 파일명을 순서대로 출력합니다.
                      List<String> connectedImages = [startImage.path];
                      DraggableImage? currentImage = startImage;

                      while (currentImage != null && currentImage.blockIndex != 3) {
                        DraggableImage? nextImage;
                        double minDistance = double.infinity;

                        // 블록2의 내부 스냅 포인트에 연결된 이미지를 찾습니다.
                        if (currentImage.blockIndex == 2) {
                          for (var image in droppedImages) {
                            if (image == currentImage) continue;
                            double distance = (image.leftSnapPoint + image.position -
                                currentImage.rightInnerSnapPoint - currentImage.position)
                                .distance;
                            if (distance < minDistance) {
                              nextImage = image;
                              minDistance = distance;
                            }
                          }
                          // 내부 스냅 포인트에 연결된 이미지가 있으면 추가하고 currentImage를 유지합니다.
                          if (nextImage != null && minDistance < 50.0) {
                            connectedImages.add(nextImage.path);
                            continue;
                          }
                        }

                        // 외부 스냅 포인트에 연결된 이미지를 찾습니다.
                        for (var image in droppedImages) {
                          if (image == currentImage) continue;
                          double distance = (image.leftSnapPoint + image.position -
                              currentImage.rightSnapPoint - currentImage.position)
                              .distance;
                          if (distance < minDistance) {
                            nextImage = image;
                            minDistance = distance;
                          }
                        }

                        if (nextImage != null && minDistance < 50.0) {
                          connectedImages.add(nextImage.path);
                          currentImage = nextImage;
                        } else {
                          currentImage = null;
                        }
                      }

                      if (currentImage != null && currentImage.blockIndex == 3) {
                        // 팝업을 띄웁니다.
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('연결된 이미지 목록'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: connectedImages.map((path) => Text(path)).toList(),
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('확인'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },






                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Icon(
                      Icons.play_circle_fill,
                      size: 100,
                    ),
                  ),
                ),


                // 쓰레기통
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: DragTarget<DraggableImage>(
                    builder: (context, candidateData, rejectedData) {
                      return Container(
                        width: 100,  // 쓰레기통의 드롭 수용 범위 너비
                        height: 100,  // 쓰레기통의 드롭 수용 범위 높이
                        child: Center(  // Container의 중앙에 배치하기 위해 Center 위젯 사용
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: CircleBorder(),
                            ),
                            child: Icon(
                              Icons.delete_outline,
                              size: 80,
                            ),
                          ),
                        ),
                      );
                    },
                    onWillAccept: (data) => true,
                    onAccept: (data) {
                      setState(() {
                        droppedImages.remove(data);
                        if (data.blockIndex == 1) {
                          startFlag = 0;
                        }
                      });

                      // 드롭된 이미지의 위치를 쓰레기통 이미지의 중심으로 조정
                      // 쓰레기통 이미지의 중심 좌표
                      final trashCanCenter = Offset(16 + 200 / 2, MediaQuery.of(context).size.height - 16 - 200 / 2);
                      // 드롭된 이미지의 중심 좌표
                      final imageCenter = Offset(data.position.dx + data.size.width / 2, data.position.dy + data.size.height / 2);
                      // 쓰레기통과 드롭된 이미지의 중심 사이의 거리
                      final distanceToTrashCan = (imageCenter - trashCanCenter).distance;
                      // 일정 거리 내에 드롭된 경우 이미지 삭제
                      if (distanceToTrashCan <= 100) { // 일정 거리 예시로 100으로 설정
                        droppedImages.remove(data);
                      }
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

  // 가장 가까운 이미지를 찾는 함수
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

  // 스냅된 위치를 반환하는 함수
  Offset getSnappedPosition(Offset targetPosition, DraggableImage newImage) {
    Offset nearestSnapPoint = targetPosition;
    double minDistance = double.infinity;
    bool useInnerSnapPoint = false;

    final newImageLeftSnapPoint = newImage.leftSnapPoint + targetPosition;
    final newImageRightSnapPoint = newImage.rightSnapPoint + targetPosition;
    final newImageRightInnerSnapPoint = newImage.rightInnerSnapPoint + targetPosition;

    for (var droppedImage in droppedImages) {
      final droppedImageLeftSnapPoint = droppedImage.leftSnapPoint + droppedImage.position;
      final droppedImageRightSnapPoint = droppedImage.rightSnapPoint + droppedImage.position;
      final droppedImageRightInnerSnapPoint = droppedImage.rightInnerSnapPoint + droppedImage.position;

      final distanceRightInner = (newImageRightInnerSnapPoint - droppedImageRightInnerSnapPoint).distance;

      if (distanceRightInner < 30.0 && distanceRightInner < minDistance) {
        nearestSnapPoint = droppedImageRightInnerSnapPoint - newImage.rightInnerSnapPoint;
        minDistance = distanceRightInner;
        useInnerSnapPoint = true;
      }

      if (!useInnerSnapPoint) {
        final distanceLeft = (newImageRightSnapPoint - droppedImageLeftSnapPoint).distance;
        final distanceRight = (newImageLeftSnapPoint - droppedImageRightSnapPoint).distance;

        if (distanceLeft < 30.0 && distanceLeft < minDistance) {
          nearestSnapPoint = droppedImageLeftSnapPoint - newImage.rightSnapPoint;
          minDistance = distanceLeft;
        }

        if (distanceRight < 30.0 && distanceRight < minDistance) {
          nearestSnapPoint = droppedImageRightSnapPoint - newImage.leftSnapPoint;
          minDistance = distanceRight;
        }
      }
    }

    return nearestSnapPoint;
  }



}

// 드래그 가능한 이미지 클래스
class DraggableImage {
  final String name;
  final String path;
  Offset position;
  Size size;
  int blockIndex; // 블록의 인덱스 추가
  Offset leftSnapPoint; // 왼쪽 스냅 포인트 추가
  Offset rightSnapPoint; // 오른쪽 스냅 포인트 추가
  Offset leftInnerSnapPoint; // 내부 왼쪽 스냅 포인트 추가
  Offset rightInnerSnapPoint; // 내부 오른쪽 스냅 포인트 추가

  // 생성자
  DraggableImage({
    required this.name,
    required this.path,
    required this.position,
    required this.size,
    required this.blockIndex,
  }) : leftSnapPoint = getSnapPoints(blockIndex)['left']!,
        rightSnapPoint = getSnapPoints(blockIndex)['right']!,
        leftInnerSnapPoint = getSnapPoints(blockIndex)['leftInner']!,
        rightInnerSnapPoint = getSnapPoints(blockIndex)['rightInner']!;


  // 블록의 스냅 포인트를 반환하는 함수
  static Map<String, Offset> getSnapPoints(int index) {
    return {
      1: {'left': Offset(16, 50), 'right': Offset(116, 50),'leftInner': Offset(16, 50), 'rightInner': Offset(116, 50),},
      2: {'left': Offset(16, 50), 'right': Offset(284, 50), 'leftInner': Offset(40, 74), 'rightInner': Offset(172, 74),},
      3: {'left': Offset(16, 50), 'right': Offset(116, 50),'leftInner': Offset(16, 50), 'rightInner': Offset(116, 50),},
      4: {'left': Offset(16, 50), 'right': Offset(132, 50),'leftInner': Offset(16, 50), 'rightInner': Offset(132, 50),},
      5: {'left': Offset(16, 50), 'right': Offset(132, 50), 'leftInner': Offset(16, 50), 'rightInner': Offset(132, 50),},
      6: {'left': Offset(16, 50), 'right': Offset(132, 50), 'leftInner': Offset(16, 50), 'rightInner': Offset(132, 50),},
      7: {'left': Offset(16, 50), 'right': Offset(132, 50), 'leftInner': Offset(16, 50), 'rightInner': Offset(132, 50),},
      8: {'left': Offset(16, 50), 'right': Offset(132, 50), 'leftInner': Offset(16, 50), 'rightInner': Offset(132, 50),},
      9: {'left': Offset(16, 50), 'right': Offset(132, 50), 'leftInner': Offset(16, 50), 'rightInner': Offset(132, 50),},
      10: {'left': Offset(16, 50), 'right': Offset(132, 50), 'leftInner': Offset(16, 50), 'rightInner': Offset(132, 50),},
      11: {'left': Offset(16, 50), 'right': Offset(132, 50), 'leftInner': Offset(16, 50), 'rightInner': Offset(132, 50),},
      12: {'left': Offset(16, 50), 'right': Offset(132, 50), 'leftInner': Offset(16, 50), 'rightInner': Offset(132, 50),},
      13: {'left': Offset(16, 50), 'right': Offset(132, 50), 'leftInner': Offset(16, 50), 'rightInner': Offset(132, 50),},
    }[index]!;
  }
}