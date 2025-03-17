import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'personne_varaible.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() {
    return _MyLoginPage();
  }
}

class _MyLoginPage extends State<LoginPage> {
  final dio = Dio();

  String userName = '';
  String password = '';
  bool _obscurePassword = true;

  Future<void> login({String? email, String? password}) async {
    // Code pour la connexion
    try {
      final response = await dio.post(
        //http://10.0.2.2:8000/api/auth pour l'émulateur android apple 127.0.0.1
        'http://10.0.2.2:8000/api/auth',
        queryParameters: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.data['token'] != null) {
        setState(() {
          PersonneVaraible().token = response.data['token'];
          PersonneVaraible().nameType = response.data['name'];
          PersonneVaraible().userId = response.data['userId'];
        });
      } else {
        throw Exception('Utillisateurs ou mot de passe incorrect');
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Utillisateurs ou mot de passe incorrect'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = const Color.fromARGB(255, 251, 7, 7);
    final size = MediaQuery.of(context).size; // Récupérer la taille de l'écran

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        // Centre le contenu pour éviter le débordement
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize
                  .min, // Ajuste la taille pour éviter le débordement
              children: [
                SizedBox(
                  height: size.height * 0.25, // Adapte la hauteur au viewport
                  child: Image.asset('assets/images/logo.png'),
                ),
                const SizedBox(height: 40), // Adapte la hauteur au viewport
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Nom d'utilisateur",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  cursorColor: Colors.black,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: borderColor, width: 2.0),
                    ),
                    labelText: "Entrez votre nom d'utilisateur",
                    labelStyle: const TextStyle(color: Colors.black),
                    prefixIcon: const Icon(Icons.person, color: Colors.black),
                  ),
                  onChanged: (value) => setState(() => userName = value),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Mot de passe",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  cursorColor: Colors.black,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: borderColor, width: 2.0),
                    ),
                    labelText: "Entrez votre mot de passe",
                    labelStyle: const TextStyle(color: Colors.black),
                    prefixIcon: const Icon(Icons.lock, color: Colors.black),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  onChanged: (value) => setState(() => password = value),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: borderColor,
                    minimumSize:
                        Size(size.width * 0.7, 50), // Ajustement dynamique
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    await login(email: userName, password: password);
                    if (PersonneVaraible().token.isNotEmpty) {
                      print(
                          'Connexion réussie : ${PersonneVaraible().token} ${PersonneVaraible().nameType} ${PersonneVaraible().userId}');
                      Navigator.pushNamed(context, '/home');
                    }
                    //Navigator.pushNamed(context, '/home');
                  },
                  child: const Text(
                    "Se connecter",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/motDePasseOublier');
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                  child: const Text(
                    "Mot de passe oublié ?",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
