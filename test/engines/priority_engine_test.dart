import 'package:flutter_test/flutter_test.dart';
import 'package:civicmind/engines/priority_engine.dart';

void main() {
  late PriorityEngine priorityEngine;

  setUp(() {
    priorityEngine = PriorityEngine();
  });

  group('PriorityEngine', () {
    test('should calculate priority score correctly', () {
      final priority = priorityEngine.calculatePriority(
        severity: 0.8,
        density: 0.6,
        environmentalFactor: 0.5,
        delayFactor: 0.2,
      );

      expect(priority, greaterThanOrEqualTo(0.0));
      expect(priority, lessThanOrEqualTo(1.0));
    });

    test('high severity should result in higher priority', () {
      final highPriority = priorityEngine.calculatePriority(
        severity: 0.9,
        density: 0.5,
        environmentalFactor: 0.5,
        delayFactor: 0.1,
      );

      final lowPriority = priorityEngine.calculatePriority(
        severity: 0.3,
        density: 0.5,
        environmentalFactor: 0.5,
        delayFactor: 0.1,
      );

      expect(highPriority, greaterThan(lowPriority));
    });

    test('should get severity from category', () {
      final severity = priorityEngine.getSeverityFromCategory('Infrastructure');

      expect(severity, greaterThanOrEqualTo(0.0));
      expect(severity, lessThanOrEqualTo(1.0));
    });
  });
}
