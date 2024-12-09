import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
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
  Future<void> _openMap(String lieuNom) async {
    final String encodedLocation = Uri.encodeComponent(lieuNom); // Encoder le nom du lieu
    final Uri url = Uri.parse('https://www.google.com/maps?q=$encodedLocation'); 
      await launchUrl(url);
   }

  Future<List<Lieu>> _getFavoris() async {
    List<Lieu> lieux = await DataService().loadLieux();

    final prefs = await SharedPreferences.getInstance();
    List<Lieu> favoris = [];

    for (var lieu in lieux) {
      bool? isFavori = prefs.getBool('favori_${lieu.id}') ?? false;
      if (isFavori) {
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
      await prefs.setBool('favori_${lieu.id}', false);
    } else {
      await prefs.setBool('favori_${lieu.id}', true);
    }
    setState(() {
      _futureFavoris = _getFavoris();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('À Visiter',
        style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          ),
        backgroundColor: Colors.deepOrange,
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
                            _toggleFavori(lieu);
                          },
                        ),
                         IconButton(
                              icon: Icon(Icons.map, color: Colors.blue),
                              onPressed: () {
                                _openMap(lieu.nom); 
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
