class Ville {
  final int id;
  final String nom;
  final String description;
  final String image;

  Ville({
    required this.id,
    required this.nom,
    required this.description,
    required this.image,
  });

  factory Ville.fromJson(Map<String, dynamic> json) {
    return Ville(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
      image: json['image'],
    );
  }
}
