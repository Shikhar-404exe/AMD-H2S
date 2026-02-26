import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/sensor_data_model.dart';
import '../core/constants/app_constants.dart';

abstract class IoTServiceInterface {
  Stream<SensorDataModel> getSensorStream();
  Future<void> connectDevice(String deviceId);
  Future<void> disconnectDevice(String deviceId);
}

class IoTService extends ChangeNotifier implements IoTServiceInterface {
  final List<SensorDataModel> _sensorData = [];
  final Set<String> _connectedDevices = {};
  StreamController<SensorDataModel>? _streamController;
  Timer? _timer;
  bool _isConnected = false;
  
  List<SensorDataModel> get sensorData => List.unmodifiable(_sensorData);
  Set<String> get connectedDevices => Set.unmodifiable(_connectedDevices);
  bool get isConnected => _isConnected;
  SensorDataModel? get latestData => _sensorData.isNotEmpty ? _sensorData.last : null;
  
  IoTService() {
    _initMockStream();
  }
  
  void _initMockStream() {
    _streamController = StreamController<SensorDataModel>.broadcast();
    _isConnected = true;
    _connectedDevices.add('ESP32-001');
    _connectedDevices.add('ESP32-002');
    
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      _generateMockData();
    });
    
    _generateMockData();
  }
  
  void _generateMockData() {
    final random = Random();
    final zones = AppConstants.zones;
    
    final data = SensorDataModel(
      sensorId: 'SEN${random.nextInt(100).toString().padLeft(3, '0')}',
      zoneId: zones[random.nextInt(zones.length)],
      temperature: 20 + random.nextDouble() * 15,
      humidity: 40 + random.nextDouble() * 40,
      lightLevel: random.nextDouble() * 100,
      airQualityIndex: 50 + random.nextDouble() * 150,
      noiseLevel: 30 + random.nextDouble() * 60,
      powerConsumption: 100 + random.nextDouble() * 400,
      timestamp: DateTime.now(),
    );
    
    _sensorData.add(data);
    if (_sensorData.length > 100) {
      _sensorData.removeAt(0);
    }
    
    _streamController?.add(data);
    notifyListeners();
  }
  
  @override
  Stream<SensorDataModel> getSensorStream() {
    return _streamController?.stream ?? const Stream.empty();
  }
  
  @override
  Future<void> connectDevice(String deviceId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _connectedDevices.add(deviceId);
    _isConnected = true;
    notifyListeners();
  }
  
  @override
  Future<void> disconnectDevice(String deviceId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _connectedDevices.remove(deviceId);
    if (_connectedDevices.isEmpty) {
      _isConnected = false;
    }
    notifyListeners();
  }
  
  double getAverageTemperature() {
    if (_sensorData.isEmpty) return 0;
    return _sensorData.map((d) => d.temperature).reduce((a, b) => a + b) / _sensorData.length;
  }
  
  double getAverageAirQuality() {
    if (_sensorData.isEmpty) return 0;
    return _sensorData.map((d) => d.airQualityIndex).reduce((a, b) => a + b) / _sensorData.length;
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    _streamController?.close();
    super.dispose();
  }
}
