class VehiculeTemps {
  static final VehiculeTemps _instance = VehiculeTemps._internal();

  factory VehiculeTemps() {
    return _instance;
  }

  VehiculeTemps._internal();

  ChronometreEtat etatChronometre = ChronometreEtat.arreter;
  int tempsEnSecondes = 0;
}

enum ChronometreEtat { lancer, arreter, enPause }
