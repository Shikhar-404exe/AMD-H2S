class PriorityEngine {
  double calculatePriority({
    required double severity,
    required double density,
    required double environmentalFactor,
    required double delayFactor,
  }) {
    final priority = (severity * 0.4) + 
                     (density * 0.3) + 
                     (environmentalFactor * 0.2) + 
                     (delayFactor * 0.1);
    
    return priority.clamp(0.0, 1.0);
  }
  
  double calculateDelayFactor(DateTime createdAt) {
    final now = DateTime.now();
    final hoursSinceCreation = now.difference(createdAt).inHours;
    
    if (hoursSinceCreation <= 6) return 0.2;
    if (hoursSinceCreation <= 24) return 0.4;
    if (hoursSinceCreation <= 72) return 0.6;
    if (hoursSinceCreation <= 168) return 0.8;
    return 1.0;
  }
  
  double getSeverityFromCategory(String category) {
    switch (category) {
      case 'Public Safety':
        return 0.95;
      case 'Road Damage':
        return 0.85;
      case 'Water Supply':
        return 0.8;
      case 'Traffic Signal':
        return 0.75;
      case 'Drainage':
        return 0.7;
      case 'Street Light':
        return 0.6;
      case 'Garbage':
        return 0.55;
      case 'Noise Pollution':
        return 0.5;
      case 'Air Quality':
        return 0.65;
      default:
        return 0.5;
    }
  }
  
  String getPriorityLevel(double priority) {
    if (priority >= 0.8) return 'Critical';
    if (priority >= 0.6) return 'High';
    if (priority >= 0.4) return 'Medium';
    return 'Low';
  }
}
