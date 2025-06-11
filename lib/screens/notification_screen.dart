import 'package:flutter/material.dart';
import 'package:myapp/utils/date_format.dart';
import '../models/app_notification_model.dart';

class NotificationScreen extends StatelessWidget {
  final List<AppNotification> notifications = [
    AppNotification(
      id: '1',
      titulo: 'Promotion',
      mensagem:
          'Today 50% discount on all Books in Novel category with online orders worldwide.',
      lida: false,
      data: DateTime(2021, 10, 21, 8, 0),
    ),
    AppNotification(
      id: '2',
      titulo: 'Promotion',
      mensagem: 'Buy 2 get 1 free for since books from 08 - 10 October 2021.',
      lida: false,
      data: DateTime(2021, 10, 8, 20, 30),
    ),
    AppNotification(
      id: '3',
      titulo: 'Information',
      mensagem: 'There is a new book now available',
      lida: true,
      data: DateTime(2021, 9, 16, 11, 0),
    ),
  ];

  Map<String, List<AppNotification>> _groupByMonth(List<AppNotification> list) {
    Map<String, List<AppNotification>> grouped = {};

    for (var notification in list) {
      String key = FormatData.formatData(notification.data);
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(notification);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedNotifications = _groupByMonth(notifications);

    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
        centerTitle: true,
        leading: BackButton(),
      ),
      body: ListView(
        children:
            groupedNotifications.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...entry.value.map(
                    (notif) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  notif.titulo,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              Text(
                                FormatData.formatData(notif.data),
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notif.mensagem,
                            style: const TextStyle(color: Colors.black87),
                          ),
                          const Divider(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }
}
