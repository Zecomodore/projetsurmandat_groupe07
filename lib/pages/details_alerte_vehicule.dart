import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'personne_varaible.dart';

class DetailsAlerteVehicule extends StatefulWidget {
  final String type;
  final String heure;
  final String adresse;
  final int idIntervention;

  const DetailsAlerteVehicule({
    super.key,
    required this.type,
    required this.heure,
    required this.adresse,
    required this.idIntervention,
  });

  @override
  State<DetailsAlerteVehicule> createState() => _DetailsAlerteVehiculeState();
}

class _DetailsAlerteVehiculeState extends State<DetailsAlerteVehicule> {
  Color disponibleColor = const Color.fromARGB(255, 3, 183, 60);
  Color indisponibleColor = const Color.fromARGB(255, 251, 7, 7);
  bool? chronometreLancer = false;
  bool? chronometreArreter = false;
  Timer? _timer;
  int _seconds = 0;

  void _startTimer() {
    _timer?.cancel();
    _seconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _openGoogleMaps(String adresse) async {
    Uri googleUrl = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(adresse)}");
    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl, mode: LaunchMode.externalApplication);
    } else {
      throw "Impossible d'ouvrir Google Maps";
    }
  }

  void vahiculeDisponible() async {
    try {
      String token = PersonneVaraible().token;
      if (token.isEmpty) {
        throw Exception("Aucun token trouvé !");
      }

      Dio dio = Dio(BaseOptions(
        baseUrl: "http://127.0.0.1:8000/api",
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ));

      final response = await dio.post(
        "/interventions/ajout/vehicule",
        queryParameters: {
          'veh_use_id': PersonneVaraible().userId,
          'lsv_int_no': widget.idIntervention,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          setState(() => disponibleColor = Colors.grey);
          chronometreLancer = true;
          _startTimer();
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

  void vahiculeArrivee() async {
    try {
      String token = PersonneVaraible().token;
      if (token.isEmpty) {
        throw Exception("Aucun token trouvé !");
      }

      Dio dio = Dio(BaseOptions(
        baseUrl: "http://127.0.0.1:8000/api",
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ));

      final response = await dio.put(
        "/interventions/arrive/vehicule",
        queryParameters: {
          'veh_use_id': PersonneVaraible().userId,
          'lsv_int_no': widget.idIntervention,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          setState(() => indisponibleColor = Colors.grey);
          _stopTimer();
          chronometreArreter = true;
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

  void vahiculeFinIntervention() async {
    try {
      String token = PersonneVaraible().token;
      if (token.isEmpty) {
        throw Exception("Aucun token trouvé !");
      }

      Dio dio = Dio(BaseOptions(
        baseUrl: "http://127.0.0.1:8000/api",
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ));

      final response = await dio.put(
        "/interventions/supprimer/vehicule",
        queryParameters: {
          'veh_use_id': PersonneVaraible().userId,
          'lsv_int_no': widget.idIntervention,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          Navigator.pop(context);
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

  void vahiculeEtat() async {
    try {
      String token = PersonneVaraible().token;
      if (token.isEmpty) {
        throw Exception("Aucun token trouvé !");
      }

      Dio dio = Dio(BaseOptions(
        baseUrl: "http://127.0.0.1:8000/api",
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ));

      final response = await dio.get(
        "/interventions/etat/vehicule",
        queryParameters: {
          'veh_use_id': PersonneVaraible().userId,
          'lsv_int_no': widget.idIntervention,
        },
      );

      if (response.statusCode == 200) {
        if (response.data == true) {
          setState(() {
            disponibleColor = Colors.grey;
            indisponibleColor = Colors.grey;
            chronometreLancer = true;
            chronometreArreter = true;
          });
        } else {
          setState(() {
            disponibleColor = const Color.fromARGB(255, 3, 183, 60);
            indisponibleColor = const Color.fromARGB(255, 251, 7, 7);
            chronometreLancer = false;
            chronometreArreter = false;
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

  @override
  void initState() {
    super.initState();
    vahiculeEtat();
  }

  @override
  Widget build(BuildContext context) {
    //double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Détails de l\'Alerte',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 251, 7, 7),
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false, // Empêche le bouton retour par défaut
        leading: (chronometreLancer == true && chronometreArreter == false)
            ? null // Masque le bouton retour tant que "Arrivée" n'est pas appuyé
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _formatTime(_seconds),
              style: const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: screenHeight * 0.02),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: disponibleColor,
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.03),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      if (chronometreLancer == false) {
                        vahiculeDisponible();
                      }
                    },
                    child: const Text('Départ',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: indisponibleColor,
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.03),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      if (chronometreLancer == true &&
                          chronometreArreter == false) {
                        vahiculeArrivee();
                      }
                    },
                    child: const Text('Arrivée',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),
            Text('Type : ${widget.type}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Heure : ${widget.heure}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Adresse : ${widget.adresse}',
                style: const TextStyle(fontSize: 18)),
            SizedBox(height: screenHeight * 0.03),
            FractionallySizedBox(
              widthFactor: 0.9,
              child: ElevatedButton(
                onPressed: () => _openGoogleMaps(widget.adresse),
                child: const Text("Voir sur Google Maps"),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            FractionallySizedBox(
              widthFactor: 0.9,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 251, 7, 7),
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  vahiculeFinIntervention();
                },
                child: const Text('Alerte terminée',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
