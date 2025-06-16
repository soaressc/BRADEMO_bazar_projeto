import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/app_notification_model.dart';

class NotificationService {
  final CollectionReference<AppNotification> notificationsRef =
      FirebaseFirestore.instance
          .collection('notifications')
          .withConverter<AppNotification>(
            fromFirestore: (snap, _) => AppNotification.fromMap(snap.data()!),
            toFirestore: (notification, _) => notification.toMap(),
          );

  Future<void> createNotificationWithAutoId({
    required String userId,
    required String title,
    required String message,
  }) async {
    final docRef = notificationsRef.doc(); 

    final notification = AppNotification(
      id: docRef.id,
      userId: userId,
      title: title,
      message: message,
      sentDate: DateTime.now(),
      read: false,
    );

    await docRef.set(notification); 
    await showNotification(title, message); 
  }

  Future<void> createNotification(AppNotification notification) async {
    await notificationsRef.doc(notification.id.toString()).set(notification);
    await showNotification(notification.title, notification.message);
  }

  Future<AppNotification?> getNotification(String id) async {
    final doc = await notificationsRef.doc(id).get();
    return doc.data();
  }

  Future<void> updateNotification(AppNotification notification) =>
      notificationsRef
          .doc(notification.id.toString())
          .update(notification.toMap());

  Future<void> deleteNotification(String id) =>
      notificationsRef.doc(id).delete();

  Stream<List<AppNotification>> getNotificationsStream(String userId) {
    return notificationsRef
        .where('userId', isEqualTo: userId)
        .orderBy('sentDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> marcarComoLida(String id) async {
    await notificationsRef.doc(id).update({'read': true});
  }

  Future<void> marcarTodasComoLidas(String userId) async {
    final snapshot =
        await notificationsRef
            .where('userId', isEqualTo: userId)
            .where('read', isEqualTo: false)
            .get();

    for (var doc in snapshot.docs) {
      await doc.reference.update({'read': true});
    }
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings androidInitSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings = InitializationSettings(
    android: androidInitSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(initSettings);
}

Future<void> showNotification(String title, String message) async {
  const androidDetails = AndroidNotificationDetails(
    'default_channel_id',
    'Notificações',
    channelDescription: 'Canal padrão de notificações',
    importance: Importance.max,
    priority: Priority.high,
  );

  const notificationDetails = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    DateTime.now().millisecondsSinceEpoch ~/ 1000,
    title,
    message,
    notificationDetails,
  );
}
