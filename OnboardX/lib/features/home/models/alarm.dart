class Alarm {
  Alarm({
    required this.id,
    required this.dateTime,
    required this.location,
    this.isActive = true,
  });

  final int id;
  final DateTime dateTime;
  final String location;
  bool isActive;
}
