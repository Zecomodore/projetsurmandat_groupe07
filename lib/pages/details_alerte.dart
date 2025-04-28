import 'package:flutter/material.dart';
import 'package:sapeur_pompier/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'personne_varaible.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class DetailsAlerte extends StatefulWidget {
  final String type;
  final String heure;
  //final String adresse;
  final int interventionId;

  const DetailsAlerte({
    super.key,
    required this.type,
    required this.heure,
    //required this.adresse,
    required this.interventionId,
  });

  @override
  State<DetailsAlerte> createState() => _DetailsAlerteState();
}

class _DetailsAlerteState extends State<DetailsAlerte> {
  List personnes = [];
  List vehicules = [];

  @override
  void initState() {
    super.initState();
    chargerPompierPresent();
    chargerVehiculePresent();
    _setupFCM(); // Initialise Firebase Cloud Messaging
  }

  // Gestion de Firebase Cloud Messaging
  Future<void> _setupFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      _getTokenAndSave(); // Récupère et enregistre le token FCM
      listenForNotifications(); // Écoute les notifications
    } else {
      print('User declined or has not accepted permission');
    }
  }

  // Récupère le token FCM et l'envoie au serveur
  Future<void> _getTokenAndSave() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      String authToken = PersonneVaraible().token;
      Dio dio = Dio(BaseOptions(
        baseUrl: "http://10.0.2.2:8000/api",
        headers: {
          "Authorization": "Bearer $authToken",
          "Accept": "application/json",
        },
      ));

      final response = await dio.post(
        "/fcm-token", // Endpoint pour enregistrer le token côté serveur
        data: {'fcm_token': token},
      );

      if (response.statusCode == 200) {
        print("Token FCM enregistré avec succès sur le serveur");
      } else {
        print(
            "Erreur lors de l'enregistrement du token FCM: ${response.statusCode}");
      }
    }
  }

  // Écoute les notifications reçues par Firebase
  void listenForNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        displayNotification(notification.title,
            notification.body); // Affiche une notification locale
      }
    });
  }

  // Affiche une notification locale
  void displayNotification(String? title, String? body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'main_channel',
      'Main Channel',
      channelDescription: 'Main channel for notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

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

  void _showRenfortPopup() async {
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

      final response = await dio.post(
        "/demande-renfort", // Endpoint pour demander un renfort
        queryParameters: {
          'intervention_id': widget.interventionId,
        },
      );

      if (response.statusCode == 200) {
        // Appel de la fonction pour envoyer la notification push
        _sendNotification(widget
            .type); // Envoyer le type d'alerte comme titre de la notification

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
                    Navigator.pop(context); // Ferme le pop-up
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception("Erreur lors de la demande de renfort");
      }
    } catch (e) {
      print("Erreur: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("La demande de renfort à échoué"),
            backgroundColor: Colors.red),
      );
    }
  }

  // Envoie une notification push
  Future<void> _sendNotification(String title) async {
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

      final response = await dio.post(
        "/send-notification", // Endpoint pour envoyer une notification
        data: {
          'title': title, // Envoie le titre de l'alerte
          'message': 'Une demande de renfort a été effectuée.',
        },
      );

      if (response.statusCode == 200) {
        print("Notification envoyée avec succès");
      } else {
        throw Exception("Erreur lors de l'envoi de la notification");
      }
    } catch (e) {
      print("Erreur: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("L'envoi de la notification à échoué"),
            backgroundColor: Colors.red),
      );
    }
  }

  void finAlerte() async {
    try {
      String token = PersonneVaraible().token;
      if (token.isEmpty) {
        throw Exception("Aucun token trouvé !");
      }

      Dio dio = Dio(BaseOptions(
        baseUrl: "http://127.0.0.1:8000/api",
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
        baseUrl: "http://127.0.0.1:8000/api",
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
        baseUrl: "http://127.0.0.1:8000/api",
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
              /*
              const SizedBox(height: 10),
              Text(
                'Adresse : ${widget.adresse}',
                style: const TextStyle(fontSize: 18),
              ),
              */
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _openGoogleMaps();
                },
                child: Text("Voir sur Google Maps"),
              ),
              const SizedBox(height: 20),
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
                          '${personnes[index]['uti_prenom']} ${personnes[index]['uti_nom']}'),
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
                    finAlerte();
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
      ),
    );
  }
}
