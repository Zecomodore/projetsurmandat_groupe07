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

  bool isLoading = false;

  Widget buildTextField(
      String label, int maxLines, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          maxLines: maxLines,
          cursorColor: Colors.black,
          style: const TextStyle(fontSize: 16),
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

  Future<void> envoyerAlerte() async {
    setState(() => isLoading = true);
    try {
      String titre = titreController.text;
      String token = PersonneVaraible().token;
      if (token.isEmpty) throw Exception("Aucun token trouvé !");

      Dio dio = Dio(BaseOptions(
        baseUrl: "http://10.0.2.2:8000/api",
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ));

      final response = await dio.post(
        "/interventions",
        queryParameters: {'int_description': titre},
      );

      if (response.statusCode == 200) {
        await envoyerNotification(); // on attend aussi la notification
        Navigator.pop(context, true);
      } else {
        throw Exception("Erreur lors de la création de l'intervention");
      }
    } catch (e) {
      print("Erreur: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Envoi de l'intervention échoué"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> envoyerNotification() async {
    try {
      String token = PersonneVaraible().token;
      if (token.isEmpty) throw Exception("Aucun token trouvé !");

      Dio dio = Dio(BaseOptions(
        baseUrl: "http://10.0.2.2:8000/api",
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ));

      await dio.get("/send-firebase-notification");
    } catch (e) {
      print("Erreur envoi notif: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Envoi des notifications échoué"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const redColor = Color.fromARGB(255, 251, 7, 7);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Création d\'alerte',
          style: TextStyle(
              fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: redColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Information alerte',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            buildTextField('Titre de l\'alerte', 10, titreController),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : envoyerAlerte,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isLoading ? Colors.grey : redColor,
                  minimumSize: const Size(400, 50),
                  elevation: 18,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Envoyer l\'alerte',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
