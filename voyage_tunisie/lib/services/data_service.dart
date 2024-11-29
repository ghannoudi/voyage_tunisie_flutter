import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/ville.dart';
import '../models/lieu.dart';

class DataService {
  Future<List<Ville>> loadVilles() async {
    // Charger le fichier JSON
    final jsonString = await rootBundle.loadString('assets/data.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);

    // Charger la liste des villes
    final List villesJson = jsonData['villes'];
    List<Ville> villes = villesJson.map((villeJson) {
      return Ville.fromJson(villeJson);  // Ne pas passer les lieux ici
    }).toList();

    return villes;
  }

  Future<List<Lieu>> loadLieux() async {
    // Charger le fichier JSON
    final jsonString = await rootBundle.loadString('assets/data.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);

    // Charger la liste des lieux
    final List lieuxJson = jsonData['lieux'];
    List<Lieu> lieux = lieuxJson.map((lieuJson) {
      return Lieu.fromJson(lieuJson);
    }).toList();

    return lieux;
  }
}
