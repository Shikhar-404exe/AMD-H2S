import 'package:flutter/material.dart';
import '../models/issue_model.dart';

class AdminService extends ChangeNotifier {
  String? _selectedZoneFilter;
  String? _selectedCategoryFilter;
  IssueStatus? _selectedStatusFilter;
  String _sortBy = 'priority';
  bool _sortDescending = true;
  
  String? get selectedZoneFilter => _selectedZoneFilter;
  String? get selectedCategoryFilter => _selectedCategoryFilter;
  IssueStatus? get selectedStatusFilter => _selectedStatusFilter;
  String get sortBy => _sortBy;
  bool get sortDescending => _sortDescending;
  
  void setZoneFilter(String? zone) {
    _selectedZoneFilter = zone;
    notifyListeners();
  }
  
  void setCategoryFilter(String? category) {
    _selectedCategoryFilter = category;
    notifyListeners();
  }
  
  void setStatusFilter(IssueStatus? status) {
    _selectedStatusFilter = status;
    notifyListeners();
  }
  
  void setSortBy(String sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }
  
  void toggleSortOrder() {
    _sortDescending = !_sortDescending;
    notifyListeners();
  }
  
  void clearFilters() {
    _selectedZoneFilter = null;
    _selectedCategoryFilter = null;
    _selectedStatusFilter = null;
    notifyListeners();
  }
  
  List<IssueModel> applyFilters(List<IssueModel> issues) {
    var filtered = List<IssueModel>.from(issues);
    
    if (_selectedZoneFilter != null) {
      filtered = filtered.where((i) => i.zone == _selectedZoneFilter).toList();
    }
    
    if (_selectedCategoryFilter != null) {
      filtered = filtered.where((i) => i.category == _selectedCategoryFilter).toList();
    }
    
    if (_selectedStatusFilter != null) {
      filtered = filtered.where((i) => i.status == _selectedStatusFilter).toList();
    }
    
    switch (_sortBy) {
      case 'priority':
        filtered.sort((a, b) => _sortDescending 
          ? b.priorityScore.compareTo(a.priorityScore)
          : a.priorityScore.compareTo(b.priorityScore));
        break;
      case 'date':
        filtered.sort((a, b) => _sortDescending 
          ? b.createdAt.compareTo(a.createdAt)
          : a.createdAt.compareTo(b.createdAt));
        break;
      case 'zone':
        filtered.sort((a, b) => _sortDescending 
          ? b.zone.compareTo(a.zone)
          : a.zone.compareTo(b.zone));
        break;
    }
    
    return filtered;
  }
  
  Map<String, dynamic> getStatistics(List<IssueModel> issues) {
    final total = issues.length;
    final pending = issues.where((i) => i.status == IssueStatus.pending).length;
    final inProgress = issues.where((i) => i.status == IssueStatus.inProgress).length;
    final resolved = issues.where((i) => i.status == IssueStatus.resolved).length;
    final critical = issues.where((i) => i.priorityScore >= 0.8).length;
    
    final avgResolutionTime = _calculateAverageResolutionTime(issues);
    
    return {
      'total': total,
      'pending': pending,
      'inProgress': inProgress,
      'resolved': resolved,
      'critical': critical,
      'avgResolutionTime': avgResolutionTime,
      'resolutionRate': total > 0 ? (resolved / total * 100).toStringAsFixed(1) : '0',
    };
  }
  
  double _calculateAverageResolutionTime(List<IssueModel> issues) {
    final resolvedIssues = issues.where((i) => i.resolvedAt != null).toList();
    if (resolvedIssues.isEmpty) return 0;
    
    final totalHours = resolvedIssues.map((i) {
      return i.resolvedAt!.difference(i.createdAt).inHours;
    }).reduce((a, b) => a + b);
    
    return totalHours / resolvedIssues.length;
  }
}
