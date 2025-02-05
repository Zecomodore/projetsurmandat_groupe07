import 'package:flutter/material.dart';

class ValidationCodeMail extends StatelessWidget {
  const ValidationCodeMail({super.key});

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
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 350, // Largeur fixe pour le bouton
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/changerMotDePasse');

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
