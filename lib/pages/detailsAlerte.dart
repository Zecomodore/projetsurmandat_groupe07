import 'package:flutter/material.dart';

class DetailsAlerte extends StatefulWidget {
  final String type;
  final String heure;
  final String adresse;

  const DetailsAlerte({
    super.key,
    required this.type,
    required this.heure,
    required this.adresse,
  });

  @override
  State<DetailsAlerte> createState() => _DetailsAlerteState();
}

class _DetailsAlerteState extends State<DetailsAlerte> {
  final List<Map<String, String>> personnes = [
    {'prenom': 'Alice', 'nom': 'Dupont'},
    {'prenom': 'Bob', 'nom': 'Martin'},
    {'prenom': 'Claire', 'nom': 'Leclerc'},
    {'prenom': 'David', 'nom': 'Lemoine'},
    {'prenom': 'Eva', 'nom': 'Benoit'},
    {'prenom': 'Franck', 'nom': 'Pires'},
  ];

  final List<String> vehicules = [
    'Véhicule 1',
    'Véhicule 2',
  ];

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
          /*
          content: const Text(
            'La demande de renfort a bien été envoyée.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),*/
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Ferme le pop-up
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    /*
    // Fermer automatiquement le pop-up après 2 secondes (2000 millisecondes)
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Ferme la boîte de dialogue après 2 secondes
    });
    */
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
            const SizedBox(height: 30),
            Text(
              'Nombre de personne présente : ${personnes.length}',
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
                        '${personnes[index]['prenom']} ${personnes[index]['nom']}'),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Nombre de véhicule présent : ${vehicules.length}',
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
                    title: Text('${vehicules[index]}'),
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
