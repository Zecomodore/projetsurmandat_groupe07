import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'personne_varaible.dart';

class CreationAlerte extends StatefulWidget {
  const CreationAlerte({super.key});

  @override
  State<CreationAlerte> createState() => _CreationAlerteState();
}

class _CreationAlerteState extends State<CreationAlerte> {
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

  void envoyerAlerte() async {
    String titre = titreController.text;

    try {
      String token = PersonneVaraible().token;
      if (token.isEmpty) {
        throw Exception("Aucun token trouvé !");
      }

      Dio dio = Dio(BaseOptions(
        baseUrl: "http://10.0.2.2:8000/api",
        connectTimeout: Duration(seconds: 20),
        receiveTimeout: Duration(seconds: 20),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ));

      final response = await dio.post(
        "/interventions",
        queryParameters: {
          'int_description': titre,
        },
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true);
      } else {
        throw Exception("Erreur lors de la déconnexion");
      }
    } catch (e) {
      print("Erreur: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Envoie de l'intervention à échoué"),
            backgroundColor: Colors.red),
      );
    }
  }

  void envoyerNotification() async {
    try {
      String token = PersonneVaraible().token;
      if (token.isEmpty) {
        throw Exception("Aucun token trouvé !");
      }

      Dio dio = Dio(BaseOptions(
        baseUrl: "http://10.0.2.2:8000/api",
        connectTimeout: Duration(seconds: 20),
        receiveTimeout: Duration(seconds: 20),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ));

      final response = await dio.get("/send-firebase-notification");

      if (response.statusCode == 200) {
      } else {
        throw Exception("Erreur lors de l'envoie");
      }
    } catch (e) {
      print("Erreur: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Envoie des notifications échoué"),
            backgroundColor: Colors.red),
      );
    }
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
              buildTextField('Titre de l\'alerte', 10, titreController),
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
                  envoyerNotification();
                },
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
