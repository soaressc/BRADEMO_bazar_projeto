import 'package:flutter/material.dart';
import 'package:myapp/utils/date_format.dart';
import '../models/app_notification_model.dart';
// import '../widgets/bottom_bar.dart';

class NotificationScreen extends StatelessWidget {
  final List<AppNotification> notifications = [
    AppNotification(
      titulo: 'Notificação 1',
      mensagem: 'Teste mensagem',
      lida: false,
      data: DateTime(2025, 2, 13),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notificações')),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return ListTile(
            leading: Icon(
              notif.lida ? Icons.mark_email_read : Icons.mark_email_unread,
              color: notif.lida ? Colors.green : Colors.red,
            ),
            title: Text(notif.titulo),
            subtitle: Text(
              '${notif.mensagem}\n${FormatData.formatData(notif.data)}',
            ),
            isThreeLine: true,
          );
        },
      ),
    );
  }
}
