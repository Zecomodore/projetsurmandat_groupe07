import 'package:flutter/material.dart';

class EspacePersonel extends StatefulWidget {
  const EspacePersonel({super.key});

  @override
  _EspacePersonel createState() => _EspacePersonel();
}

class _EspacePersonel extends State<EspacePersonel> {
  final borderColor = const Color.fromARGB(255, 251, 7, 7);
  bool? isAvailable; // Variable pour suivre la sélection des boutons

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Espace personnel',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        centerTitle: true,
        backgroundColor: borderColor, // AppBar rouge
        iconTheme: const IconThemeData(
          color: Colors
              .white, // Définit la couleur des icônes de l'AppBar en blanc
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            // Section de nom/prénom et image
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Nom Prénom', // Nom à personnaliser
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Rôle ici', // Rôle à personnaliser
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  'assets/images/personnel.png',
                  width: 50,
                  height: 50,
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Question "Êtes-vous disponible ?"
            const Text(
              "Êtes-vous disponible ?",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isAvailable = true; // Marquer comme "Oui"
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAvailable == true
                        ? Colors.red
                        : Colors.grey, // Changer 'primary' en 'backgroundColor'
                    minimumSize: const Size(120, 50),
                    elevation: 18,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Oui',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isAvailable = false; // Marquer comme "Non"
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAvailable == false
                        ? Colors.red
                        : Colors.grey, // Changer 'primary' en 'backgroundColor'
                    minimumSize: const Size(120, 50),
                    elevation: 18,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Non',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: 350, // Largeur fixe pour le bouton
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/changerMotDePasse');
                  // Ajouter le code pour envoyer un e-mail de réinitialisation
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: borderColor, // Couleur identique au contour
                  minimumSize: Size(200, 50),
                  elevation: 18,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Changer de mot de passe',
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
    );
  }
}
