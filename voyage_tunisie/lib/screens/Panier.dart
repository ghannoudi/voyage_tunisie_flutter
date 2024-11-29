import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/lieu.dart';
import '../services/data_service.dart';

class PanierScreen extends StatefulWidget {
  @override
  _PanierScreenState createState() => _PanierScreenState();
}

class _PanierScreenState extends State<PanierScreen> {
  late Future<List<Lieu>> _futureFavoris;

  @override
  void initState() {
    super.initState();
    _futureFavoris = _getFavoris();
  }

  // Fonction pour récupérer les lieux favoris depuis SharedPreferences
  Future<List<Lieu>> _getFavoris() async {
    // Charger les lieux
    List<Lieu> lieux = await DataService().loadLieux();

    // Récupérer les lieux favoris
    final prefs = await SharedPreferences.getInstance();
    List<Lieu> favoris = [];

    for (var lieu in lieux) {
      bool? isFavori = prefs.getBool('favori_${lieu.id}') ?? false;
      if (isFavori) {
        // Marquer les lieux favoris
        lieu.favori = true;
        favoris.add(lieu);
      } else {
        lieu.favori = false;
      }
    }

    return favoris;
  }

  // Fonction pour ajouter ou retirer un lieu des favoris
  Future<void> _toggleFavori(Lieu lieu) async {
    final prefs = await SharedPreferences.getInstance();
    bool currentFavoriState = prefs.getBool('favori_${lieu.id}') ?? false;

    if (currentFavoriState) {
      // Si le lieu est déjà favori, on le retire
      await prefs.setBool('favori_${lieu.id}', false);
    } else {
      // Si le lieu n'est pas favori, on l'ajoute
      await prefs.setBool('favori_${lieu.id}', true);
    }

    // Rafraîchir la liste des favoris
    setState(() {
      _futureFavoris = _getFavoris();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panier'),
      ),
      body: FutureBuilder<List<Lieu>>(
        future: _futureFavoris,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Aucun lieu favori."));
          }

          // Liste des lieux favoris
          final lieuxFavoris = snapshot.data!;

          return ListView.builder(
            itemCount: lieuxFavoris.length,
            itemBuilder: (context, index) {
              final lieu = lieuxFavoris[index];

              return Card(
                margin: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        lieu.nom,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        lieu.description,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Image.asset(
                        lieu.image,
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(
                            lieu.favori ? Icons.favorite : Icons.favorite_border,
                            color: lieu.favori ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            // Appeler la fonction pour ajouter ou supprimer le lieu des favoris
                            _toggleFavori(lieu);
                          },
                        ),
                      ],
                    ),
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
