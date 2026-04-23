import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a blood donation camp/drive in RaktSetu.
/// Maps to Firestore `/camps/{campId}` documents.
class CampModel {
  final String id;
  final String organizerId;
  final String title;
  final DateTime date;
  final GeoPoint? location;
  final String address;
  final int targetUnits;
  final int collectedUnits;
  final int rsvpCount;
  final String status; // 'upcoming' | 'live' | 'completed'
  final String? description;
  final String? imageUrl;

  const CampModel({
    required this.id,
    required this.organizerId,
    required this.title,
    required this.date,
    this.location,
    this.address = '',
    this.targetUnits = 0,
    this.collectedUnits = 0,
    this.rsvpCount = 0,
    this.status = 'upcoming',
    this.description,
    this.imageUrl,
  });

  factory CampModel.fromFirestore(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>?) ?? <String, dynamic>{};
    return CampModel(
      id: doc.id,
      organizerId: data['organizerId'] as String? ?? '',
      title: data['title'] as String? ?? '',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      location: data['location'] as GeoPoint?,
      address: data['address'] as String? ?? '',
      targetUnits: (data['targetUnits'] as num?)?.toInt() ?? 0,
      collectedUnits: (data['collectedUnits'] as num?)?.toInt() ?? 0,
      rsvpCount: (data['rsvpCount'] as num?)?.toInt() ?? 0,
      status: data['status'] as String? ?? 'upcoming',
      description: data['description'] as String?,
      imageUrl: data['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'organizerId': organizerId,
      'title': title,
      'date': Timestamp.fromDate(date),
      'location': location,
      'address': address,
      'targetUnits': targetUnits,
      'collectedUnits': collectedUnits,
      'rsvpCount': rsvpCount,
      'status': status,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  /// Progress percentage of units collected vs target.
  double get progress =>
      targetUnits > 0 ? (collectedUnits / targetUnits).clamp(0.0, 1.0) : 0.0;

  /// Whether the camp is currently accepting donations.
  bool get isLive => status == 'live';
}
