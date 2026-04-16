import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a user in RaktSetu (donor, patient, or hospital admin).
/// Maps directly to Firestore `/users/{userId}` documents.
class UserModel {
  final String uid;
  final String name;
  final String phone;
  final String email;
  final String role; // 'donor' | 'patient' | 'hospital_admin'
  final String bloodGroup;
  final String rhFactor;
  final GeoPoint? location;
  final String? city;
  final String? state;
  final bool isAvailable;
  final String availabilityMode; // 'on_duty' | 'off_duty' | 'traveling'
  final DateTime? lastDonated;
  final int totalDonations;
  final List<String> badges;
  final int healthScore;
  final double preferredRadiusKm;
  final bool anonymousDonation;
  final String? profilePhotoUrl;
  final double? hemoglobinLevel;
  final List<String>? medicalConditions;
  final List<String>? medications;
  final DateTime createdAt;

  const UserModel({
    required this.uid,
    required this.name,
    required this.phone,
    this.email = '',
    required this.role,
    required this.bloodGroup,
    this.rhFactor = '+',
    this.location,
    this.city,
    this.state,
    this.isAvailable = true,
    this.availabilityMode = 'on_duty',
    this.lastDonated,
    this.totalDonations = 0,
    this.badges = const [],
    this.healthScore = 100,
    this.preferredRadiusKm = 10.0,
    this.anonymousDonation = false,
    this.profilePhotoUrl,
    this.hemoglobinLevel,
    this.medicalConditions,
    this.medications,
    required this.createdAt,
  });

  /// Create UserModel from Firestore document snapshot.
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'patient',
      bloodGroup: data['bloodGroup'] ?? 'O+',
      rhFactor: data['rhFactor'] ?? '+',
      location: data['location'] as GeoPoint?,
      city: data['city'],
      state: data['state'],
      isAvailable: data['isAvailable'] ?? true,
      availabilityMode: data['availabilityMode'] ?? 'on_duty',
      lastDonated: (data['lastDonated'] as Timestamp?)?.toDate(),
      totalDonations: data['totalDonations'] ?? 0,
      badges: List<String>.from(data['badges'] ?? []),
      healthScore: data['healthScore'] ?? 100,
      preferredRadiusKm: (data['preferredRadiusKm'] ?? 10.0).toDouble(),
      anonymousDonation: data['anonymousDonation'] ?? false,
      profilePhotoUrl: data['profilePhotoUrl'],
      hemoglobinLevel: (data['hemoglobinLevel'] as num?)?.toDouble(),
      medicalConditions: data['medicalConditions'] != null
          ? List<String>.from(data['medicalConditions'])
          : null,
      medications: data['medications'] != null
          ? List<String>.from(data['medications'])
          : null,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Convert UserModel to Firestore-compatible map.
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'role': role,
      'bloodGroup': bloodGroup,
      'rhFactor': rhFactor,
      'location': location,
      'city': city,
      'state': state,
      'isAvailable': isAvailable,
      'availabilityMode': availabilityMode,
      'lastDonated': lastDonated != null ? Timestamp.fromDate(lastDonated!) : null,
      'totalDonations': totalDonations,
      'badges': badges,
      'healthScore': healthScore,
      'preferredRadiusKm': preferredRadiusKm,
      'anonymousDonation': anonymousDonation,
      'profilePhotoUrl': profilePhotoUrl,
      'hemoglobinLevel': hemoglobinLevel,
      'medicalConditions': medicalConditions,
      'medications': medications,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Whether the donor can donate (56-day cooldown check).
  bool get canDonate {
    if (lastDonated == null) return true;
    final daysSince = DateTime.now().difference(lastDonated!).inDays;
    return daysSince >= 56;
  }

  /// Days until next eligible donation.
  int get daysUntilEligible {
    if (lastDonated == null) return 0;
    final daysSince = DateTime.now().difference(lastDonated!).inDays;
    return (56 - daysSince).clamp(0, 56);
  }

  /// Display name (respects anonymous setting).
  String get displayName => anonymousDonation ? 'Anonymous Donor' : name;

  UserModel copyWith({
    String? name,
    String? phone,
    String? email,
    String? role,
    String? bloodGroup,
    GeoPoint? location,
    String? city,
    String? state,
    bool? isAvailable,
    String? availabilityMode,
    DateTime? lastDonated,
    int? totalDonations,
    List<String>? badges,
    double? preferredRadiusKm,
    bool? anonymousDonation,
    String? profilePhotoUrl,
    double? hemoglobinLevel,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      role: role ?? this.role,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      rhFactor: rhFactor,
      location: location ?? this.location,
      city: city ?? this.city,
      state: state ?? this.state,
      isAvailable: isAvailable ?? this.isAvailable,
      availabilityMode: availabilityMode ?? this.availabilityMode,
      lastDonated: lastDonated ?? this.lastDonated,
      totalDonations: totalDonations ?? this.totalDonations,
      badges: badges ?? this.badges,
      preferredRadiusKm: preferredRadiusKm ?? this.preferredRadiusKm,
      anonymousDonation: anonymousDonation ?? this.anonymousDonation,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      hemoglobinLevel: hemoglobinLevel ?? this.hemoglobinLevel,
      medicalConditions: medicalConditions,
      medications: medications,
      createdAt: createdAt,
    );
  }
}
