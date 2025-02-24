import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class DetailsAlerteVehicule extends StatefulWidget {
  final String type;
  final String heure;
  final String adresse;

  const DetailsAlerteVehicule({
    super.key,
    required this.type,
    required this.heure,
    required this.adresse,
  });

  @override
  State<DetailsAlerteVehicule> createState() => _DetailsAlerteVehiculeState();
}

class _DetailsAlerteVehiculeState extends State<DetailsAlerteVehicule> {
  Color disponibleColor = const Color.fromARGB(255, 3, 183, 60);
  Color indisponibleColor = const Color.fromARGB(255, 251, 7, 7);
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
                      setState(() => disponibleColor = Colors.grey);
                      _startTimer();
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
                      setState(() => indisponibleColor = Colors.grey);
                      _stopTimer();
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
                onPressed: () => Navigator.pop(context),
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
