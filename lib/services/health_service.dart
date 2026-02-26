import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/health_data_model.dart';

abstract class HealthServiceInterface {
  Future<int> getSteps();
  Future<int> getHeartRate();
  Future<double> getActivityLevel();
}

class HealthService extends ChangeNotifier implements HealthServiceInterface {
  HealthDataModel? _currentData;
  final List<HealthDataModel> _history = [];
  Timer? _timer;
  
  HealthDataModel? get currentData => _currentData;
  List<HealthDataModel> get history => List.unmodifiable(_history);
  
  HealthService() {
    _initMockData();
  }
  
  void _initMockData() {
    _generateMockData();
    
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      _generateMockData();
    });
  }
  
  void _generateMockData() {
    final random = Random();
    
    _currentData = HealthDataModel(
      steps: 3000 + random.nextInt(10000),
      heartRate: 60 + random.nextInt(40),
      activityLevel: random.nextDouble(),
      stressLevel: random.nextDouble(),
      caloriesBurned: 500 + random.nextInt(1500),
      sleepHours: 5 + random.nextDouble() * 4,
      timestamp: DateTime.now(),
    );
    
    _history.add(_currentData!);
    if (_history.length > 50) {
      _history.removeAt(0);
    }
    
    notifyListeners();
  }
  
  @override
  Future<int> getSteps() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _currentData?.steps ?? 0;
  }
  
  @override
  Future<int> getHeartRate() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _currentData?.heartRate ?? 0;
  }
  
  @override
  Future<double> getActivityLevel() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _currentData?.activityLevel ?? 0;
  }
  
  double getAverageHeartRate() {
    if (_history.isEmpty) return 0;
    return _history.map((d) => d.heartRate).reduce((a, b) => a + b) / _history.length;
  }
  
  double getAverageStressLevel() {
    if (_history.isEmpty) return 0;
    return _history.map((d) => d.stressLevel).reduce((a, b) => a + b) / _history.length;
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
