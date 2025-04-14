import 'package:flutter/material.dart';
import 'personne_varaible.dart';
import 'package:dio/dio.dart';

class EspacePersonel extends StatefulWidget {
  const EspacePersonel({super.key});

  @override
  _EspacePersonel createState() => _EspacePersonel();
}

class _EspacePersonel extends State<EspacePersonel> {
  String? info;
  List utilisrateur = [];
  final borderColor = const Color.fromARGB(255, 251, 7, 7);
  bool? isAvailable; // Variable pour suivre la sélection des boutons
  String? role;

  void regardeDispo(int chiffre) {
    if (chiffre == 1) {
      setState(() {
        isAvailable = true;
      });
    } else {
      setState(() {
        isAvailable = false;
      });
    }
  }

  void chargerInfoUtilisateur() async {
    try {
      String token = PersonneVaraible().token;
      if (token.isEmpty) {
        throw Exception("Aucun token trouvé !");
      }

      Dio dio = Dio(BaseOptions(
        baseUrl: "http://10.0.2.2:8000/api",
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ));

      final response =
          await dio.get("/utilisateur/info/${PersonneVaraible().userId}");

      if (response.statusCode == 200) {
        List data = response.data; // Récupération des données de l'API

        if (data.isNotEmpty) {
          // Vérifier que la liste n'est pas vide
          setState(() {
            utilisrateur = data;
            info =
                '${utilisrateur[0]['uti_prenom']} ${utilisrateur[0]['uti_nom']}';
            regardeDispo(utilisrateur[0]['uti_disponible']);
          });
        } else {
          setState(() {
            info = "Inconnu";
          });
        }
      } else {
        throw Exception("Erreur lors du chargement");
      }
    } catch (e) {
      print("Erreur: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Le chargement a échoué"),
            backgroundColor: Colors.red),
      );
    }
  }

  void chargerInfoVehicule() async {
    try {
      String token = PersonneVaraible().token;
      if (token.isEmpty) {
        throw Exception("Aucun token trouvé !");
      }

      Dio dio = Dio(BaseOptions(
        baseUrl: "http://10.0.2.2:8000/api",
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ));

      final response =
          await dio.get("/vehicule/info/${PersonneVaraible().userId}");

      if (response.statusCode == 200) {
        List data = response.data;

        if (data.isNotEmpty) {
          setState(() {
            utilisrateur = data;
            info = '${utilisrateur[0]['veh_nom']}';
            regardeDispo(utilisrateur[0]['veh_disponible']);
          });
        } else {
          setState(() {
            info = "Inconnu";
          });
        }
      } else {
        throw Exception("Erreur lors du chargement");
      }
    } catch (e) {
      print("Erreur: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Le chargement a échoué"),
            backgroundColor: Colors.red),
      );
    }
  }

  void changerVehiculeIndisponible() async {
    try {
      String token = PersonneVaraible().token;
      if (token.isEmpty) {
        throw Exception("Aucun token trouvé !");
      }

      Dio dio = Dio(BaseOptions(
        baseUrl: "http://10.0.2.2:8000/api",
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ));

      final response = await dio.put(
        "/vehicule/indisponible",
        queryParameters: {
          'veh_use_no': PersonneVaraible().userId,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          isAvailable = false;
        });
      } else {
        throw Exception("Erreur lors du chargement");
      }
    } catch (e) {
      print("Erreur: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Le chargement a échoué"),
            backgroundColor: Colors.red),
      );
    }
  }

  void changerVehiculeDisponible() async {
    try {
      String token = PersonneVaraible().token;
      if (token.isEmpty) {
        throw Exception("Aucun token trouvé !");
      }

      Dio dio = Dio(BaseOptions(
        baseUrl: "http://10.0.2.2:8000/api",
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ));

      final response = await dio.put(
        "/vehicule/disponible",
        queryParameters: {
          'veh_use_no': PersonneVaraible().userId,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          isAvailable = true;
        });
      } else {
        throw Exception("Erreur lors du chargement");
      }
    } catch (e) {
      print("Erreur: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Le chargement a échoué"),
            backgroundColor: Colors.red),
      );
    }
  }

  void changerUtilisateurIndisponible() async {
    try {
      String token = PersonneVaraible().token;
      if (token.isEmpty) {
        throw Exception("Aucun token trouvé !");
      }

      Dio dio = Dio(BaseOptions(
        baseUrl: "http://10.0.2.2:8000/api",
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ));

      final response = await dio.put(
        "/utilisateur/indisponible",
        queryParameters: {
          'uti_use_no': PersonneVaraible().userId,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          isAvailable = false;
        });
      } else {
        throw Exception("Erreur lors du chargement");
      }
    } catch (e) {
      print("Erreur: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Le chargement a échoué"),
            backgroundColor: Colors.red),
      );
    }
  }

  void changerUtilisateurDisponible() async {
    try {
      String token = PersonneVaraible().token;
      if (token.isEmpty) {
        throw Exception("Aucun token trouvé !");
      }

      Dio dio = Dio(BaseOptions(
        baseUrl: "http://10.0.2.2:8000/api",
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ));

      final response = await dio.put(
        "/utilisateur/disponible",
        queryParameters: {
          'uti_use_no': PersonneVaraible().userId,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          isAvailable = true;
        });
      } else {
        throw Exception("Erreur lors du chargement");
      }
    } catch (e) {
      print("Erreur: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Le chargement a échoué"),
            backgroundColor: Colors.red),
      );
    }
  }

  void _choixRole() {
    // Code pour choisir le rôle
    if (PersonneVaraible().nameType == 'ChefIntervention') {
      setState(() {
        role = 'Chef d\'intervention';
        chargerInfoUtilisateur();
      });
    } else if (PersonneVaraible().nameType == 'SapeurPompier') {
      setState(() {
        role = 'Sapeur-pompier';
        chargerInfoUtilisateur();
      });
    } else if (PersonneVaraible().nameType == 'Vehicule') {
      setState(() {
        role = 'Véhicule';
        chargerInfoVehicule();
      });
    } else {
      setState(() {
        role = 'Rôle non défini';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _choixRole(); // Appelle la fonction pour définir le rôle
  }

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
                  children: [
                    Text(
                      info ?? 'Inconnu', // Nom à personnaliser
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      role ??
                          'Rôle non défini', // Affiche le rôle ou une valeur par défaut
                      style: const TextStyle(
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
                      //isAvailable = true;
                      if (PersonneVaraible().nameType == 'ChefIntervention' ||
                          PersonneVaraible().nameType == 'SapeurPompier') {
                        changerUtilisateurDisponible();
                      } else if (PersonneVaraible().nameType == 'Vehicule') {
                        changerVehiculeDisponible();
                      }
                      // Marquer comme "Oui"
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAvailable == true
                        ? Colors.green
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
                      if (PersonneVaraible().nameType == 'ChefIntervention' ||
                          PersonneVaraible().nameType == 'SapeurPompier') {
                        changerUtilisateurIndisponible();
                      } else if (PersonneVaraible().nameType == 'Vehicule') {
                        changerVehiculeIndisponible();
                      }
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
