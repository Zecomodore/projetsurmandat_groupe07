import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: DarwinInitializationSettings(),
    );

    await _notificationsPlugin.initialize(initializationSettings);

    // 🔧 Créer un vrai AndroidNotificationChannel (non const)
    const channel = AndroidNotificationChannel(
      'default_channel',
      'Notifications',
      description: 'Canal par défaut pour les notifications',
      importance: Importance.high,
    );

    // 🔧 Enregistrer le canal après initialisation
    final androidPlugin =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(channel);
    }
  }

  static void showNotification(RemoteMessage message) {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'emergency_channel', // ⚠️ Utilise le même ID que dans createNotificationChannel
      'Alerte d\'intervention', // Nom du canal
      channelDescription: 'Notification d’urgence pour interventions',
      importance: Importance.max, // 🔊 Priorité maximale
      priority: Priority.high,
      playSound: true, // ✅ Son système
      enableVibration: true, // ✅ Vibration
      ticker: 'Nouvelle intervention !', // 📢 Texte de survol Android
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000, // ID unique
      message.notification?.title ?? 'Nouvelle intervention',
      message.notification?.body ?? 'Une nouvelle intervention est disponible.',
      details,
    );
  }
}
