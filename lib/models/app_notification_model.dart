import 'package:cloud_firestore/cloud_firestore.dart';

class AppNotification {
  final String id; 
  final String userId;
  final String title;
  final String message;
  final DateTime sentDate;
  final bool read;

  AppNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.sentDate,
    this.read = false,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'title': title,
    'message': message,
    'sentDate': Timestamp.fromDate(sentDate),
    'read': read,
  };

  factory AppNotification.fromMap(Map<String, dynamic> map) => AppNotification(
    id: map['id'], 
    userId: map['userId'],
    title: map['title'],
    message: map['message'],
    sentDate:
        map['sentDate'] is Timestamp
            ? (map['sentDate'] as Timestamp).toDate()
            : DateTime.parse(map['sentDate']),
    read: map['read'] ?? false,
  );
}
