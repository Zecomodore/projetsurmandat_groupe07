import 'package:flutter/material.dart';
import 'pages/login.dart';
import 'pages/mot_de_passe_oublier.dart';
//import 'pages/validation_code_mail.dart';
import 'pages/changer_mot_de_passe.dart';
import 'pages/home.dart';
import 'pages/espace_personel.dart';
import 'pages/sos.dart';
import 'pages/creation_alerte.dart';
import 'pages/sos_pompier.dart';
import 'pages/sos_vehicules.dart';

import 'package:firebase_core/firebase_core.dart';
import 'pages/notification_service.dart';
import 'pages/push_notification_service.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(
      '🔵 Message reçu en arrière-plan ou app fermée : ${message.notification?.title}');
  // Tu peux aussi afficher une notification locale ici si tu veux
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔁 Enregistrer le handler pour messages en background/terminated
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await Firebase.initializeApp();
  await PushNotificationService.initialize(); // ← le `await` est recommandé
  LocalNotificationService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sapeur Pompier',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 251, 7, 7)),
        primarySwatch: Colors.red,
        popupMenuTheme: PopupMenuThemeData(
          color: Colors.white, // Fond blanc pour le menu
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.black), // Bordure noire
          ),
          elevation: 0, // Enlever l'ombre
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/motDePasseOublier': (context) => const Motdepasseoublier(),
        //'/validationCodeMail': (context) => const ValidationCodeMail(),
        '/changerMotDePasse': (context) => const ChangerMotDePasse(),
        '/home': (context) => const HomePage(),
        '/espacePersonel': (context) => const EspacePersonel(),
        '/sos': (context) => const SosPage(),
        '/creationAlerte': (context) => const CreationAlerte(),
        '/sosPompier': (context) => const SosPompierPage(),
        '/sosVehicules': (context) => const SosVehiculePage(),
      },
    );
  }
}
