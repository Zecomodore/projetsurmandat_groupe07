import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'personne_varaible.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  final borderColor = const Color.fromARGB(255, 251, 7, 7);

  Future<void> logout() async {
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

      final response = await dio.post("/logout");

      if (response.statusCode == 200) {
        print("Déconnexion réussie");

        // Effacer le token stocké
        PersonneVaraible().token = "";
        PersonneVaraible().nameType = "";
        PersonneVaraible().userId = 0;

        // Rediriger l'utilisateur vers l'écran de connexion
        Navigator.pushReplacementNamed(context, "/login");
      } else {
        throw Exception("Erreur lors de la déconnexion");
      }
    } catch (e) {
      print("Erreur: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Erreur de déconnexion"),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: borderColor,
        title: Text(
          'Sapeur Pompier',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 12,
        automaticallyImplyLeading: false, // Désactive le bouton de retour
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white, // Définit la couleur de l'icône en blanc
            ),
            onPressed: () {
              showMenu<String>(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                position: RelativeRect.fromLTRB(150, 110, 0, 0),
                items: [
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white, // Fond blanc
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black), // Contour noir
                      ),
                      child: TextButton(
                        onPressed: () {
                          logout();
                        },
                        child: Row(
                          children: [
                            Icon(Icons.logout, color: Colors.black),
                            SizedBox(width: 10),
                            Text(
                              'Déconnexion',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 40),
            // Remplacer le ListView par un GridView
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // Deux éléments par ligne
                padding: EdgeInsets.all(8),
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (PersonneVaraible().nameType == "ChefIntervention") {
                        Navigator.pushNamed(context, '/sos');
                      } else if (PersonneVaraible().nameType == "Vehicule") {
                        Navigator.pushNamed(context, '/sosVehicules');
                      } else if (PersonneVaraible().nameType ==
                          "SapeurPompier") {
                        Navigator.pushNamed(context, '/sosPompier');
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor),
                      ),
                      child: Image.asset('assets/images/sos.png'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      //Navigator.pushNamed(context, '/sosVehicules');
                      //mettre navigation
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor),
                      ),
                      child: Image.asset('assets/images/document.png'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      //Navigator.pushNamed(context, '/sosPompier');
                      //mettre navigation
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor),
                      ),
                      child: Image.asset('assets/images/agenda.png'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/espacePersonel');
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor),
                      ),
                      child: Image.asset('assets/images/personnel.png'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
