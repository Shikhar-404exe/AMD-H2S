import 'package:flutter_test/flutter_test.dart';
import 'package:civicmind/services/location_service.dart';

void main() {
  late LocationService locationService;

  setUp(() {
    locationService = LocationService();
  });

  group('LocationService', () {
    test('should calculate distance between two coordinates', () {
      const lat1 = 28.6139;
      const lon1 = 77.2090;
      const lat2 = 28.7041;
      const lon2 = 77.1025;

      final distance =
          locationService.calculateDistance(lat1, lon1, lat2, lon2);

      expect(distance, greaterThan(0));
      expect(distance, lessThan(20000));
    });

    test('should return LocationService instance', () {
      final service1 = LocationService();
      final service2 = LocationService();

      expect(service1, equals(service2));
    });
  });
}
