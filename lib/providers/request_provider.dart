import 'dart:async';
import 'package:flutter/material.dart';
import '../models/request_model.dart';
import '../services/firestore_service.dart';

/// Blood request state provider.
/// Manages request creation, real-time status tracking, and history.
class RequestProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<RequestModel> _userRequests = [];
  RequestModel? _activeRequest;
  StreamSubscription<RequestModel?>? _activeRequestSub;
  bool _isLoading = false;
  String? _error;

  List<RequestModel> get userRequests => _userRequests;
  RequestModel? get activeRequest => _activeRequest;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasActiveRequest =>
      _activeRequest != null && _activeRequest!.isActive;

  Future<void> loadUserRequests(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _userRequests = await _firestoreService.getUserRequests(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load requests: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> createRequest(RequestModel request) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final docRef = await _firestoreService.createRequest(request);
      _isLoading = false;
      watchRequest(docRef.id);
      notifyListeners();
      return docRef.id;
    } catch (e) {
      _error = 'Failed to create request: $e';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  void watchRequest(String requestId) {
    _activeRequestSub?.cancel();
    _activeRequestSub =
        _firestoreService.streamRequest(requestId).listen((request) {
      _activeRequest = request;
      notifyListeners();
    });
  }

  void stopWatching() {
    _activeRequestSub?.cancel();
    _activeRequest = null;
    notifyListeners();
  }

  Future<void> acceptMatch(String requestId, String donorId) async {
    try {
      await _firestoreService.updateRequest(requestId, {
        'matchedDonorId': donorId,
        'status': 'matched',
      });
    } catch (e) {
      _error = 'Failed to accept match: $e';
      notifyListeners();
    }
  }

  Future<void> cancelActiveRequest() async {
    final request = _activeRequest;
    if (request == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      await _firestoreService.updateRequest(request.id, {
        'status': 'cancelled',
      });
      _activeRequest = request.copyWith(status: 'cancelled');
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to cancel request: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _activeRequestSub?.cancel();
    super.dispose();
  }
}
