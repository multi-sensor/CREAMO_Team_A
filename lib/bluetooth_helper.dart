import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothHelper {
  static List<BluetoothDevice> devices = [];
  static StreamSubscription<List<ScanResult>>? scanSubscription;

  static Future<void> startBluetoothScan(BuildContext context) async {
    devices.clear(); // 기존에 스캔한 장치 정보 초기화

    var status = await Permission.location.status;
    if (status != PermissionStatus.granted) {
      await Permission.location.request();
    }

    if (await Permission.location.status == PermissionStatus.granted) {
      _startScanAndShowDialog(context);
    }
  }

  static void _startScanAndShowDialog(BuildContext context) {
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
      for (ScanResult r in results) {
        devices.add(r.device);
      }
    });

    Future.delayed(Duration(seconds: 3), () {
      FlutterBluePlus.stopScan();
      if (Navigator.canPop(context)) { // 다이얼로그가 여전히 열려 있는지 확인
        Navigator.pop(context); // 다이얼로그 닫기
        _showDevicesDialog(context); // 연결 가능한 디바이스 목록 다이얼로그 열기
      }
    });
  }

  static void _showDevicesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('연결 가능한 기기들'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(devices[index].name),
                  subtitle: Text(devices[index].id.toString()),
                  onTap: () async {
                    try {
                      await devices[index].connect();
                      Fluttertoast.showToast(
                        msg: "기기와 연결되었습니다: ${devices[index].name}",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
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
              child: Text("Rescan"),
              onPressed: () {
                Navigator.pop(context); // 현재 다이얼로그 닫기
                scanSubscription?.cancel(); // 이전 핸들러 취소
                _startScanAndShowDialog(context); // 스캔 다시 시작
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
}
