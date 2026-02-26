import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'storage_service.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Logger _logger = Logger();
  final StorageService _storage = StorageService();

  User? _currentUser;
  User? get currentUser => _currentUser ?? _auth.currentUser;
  bool get isAuthenticated => currentUser != null;

  AuthService() {
    _auth.authStateChanges().listen((User? user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  Future<UserCredential?> signInWithEmailPassword(
      String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _storage.setString('user_email', email);
      return credential;
    } on FirebaseAuthException catch (e) {
      _logger.e('Sign in error: ${e.message}');
      rethrow;
    }
  }

  Future<UserCredential?> signUpWithEmailPassword(
      String email, String password, String displayName) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user?.updateDisplayName(displayName);
      await _storage.setString('user_email', email);
      return credential;
    } on FirebaseAuthException catch (e) {
      _logger.e('Sign up error: ${e.message}');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _storage.remove('user_email');
    } catch (e) {
      _logger.e('Sign out error: $e');
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      _logger.e('Password reset error: ${e.message}');
      rethrow;
    }
  }

  Future<void> updateDisplayName(String displayName) async {
    try {
      await currentUser?.updateDisplayName(displayName);
      await currentUser?.reload();
      _currentUser = _auth.currentUser;
      notifyListeners();
    } catch (e) {
      _logger.e('Update display name error: $e');
      rethrow;
    }
  }

  Future<void> updateEmail(String newEmail) async {
    try {
      await currentUser?.verifyBeforeUpdateEmail(newEmail);
      await currentUser?.reload();
      _currentUser = _auth.currentUser;
      await _storage.setString('user_email', newEmail);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _logger.e('Update email error: ${e.message}');
      rethrow;
    }
  }

  Future<void> deleteAccount() async {
    try {
      await currentUser?.delete();
      await _storage.clear();
      _currentUser = null;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _logger.e('Delete account error: ${e.message}');
      rethrow;
    }
  }
}
