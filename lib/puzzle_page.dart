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
  List<DraggableImage> droppedImages = [];
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> devices = [];

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
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Draggable<DraggableImage>(
                    data: DraggableImage(
                        name: 'images/puzzle/puzzle${index + 1}',
                        path: 'images/puzzle/puzzle${index + 1}.png'),
                    feedback: Image.asset('images/puzzle/puzzle${index + 1}.png',
                        width: 50, height: 50),
                    child: Image.asset('images/puzzle/puzzle${index + 1}.png',
                        width: 100, height: 100),
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

  DraggableImage({required this.name, required this.path});
}
