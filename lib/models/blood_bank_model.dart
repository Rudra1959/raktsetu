import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a blood bank in RaktSetu.
/// Maps to Firestore `/bloodBanks/{bankId}` documents.
class BloodBankModel {
  final String id;
  final String name;
  final String license;
  final GeoPoint? location;
  final String phone;
  final String? address;
  final Map<String, int> inventory; // e.g. {'A+': 12, 'O-': 3, ...}
  final DateTime lastUpdated;
  final bool isVerified;

  const BloodBankModel({
    required this.id,
    required this.name,
    this.license = '',
    this.location,
    required this.phone,
    this.address,
    this.inventory = const {},
    required this.lastUpdated,
    this.isVerified = false,
  });

  factory BloodBankModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BloodBankModel(
      id: doc.id,
      name: data['name'] ?? '',
      license: data['license'] ?? '',
      location: data['location'] as GeoPoint?,
      phone: data['phone'] ?? '',
      address: data['address'],
      inventory: Map<String, int>.from(data['inventory'] ?? {}),
      lastUpdated: (data['lastUpdated'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isVerified: data['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'license': license,
      'location': location,
      'phone': phone,
      'address': address,
      'inventory': inventory,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
      'isVerified': isVerified,
    };
  }

  /// Total units of all blood types in stock.
  int get totalUnits => inventory.values.fold(0, (sum, count) => sum + count);

  /// Whether a specific blood group is available.
  bool hasBloodGroup(String group) => (inventory[group] ?? 0) > 0;

  /// Get stock for a specific blood group.
  int stockFor(String group) => inventory[group] ?? 0;
}
