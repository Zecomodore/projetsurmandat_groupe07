class VehiculeTemps {
  static final VehiculeTemps _instance = VehiculeTemps._internal();

  factory VehiculeTemps() {
    return _instance;
  }

  VehiculeTemps._internal();

  // Définir un état pour le chronomètre
  ChronometreEtat etatChronometre = ChronometreEtat.arreter;
  int tempsEnSecondes = 0;
}

enum ChronometreEtat { lancer, arreter, enPause }
