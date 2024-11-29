import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ville.dart';
import '../models/lieu.dart';
import '../services/data_service.dart';

class LieuListScreen extends StatefulWidget {
  final Ville ville;

  const LieuListScreen({Key? key, required this.ville}) : super(key: key);

  @override
  _LieuListScreenState createState() => _LieuListScreenState();
}

class _LieuListScreenState extends State<LieuListScreen> {
  late Future<List<Lieu>> futureLieux;

  @override
  void initState() {
    super.initState();
    futureLieux = DataService().loadLieux();  // Charger les lieux séparément
  }

   // Fonction pour ouvrir Google Maps
  Future<void> _openMap(String lieuNom) async {
    final String encodedLocation = Uri.encodeComponent(lieuNom); // Encoder le nom du lieu
    final Uri url = Uri.parse('https://www.google.com/maps?q=$encodedLocation'); 
      await launchUrl(url);
   }

  // Fonction pour charger l'état favori depuis SharedPreferences
  Future<bool> _getFavori(int lieuId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('favori_$lieuId') ?? false;
  }

  // Fonction pour sauvegarder l'état favori dans SharedPreferences
  Future<void> _setFavori(int lieuId, bool isFavori) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('favori_$lieuId', isFavori);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ville.nom),
      ),
      body: FutureBuilder<List<Lieu>>(
        future: futureLieux,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Aucun lieu trouvé."));
          }

          // Filtrer les lieux de la ville sélectionnée
          final lieux = snapshot.data!
              .where((lieu) => lieu.villeId == widget.ville.id) // Filtrer par villeId
              .toList();

          return ListView.builder(
            itemCount: lieux.length,
            itemBuilder: (context, index) {
              final lieu = lieux[index];

              return FutureBuilder<bool>(
                future: _getFavori(lieu.id),  // Charger l'état favori depuis SharedPreferences
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  bool isFavori = snapshot.data ?? false; // Si non défini, utiliser false par défaut

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
                                isFavori ? Icons.favorite : Icons.favorite_border,
                                color: isFavori ? Colors.red : Colors.grey,
                              ),
                              onPressed: () async {
                                setState(() {
                                  isFavori = !isFavori;  // Inverser l'état favori localement
                                });
                                await _setFavori(lieu.id, isFavori);  // Sauvegarder l'état favori
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.map, color: Colors.blue),
                              onPressed: () {
                                _openMap(lieu.nom); // Ouvrir Google Maps
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
          );
        },
      ),
    );
  }
}
