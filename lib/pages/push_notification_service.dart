import 'package:firebase_messaging/firebase_messaging.dart';
import 'notification_service.dart';
import 'package:dio/dio.dart';
import 'personne_varaible.dart';

class PushNotificationService {
  static bool _initialized = false;

  static Future<void> basicSetup() async {
    if (_initialized) return;
    _initialized = true;

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Demander permission
    await messaging.requestPermission();

    // Abonnement au topic
    await messaging.subscribeToTopic('interventions');
    print('Abonné au topic "interventions"');

    // Notifications foreground
    FirebaseMessaging.onMessage.listen((message) {
      LocalNotificationService.showNotification(message);
    });
  }

  // À appeler après login → on a un token utilisateur
  static Future<void> registerFcmToken() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    print('FCM Token après login: $fcmToken');

    if (fcmToken != null) {
      await sendTokenToBackend(fcmToken);
    }
  }

  static Future<void> sendTokenToBackend(String tokenFCM) async {
    try {
      String token = PersonneVaraible().token;
      if (token.isEmpty) {
        throw Exception("Aucun token trouvé !");
      }

      Dio dio = Dio(BaseOptions(
        baseUrl: "http://10.0.2.2:8000/api",
        connectTimeout: Duration(seconds: 20),
        receiveTimeout: Duration(seconds: 20),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ));

      final response = await dio.put(
        "/notif/ajout",
        queryParameters: {
          'user_id': PersonneVaraible().userId,
          'fcm_token': tokenFCM,
        },
      );

      if (response.statusCode == 200) {
        print("ajout du token FCM réussi");
      } else {
        throw Exception("Erreur lors de l'envoie");
      }
    } catch (e) {
      print("Erreur: $e");
    }
  }
}
