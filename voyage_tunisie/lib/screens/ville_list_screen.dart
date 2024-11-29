import 'package:flutter/material.dart';
import '../models/ville.dart';
import '../services/data_service.dart';
import 'Panier.dart'; // Importer le fichier Panier.dart

class VilleListScreen extends StatefulWidget {
  @override
  _VilleListScreenState createState() => _VilleListScreenState();
}

class _VilleListScreenState extends State<VilleListScreen> {
  late Future<List<Ville>> futureVilles;

  @override
  void initState() {
    super.initState();
    futureVilles = DataService().loadVilles(); // Charger la liste des villes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "les trésors de la Tunisie",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepOrange, // Couleur attrayante pour l'AppBar
        actions: [
          TextButton(
            onPressed: () {
              // Naviguer vers l'écran PanierScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PanierScreen(),
                ),
              );
            },
            child: Row(
              children: [
                Icon(Icons.shopping_cart, color: Colors.white), // Icône blanche
                SizedBox(width: 5), // Espacement entre l'icône et le texte
                Text(
                  "",  // Texte du bouton
                  style: TextStyle(color: Colors.white), // Texte blanc
                ),
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Ville>>(
        future: futureVilles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Indicateur de chargement
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}")); // Affichage des erreurs
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Aucune ville trouvée.")); // Aucun résultat
          } else {
            final villes = snapshot.data!; // Liste des villes
            return ListView.builder(
              itemCount: villes.length,
              itemBuilder: (context, index) {
                final ville = villes[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Coins arrondis
                    ),
                    elevation: 5, // Ombre portée pour l'effet de profondeur
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/lieux',
                          arguments: ville,
                        ); // Navigation vers les lieux de la ville
                      },
                      child: Row(
                        children: [
                          // Image de la ville
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12), // Coins arrondis de l'image
                            child: Image.asset(
                              ville.image,
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            ),
                          ),
                          SizedBox(width: 16),
                          // Détails de la ville
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ville.nom,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  ville.description,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
