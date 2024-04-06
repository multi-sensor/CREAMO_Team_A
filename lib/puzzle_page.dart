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
  double scrollPosition = 0.0; // 스크롤 위치를 저장할 변수

  int selectedSlide = 1; // 현재 선택된 슬라이드 번호


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

    Widget _buildButton(String imagePath, int slideNumber) {
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedSlide = slideNumber;
          });
        },
        child: Image.asset(imagePath),
      );
    }
    int _getItemCountForSelectedSlide() {
      switch (selectedSlide) {
        case 1:
          return (startFlag==0? 2 : 1); // 첫 번째 슬라이드이미지
        case 2:
          return 2; // 두 번째 슬라이드에는 2개의 이미지
        case 3:
          return 5; // 세 번째 슬라이드에는 5개의 이미지
        case 4:
          return 12; // 세 번째 슬라이드에는 5개의 이미지
        case 5:
          return 14; // 세 번째 슬라이드에는 5개의 이미지
        case 6:
          return 8; // 세 번째 슬라이드에는 5개의 이미지
        default:
          return 0;
      }
    }

    int _getImageIndexForSelectedSlide(int index) {
      if (selectedSlide == 1) {
        return (startFlag == 0 ? index + 1 : index + 2);
      } else if (selectedSlide == 2) {
        return index + 3; // block3.png부터 시작
      } else if (selectedSlide == 3) {
        return index + 5; // block5.png부터 시작
      } else if (selectedSlide == 4) {
        return index + 10; // block5.png부터 시작
      } else if (selectedSlide == 5) {
        return index + 22; // block5.png부터 시작
      } else if (selectedSlide == 6) {
        return index + 36; // block5.png부터 시작
      }
      return 0;
    }

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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      Padding(
                        padding: EdgeInsets.only(right: 20.0),
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
                      Padding(
                          padding: EdgeInsets.only(right: 20.0), // 좌우 간격 동일하게 설정
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildButton('images/button/button1.png', 1),
                  SizedBox(width: 10), // 간격 추가
                  _buildButton('images/button/button2.png', 2),
                  SizedBox(width: 10), // 간격 추가
                  _buildButton('images/button/button3.png', 3),
                  SizedBox(width: 10), // 간격 추가
                  _buildButton('images/button/button4.png', 4),
                  SizedBox(width: 10), // 간격 추가
                  _buildButton('images/button/button5.png', 5),
                  SizedBox(width: 10), // 간격 추가
                  _buildButton('images/button/button6.png', 6),
                  SizedBox(width: 10), // 간격 추가
                ],
              ),
            ),
          ),

          Expanded(
            flex: 16,
            child: Container(
              color: Color(0xFFFFF6EB),
              child: Scrollbar(
                controller: scrollController,
                child: ListView.builder(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemCount: _getItemCountForSelectedSlide(),
                  itemBuilder: (context, index) {
                    final imageIdx = _getImageIndexForSelectedSlide(index);
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
                            onDragStarted: () {
                              scrollPosition = scrollController.position.pixels; // 드래그 시작시 스크롤 위치 저장
                            },
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

                              Future.delayed(Duration(milliseconds: 50), () {
                                scrollController.jumpTo(scrollPosition);
                              });

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

                      while (currentImage != null && currentImage.blockIndex != 2) {
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


                      if (currentImage != null && currentImage.blockIndex == 2) {
                        // 허용된 숫자들의 리스트
                        List<int> allowedNumbers = [3, 5, 6, 10, 11, 12, 22, 36, 38, 39, 40, 41, 42, 43];

                        // 맨 앞의 블럭과 맨 뒤의 블럭을 제외하고, 나머지 블럭들의 순서를 추출합니다.
                        List<int> blockNumbers = connectedImages.sublist(1, connectedImages.length - 1).map((path) {
                          return int.parse(path.replaceAll(RegExp(r'\D'), ''));
                        }).toList();

                        List<String> formattedNumbers = [];
                        int i = 0;
                        bool isConditionBlock = false; // 조건 블록 여부를 확인하는 플래그 변수

                        while (i < blockNumbers.length) {
                          if (blockNumbers[i] == 42) { // 조건 시작 블록 처리
                            formattedNumbers.add('42,');
                            isConditionBlock = true; // 조건 블록 시작
                            i++;
                            continue;
                          }
                          if (blockNumbers[i] == 43) { // 조건 끝 블록 처리
                            isConditionBlock = false; // 조건 블록 종료
                            i++;
                            continue;
                          }

                          if (isConditionBlock || allowedNumbers.contains(blockNumbers[i])) { // 조건 블록 내부이거나 허용된 숫자일 경우
                            formattedNumbers.add('${blockNumbers[i]}:'); // 직접 숫자를 추가
                            i++;
                          } else { // 허용되지 않은 숫자일 경우
                            String numberString = '';
                            while (i < blockNumbers.length && !allowedNumbers.contains(blockNumbers[i]) && blockNumbers[i] != 42 && blockNumbers[i] != 43) {
                              numberString += '${blockNumbers[i]}';
                              i++;
                            }
                            // 조건 블록이 아니고, 허용되지 않은 숫자일 때만 [ ]로 묶어서 추가
                            if (!numberString.isEmpty) {
                              formattedNumbers.add('[$numberString],');
                            }
                          }
                        }

// 마지막 원소가 ','로 끝나면 제거
                        if (formattedNumbers.isNotEmpty && formattedNumbers.last.endsWith(',')) {
                          formattedNumbers[formattedNumbers.length - 1] = formattedNumbers.last.substring(0, formattedNumbers.last.length - 1);
                        }

                        connected_block_numbers = formattedNumbers.join('');

                      }
                      // connected_block_numbers 문자열을 처리하여 조건에 맞게 수정하는 부분
                      // '38'과 '39', '40', '41' 사이의 모든 문자열을 올바르게 반복하기 위한 로직
                      RegExp regExp = RegExp(r'38(.*?)(39|40|41)');
                      var matches = regExp.allMatches(connected_block_numbers).toList();

                      if (matches.isNotEmpty) {
                        String result = connected_block_numbers;
                        for (var match in matches.reversed) {
                          // 38과 39, 40, 41 사이의 전체 문자열을 추출합니다.
                          String betweenText = match.group(1)!;

                          // 마지막 숫자 (39, 40, 41)를 추출하여 반복 횟수를 결정합니다.
                          int endingNumber = int.parse(match.group(2)!); // 마지막 숫자 (39, 40, 41)
                          int repeatCount = endingNumber - 37; // 반복 횟수 계산

                          // 반복될 문자열을 생성합니다.
                          String repeatedText = '';
                          for (int i = 0; i < repeatCount; i++) {
                            repeatedText += betweenText;
                          }

                          // 원래 문자열에서 매치된 부분을 반복된 문자열로 교체합니다.
                          int startIndex = match.start;
                          int endIndex = match.end;
                          result = result.substring(0, startIndex) + repeatedText + result.substring(endIndex);
                        }
                        connected_block_numbers = result;
                      }


                      RegExp regExp2 = RegExp(r',:');
                      connected_block_numbers = connected_block_numbers.replaceAllMapped(regExp2, (match) {
                        return ',';
                      });
                      // 수정된 connected_block_numbers 문자열을 Bluetooth를 통해 전송하고 출력합니다.
                      BluetoothHelper.sendData(connected_block_numbers);
                      print(connected_block_numbers);

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

    final newImageLeftSnapPoint = newImage.leftSnapPoint + targetPosition;
    final newImageRightSnapPoint = newImage.rightSnapPoint + targetPosition;

    for (var droppedImage in droppedImages) {
      final droppedImageLeftSnapPoint = droppedImage.leftSnapPoint + droppedImage.position;
      final droppedImageRightSnapPoint = droppedImage.rightSnapPoint + droppedImage.position;

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


  // 생성자
  DraggableImage({
    required this.name,
    required this.path,
    required this.position,
    required this.size,
    required this.blockIndex,
  }) : leftSnapPoint = getSnapPoints(blockIndex)['left']!,
        rightSnapPoint = getSnapPoints(blockIndex)['right']!;


  // 블록의 스냅 포인트를 반환하는 함수
  static Map<String, Offset> getSnapPoints(int index) {
    return {
      1: {'left': Offset(16, 50), 'right': Offset(116, 50),},
      2: {'left': Offset(16, 50), 'right': Offset(284, 50),},
      3: {'left': Offset(16, 50), 'right': Offset(116, 50),},
      4: {'left': Offset(16, 50), 'right': Offset(132, 50),},
      5: {'left': Offset(16, 50), 'right': Offset(132, 50),},
      6: {'left': Offset(16, 50), 'right': Offset(132, 50),},
      7: {'left': Offset(16, 50), 'right': Offset(132, 50), },
      8: {'left': Offset(16, 50), 'right': Offset(132, 50), },
      9: {'left': Offset(16, 50), 'right': Offset(132, 50), },
      10: {'left': Offset(16, 50), 'right': Offset(132, 50), },
      11: {'left': Offset(16, 50), 'right': Offset(132, 50), },
      12: {'left': Offset(16, 50), 'right': Offset(132, 50), },
      13: {'left': Offset(16, 50), 'right': Offset(132, 50), },
      14: {'left': Offset(16, 50), 'right': Offset(132, 50), },
      15: {'left': Offset(16, 50), 'right': Offset(132, 50), },
      16: {'left': Offset(16, 50), 'right': Offset(132, 50), },
      17: {'left': Offset(16, 50), 'right': Offset(132, 50), },
      18: {'left': Offset(16, 50), 'right': Offset(132, 50),},
      19: {'left': Offset(16, 50), 'right': Offset(132, 50),},
      20: {'left': Offset(16, 50), 'right': Offset(132, 50), },
      21: {'left': Offset(16, 50), 'right': Offset(132, 50), },
      22: {'left': Offset(16, 50), 'right': Offset(132, 50),},
      23: {'left': Offset(16, 50), 'right': Offset(132, 50), },
      24: {'left': Offset(16, 50), 'right': Offset(132, 50), },
      25: {'left': Offset(16, 50), 'right': Offset(132, 50), },
      26: {'left': Offset(16, 50), 'right': Offset(132, 50), },
      27: {'left': Offset(16, 50), 'right': Offset(132, 50), },
      28: {'left': Offset(16, 50), 'right': Offset(132, 50), },
      29: {'left': Offset(16, 50), 'right': Offset(132, 50), },
      30: {'left': Offset(16, 50), 'right': Offset(132, 50), },
      31: {'left': Offset(16, 50), 'right': Offset(132, 50), },
      32: {'left': Offset(16, 50), 'right': Offset(132, 50), },
      33: {'left': Offset(16, 50), 'right': Offset(132, 50), },
      34: {'left': Offset(16, 50), 'right': Offset(132, 50), },
      35: {'left': Offset(16, 50), 'right': Offset(132, 50),},
      36: {'left': Offset(16, 50), 'right': Offset(132, 50), },
      37: {'left': Offset(16, 50), 'right': Offset(132, 50), },
      38: {'left': Offset(16, 50), 'right': Offset(132, 50), },
      39: {'left': Offset(16, 50), 'right': Offset(132, 50),},
      40: {'left': Offset(16, 50), 'right': Offset(132, 50), },
      41: {'left': Offset(16, 50), 'right': Offset(132, 50), },
      42: {'left': Offset(16, 50), 'right': Offset(132, 50),},
      43: {'left': Offset(16, 50), 'right': Offset(132, 50), },
      //44: {'left': Offset(16, 50), 'right': Offset(132, 50), },

    }[index]!;
  }

}