import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/crowd_data_model.dart';
import '../core/constants/app_constants.dart';

class CrowdService extends ChangeNotifier {
  final List<CrowdDataModel> _crowdData = [];
  Timer? _timer;
  
  List<CrowdDataModel> get crowdData => List.unmodifiable(_crowdData);
  
  CrowdService() {
    _initMockData();
  }
  
  void _initMockData() {
    _generateCrowdData();
    
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      _generateCrowdData();
    });
  }
  
  void _generateCrowdData() {
    _crowdData.clear();
    final random = Random();
    final zones = AppConstants.zones;
    final trends = ['increasing', 'decreasing', 'stable'];
    
    for (final zone in zones) {
      final density = random.nextDouble();
      _crowdData.add(CrowdDataModel(
        zoneId: zone.split(' ')[0],
        zoneName: zone,
        density: density,
        estimatedCount: (density * 1000).toInt(),
        heatScore: density * 0.8 + random.nextDouble() * 0.2,
        trend: trends[random.nextInt(trends.length)],
        timestamp: DateTime.now(),
      ));
    }
    
    _crowdData.sort((a, b) => b.density.compareTo(a.density));
    notifyListeners();
  }
  
  CrowdDataModel? getZoneCrowdData(String zoneId) {
    try {
      return _crowdData.firstWhere((d) => d.zoneId == zoneId);
    } catch (_) {
      return null;
    }
  }
  
  double getAverageDensity() {
    if (_crowdData.isEmpty) return 0;
    return _crowdData.map((d) => d.density).reduce((a, b) => a + b) / _crowdData.length;
  }
  
  CrowdDataModel? getMostCrowdedZone() {
    if (_crowdData.isEmpty) return null;
    return _crowdData.reduce((a, b) => a.density > b.density ? a : b);
  }
  
  CrowdDataModel? getLeastCrowdedZone() {
    if (_crowdData.isEmpty) return null;
    return _crowdData.reduce((a, b) => a.density < b.density ? a : b);
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
