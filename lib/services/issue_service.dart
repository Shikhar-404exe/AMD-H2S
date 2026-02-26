import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/issue_model.dart';
import '../core/constants/app_constants.dart';

class IssueService extends ChangeNotifier {
  final List<IssueModel> _issues = [];
  bool _isLoading = false;
  
  List<IssueModel> get issues => List.unmodifiable(_issues);
  bool get isLoading => _isLoading;
  
  List<IssueModel> get activeIssues => _issues.where((i) => i.status != IssueStatus.resolved && i.status != IssueStatus.closed).toList();
  List<IssueModel> get criticalIssues => _issues.where((i) => i.priorityScore >= 0.8 && i.status != IssueStatus.resolved).toList();
  List<IssueModel> get resolvedIssues => _issues.where((i) => i.status == IssueStatus.resolved || i.status == IssueStatus.closed).toList();
  
  IssueService() {
    _initMockData();
  }
  
  void _initMockData() {
    final random = Random();
    final categories = AppConstants.issueCategories;
    final zones = AppConstants.zones;
    
    for (int i = 0; i < 25; i++) {
      final category = categories[random.nextInt(categories.length)];
      final zone = zones[random.nextInt(zones.length)];
      final severity = 0.2 + random.nextDouble() * 0.8;
      final status = IssueStatus.values[random.nextInt(IssueStatus.values.length)];
      
      _issues.add(IssueModel(
        id: 'ISS${1000 + i}',
        title: '$category Issue in ${zone.split(' - ')[1]}',
        description: 'Reported $category problem that needs attention in the $zone area. Citizens have complained about this issue multiple times.',
        category: category,
        zone: zone,
        latitude: 28.6 + random.nextDouble() * 0.1,
        longitude: 77.2 + random.nextDouble() * 0.1,
        createdAt: DateTime.now().subtract(Duration(days: random.nextInt(30), hours: random.nextInt(24))),
        resolvedAt: status == IssueStatus.resolved ? DateTime.now().subtract(Duration(days: random.nextInt(5))) : null,
        status: status,
        priorityScore: severity,
        severity: severity,
        reportedBy: 'User${random.nextInt(100)}',
      ));
    }
    
    _issues.sort((a, b) => b.priorityScore.compareTo(a.priorityScore));
    notifyListeners();
  }
  
  Future<void> addIssue(IssueModel issue) async {
    _isLoading = true;
    notifyListeners();
    
    await Future.delayed(const Duration(milliseconds: 500));
    _issues.insert(0, issue);
    _issues.sort((a, b) => b.priorityScore.compareTo(a.priorityScore));
    
    _isLoading = false;
    notifyListeners();
  }
  
  Future<void> updateIssueStatus(String issueId, IssueStatus newStatus) async {
    _isLoading = true;
    notifyListeners();
    
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _issues.indexWhere((i) => i.id == issueId);
    if (index != -1) {
      _issues[index] = _issues[index].copyWith(
        status: newStatus,
        resolvedAt: newStatus == IssueStatus.resolved ? DateTime.now() : null,
      );
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  List<IssueModel> getIssuesByZone(String zone) {
    return _issues.where((i) => i.zone == zone).toList();
  }
  
  List<IssueModel> getIssuesByCategory(String category) {
    return _issues.where((i) => i.category == category).toList();
  }
  
  List<IssueModel> getIssuesByStatus(IssueStatus status) {
    return _issues.where((i) => i.status == status).toList();
  }
  
  Map<String, int> getCategoryDistribution() {
    final Map<String, int> distribution = {};
    for (final issue in _issues) {
      distribution[issue.category] = (distribution[issue.category] ?? 0) + 1;
    }
    return distribution;
  }
  
  Map<String, int> getStatusDistribution() {
    final Map<String, int> distribution = {};
    for (final issue in _issues) {
      final statusName = issue.status.name;
      distribution[statusName] = (distribution[statusName] ?? 0) + 1;
    }
    return distribution;
  }
}
