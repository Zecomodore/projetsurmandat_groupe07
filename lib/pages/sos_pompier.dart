import 'package:flutter/material.dart';
import 'details_alerte_pompier.dart';
import 'package:dio/dio.dart';
import 'personne_varaible.dart';

class SosPompierPage extends StatefulWidget {
  const SosPompierPage({super.key});

  @override
  State<SosPompierPage> createState() => _SosPompierPageState();
}

class _SosPompierPageState extends State<SosPompierPage> {
  List alertes = [];
  bool occuper = false;
  int idIntervention = 0;

  Future<void> getIntervention() async {
    try {
      String token = PersonneVaraible().token;
      Dio dio = Dio(BaseOptions(
        baseUrl: "http://127.0.0.1:8000/api",
        connectTimeout: Duration(seconds: 20),
        receiveTimeout: Duration(seconds: 20),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ));

      final response = await dio.get("/interventions");
      setState(() {
        alertes = response.data;
      });
    } catch (e) {
      print('Erreur lors du téléchargement des alertes: $e');
    }
  }

  void utiDispo() async {
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
        "/lstutilisateur/etat",
        queryParameters: {
          'uti_use_id': PersonneVaraible().userId,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['original']['resultat']) {
          setState(() {
            occuper = true;
            idIntervention = data['original']['lsu_int_no'];
          });
        } else {
          setState(() {
            occuper = false;
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
    getIntervention();
    utiDispo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Interventions en cours',
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () async {
              await getIntervention();
              utiDispo();
              setState(() {});
            },
            tooltip: 'Rafraîchir',
          ),
        ],
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
                      type: alertes[index]['int_description']!,
                      heure: alertes[index]['int_heure']!,
                      //adresse: alertes[index]['int_adresse']!,
                      id: alertes[index]['int_no']!,
                      occuper: occuper,
                      idRecu: idIntervention,
                      onRefresh: () async {
                        await getIntervention();
                        utiDispo();
                      },
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
  //final String adresse;
  final int id;
  final bool occuper;
  final int idRecu;
  final Future<void> Function() onRefresh;

  const SosCard({
    super.key,
    required this.type,
    required this.heure,
    //required this.adresse,
    required this.id,
    required this.occuper,
    required this.idRecu,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (occuper == true) {
          if (idRecu == id) {
            await  Navigator.push(context,MaterialPageRoute(
            builder: (context) => DetailsAlertePompier(
              type: type,
              heure: heure,
              //adresse: adresse,
              idIntervention: id,
            ),
          ),
        );
            await onRefresh(); // Appel ici
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Vous avez déjà une alerte en cours"),
                backgroundColor: Colors.red,
                duration: Duration(milliseconds: 500),
              ),
            );
          }
        } else {
          await  Navigator.push(context,MaterialPageRoute(
            builder: (context) => DetailsAlertePompier(
              type: type,
              heure: heure,
              //adresse: adresse,
              idIntervention: id,
            ),
          ),
        );
          await onRefresh(); // Appel ici
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Info : $type',
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text('Heure : $heure'),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                color: Color.fromARGB(255, 251, 7, 7)),
          ],
        ),
      ),
    );
  }
}
