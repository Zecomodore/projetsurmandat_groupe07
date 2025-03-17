class PersonneVaraible {
  static final PersonneVaraible _instance = PersonneVaraible._internal();
  factory PersonneVaraible() {
    return _instance;
  }
  PersonneVaraible._internal();

  String token = '';
  String nameType = '';
  int userId = 0;
}
