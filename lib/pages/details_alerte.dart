import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'personne_varaible.dart';

import 'dart:async';

class DetailsAlerte extends StatefulWidget {
  final String type;
  final String heure;
  final int interventionId;

  const DetailsAlerte({
    super.key,
    required this.type,
    required this.heure,
    required this.interventionId,
  });

  @override
  State<DetailsAlerte> createState() => _DetailsAlerteState();
}

class _DetailsAlerteState extends State<DetailsAlerte> {
  List personnes = [];
  List vehicules = [];

  bool isDisponible = true;
  Timer? _autoRefreshTimer;

  void _showRenfortPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shadowColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text(
            'Demande de renfort effectuée',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void finAlerte() async {
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

      final response = await dio.put(
        "/interventions",
        queryParameters: {
          'int_no': widget.interventionId,
        },
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true);
      } else {
        throw Exception("Erreur lors de l'arrêt de l'alerte");
      }
    } catch (e) {
      print("Erreur: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("La fin de l'intervention à échoué"),
            backgroundColor: Colors.red),
      );
    }
  }

  void chargerPompierPresent() async {
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

      final response =
          await dio.get("/interventions/utilisateur/${widget.interventionId}");

      if (response.statusCode == 200) {
        setState(() {
          personnes = response.data;
        });
      } else {
        throw Exception("Erreur lors du chargement");
      }
    } catch (e) {
      print("Erreur: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Le chargement à échoué"),
            backgroundColor: Colors.red),
      );
    }
  }

  void chargerVehiculePresent() async {
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

      final response =
          await dio.get("/interventions/vehicule/${widget.interventionId}");

      if (response.statusCode == 200) {
        setState(() {
          vehicules = response.data;
        });
      } else {
        throw Exception("Erreur lors du chargement");
      }
    } catch (e) {
      print("Erreur: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Le chargement à échoué"),
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

      final response = await dio.get("/renfort-notification");

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

  void pompierDisponible() async {
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

      final response = await dio.post(
        "/interventions/ajout/pompier",
        queryParameters: {
          'uti_use_id': PersonneVaraible().userId,
          'lsu_int_no': widget.interventionId
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          isDisponible = false;
          chargerPompierPresent();
          chargerVehiculePresent();
        });
      } else {
        throw Exception("Erreur lors du chargement");
      }
    } catch (e) {
      print("Erreur: $e");
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Cette intervention a déjà été terminée"),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  void pompierEtat() async {
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

      final response = await dio.get(
        "/interventions/etat/pompier",
        queryParameters: {
          'uti_use_id': PersonneVaraible().userId,
          'lsu_int_no': widget.interventionId
        },
      );

      if (response.statusCode == 200) {
        bool data = response.data;
        setState(() {
          if (data == true) {
            isDisponible = false;
          } else {
            isDisponible = true;
          }
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

  void finIntervention() async {
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
        "/interventions/supprimer/pompier",
        queryParameters: {
          'uti_use_id': PersonneVaraible().userId,
          'lsu_int_no': widget.interventionId
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          isDisponible = true;
          chargerPompierPresent();
          chargerVehiculePresent();
        });
      } else {
        throw Exception("Erreur lors du la connexion");
      }
    } catch (e) {
      print("Erreur: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("L'action à échoué"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    chargerPompierPresent();
    chargerVehiculePresent();
    pompierEtat();

    _autoRefreshTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      chargerPompierPresent();
      chargerVehiculePresent();
    });
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Détails de l\'Alerte',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 251, 7, 7),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () async {
              chargerPompierPresent();
              chargerVehiculePresent();
              setState(() {});
            },
            tooltip: 'Rafraîchir',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Info : ${widget.type}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Heure : ${widget.heure}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(isDisponible
                      ? const Color.fromARGB(255, 3, 183, 60)
                      : const Color.fromARGB(255, 251, 7, 7)),
                  minimumSize:
                      WidgetStateProperty.all<Size>(const Size(400, 50)),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () {
                  if (isDisponible) {
                    pompierDisponible();
                  } else {
                    finIntervention();
                  }
                },
                child: Text(
                  isDisponible ? 'Disponible' : 'Indisponible',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Personnel disponible : ${personnes.length}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: personnes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      visualDensity: const VisualDensity(vertical: -4),
                      leading: const Icon(Icons.person),
                      title: Text(
                          '${personnes[index]['uti_prenom']} ${personnes[index]['uti_nom']}'),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Véhicules disponible : ${vehicules.length}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: vehicules.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      visualDensity: const VisualDensity(vertical: -4),
                      leading: const Icon(Icons.directions_car),
                      title: Text('${vehicules[index]['veh_nom']}'),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                        const Color.fromARGB(255, 251, 7, 7)),
                    minimumSize:
                        WidgetStateProperty.all<Size>(const Size(400, 50)),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () {
                    _showRenfortPopup();
                    envoyerNotification();
                  },
                  child: Text(
                    'Demande de renfort',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  )),
              SizedBox(height: 25),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                        const Color.fromARGB(255, 3, 183, 60)),
                    minimumSize:
                        WidgetStateProperty.all<Size>(const Size(400, 50)),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () {
                    finAlerte();
                  },
                  child: Text(
                    'Alerte terminée',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
