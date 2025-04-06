import 'package:flutter/material.dart';
import 'package:sapeur_pompier/pages/login.dart';
import 'package:dio/dio.dart';
import 'personne_varaible.dart';

class ChangerMotDePasse extends StatefulWidget {
  const ChangerMotDePasse({super.key});

  @override
  State<ChangerMotDePasse> createState() => _ChangerMotDePasseState();
}

class _ChangerMotDePasseState extends State<ChangerMotDePasse> {
  String mdp = ''; // Variable pour stocker le mot de passe
  String mpdConfirme =
      ''; // Variable pour stocker la confirmation du mot de passe

  void chagerMotDePasse({String? mdp, String? mpdConfirme}) async {
    // Affichage des valeurs dans la console (peut être remplacé par une API)

    try {
      String token = PersonneVaraible().token;
      if (token.isEmpty) {
        throw Exception("Aucun token trouvé !");
      }

      Dio dio = Dio(BaseOptions(
        baseUrl: "http://127.0.0.1:8000/api",
        connectTimeout: Duration(seconds: 20),
        receiveTimeout: Duration(seconds: 20),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ));

      final response = await dio.post(
        "/changer",
        queryParameters: {
          'password': mdp,
          'password_confirmation': mpdConfirme,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Chamgement validé"),
              backgroundColor: const Color.fromARGB(255, 54, 244, 54)),
        );
        PersonneVaraible().token = ''; // Réinitialiser le token
        PersonneVaraible().nameType = '';
        PersonneVaraible().userId = 0;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false,
        );
      } else {
        throw Exception("Erreur lors de la déconnexion");
      }
    } catch (e) {
      print("Erreur: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Chamgement échoué"), backgroundColor: Colors.red),
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
                'Veuillez entrer le nouveau mot de passe',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
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
                    labelText: "Nouveau mot de passe",
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
                  onChanged: (value) => setState(() => mdp = value),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Veuillez entrer à nouveau le mot de passe',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
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
                    labelText: "Nouveau mot de passe",
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
                  onChanged: (value) => setState(() => mpdConfirme = value),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 350, // Largeur fixe pour le bouton
                child: ElevatedButton(
                  onPressed: () {
                    chagerMotDePasse(
                        mdp: mdp,
                        mpdConfirme:
                            mpdConfirme); // Appel de la méthode de changement de mot de passe
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
                    'Valider',
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
