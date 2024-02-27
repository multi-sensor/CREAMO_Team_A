import 'dart:async';
import 'package:flutter/material.dart';
import 'bluetooth_helper.dart'; // 블루투스 도우미 파일 임포트
import 'package:flutter/services.dart';
import 'start_page.dart';

//전역변수 설정
String connected_block_numbers='';

// 퍼즐 페이지 위젯
class PuzzlePage extends StatefulWidget {
  final String imagePath;

  const PuzzlePage({Key? key, required this.imagePath}) : super(key: key);

  @override
  _PuzzlePageState createState() => _PuzzlePageState();
}

class _PuzzlePageState extends State<PuzzlePage> {
  ScrollController scrollController = ScrollController();

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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  color: Color(0xFFFFF6EB), // 첫 번째 상자의 색상
                  child: Image.asset('images/start/creamo_logo.png'),
                ),
              ),
              Expanded(
                flex: 8,
                child: Container(
                  color: Color(0xFFFAB75D), // 두 번째 상자의 색상
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20.0),
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
                      Row(
                        children:[

                          Padding(
                              padding: EdgeInsets.only(right: 30.0), // 좌우 간격 동일하게 설정
                              child: InkWell(
                                onTap: () {
                                  BluetoothHelper.startBluetoothScan(context);
                                },
                                child: Image.asset('images/bluetooth_1.png'),
                              )

                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20.0),
                            child: InkWell(
                              onTap: () {
                                // 버튼을 눌렀을 때 수행할 작업을 추가하세요.
                              },
                              child: Image.asset('images/button/poweroff.png'),
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Container(
              color: Color(0xFFFFF6EB),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 0.0),  // 원하는 간격으로 조절 가능
                    child: IconButton(
                      icon: Image.asset('images/button/button1.png'),
                      onPressed: () {
                        scrollController.animateTo(
                          0.0,  // 이동할 위치
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.0),  // 원하는 간격으로 조절 가능
                    child: IconButton(
                      icon: Image.asset('images/button/button2.png'),
                      onPressed: () {
                        scrollController.animateTo(
                          520.0  - startFlag *125,  // 이동할 위치
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.0),  // 원하는 간격으로 조절 가능
                    child: IconButton(
                      icon: Image.asset('images/button/button3.png'),
                      onPressed: () {
                        scrollController.animateTo(
                          815.0 - startFlag *125,  // 이동할 위치
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.0),  // 원하는 간격으로 조절 가능
                    child: IconButton(
                      icon: Image.asset('images/button/button4.png'),
                      onPressed: () {
                        scrollController.animateTo(
                          1550.0 - startFlag *125,  // 이동할 위치
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.0),  // 원하는 간격으로 조절 가능
                    child: IconButton(
                      icon: Image.asset('images/button/button5.png'),
                      onPressed: () {
                        scrollController.animateTo(
                          3310.0 - startFlag *125,  // 이동할 위치
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 0.0),  // 원하는 간격으로 조절 가능
                    child: IconButton(
                      icon: Image.asset('images/button/button6.png'),
                      onPressed: () {
                        scrollController.animateTo(
                          4500.0 - startFlag *125,  // 이동할 위치
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            flex: 16,
            child: Container(
              color : Color(0xFFFFF6EB),
              child: Scrollbar(
                controller: scrollController,
                child: ListView.builder(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemCount: startFlag == 0 ? 38 : 37,
                  itemBuilder: (context, index) {
                    final imageIdx = startFlag == 0 ? index + 1 : index + 2;
                    final image = Image.asset('images/puzzle/block${imageIdx}.png');
                    return FutureBuilder<Size>(
                      future: _getImageSize(image),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return LongPressDraggable<DraggableImage>(
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
            flex: 80,
            child: Stack(
              children: <Widget>[
                DragTarget<DraggableImage>(
                  key: _targetKey,
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      color: Colors.white,
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
                  bottom: 30,
                  left: 140,
                  child: InkWell(
                    onTap: _resetImages,
                    child: Image.asset('images/button/reset.png'),  // 이미지 경로 적용
                  ),
                ),
                //플레이버튼
                Positioned(
                  bottom: 30,
                  left: 20,
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
                        // 블록2의 내부 스냅 포인트에 연결된 이미지를 찾습니다.
                        if (currentImage.blockIndex == 2) {
                          DraggableImage? innerImage;
                          double minDistance = double.infinity;
                          for (var image in droppedImages) {
                            if (image == currentImage) continue;
                            double distance = (image.leftSnapPoint + image.position -
                                currentImage.rightInnerSnapPoint - currentImage.position)
                                .distance;
                            if (distance < minDistance) {
                              innerImage = image;
                              minDistance = distance;
                            }
                          }
                          if (innerImage != null && minDistance < 50.0) {
                            connectedImages.add(innerImage.path);
                          }
                        }

                        // 외부 스냅 포인트에 연결된 이미지를 찾습니다.
                        DraggableImage? nextImage;
                        double minDistance = double.infinity;
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
                        // 맨 앞의 블럭과 맨 뒤의 블럭을 제외하고, 나머지 블럭들의 순서를 추출합니다.
                        connected_block_numbers = connectedImages.sublist(1, connectedImages.length - 1).map((path) {
                          return path.replaceAll(RegExp(r'\D'), '');
                        }).join(', ');
                        connected_block_numbers = connected_block_numbers.replaceAllMapped(RegExp(r'(\d+), (\d+)'), (match) {
                          return '${match.group(1)}:${match.group(2)}';
                        });
                        BluetoothHelper.sendData(connected_block_numbers);

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('연결된 이미지 목록'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text(connected_block_numbers),  // 합친 문자열을 표시합니다.
                                  ],
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
                    child: Image.asset('images/button/run.png'),  // 이미지 경로 적용

                  ),
                ),


                // 쓰레기통
                Positioned(
                  right: 30,
                  bottom: 30,
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
                              color: Colors.transparent,
                              shape: CircleBorder(),
                            ),
                            child: Image.asset('images/button/trash.png'),  // 이미지 경로 적용

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
      14: {'left': Offset(16, 50), 'right': Offset(132, 50), 'leftInner': Offset(16, 50), 'rightInner': Offset(132, 50),},
      15: {'left': Offset(16, 50), 'right': Offset(132, 50), 'leftInner': Offset(16, 50), 'rightInner': Offset(132, 50),},
      16: {'left': Offset(16, 50), 'right': Offset(132, 50), 'leftInner': Offset(16, 50), 'rightInner': Offset(132, 50),},
      17: {'left': Offset(16, 50), 'right': Offset(132, 50), 'leftInner': Offset(16, 50), 'rightInner': Offset(132, 50),},
      18: {'left': Offset(16, 50), 'right': Offset(132, 50), 'leftInner': Offset(16, 50), 'rightInner': Offset(132, 50),},
      19: {'left': Offset(16, 50), 'right': Offset(132, 50), 'leftInner': Offset(16, 50), 'rightInner': Offset(132, 50),},
      20: {'left': Offset(16, 50), 'right': Offset(132, 50), 'leftInner': Offset(16, 50), 'rightInner': Offset(132, 50),},
      21: {'left': Offset(16, 50), 'right': Offset(132, 50), 'leftInner': Offset(16, 50), 'rightInner': Offset(132, 50),},
      22: {'left': Offset(16, 50), 'right': Offset(132, 50), 'leftInner': Offset(16, 50), 'rightInner': Offset(132, 50),},
      23: {'left': Offset(16, 50), 'right': Offset(132, 50), 'leftInner': Offset(16, 50), 'rightInner': Offset(132, 50),},
      24: {'left': Offset(16, 50), 'right': Offset(132, 50), 'leftInner': Offset(16, 50), 'rightInner': Offset(132, 50),},
      25: {'left': Offset(16, 50), 'right': Offset(132, 50), 'leftInner': Offset(16, 50), 'rightInner': Offset(132, 50),},
      26: {'left': Offset(16, 50), 'right': Offset(132, 50), 'leftInner': Offset(16, 50), 'rightInner': Offset(132, 50),},
      27: {'left': Offset(16, 50), 'right': Offset(132, 50), 'leftInner': Offset(16, 50), 'rightInner': Offset(132, 50),},
      28: {'left': Offset(16, 50), 'right': Offset(132, 50), 'leftInner': Offset(16, 50), 'rightInner': Offset(132, 50),},
      29: {'left': Offset(16, 50), 'right': Offset(132, 50), 'leftInner': Offset(16, 50), 'rightInner': Offset(132, 50),},
      30: {'left': Offset(16, 50), 'right': Offset(132, 50), 'leftInner': Offset(16, 50), 'rightInner': Offset(132, 50),},
      31: {'left': Offset(16, 50), 'right': Offset(132, 50), 'leftInner': Offset(16, 50), 'rightInner': Offset(132, 50),},
      32: {'left': Offset(16, 50), 'right': Offset(132, 50), 'leftInner': Offset(16, 50), 'rightInner': Offset(132, 50),},
      33: {'left': Offset(16, 50), 'right': Offset(132, 50), 'leftInner': Offset(16, 50), 'rightInner': Offset(132, 50),},
      34: {'left': Offset(16, 50), 'right': Offset(132, 50), 'leftInner': Offset(16, 50), 'rightInner': Offset(132, 50),},
      35: {'left': Offset(16, 50), 'right': Offset(132, 50), 'leftInner': Offset(16, 50), 'rightInner': Offset(132, 50),},
      36: {'left': Offset(16, 50), 'right': Offset(132, 50), 'leftInner': Offset(16, 50), 'rightInner': Offset(132, 50),},
      37: {'left': Offset(16, 50), 'right': Offset(132, 50), 'leftInner': Offset(16, 50), 'rightInner': Offset(132, 50),},
      38: {'left': Offset(16, 50), 'right': Offset(132, 50), 'leftInner': Offset(16, 50), 'rightInner': Offset(132, 50),},
    }[index]!;
  }
}
