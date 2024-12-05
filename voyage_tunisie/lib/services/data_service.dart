import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/ville.dart';
import '../models/lieu.dart';
import '../models/spectacle.dart';

class DataService {
  // Charger la liste des villes depuis le fichier JSON
  Future<List<Ville>> loadVilles() async {
    final jsonString = await rootBundle.loadString('assets/data.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);

    final List villesJson = jsonData['villes'];
    List<Ville> villes = villesJson.map((villeJson) {
      return Ville.fromJson(villeJson);
    }).toList();

    return villes;
  }

  // Charger la liste des lieux depuis le fichier JSON
  Future<List<Lieu>> loadLieux() async {
    final jsonString = await rootBundle.loadString('assets/data.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);

    final List lieuxJson = jsonData['lieux'];
    List<Lieu> lieux = lieuxJson.map((lieuJson) {
      return Lieu.fromJson(lieuJson);
    }).toList();

    return lieux;
  }

  // Charger la liste des spectacles depuis le fichier JSON
  Future<List<Spectacle>> loadSpectacles() async {
    final jsonString = await rootBundle.loadString('assets/data.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);

    final List spectaclesJson = jsonData['spectacles'];
    List<Spectacle> spectacles = spectaclesJson.map((spectacleJson) {
      return Spectacle.fromJson(spectacleJson);
    }).toList();

    return spectacles;
  }
}
