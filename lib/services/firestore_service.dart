import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/request_model.dart';
import '../models/blood_bank_model.dart';
import '../models/camp_model.dart';
import '../models/notification_model.dart';
import '../config/constants.dart';

/// Firestore service — CRUD operations for all RaktSetu collections.
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ══════════════════════════════════════════
  // USERS
  // ══════════════════════════════════════════

  /// Get a user by ID.
  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection(AppConstants.usersCollection).doc(uid).get();
    return doc.exists ? UserModel.fromFirestore(doc) : null;
  }

  /// Update user profile fields.
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection(AppConstants.usersCollection).doc(uid).update(data);
  }

  /// Stream real-time user profile updates.
  Stream<UserModel?> streamUser(String uid) {
    return _db
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists ? UserModel.fromFirestore(doc) : null);
  }

  /// Query available donors by blood group.
  Future<List<UserModel>> getAvailableDonors(String bloodGroup) async {
    final snap = await _db
        .collection(AppConstants.usersCollection)
        .where('role', isEqualTo: 'donor')
        .where('isAvailable', isEqualTo: true)
        .where('bloodGroup', isEqualTo: bloodGroup)
        .get();
    return snap.docs.map(UserModel.fromFirestore).toList();
  }

  /// Get compatible donors for a patient blood group.
  Future<List<UserModel>> getCompatibleDonors(String patientBloodGroup) async {
    final compatible = AppConstants.compatibilityChart[patientBloodGroup] ?? [];
    final List<UserModel> donors = [];
    for (final group in compatible) {
      donors.addAll(await getAvailableDonors(group));
    }
    return donors;
  }

  // ══════════════════════════════════════════
  // BLOOD REQUESTS
  // ══════════════════════════════════════════

  /// Create a new blood request.
  Future<DocumentReference> createRequest(RequestModel request) async {
    return _db
        .collection(AppConstants.requestsCollection)
        .add(request.toFirestore());
  }

  /// Stream real-time updates for a specific request.
  Stream<RequestModel?> streamRequest(String requestId) {
    return _db
        .collection(AppConstants.requestsCollection)
        .doc(requestId)
        .snapshots()
        .map((doc) => doc.exists ? RequestModel.fromFirestore(doc) : null);
  }

  /// Get all active requests for a user (as requester).
  Future<List<RequestModel>> getUserRequests(String userId) async {
    final snap = await _db
        .collection(AppConstants.requestsCollection)
        .where('requesterId', isEqualTo: userId)
        .orderBy('requestedAt', descending: true)
        .get();
    return snap.docs.map(RequestModel.fromFirestore).toList();
  }

  /// Get pending requests ordered by urgency (highest first).
  Future<List<RequestModel>> getPendingRequests() async {
    final snap = await _db
        .collection(AppConstants.requestsCollection)
        .where('status', isEqualTo: 'pending')
        .orderBy('urgencyScore', descending: true)
        .get();
    return snap.docs.map(RequestModel.fromFirestore).toList();
  }

  /// Update request status.
  Future<void> updateRequest(String requestId, Map<String, dynamic> data) async {
    await _db.collection(AppConstants.requestsCollection).doc(requestId).update(data);
  }

  // ══════════════════════════════════════════
  // BLOOD BANKS
  // ══════════════════════════════════════════

  /// Get all verified blood banks.
  Future<List<BloodBankModel>> getBloodBanks() async {
    final snap = await _db
        .collection(AppConstants.bloodBanksCollection)
        .where('isVerified', isEqualTo: true)
        .get();
    return snap.docs.map(BloodBankModel.fromFirestore).toList();
  }

  /// Stream a blood bank's inventory in real-time.
  Stream<BloodBankModel?> streamBloodBank(String bankId) {
    return _db
        .collection(AppConstants.bloodBanksCollection)
        .doc(bankId)
        .snapshots()
        .map((doc) => doc.exists ? BloodBankModel.fromFirestore(doc) : null);
  }

  // ══════════════════════════════════════════
  // BLOOD CAMPS
  // ══════════════════════════════════════════

  /// Get upcoming camps.
  Future<List<CampModel>> getUpcomingCamps() async {
    final snap = await _db
        .collection(AppConstants.campsCollection)
        .where('status', isEqualTo: 'upcoming')
        .orderBy('date')
        .get();
    return snap.docs.map(CampModel.fromFirestore).toList();
  }

  /// Create a blood camp.
  Future<DocumentReference> createCamp(CampModel camp) async {
    return _db.collection(AppConstants.campsCollection).add(camp.toFirestore());
  }

  // ══════════════════════════════════════════
  // NOTIFICATIONS
  // ══════════════════════════════════════════

  /// Stream user's unread notifications.
  Stream<List<NotificationModel>> streamNotifications(String userId) {
    return _db
        .collection(AppConstants.notificationsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('sentAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snap) =>
            snap.docs.map(NotificationModel.fromFirestore).toList(),);
  }

  /// Mark notification as read.
  Future<void> markNotificationRead(String notifId) async {
    await _db
        .collection(AppConstants.notificationsCollection)
        .doc(notifId)
        .update({'read': true});
  }

  // ══════════════════════════════════════════
  // LEADERBOARD
  // ══════════════════════════════════════════

  /// Get top donors leaderboard.
  Future<List<UserModel>> getLeaderboard({int limit = 20}) async {
    final snap = await _db
        .collection(AppConstants.usersCollection)
        .where('role', isEqualTo: 'donor')
        .orderBy('totalDonations', descending: true)
        .limit(limit)
        .get();
    return snap.docs.map(UserModel.fromFirestore).toList();
  }
}
