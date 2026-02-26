import 'dart:math';
import 'package:flutter/material.dart';
import '../models/calm_zone_model.dart';

class CalmZoneService extends ChangeNotifier {
  final List<CalmZoneModel> _calmZones = [];
  bool _isLoading = false;
  
  List<CalmZoneModel> get calmZones => List.unmodifiable(_calmZones);
  bool get isLoading => _isLoading;
  
  CalmZoneService() {
    _initMockData();
  }
  
  void _initMockData() {
    _calmZones.addAll([
      CalmZoneModel(
        id: 'CZ001',
        name: 'Serenity Park',
        description: 'A peaceful urban park with lush greenery, walking trails, and meditation spots. Perfect for stress relief and relaxation.',
        latitude: 28.6129,
        longitude: 77.2295,
        calmScore: 0.92,
        noiseLevel: 0.15,
        crowdDensity: 0.2,
        greeneryIndex: 0.95,
        amenities: ['Walking Trails', 'Benches', 'Water Fountain', 'Meditation Area'],
        imageUrl: 'https://images.unsplash.com/photo-1585320806297-9794b3e4eeae',
        isOpen: true,
        openingHours: '6:00 AM - 9:00 PM',
      ),
      CalmZoneModel(
        id: 'CZ002',
        name: 'Lotus Garden',
        description: 'Beautiful botanical garden with diverse plant species and serene water features.',
        latitude: 28.6234,
        longitude: 77.2156,
        calmScore: 0.88,
        noiseLevel: 0.2,
        crowdDensity: 0.25,
        greeneryIndex: 0.9,
        amenities: ['Botanical Tours', 'Rest Areas', 'Cafe', 'Butterfly Garden'],
        imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64',
        isOpen: true,
        openingHours: '8:00 AM - 6:00 PM',
      ),
      CalmZoneModel(
        id: 'CZ003',
        name: 'Riverside Promenade',
        description: 'Scenic walkway along the river with sunset views and gentle breezes.',
        latitude: 28.6045,
        longitude: 77.2367,
        calmScore: 0.85,
        noiseLevel: 0.25,
        crowdDensity: 0.3,
        greeneryIndex: 0.7,
        amenities: ['River View', 'Cycling Track', 'Food Stalls', 'Photography Spots'],
        imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4',
        isOpen: true,
        openingHours: '24 Hours',
      ),
      CalmZoneModel(
        id: 'CZ004',
        name: 'Zen Library Garden',
        description: 'Quiet outdoor reading space adjacent to the city library with shaded seating.',
        latitude: 28.6178,
        longitude: 77.2089,
        calmScore: 0.95,
        noiseLevel: 0.1,
        crowdDensity: 0.15,
        greeneryIndex: 0.8,
        amenities: ['Free WiFi', 'Reading Nooks', 'Coffee Corner', 'Charging Stations'],
        imageUrl: 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570',
        isOpen: true,
        openingHours: '9:00 AM - 8:00 PM',
      ),
      CalmZoneModel(
        id: 'CZ005',
        name: 'Harmony Hills',
        description: 'Elevated park area with panoramic city views and yoga lawns.',
        latitude: 28.6312,
        longitude: 77.2234,
        calmScore: 0.82,
        noiseLevel: 0.3,
        crowdDensity: 0.35,
        greeneryIndex: 0.85,
        amenities: ['Yoga Classes', 'Jogging Track', 'Picnic Areas', 'Playground'],
        imageUrl: 'https://images.unsplash.com/photo-1501785888041-af3ef285b470',
        isOpen: true,
        openingHours: '5:00 AM - 10:00 PM',
      ),
    ]);
    notifyListeners();
  }
  
  List<CalmZoneModel> getRecommendedZones(double stressLevel) {
    final sorted = List<CalmZoneModel>.from(_calmZones);
    sorted.sort((a, b) => b.calmScore.compareTo(a.calmScore));
    
    if (stressLevel > 0.7) {
      return sorted.where((z) => z.calmScore > 0.85).toList();
    }
    return sorted.take(3).toList();
  }
  
  CalmZoneModel? getNearestCalmZone(double lat, double lng) {
    if (_calmZones.isEmpty) return null;
    
    CalmZoneModel? nearest;
    double minDistance = double.infinity;
    
    for (final zone in _calmZones) {
      final distance = _calculateDistance(lat, lng, zone.latitude, zone.longitude);
      if (distance < minDistance) {
        minDistance = distance;
        nearest = zone;
      }
    }
    
    return nearest;
  }
  
  double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    final dLat = lat2 - lat1;
    final dLng = lng2 - lng1;
    return sqrt(dLat * dLat + dLng * dLng);
  }
}
