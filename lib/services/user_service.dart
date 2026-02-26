import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserService extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  bool _hasCompletedOnboarding = false;
  
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;
  
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    await Future.delayed(const Duration(seconds: 1));
    
    _currentUser = UserModel(
      id: 'USR001',
      name: 'Alex Johnson',
      email: email,
      avatarUrl: null,
      role: email.contains('admin') ? 'admin' : 'citizen',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      issuesReported: 12,
      issuesResolved: 8,
    );
    
    _isLoggedIn = true;
    _isLoading = false;
    notifyListeners();
    
    return true;
  }
  
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    _currentUser = null;
    _isLoggedIn = false;
    _isLoading = false;
    notifyListeners();
  }
  
  void completeOnboarding() {
    _hasCompletedOnboarding = true;
    notifyListeners();
  }
  
  void skipLogin() {
    _currentUser = UserModel(
      id: 'GUEST001',
      name: 'Guest User',
      email: 'guest@civicmind.app',
      avatarUrl: null,
      role: 'guest',
      createdAt: DateTime.now(),
      issuesReported: 0,
      issuesResolved: 0,
    );
    _isLoggedIn = true;
    notifyListeners();
  }
  
  bool get isAdmin => _currentUser?.role == 'admin';
  bool get isGuest => _currentUser?.role == 'guest';
}
