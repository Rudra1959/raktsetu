import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a blood request in RaktSetu.
/// Maps to Firestore `/requests/{requestId}` documents.
class RequestModel {
  final String id;
  final String requesterId;
  final String patientName;
  final String bloodGroup;
  final int units;
  final int urgencyScore; // 0-100
  final String condition; // 'critical' | 'urgent' | 'standard'
  final HospitalInfo hospital;
  final String status; // 'pending'|'matching'|'matched'|'en_route'|'fulfilled'|'no_match'|'cancelled'
  final String? matchedDonorId;
  final List<String> candidateDonors;
  final int? etaMinutes;
  final DateTime? surgeryTime;
  final int escalationLevel; // 0, 1, 2
  final String? notes;
  final DateTime requestedAt;
  final DateTime? fulfilledAt;

  const RequestModel({
    required this.id,
    required this.requesterId,
    required this.patientName,
    required this.bloodGroup,
    this.units = 1,
    this.urgencyScore = 0,
    this.condition = 'standard',
    required this.hospital,
    this.status = 'pending',
    this.matchedDonorId,
    this.candidateDonors = const [],
    this.etaMinutes,
    this.surgeryTime,
    this.escalationLevel = 0,
    this.notes,
    required this.requestedAt,
    this.fulfilledAt,
  });

  factory RequestModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RequestModel(
      id: doc.id,
      requesterId: data['requesterId'] ?? '',
      patientName: data['patientName'] ?? '',
      bloodGroup: data['bloodGroup'] ?? 'O+',
      units: data['units'] ?? 1,
      urgencyScore: data['urgencyScore'] ?? 0,
      condition: data['condition'] ?? 'standard',
      hospital: HospitalInfo.fromMap(data['hospital'] ?? {}),
      status: data['status'] ?? 'pending',
      matchedDonorId: data['matchedDonorId'],
      candidateDonors: List<String>.from(data['candidateDonors'] ?? []),
      etaMinutes: data['etaMinutes'],
      surgeryTime: (data['surgeryTime'] as Timestamp?)?.toDate(),
      escalationLevel: data['escalationLevel'] ?? 0,
      notes: data['notes'],
      requestedAt: (data['requestedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      fulfilledAt: (data['fulfilledAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'requesterId': requesterId,
      'patientName': patientName,
      'bloodGroup': bloodGroup,
      'units': units,
      'urgencyScore': urgencyScore,
      'condition': condition,
      'hospital': hospital.toMap(),
      'status': status,
      'matchedDonorId': matchedDonorId,
      'candidateDonors': candidateDonors,
      'etaMinutes': etaMinutes,
      'surgeryTime': surgeryTime != null ? Timestamp.fromDate(surgeryTime!) : null,
      'escalationLevel': escalationLevel,
      'notes': notes,
      'requestedAt': Timestamp.fromDate(requestedAt),
      'fulfilledAt': fulfilledAt != null ? Timestamp.fromDate(fulfilledAt!) : null,
    };
  }

  /// Status step index for the StatusTracker widget.
  int get statusIndex {
    const statusOrder = ['pending', 'matching', 'matched', 'en_route', 'fulfilled'];
    final idx = statusOrder.indexOf(status);
    return idx >= 0 ? idx : 0;
  }

  /// Whether this request is still active (not completed or cancelled).
  bool get isActive => status != 'fulfilled' && status != 'cancelled';

  /// Whether this is an emergency-level request.
  bool get isEmergency => urgencyScore >= 70;
}

/// Hospital information embedded in a blood request.
class HospitalInfo {
  final String name;
  final String address;
  final GeoPoint? geopoint;

  const HospitalInfo({
    required this.name,
    this.address = '',
    this.geopoint,
  });

  factory HospitalInfo.fromMap(Map<String, dynamic> map) {
    return HospitalInfo(
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      geopoint: map['geopoint'] as GeoPoint?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'geopoint': geopoint,
    };
  }
}
