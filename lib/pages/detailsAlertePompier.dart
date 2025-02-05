import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsAlertePompier extends StatefulWidget {
  final String type;
  final String heure;
  final String adresse;

  const DetailsAlertePompier({
    super.key,
    required this.type,
    required this.heure,
    required this.adresse,
  });

  @override
  State<DetailsAlertePompier> createState() => _DetailsAlertePompierState();
}

class _DetailsAlertePompierState extends State<DetailsAlertePompier> {
  var disponibleColor = const Color.fromARGB(255, 3, 183, 60);
  var indisponibleColor = const Color.fromARGB(255, 251, 7, 7);

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
                      disponibleColor = const Color.fromARGB(255, 3, 183, 60);
                      indisponibleColor = const Color.fromARGB(255, 76, 76, 76);
                    });
                  },
                  child: Text('Disponible',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      )),
                ),
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
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Type : ${widget.type}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Heure : ${widget.heure}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Adresse : ${widget.adresse}',
              style: const TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _openGoogleMaps(widget.adresse);
              },
              child: Text("Voir sur Google Maps"),
            ),
            SizedBox(height: 25),
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
                  Navigator.pop(context);
                },
                child: Text(
                  'Alerte terminer',
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
