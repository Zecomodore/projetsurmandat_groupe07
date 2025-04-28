import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'validation_code_mail.dart';

class Motdepasseoublier extends StatefulWidget {
  const Motdepasseoublier({super.key});

  @override
  State<Motdepasseoublier> createState() => _MotdepasseoublierState();
}

class _MotdepasseoublierState extends State<Motdepasseoublier> {
  String mail = '';
  final dio = Dio();

  bool isLoading = false;
  String? infoMessage;
  Color buttonColor = const Color.fromARGB(255, 251, 7, 7);

  Future<void> demandeCode({String? email}) async {
    setState(() {
      isLoading = true;
      infoMessage = "Vérification en cours...";
      buttonColor = Colors.grey;
    });

    try {
      final response = await dio.post(
        'http://127.0.0.1:8000/api/envoie',
        queryParameters: {'email': email},
      );

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ValidationCodeMail(mail: email!),
          ),
        );
      } else {
        throw Exception('Erreur inattendue');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        buttonColor = const Color.fromARGB(255, 251, 7, 7);
        infoMessage = "Mail incorrect ou introuvable.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = const Color.fromARGB(255, 251, 7, 7);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: borderColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Veuillez saisir votre adresse mail',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 350,
                child: TextField(
                  cursorColor: Colors.black,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  decoration: InputDecoration(
                    labelText: "Adresse e-mail",
                    labelStyle: const TextStyle(color: Colors.black),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 251, 7, 7),
                        width: 2.0,
                      ),
                    ),
                  ),
                  onChanged: (value) => setState(() => mail = value),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 350,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          demandeCode(email: mail);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    minimumSize: const Size(200, 50),
                    elevation: 18,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Envoyer',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              if (infoMessage != null)
                Text(
                  infoMessage!,
                  style: TextStyle(
                    color:
                        buttonColor == Colors.grey ? Colors.black : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
