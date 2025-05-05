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
import 'pages/personne_varaible.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await registerFcmToken();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // Affiche une notification locale ou un snackbar
    print('Notification reçue: ${message.notification?.title}');
  });

  runApp(const MyApp());
}

Future<void> registerFcmToken() async {
  final fcm = FirebaseMessaging.instance;
  String? token = await fcm.getToken();
  if (token != null) {
    // Envoie le token à Laravel
    final dio = Dio();
    final userToken = PersonneVaraible().token; // Ton token d'auth utilisateur
    await dio.post(
      'http://10.0.2.2:8000/api/store-fcm-token',
      data: {'token': token},
      options: Options(headers: {
        "Authorization": "Bearer $userToken",
        "Accept": "application/json",
      }),
    );
  }
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
