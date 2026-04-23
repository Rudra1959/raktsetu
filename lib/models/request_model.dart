import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a blood request in RaktSetu.
/// Maps to Firestore `/requests/{requestId}` documents.
class RequestModel {
  final String id;
  final String requesterId;
  final String patientName;
  final String bloodGroup;
  final int units;
  final int urgencyScore;
  final String condition;
  final HospitalInfo hospital;
  final String status;
  final String? matchedDonorId;
  final List<String> candidateDonors;
  final int? etaMinutes;
  final DateTime? surgeryTime;
  final int escalationLevel;
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
    final data = (doc.data() as Map<String, dynamic>?) ?? <String, dynamic>{};
    return RequestModel(
      id: doc.id,
      requesterId: data['requesterId'] as String? ?? '',
      patientName: data['patientName'] as String? ?? '',
      bloodGroup: data['bloodGroup'] as String? ?? 'O+',
      units: (data['units'] as num?)?.toInt() ?? 1,
      urgencyScore: (data['urgencyScore'] as num?)?.toInt() ?? 0,
      condition: data['condition'] as String? ?? 'standard',
      hospital: HospitalInfo.fromMap(
        Map<String, dynamic>.from(
          (data['hospital'] as Map<dynamic, dynamic>?) ?? const <dynamic, dynamic>{},
        ),
      ),
      status: data['status'] as String? ?? 'pending',
      matchedDonorId: data['matchedDonorId'] as String?,
      candidateDonors: List<String>.from(
        (data['candidateDonors'] as List<dynamic>?) ?? const <dynamic>[],
      ),
      etaMinutes: (data['etaMinutes'] as num?)?.toInt(),
      surgeryTime: (data['surgeryTime'] as Timestamp?)?.toDate(),
      escalationLevel: (data['escalationLevel'] as num?)?.toInt() ?? 0,
      notes: data['notes'] as String?,
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

  int get statusIndex {
    const statusOrder = ['pending', 'matching', 'matched', 'en_route', 'fulfilled'];
    final idx = statusOrder.indexOf(status);
    return idx >= 0 ? idx : 0;
  }

  bool get isActive => status != 'fulfilled' && status != 'cancelled';
  bool get isEmergency => urgencyScore >= 70;

  RequestModel copyWith({
    String? id,
    String? requesterId,
    String? patientName,
    String? bloodGroup,
    int? units,
    int? urgencyScore,
    String? condition,
    HospitalInfo? hospital,
    String? status,
    String? matchedDonorId,
    List<String>? candidateDonors,
    int? etaMinutes,
    DateTime? surgeryTime,
    int? escalationLevel,
    String? notes,
    DateTime? requestedAt,
    DateTime? fulfilledAt,
  }) {
    return RequestModel(
      id: id ?? this.id,
      requesterId: requesterId ?? this.requesterId,
      patientName: patientName ?? this.patientName,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      units: units ?? this.units,
      urgencyScore: urgencyScore ?? this.urgencyScore,
      condition: condition ?? this.condition,
      hospital: hospital ?? this.hospital,
      status: status ?? this.status,
      matchedDonorId: matchedDonorId ?? this.matchedDonorId,
      candidateDonors: candidateDonors ?? this.candidateDonors,
      etaMinutes: etaMinutes ?? this.etaMinutes,
      surgeryTime: surgeryTime ?? this.surgeryTime,
      escalationLevel: escalationLevel ?? this.escalationLevel,
      notes: notes ?? this.notes,
      requestedAt: requestedAt ?? this.requestedAt,
      fulfilledAt: fulfilledAt ?? this.fulfilledAt,
    );
  }
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
      name: map['name'] as String? ?? '',
      address: map['address'] as String? ?? '',
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
