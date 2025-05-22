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
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/personne_varaible.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(
      'Message reçu en arrière-plan ou app fermée : ${message.notification?.title}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await Firebase.initializeApp();
  await PushNotificationService.basicSetup();
  LocalNotificationService.initialize();

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token != null) {
    PersonneVaraible().token = token;
  }

  runApp(MyApp(initialRoute: token != null ? '/home' : '/login'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sapeur Pompier',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 251, 7, 7)),
        primarySwatch: Colors.red,
        popupMenuTheme: PopupMenuThemeData(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.black),
          ),
          elevation: 0,
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
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
