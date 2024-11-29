class Lieu {
  final int id;
  final String nom;
  final String description;
  final String image;
  final int villeId;  // L'ID de la ville à laquelle ce lieu appartient
  bool favori;        // Nouveau champ pour indiquer si le lieu est favori

  Lieu({
    required this.id,
    required this.nom,
    required this.description,
    required this.image,
    required this.villeId,
    this.favori = false, // Valeur par défaut pour favori
  });

  // Factory pour créer un objet Lieu depuis un JSON
  factory Lieu.fromJson(Map<String, dynamic> json) {
    return Lieu(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
      image: json['image'],
      villeId: json['ville'], // L'ID de la ville
      favori: json['favori'] ?? false, // Si le champ 'favori' est absent, la valeur par défaut est false
    );
  }

  // Méthode pour convertir un objet Lieu en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'description': description,
      'image': image,
      'ville': villeId,
      'favori': favori, // Ajout du champ 'favori' dans le JSON
    };
  }
}
