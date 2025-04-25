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
  Dio dio = Dio();
  String code = '';

  bool isVerifying = false;
  bool isResending = false;
  String? verifyMessage;
  String? resendMessage;

  Color redColor = const Color.fromARGB(255, 251, 7, 7);

  Future<void> verificationCode({String? codeRecus}) async {
    setState(() {
      isVerifying = true;
      verifyMessage = "Vérification en cours...";
    });

    try {
      final response = await dio.post(
        'http://127.0.0.1:8000/api/validation',
        data: {'code': codeRecus},
      );

      if (response.statusCode == 200) {
        var data = response.data['original'];

        PersonneVaraible().token = data['token'];
        PersonneVaraible().nameType = data['name'];
        PersonneVaraible().userId = data['userId'];

        Navigator.pushNamed(context, '/changerMotDePasse');
      } else {
        throw Exception('Code incorrect');
      }
    } catch (e) {
      setState(() {
        verifyMessage = "Code incorrect";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Code incorrect'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        isVerifying = false;
      });
    }
  }

  Future<void> demandeCode({String? email}) async {
    setState(() {
      isResending = true;
      resendMessage = "Envoi du code...";
    });

    try {
      final response = await dio.post(
        'http://127.0.0.1:8000/api/envoie',
        queryParameters: {'email': email},
      );

      if (response.statusCode == 200) {
        setState(() {
          resendMessage = "Code renvoyé avec succès !";
        });
      } else {
        throw Exception('Échec de l’envoi');
      }
    } catch (e) {
      setState(() {
        resendMessage = "Erreur lors de l’envoi du code.";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Erreur envoi code'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        isResending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = redColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: borderColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, '/login', (route) => false);
          },
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Entrer le code reçu par mail',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 350,
                child: TextField(
                  cursorColor: Colors.black,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  decoration: const InputDecoration(
                    labelText: "Code de validation",
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 251, 7, 7), width: 2.0),
                    ),
                  ),
                  onChanged: (value) => setState(() => code = value),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 350,
                child: ElevatedButton(
                  onPressed: isVerifying
                      ? null
                      : () => verificationCode(codeRecus: code),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isVerifying ? Colors.grey : redColor,
                    minimumSize: const Size(200, 50),
                    elevation: 18,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: isVerifying
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Envoyer',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
              if (verifyMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    verifyMessage!,
                    style: TextStyle(
                      color: verifyMessage == "Vérification en cours..."
                          ? Colors.black
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 40),
              const Text("Vous n'avez pas reçu le code ?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text('Vérifiez vos spams ou cliquez sur "Renvoyer"',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
              const SizedBox(height: 30),
              SizedBox(
                width: 350,
                child: ElevatedButton(
                  onPressed: isResending
                      ? null
                      : () => demandeCode(email: widget.mail),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isResending ? Colors.grey : redColor,
                    minimumSize: const Size(200, 50),
                    elevation: 18,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: isResending
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Renvoyer un code',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
              if (resendMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    resendMessage!,
                    style: TextStyle(
                      color: resendMessage!.contains("succès")
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
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
