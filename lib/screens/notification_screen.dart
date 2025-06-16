import 'package:flutter/material.dart';
import '../models/app_notification_model.dart';
import '../service/notification_service.dart';
import 'package:myapp/utils/date_format.dart';

class NotificationScreen extends StatelessWidget {
  final NotificationService notificationService = NotificationService();
  final String userId;

  NotificationScreen({required this.userId});

  Map<String, List<AppNotification>> _groupByDate(List<AppNotification> list) {
    Map<String, List<AppNotification>> grouped = {};
    for (var notification in list) {
      String key = FormatData.nomeMesEAno(notification.sentDate);
      grouped.putIfAbsent(key, () => []).add(notification);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    notificationService.marcarTodasComoLidas(userId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações'),
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: StreamBuilder<List<AppNotification>>(
        stream: notificationService.getNotificationsStream(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar notificações.'));
          }

          final notificacoes = snapshot.data ?? [];
          if (notificacoes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: 0.2,
                    child: Icon(
                      Icons.notifications_none,
                      size: screenWidth * 0.5, // Responsivo
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'There is no notifications',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }

          final groupedNotifications = _groupByDate(notificacoes);

          return LayoutBuilder(
            builder: (context, constraints) {
              return ListView(
                children: groupedNotifications.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Text(
                          entry.key,
                          style: TextStyle(
                            fontSize: screenWidth < 360 ? 14 : 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ...entry.value.map((notif) {
                        return GestureDetector(
                          onTap: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirmar exclusão'),
                                content: const Text(
                                    'Deseja realmente excluir essa notificação?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text('Não'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: const Text('Sim'),
                                  ),
                                ],
                              ),
                            );

                            if (confirmed == true) {
                              final service = NotificationService();
                              await service.marcarComoLida(notif.id.toString());
                              await service.deleteNotification(notif.id.toString());
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        notif.title,
                                        style: TextStyle(
                                          fontSize: screenWidth < 360 ? 14 : 16,
                                          fontWeight: FontWeight.bold,
                                          color: const Color.fromARGB(255, 84, 64, 140),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      FormatData.nomeMesEAnoAbreviado(
                                        notif.sentDate,
                                        comHora: true,
                                      ),
                                      style: TextStyle(
                                        fontSize: screenWidth < 360 ? 10 : 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  notif.message,
                                  style: TextStyle(
                                    fontSize: screenWidth < 360 ? 12 : 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                const Divider(height: 24),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
