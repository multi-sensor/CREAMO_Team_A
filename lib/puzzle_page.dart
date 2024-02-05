//test
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
                          ),
                          feedback: image,
                          child: image,
                          onDragEnd: (details) {
                            final RenderBox targetBox =
                            _targetKey.currentContext!.findRenderObject() as RenderBox;
                            final targetPosition = targetBox.globalToLocal(details.offset);

                            if (targetBox.size.contains(targetPosition)) {
                              setState(() {
                                droppedImages.add(DraggableImage(
                                  name: 'images/puzzle/block${index + 1}',
                                  path: 'images/puzzle/block${index + 1}.png',
                                  position: targetPosition,
                                  size: snapshot.data!,
                                ));
                              });
                            }
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

  void startBluetoothScan() {
    flutterBlue.startScan(timeout: Duration(seconds: 4));

    flutterBlue.scanResults.listen((results) {
      for (ScanResult r in results) {
        setState(() {
          devices.add(r.device);
        });
      }
    });

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
                      Fluttertoast.showToast(
                          msg: "Connected to ${devices[index].name}",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                      Navigator.of(context).pop();
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
  }
}

class DraggableImage {
  final String name;
  final String path;
  Offset position;
  Size size;

  DraggableImage({required this.name, required this.path, required this.position, required this.size});
}