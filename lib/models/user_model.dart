class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String role;
  final DateTime createdAt;
  final int issuesReported;
  final int issuesResolved;
  
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.role,
    required this.createdAt,
    required this.issuesReported,
    required this.issuesResolved,
  });
  
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    String? role,
    DateTime? createdAt,
    int? issuesReported,
    int? issuesResolved,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      issuesReported: issuesReported ?? this.issuesReported,
      issuesResolved: issuesResolved ?? this.issuesResolved,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
      'issuesReported': issuesReported,
      'issuesResolved': issuesResolved,
    };
  }
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatarUrl: json['avatarUrl'],
      role: json['role'],
      createdAt: DateTime.parse(json['createdAt']),
      issuesReported: json['issuesReported'],
      issuesResolved: json['issuesResolved'],
    );
  }
}
