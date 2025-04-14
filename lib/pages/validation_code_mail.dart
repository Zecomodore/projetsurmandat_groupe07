import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'personne_varaible.dart';

class ValidationCodeMail extends StatefulWidget {
  final String mail;

  const ValidationCodeMail({
    super.key,
    required this.mail,
  });

  @override
  State<ValidationCodeMail> createState() => _ValidationCodeMailState();
}

class _ValidationCodeMailState extends State<ValidationCodeMail> {
  Dio dio = Dio(); // Instance de Dio pour les requêtes HTTP
  String code = ''; // Variable pour stocker le code de validation

  Future<void> verificationCode({
    String? codeRecus,
  }) async {
    // Code pour la connexion
    try {
      final response = await dio.post(
        //http://10.0.2.2:8000/api/auth pour l'émulateur android
        'http://127.0.0.1:8000/api/validation',
        data: {
          'code': codeRecus,
        },
      );

      if (response.statusCode == 200) {
        var data = response
            .data['original']; // Récupérer les données depuis "original"

        setState(() {
          PersonneVaraible().token =
              data['token']; // Correctement extrait depuis "original"
          PersonneVaraible().nameType = data['name'];
          PersonneVaraible().userId = data['userId'];
        });
        //Navigator.pushNamed(context, '/changerMotDePasse');
      } else {
        throw Exception('Code incorrect ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Code incorrect '),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> demandeCode({
    String? email,
  }) async {
    // Code pour la connexion
    try {
      final response = await dio.post(
        //http://10.0.2.2:8000/api/auth pour l'émulateur android
        'http://10.0.2.2:8000/api/envoie',
        queryParameters: {
          'email': email,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Demande effectuer'),
            backgroundColor: Colors.green,
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
                'Entrer reçu le code par mail',
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
                    labelText: "Code de validation",
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
                  onChanged: (value) => setState(() => code = value),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 350, // Largeur fixe pour le bouton
                child: ElevatedButton(
                  onPressed: () {
                    verificationCode(
                        codeRecus: code); // Appel de la méthode de vérification
                    if (PersonneVaraible().token.isNotEmpty) {
                      print(
                          'Connexion réussie : ${PersonneVaraible().token} ${PersonneVaraible().nameType} ${PersonneVaraible().userId}');
                      Navigator.pushNamed(context, '/changerMotDePasse');
                    }
                    // mettre la méthode de vérification du code de validation
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
              const SizedBox(height: 20),
              const Text(
                "Vous n'avez pas reçu le code ?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Vérifier vos spams ou cliquez sur "Renvoyer"',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 350, // Largeur fixe pour le bouton
                child: ElevatedButton(
                  onPressed: () {
                    demandeCode(
                        email: widget
                            .mail); // Appel de la méthode de demande de code
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
                    'Renvoyer un code',
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
