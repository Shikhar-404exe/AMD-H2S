class CalmZoneModel {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final double calmScore;
  final double noiseLevel;
  final double crowdDensity;
  final double greeneryIndex;
  final List<String> amenities;
  final String imageUrl;
  final bool isOpen;
  final String openingHours;
  
  CalmZoneModel({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.calmScore,
    required this.noiseLevel,
    required this.crowdDensity,
    required this.greeneryIndex,
    required this.amenities,
    required this.imageUrl,
    required this.isOpen,
    required this.openingHours,
  });
  
  CalmZoneModel copyWith({
    String? id,
    String? name,
    String? description,
    double? latitude,
    double? longitude,
    double? calmScore,
    double? noiseLevel,
    double? crowdDensity,
    double? greeneryIndex,
    List<String>? amenities,
    String? imageUrl,
    bool? isOpen,
    String? openingHours,
  }) {
    return CalmZoneModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      calmScore: calmScore ?? this.calmScore,
      noiseLevel: noiseLevel ?? this.noiseLevel,
      crowdDensity: crowdDensity ?? this.crowdDensity,
      greeneryIndex: greeneryIndex ?? this.greeneryIndex,
      amenities: amenities ?? this.amenities,
      imageUrl: imageUrl ?? this.imageUrl,
      isOpen: isOpen ?? this.isOpen,
      openingHours: openingHours ?? this.openingHours,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'calmScore': calmScore,
      'noiseLevel': noiseLevel,
      'crowdDensity': crowdDensity,
      'greeneryIndex': greeneryIndex,
      'amenities': amenities,
      'imageUrl': imageUrl,
      'isOpen': isOpen,
      'openingHours': openingHours,
    };
  }
  
  factory CalmZoneModel.fromJson(Map<String, dynamic> json) {
    return CalmZoneModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      calmScore: json['calmScore'],
      noiseLevel: json['noiseLevel'],
      crowdDensity: json['crowdDensity'],
      greeneryIndex: json['greeneryIndex'],
      amenities: List<String>.from(json['amenities']),
      imageUrl: json['imageUrl'],
      isOpen: json['isOpen'],
      openingHours: json['openingHours'],
    );
  }
}
