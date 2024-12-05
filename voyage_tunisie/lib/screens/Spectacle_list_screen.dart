import 'package:flutter/material.dart';
import '../models/spectacle.dart'; // Importer la classe Spectacle
import '../models/ville.dart'; // Importer la classe Ville
import '../services/data_service.dart'; // Service pour charger les spectacles

class SpectacleListScreen extends StatelessWidget {
  final Ville ville;

  const SpectacleListScreen({Key? key, required this.ville}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Utilisation de FutureBuilder pour attendre que la liste des spectacles soit chargée
    return Scaffold(
      appBar: AppBar(
        title: Text('Spectacles à ${ville.nom}'),
      ),
      body: FutureBuilder<List<Spectacle>>(
        future: DataService().loadSpectacles(),
        builder: (context, snapshot) {
          final spectacles = snapshot.data!
          
              .where((spectacle) =>
                  spectacle.ville == ville.id) // Comparer avec l'ID de la ville
              .toList();

          // Si aucun spectacle n'est trouvé après le filtrage
          if (spectacles.isEmpty) {
            return Center(
                child: Text("Aucun spectacle trouvé pour cette ville."));
          }

          // Affichage de la liste des spectacles
          return ListView.builder(
            itemCount: spectacles.length,
            itemBuilder: (context, index) {
              final spectacle = spectacles[index];
              
              return Card(
                elevation: 4, // Ajoute une ombre à la carte
                margin: const EdgeInsets.all(12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Coins arrondis
                ),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      title: Text(
                        spectacle.nom,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Date: ${spectacle.date.year}-${spectacle.date.month}-${spectacle.date.day}",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      leading: Icon(Icons.event,
                          color: Colors.deepPurple,
                          size: 40), // Icône de gauche
                    ),
                    Divider(), // Ligne de séparation visuelle
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: spectacle.programme.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Row(
                              children: [
                                Icon(Icons.circle,
                                    size: 10, color: Colors.deepPurple),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 8), // Espace supplémentaire en bas
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
