import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'personne_varaible.dart';
import 'vehicule_temps.dart'; // Import du singleton

class DetailsAlerteVehicule extends StatefulWidget {
  final String type;
  final String heure;
  final int idIntervention;

  const DetailsAlerteVehicule({
    super.key,
    required this.type,
    required this.heure,
    required this.idIntervention,
  });

  @override
  State<DetailsAlerteVehicule> createState() => _DetailsAlerteVehiculeState();
}

class _DetailsAlerteVehiculeState extends State<DetailsAlerteVehicule> {
  Color interventionTerminer = const Color.fromARGB(255, 76, 76, 76);
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
      if (mounted) {
        setState(() {
          _seconds++;
          VehiculeTemps().tempsEnSecondes =
              _seconds; // Mettre à jour dans le singleton
        });
      } else {
        timer.cancel();
      }
    });
    VehiculeTemps().etatChronometre =
        ChronometreEtat.lancer; // Mettre à jour l'état
  }

  void _stopTimer() {
    _timer?.cancel();
    VehiculeTemps().etatChronometre =
        ChronometreEtat.arreter; // Mettre à jour l'état
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _openGoogleMaps() async {
    final Uri googleUrl = Uri.parse("https://www.google.com/maps");

    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl, mode: LaunchMode.externalApplication);
    } else {
      throw "Impossible d’ouvrir Google Maps";
    }
  }

  void vahiculeDisponible() async {
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
        "/interventions/ajout/vehicule",
        queryParameters: {
          'veh_use_id': PersonneVaraible().userId,
          'lsv_int_no': widget.idIntervention,
        },
      );

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            disponibleColor = Colors.grey;
            chronometreLancer = true;
            VehiculeTemps().etatChronometre = ChronometreEtat.lancer;
            VehiculeTemps().tempsEnSecondes = 0;
            _seconds = 0;
            _startTimer();
          });
        }
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

  void vahiculeArrivee() async {
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
        "/interventions/arrive/vehicule",
        queryParameters: {
          'veh_use_id': PersonneVaraible().userId,
          'lsv_int_no': widget.idIntervention,
        },
      );

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            interventionTerminer = const Color.fromARGB(255, 251, 7, 7);
            indisponibleColor = Colors.grey;
            chronometreArreter = true;
            VehiculeTemps().etatChronometre = ChronometreEtat.arreter;
            _stopTimer();
          });
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Erreur lors du chargement"),
                backgroundColor: Colors.red),
          );
        }
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

  void vahiculeFinIntervention() async {
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
        "/interventions/supprimer/vehicule",
        queryParameters: {
          'veh_use_id': PersonneVaraible().userId,
          'lsv_int_no': widget.idIntervention,
        },
      );

      if (response.statusCode == 200) {
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        throw Exception("Erreur lors du chargement");
      }
    } catch (e) {
      print("Erreur: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Le chargement a échoué"),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  void vahiculeEtat() async {
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
        "/interventions/etat/vehicule",
        queryParameters: {
          'veh_use_id': PersonneVaraible().userId,
          'lsv_int_no': widget.idIntervention,
        },
      );

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            if (response.data == true) {
              disponibleColor = Colors.grey;
              indisponibleColor = Colors.grey;
              chronometreLancer = true;
              chronometreArreter = true;
              interventionTerminer = const Color.fromARGB(255, 251, 7, 7);
            } else {
              disponibleColor = const Color.fromARGB(255, 3, 183, 60);
              indisponibleColor = const Color.fromARGB(255, 251, 7, 7);
              chronometreLancer = false;
              chronometreArreter = false;
            }
          });
        }
      } else {
        throw Exception("Erreur lors du chargement");
      }
    } catch (e) {
      print("Erreur: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Le chargement a échoué"),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final etat = VehiculeTemps().etatChronometre;
    final secondes = VehiculeTemps().tempsEnSecondes;

    chronometreLancer =
        (etat == ChronometreEtat.lancer || etat == ChronometreEtat.arreter);
    chronometreArreter = (etat == ChronometreEtat.arreter);
    _seconds = secondes;
    /*
    if (chronometreLancer == true && chronometreArreter == false) {
      _startTimer();
    }
    */

    vahiculeEtat();
  }

  @override
  void dispose() {
    _timer?.cancel(); // On arrête le timer proprement
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return PopScope(
        canPop: !(chronometreLancer == true && chronometreArreter == false),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              'Détails de l\'Alerte',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 251, 7, 7),
            iconTheme: const IconThemeData(color: Colors.white),
            automaticallyImplyLeading: false,
            leading: (chronometreLancer == true && chronometreArreter == false)
                ? null
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
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.03),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          if (chronometreLancer == false) {
                            vahiculeDisponible();
                          }
                        },
                        child: const Text('Départ',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: indisponibleColor,
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.03),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          if (chronometreLancer == true &&
                              chronometreArreter == false) {
                            vahiculeArrivee();
                          }
                        },
                        child: const Text('Arrivée sur site',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                Text('Info : ${widget.type}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text('Heure : ${widget.heure}',
                    style: const TextStyle(fontSize: 18)),
                SizedBox(height: screenHeight * 0.03),
                FractionallySizedBox(
                  widthFactor: 0.9,
                  child: ElevatedButton(
                    onPressed: () => _openGoogleMaps(),
                    child: const Text("Voir sur Google Maps"),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                FractionallySizedBox(
                  widthFactor: 0.9,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: interventionTerminer,
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      if (chronometreLancer == true &&
                          chronometreArreter == true) {
                        vahiculeFinIntervention();
                        VehiculeTemps().tempsEnSecondes = 0;
                      }
                    },
                    child: const Text('Intervention terminée',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
