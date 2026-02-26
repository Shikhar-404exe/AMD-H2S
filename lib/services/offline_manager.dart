import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'connectivity_service.dart';
import 'storage_service.dart';

class OfflineManager extends ChangeNotifier {
  static final OfflineManager _instance = OfflineManager._internal();
  factory OfflineManager() => _instance;
  OfflineManager._internal();

  final ConnectivityService _connectivity = ConnectivityService();
  final StorageService _storage = StorageService();
  final Logger _logger = Logger();

  final List<PendingAction> _pendingActions = [];
  bool _isSyncing = false;

  List<PendingAction> get pendingActions => List.unmodifiable(_pendingActions);
  bool get hasPendingActions => _pendingActions.isNotEmpty;
  bool get isSyncing => _isSyncing;

  void initialize() {
    _connectivity.addListener(_onConnectivityChanged);
    _loadPendingActions();
  }

  void _onConnectivityChanged() {
    if (_connectivity.isConnected && hasPendingActions) {
      _syncPendingActions();
    }
  }

  Future<void> _loadPendingActions() async {
    try {
      final box = await _storage.openBox<Map>('pending_actions');
      for (var action in box.values) {
        _pendingActions
            .add(PendingAction.fromMap(Map<String, dynamic>.from(action)));
      }
      notifyListeners();
    } catch (e) {
      _logger.e('Error loading pending actions: $e');
    }
  }

  Future<void> addPendingAction(PendingAction action) async {
    try {
      _pendingActions.add(action);
      final box = await _storage.openBox<Map>('pending_actions');
      await box.add(action.toMap());
      notifyListeners();
    } catch (e) {
      _logger.e('Error adding pending action: $e');
    }
  }

  Future<void> _syncPendingActions() async {
    if (_isSyncing || !_connectivity.isConnected) return;

    _isSyncing = true;
    notifyListeners();

    final actionsToSync = List<PendingAction>.from(_pendingActions);

    for (var action in actionsToSync) {
      try {
        await action.execute();
        _pendingActions.remove(action);
        _logger.i('Synced action: ${action.type}');
      } catch (e) {
        _logger.e('Error syncing action ${action.type}: $e');
      }
    }

    try {
      final box = await _storage.openBox<Map>('pending_actions');
      await box.clear();
    } catch (e) {
      _logger.e('Error clearing pending actions: $e');
    }

    _isSyncing = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _connectivity.removeListener(_onConnectivityChanged);
    super.dispose();
  }
}

class PendingAction {
  final String type;
  final Map<String, dynamic> data;
  final Future<void> Function() execute;

  PendingAction({
    required this.type,
    required this.data,
    required this.execute,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'data': data,
    };
  }

  factory PendingAction.fromMap(Map<String, dynamic> map) {
    return PendingAction(
      type: map['type'] as String,
      data: Map<String, dynamic>.from(map['data'] as Map),
      execute: () async {},
    );
  }
}
