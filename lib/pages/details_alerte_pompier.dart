import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'personne_varaible.dart';
import 'package:dio/dio.dart';

class DetailsAlertePompier extends StatefulWidget {
  final String type;
  final String heure;
  //final String adresse;
  final int idIntervention;

  const DetailsAlertePompier({
    super.key,
    required this.type,
    required this.heure,
    //required this.adresse,
    required this.idIntervention,
  });

  @override
  State<DetailsAlertePompier> createState() => _DetailsAlertePompierState();
}

class _DetailsAlertePompierState extends State<DetailsAlertePompier> {
  var disponibleColor = const Color.fromARGB(255, 3, 183, 60);
  var indisponibleColor = const Color.fromARGB(255, 251, 7, 7);
  var terminerColor = const Color.fromARGB(255, 76, 76, 76);
  bool? isAvailable;
  /*
  void _openGoogleMaps(String adresse) async {
    Uri googleUrl;

    if (Uri.tryParse(adresse) != null) {
      if (await canLaunchUrl(
          Uri.parse("geo:0,0?q=${Uri.encodeComponent(adresse)}"))) {
        googleUrl =
            Uri.parse("geo:0,0?q=${Uri.encodeComponent(adresse)}"); // Android
      } else {
        googleUrl = Uri.parse(
            "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(adresse)}"); // Web/iOS
      }

      await launchUrl(googleUrl, mode: LaunchMode.externalApplication);
    } else {
      throw "Adresse non valide";
    }
  }
  */

  void _openGoogleMaps() async {
    final Uri googleUrl = Uri.parse("https://www.google.com/maps");

    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl, mode: LaunchMode.externalApplication);
    } else {
      throw "Impossible d’ouvrir Google Maps";
    }
  }

  void pompierDisponible() async {
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
        "/interventions/ajout/pompier",
        queryParameters: {
          'uti_use_id': PersonneVaraible().userId,
          'lsu_int_no': widget.idIntervention
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          isAvailable = false;
          disponibleColor = const Color.fromARGB(255, 76, 76, 76);
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
        baseUrl: "http://127.0.0.1:8000/api",
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
          'lsu_int_no': widget.idIntervention
        },
      );

      if (response.statusCode == 200) {
        bool data = response.data;
        setState(() {
          if (data == true) {
            isAvailable = false;
            disponibleColor = const Color.fromARGB(255, 76, 76, 76);
            terminerColor = const Color.fromARGB(255, 251, 7, 7);
          } else {
            isAvailable = true;
            disponibleColor = const Color.fromARGB(255, 3, 183, 60);
            terminerColor = const Color.fromARGB(255, 76, 76, 76);
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
        baseUrl: "http://127.0.0.1:8000/api",
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
          'lsu_int_no': widget.idIntervention
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          Navigator.pop(context);
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
    pompierEtat();
  }

  @override
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(disponibleColor),
                    minimumSize:
                        WidgetStateProperty.all<Size>(const Size(150, 50)),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      terminerColor = const Color.fromARGB(255, 251, 7, 7);
                      if (isAvailable == true || isAvailable == null) {
                        pompierDisponible();
                      }
                    });
                  },
                  child: Text('Disponible',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      )),
                ),
                /*
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(indisponibleColor),
                    minimumSize:
                        WidgetStateProperty.all<Size>(const Size(150, 50)),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      indisponibleColor = const Color.fromARGB(255, 251, 7, 7);
                      disponibleColor = const Color.fromARGB(255, 76, 76, 76);
                    });
                  },
                  child: Text('Indisponible',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      )),
                ),
                */
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Info : ${widget.type}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Heure : ${widget.heure}',
              style: const TextStyle(fontSize: 18),
            ),
            /*
            const SizedBox(height: 10),
            Text(
              'Adresse : ${widget.adresse}',
              style: const TextStyle(fontSize: 18),
            ),
            */
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _openGoogleMaps();
              },
              child: Text("Voir sur Google Maps"),
            ),
            SizedBox(height: 25),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all<Color>(terminerColor),
                  minimumSize:
                      WidgetStateProperty.all<Size>(const Size(400, 50)),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () {
                  if (isAvailable == false) {
                    finIntervention();
                  }
                },
                child: Text(
                  'Mon intervention terminer',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
