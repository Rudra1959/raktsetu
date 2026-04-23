import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a notification in RaktSetu.
/// Maps to Firestore `/notifications/{notifId}` documents.
class NotificationModel {
  final String id;
  final String userId;
  final String type; // 'match_found'|'reminder'|'escalation'|'broadcast'
  final List<String> channels; // ['fcm', 'sms', 'email']
  final DateTime sentAt;
  final bool read;
  final String? title;
  final String? body;
  final Map<String, dynamic> payload;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    this.channels = const ['fcm'],
    required this.sentAt,
    this.read = false,
    this.title,
    this.body,
    this.payload = const {},
  });

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>?) ?? <String, dynamic>{};
    return NotificationModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      type: data['type'] as String? ?? 'broadcast',
      channels: List<String>.from((data['channel'] as List<dynamic>?) ?? const ['fcm']),
      sentAt: (data['sentAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      read: data['read'] as bool? ?? false,
      title: data['title'] as String?,
      body: data['body'] as String?,
      payload: Map<String, dynamic>.from(
        (data['payload'] as Map<dynamic, dynamic>?) ?? const <dynamic, dynamic>{},
      ),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'type': type,
      'channel': channels,
      'sentAt': Timestamp.fromDate(sentAt),
      'read': read,
      'title': title,
      'body': body,
      'payload': payload,
    };
  }
}
