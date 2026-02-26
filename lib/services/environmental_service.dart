import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/sensor_data_model.dart';
import '../core/constants/app_constants.dart';

class EnvironmentalService extends ChangeNotifier {
  final List<SensorDataModel> _environmentalData = [];
  StreamController<SensorDataModel>? _streamController;
  Timer? _timer;
  
  List<SensorDataModel> get environmentalData => List.unmodifiable(_environmentalData);
  SensorDataModel? get latestData => _environmentalData.isNotEmpty ? _environmentalData.last : null;
  Stream<SensorDataModel> get dataStream => _streamController?.stream ?? const Stream.empty();
  
  EnvironmentalService() {
    _initMockStream();
  }
  
  void _initMockStream() {
    _streamController = StreamController<SensorDataModel>.broadcast();
    
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      _generateMockData();
    });
    
    _generateMockData();
  }
  
  void _generateMockData() {
    final random = Random();
    final zones = AppConstants.zones;
    
    final data = SensorDataModel(
      sensorId: 'ENV${random.nextInt(100).toString().padLeft(3, '0')}',
      zoneId: zones[random.nextInt(zones.length)],
      temperature: 18 + random.nextDouble() * 20,
      humidity: 30 + random.nextDouble() * 50,
      lightLevel: random.nextDouble() * 100,
      airQualityIndex: 30 + random.nextDouble() * 170,
      noiseLevel: 25 + random.nextDouble() * 70,
      powerConsumption: 50 + random.nextDouble() * 300,
      timestamp: DateTime.now(),
    );
    
    _environmentalData.add(data);
    if (_environmentalData.length > 50) {
      _environmentalData.removeAt(0);
    }
    
    _streamController?.add(data);
    notifyListeners();
  }
  
  String getAirQualityStatus() {
    final aqi = latestData?.airQualityIndex ?? 0;
    if (aqi <= 50) return 'Good';
    if (aqi <= 100) return 'Moderate';
    if (aqi <= 150) return 'Unhealthy for Sensitive';
    if (aqi <= 200) return 'Unhealthy';
    return 'Very Unhealthy';
  }
  
  Color getAirQualityColor() {
    final aqi = latestData?.airQualityIndex ?? 0;
    if (aqi <= 50) return const Color(0xFF81C784);
    if (aqi <= 100) return const Color(0xFFFFD54F);
    if (aqi <= 150) return const Color(0xFFFFB74D);
    if (aqi <= 200) return const Color(0xFFE57373);
    return const Color(0xFFBA68C8);
  }
  
  double getAverageTemperature() {
    if (_environmentalData.isEmpty) return 0;
    return _environmentalData.map((d) => d.temperature).reduce((a, b) => a + b) / _environmentalData.length;
  }
  
  double getAverageHumidity() {
    if (_environmentalData.isEmpty) return 0;
    return _environmentalData.map((d) => d.humidity).reduce((a, b) => a + b) / _environmentalData.length;
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    _streamController?.close();
    super.dispose();
  }
}
