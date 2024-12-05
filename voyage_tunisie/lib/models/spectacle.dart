class Spectacle {
  final int id;
  final String nom;
  final DateTime date;
  final List<String> programme; 
  final int ville; 

  Spectacle({
    required this.id,
    required this.nom,
    required this.date,
    required this.programme,
    required this.ville,
  });

  factory Spectacle.fromJson(Map<String, dynamic> json) {
    return Spectacle(
      id: json['id'],
      nom: json['nom'],
      date: DateTime.parse(json['date']),
      programme: List<String>.from(json['programme']),
      ville: json['ville'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'date': date.toIso8601String(),
      'programme': programme,
      'ville': ville,
    };
  }
}
