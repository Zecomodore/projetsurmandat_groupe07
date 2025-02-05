import 'package:flutter/material.dart';
import 'pages/login.dart';
import 'pages/motDePasseOublier.dart';
import 'pages/validationCodeMail.dart';
import 'pages/changerMotDePasse.dart';
import 'pages/home.dart';
import 'pages/espacePersonel.dart';
import 'pages/sos.dart';
import 'pages/creationAlerte.dart';
import 'pages/sosPompier.dart';

void main() {
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
        '/validationCodeMail': (context) => const ValidationCodeMail(),
        '/changerMotDePasse': (context) => const ChangerMotDePasse(),
        '/home': (context) => const HomePage(),
        '/espacePersonel': (context) => const EspacePersonel(),
        '/sos': (context) => const SosPage(),
        '/creationAlerte': (context) => const CreationAlerte(),
        '/sosPompier': (context) => const SosPompierPage(),
      },
    );
  }
}
