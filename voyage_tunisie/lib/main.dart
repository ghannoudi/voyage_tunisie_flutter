import 'package:flutter/material.dart';
import 'models/ville.dart'; // Importer la classe Ville
import 'screens/ville_list_screen.dart';
import 'screens/lieu_list_screen.dart';
import 'screens/panier.dart';
import 'screens/Spectacle_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Voyage en Tunisie',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/', 
      onGenerateRoute: (settings) {
        if (settings.name == '/lieux') {
          final Ville ville = settings.arguments as Ville; 
          return MaterialPageRoute(
            builder: (context) => LieuListScreen(ville: ville), 
          );
        }
          if (settings.name == '/spectacles') {
          final Ville ville = settings.arguments as Ville; 
          return MaterialPageRoute(
            builder: (context) => SpectacleListScreen(ville: ville), 
          );
        }

        if (settings.name == '/panier') {
          return MaterialPageRoute(
            builder: (context) => PanierScreen(), 
          );
        }

        return MaterialPageRoute(
          builder: (context) => VilleListScreen(), // Accueil par défaut avec la liste des villes
        );
      },
      home: VilleListScreen(), 
    );
  }
}
