import 'package:flutter/material.dart';
import 'detailsAlertePompier.dart';

class SosPompierPage extends StatefulWidget {
  const SosPompierPage({super.key});

  @override
  State<SosPompierPage> createState() => _SosPompierPageState();
}

class _SosPompierPageState extends State<SosPompierPage> {
  // Liste des alertes avec des données dynamiques à remplacer par des requetes API
  final List<Map<String, String>> alertes = [
    {
      'type': 'Chat coincé dans un arbre',
      'heure': '12:00',
      'adresse': 'Chemin du Village de Perly 16'
    },
    {
      'type': 'Feu de poubelle',
      'heure': '14:30',
      'adresse': 'Pont de Lully Bernex'
    },
    {
      'type': 'Accident de voiture',
      'heure': '16:45',
      'adresse': 'Rue des Lilas'
    },
    {
      'type': 'Personne en détresse',
      'heure': '18:10',
      'adresse': '8 boulevard Haussmann'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'SOS',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 251, 7, 7),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              'Alertes en cours',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: alertes.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SosCard(
                      type: alertes[index]['type']!,
                      heure: alertes[index]['heure']!,
                      adresse: alertes[index]['adresse']!,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SosCard extends StatelessWidget {
  final String type;
  final String heure;
  final String adresse;

  const SosCard({
    super.key,
    required this.type,
    required this.heure,
    required this.adresse,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Type : $type'),
              Text('Heure : $heure'),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(
                  const Color.fromARGB(255, 251, 7, 7)),
              minimumSize: WidgetStateProperty.all<Size>(const Size(100, 50)),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsAlertePompier(
                    type: type,
                    heure: heure,
                    adresse: adresse,
                  ),
                ),
              );
            },
            child: const Text(
              'Détails',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
