import 'package:flutter/material.dart';

class CreationAlerte extends StatefulWidget {
  const CreationAlerte({super.key});

  @override
  State<CreationAlerte> createState() => _CreationAlerteState();
}

class _CreationAlerteState extends State<CreationAlerte> {
  // Déclaration des contrôleurs pour stocker les entrées utilisateur
  final TextEditingController titreController = TextEditingController();
  final TextEditingController adresseController = TextEditingController();
  final TextEditingController infoController = TextEditingController();

  Widget buildTextField(
      String label, int maxLines, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          maxLines: maxLines,
          cursorColor: Colors.black,
          style: const TextStyle(
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Fonction appelée lors de l'envoi de l'alerte
  void envoyerAlerte() {
    String titre = titreController.text;
    String adresse = adresseController.text;
    String info = infoController.text;

    // Affichage des valeurs dans la console (peut être remplacé par une API)
    print("Titre de l'alerte: $titre");
    print("Adresse: $adresse");
    print("Informations complémentaires: $info");

    // Ici, tu peux ajouter la logique pour envoyer les données à une API
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Création d\'alerte',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 251, 7, 7),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text(
                'Information alerte',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Champs de texte avec contrôleurs
              buildTextField('Titre de l\'alerte', 5, titreController),
              buildTextField('Adresse de l\'alerte', 3, adresseController),
              buildTextField('Informations complémentaires (facultatif)', 8,
                  infoController),

              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                      const Color.fromARGB(255, 251, 7, 7)),
                  minimumSize:
                      WidgetStateProperty.all<Size>(const Size(400, 50)),
                  elevation: WidgetStateProperty.all<double>(18),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () {
                  envoyerAlerte();
                  Navigator.pop(context);
                }, // Appelle la fonction lors du clic
                child: const Text(
                  'Envoyer l\'alerte',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
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
