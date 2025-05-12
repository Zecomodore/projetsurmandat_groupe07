import 'package:firebase_messaging/firebase_messaging.dart';
import 'notification_service.dart';

class PushNotificationService {
  static Future<void> initialize() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Demander la permission sur iOS (facultatif sur Android)
    NotificationSettings settings = await messaging.requestPermission();

    // Obtenir le token FCM
    String? token = await messaging.getToken();
    print('FCM Token: $token');

    // ➕ Abonnement au topic "interventions"
    await messaging.subscribeToTopic('interventions');
    print('✅ Abonné au topic "interventions"');

    // Écouter les messages reçus en premier plan
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message reçu : ${message.notification?.title}');
      LocalNotificationService.showNotification(message);
    });
  }
}
