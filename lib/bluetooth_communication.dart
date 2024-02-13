import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothCommunication {
  BluetoothDevice? connectedDevice; // 연결된 블루투스 장치
  late BluetoothCharacteristic _writeCharacteristic; // 쓰기 가능한 특성
  late BluetoothCharacteristic _readCharacteristic; // 읽기 가능한 특성
  StreamSubscription<List<int>>? _readSubscription; // 데이터 수신을 위한 스트림 구독

  BluetoothCommunication(this.connectedDevice); // 생성자

  // 블루투스 장치에 연결하는 함수
  Future<void> connect() async {
    if (connectedDevice == null) return;

    // 서비스 및 특성 탐색
    List<BluetoothService> services = await connectedDevice!.discoverServices();
    services.forEach((service) {
      service.characteristics.forEach((characteristic) {
        if (characteristic.properties.write) {
          _writeCharacteristic = characteristic;
        }
        if (characteristic.properties.read) {
          _readCharacteristic = characteristic;
        }
      });
    });

    // 알림 구독 (데이터 수신)
    _readSubscription = _readCharacteristic.value.listen((value) {
      // 장치에서 데이터를 받았을 때
      String receivedText = String.fromCharCodes(value);
      print('Received data: $receivedText');
      // 받은 데이터를 처리할 수 있습니다. 예를 들어 UI를 업데이트하거나 작업을 실행할 수 있습니다.
    });
  }

  // 연결 해제하는 함수
  Future<void> disconnect() async {
    await _readSubscription?.cancel(); // 스트림 구독 취소
    await connectedDevice?.disconnect(); // 연결 해제
  }

  // 데이터를 보내는 함수
  Future<void> sendData(String text) async {
    List<int> data = text.codeUnits; // 텍스트를 바이트로 변환
    await _writeCharacteristic.write(data); // 데이터 쓰기
  }
}