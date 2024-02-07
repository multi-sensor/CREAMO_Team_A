import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothHelper {
  static BluetoothDevice? connectedDevice;
  static List<BluetoothDevice> devices = [];
  static StreamSubscription<List<ScanResult>>? scanSubscription;

  static Future<void> startBluetoothScan(BuildContext context) async {
    devices.clear(); // 기존에 스캔한 장치 정보 초기화

    // 연결된 기기가 있으면 해당 정보를 보여줌
    if (connectedDevice != null) {
      _showConnectedDeviceDialog(context);
      return;
    }

    var status = await Permission.location.status;
    if (status != PermissionStatus.granted) {
      await Permission.location.request();
    }

    if (await Permission.location.status == PermissionStatus.granted) {
      _startInitialScanAndShowDevicesDialog(context);
    }
  }

  static void _startInitialScanAndShowDevicesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            FlutterBluePlus.stopScan();
            return true;
          },
          child: AlertDialog(
            title: Text('블루투스 검색 중...'),
            content: Container(
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        );
      },
    );

    FlutterBluePlus.startScan(
      timeout: Duration(seconds: 3),
      androidUsesFineLocation: true,
    );

    scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      devices.clear();
      List<ScanResult> filteredResults = results.where((result) => result.device.name.contains('Creamo_CB_')).toList();
      for (ScanResult r in filteredResults) {
        devices.add(r.device);
      }
    });

    Future.delayed(Duration(seconds: 3), () {
      FlutterBluePlus.stopScan();
      scanSubscription?.cancel(); // scanSubscription 취소
      if (Navigator.canPop(context)) {
        Navigator.pop(context); // 다이얼로그 닫기
        _showDevicesDialog(context); // 연결 가능한 기기 다이얼로그 표시
      }
    });
  }

  static void _showConnectedDeviceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('연결된 기기 정보'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('기기명: ${connectedDevice?.name ?? ''}'),
              Text('기기 ID: ${connectedDevice?.id.toString() ?? ''}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("연결 해제"),
              onPressed: () {
                _disconnectDevice(context); // 연결 해제 함수 호출
              },
            ),
            TextButton(
              child: Text("닫기"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static void _showDevicesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('연결 가능한 기기들'),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.5, // 화면 높이의 절반
            width: MediaQuery.of(context).size.width * 0.5,
            child: ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(devices[index].name),
                  subtitle: Text(devices[index].id.toString()),
                  onTap: () async {
                    try {
                      await devices[index].connect();
                      connectedDevice = devices[index]; // 연결된 디바이스 설정
                      Fluttertoast.showToast(
                        msg: "기기와 연결되었습니다: ${devices[index].name}",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      Navigator.pop(context); // 현재 다이얼로그 닫기
                    } catch (e) {
                      Fluttertoast.showToast(
                        msg: "기기 연결 실패: ${e.toString()}",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  },
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("닫기"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static void _disconnectDevice(BuildContext context) {
    if (connectedDevice != null) {
      connectedDevice!.disconnect().then((_) {
        connectedDevice = null; // 연결된 기기 초기화
        Fluttertoast.showToast(
          msg: "기기와의 연결이 해제되었습니다.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pop(context); // 대화 상자 닫기
      }).catchError((error) {
        Fluttertoast.showToast(
          msg: "기기 연결 해제 실패: ${error.toString()}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      });
    }
  }
}