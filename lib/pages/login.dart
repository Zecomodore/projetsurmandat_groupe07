import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() {
    return _MyLoginPage();
  }
}

class _MyLoginPage extends State<LoginPage> {
  String userName = '';
  String password = '';
  bool _obscurePassword =
      true; // Variable pour contrôler l'affichage du mot de passe

  @override
  Widget build(BuildContext context) {
    // Couleur personnalisée pour les contours
    final borderColor = const Color.fromARGB(255, 251, 7, 7);

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: EdgeInsetsDirectional.only(top: 100),
            height: 450,
            width: 450,
            child: Image.asset('assets/images/logo.png'),
          ),
          SizedBox(height: 20),
          Text(
            "Nom d'utilisateur",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            cursorColor: Colors.black, // Curseur en noir
            style: TextStyle(
              color: Colors.black, // Texte saisi en noir
              fontSize: 16,
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: borderColor, // Couleur personnalisée du contour
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: borderColor, // Couleur lors du focus
                  width: 2.0, // Épaisseur lors du focus
                ),
              ),
              labelText: "Entrez votre nom d'utilisateur",
              labelStyle: TextStyle(
                color: Colors.black, // Label en noir
              ),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.black, // Icône en noir
              ),
            ),
            onChanged: (value) {
              setState(() {
                userName = value;
              });
            },
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Mot de passe",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            cursorColor: Colors.black, // Curseur en noir
            style: TextStyle(
              color: Colors.black, // Texte saisi en noir
              fontSize: 16,
            ),
            obscureText:
                _obscurePassword, // Contrôle de l'affichage du mot de passe
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: borderColor, // Couleur personnalisée du contour
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: borderColor, // Couleur lors du focus
                  width: 2.0, // Épaisseur lors du focus
                ),
              ),
              labelText: "Entrez votre mot de passe",
              labelStyle: TextStyle(
                color: Colors.black, // Label en noir
              ),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.black, // Icône en noir
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black, // Icône de visibilité en noir
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            onChanged: (value) {
              setState(() {
                password = value;
              });
            },
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: borderColor, // Couleur identique au contour
              minimumSize: Size(200, 50),
              elevation: 18,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
            child: Text(
              "Se connecter",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/motDePasseOublier');
            },
            style: TextButton.styleFrom(
              splashFactory:
                  NoSplash.splashFactory, // Supprime les animations de clic
              foregroundColor: Colors.black, // Texte noir
            ),
            child: Text(
              "Mot de passe oublié ?",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
