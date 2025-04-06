import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'validation_code_mail.dart';

class Motdepasseoublier extends StatefulWidget {
  const Motdepasseoublier({super.key});

  @override
  State<Motdepasseoublier> createState() => _MotdepasseoublierState();
}

class _MotdepasseoublierState extends State<Motdepasseoublier> {
  String mail = ''; // Variable pour stocker l'adresse e-mail saisie
  final dio = Dio(); // Instance de Dio pour les requêtes HTTP

  Future<void> demandeCode({
    String? email,
  }) async {
    // Code pour la connexion
    try {
      final response = await dio.post(
        //http://10.0.2.2:8000/api/auth pour l'émulateur android
        'http://127.0.0.1:8000/api/envoie',
        queryParameters: {
          'email': email,
        },
      );

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ValidationCodeMail(
              mail: email!,
            ),
          ),
        );
      } else {
        throw Exception('Mail incorrect');
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mail incorrect'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = const Color.fromARGB(255, 251, 7, 7);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: borderColor, // AppBar rouge
        iconTheme: const IconThemeData(
          color: Colors
              .white, // Définit la couleur des icônes de l'AppBar en blanc
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centrer les éléments
            children: [
              const Text(
                'Veuillez saisir votre adresse mail',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 350, // Largeur fixe pour le champ de texte
                child: TextField(
                  cursorColor: Colors.black,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    labelText: "Adresse e-mail",
                    labelStyle: const TextStyle(color: Colors.black),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 251, 7, 7), // Rouge au focus
                        width: 2.0,
                      ),
                    ),
                  ),
                  onChanged: (value) => setState(() => mail = value),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 350, // Largeur fixe pour le bouton
                child: ElevatedButton(
                  onPressed: () {
                    print(
                        'Voici le mail ------------------------------------------' +
                            mail); // Affiche l'adresse e-mail dans la console
                    demandeCode(
                        email:
                            mail); // Appel de la fonction pour envoyer le mail
                    // Ajouter le code pour envoyer un e-mail de réinitialisation
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        borderColor, // Couleur identique au contour
                    minimumSize: Size(200, 50),
                    elevation: 18,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Envoyer',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white, // Texte blanc
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
