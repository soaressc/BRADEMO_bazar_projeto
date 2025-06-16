import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_notification_model.dart';

class NotificationService {
  final CollectionReference<AppNotification> notificationsRef = FirebaseFirestore.instance
      .collection('notifications')
      .withConverter<AppNotification>(
        fromFirestore: (snap, _) => AppNotification.fromMap(snap.data()!),
        toFirestore: (notification, _) => notification.toMap(),
      );

  Future<void> createNotification(AppNotification notification) =>
      notificationsRef.doc(notification.id).set(notification);

  Future<AppNotification?> getNotification(String id) async {
    final doc = await notificationsRef.doc(id).get();
    return doc.data();
  }

  Future<void> updateNotification(AppNotification notification) =>
      notificationsRef.doc(notification.id).update(notification.toMap());

  Future<void> deleteNotification(String id) => notificationsRef.doc(id).delete();
}
