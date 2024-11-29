import 'package:flutter/material.dart';
import 'models/ville.dart'; // Importer la classe Ville
import 'screens/ville_list_screen.dart';
import 'screens/lieu_list_screen.dart';
import 'screens/panier.dart'; // Si vous avez un panier, vous pouvez l'ajouter

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
      initialRoute: '/', // L'écran par défaut
      onGenerateRoute: (settings) {
        // Vérifier si la route est '/lieux'
        if (settings.name == '/lieux') {
          final Ville ville = settings.arguments as Ville; // Récupérer l'objet Ville passé en argument
          return MaterialPageRoute(
            builder: (context) => LieuListScreen(ville: ville), // Passer la ville à l'écran des lieux
          );
        }

        // Si la route est '/panier', créer une route pour l'écran du panier
        if (settings.name == '/panier') {
          return MaterialPageRoute(
            builder: (context) => PanierScreen(), // Remplacer par votre écran PanierScreen
          );
        }

        // Retourner null ou une route par défaut pour les autres cas
        return MaterialPageRoute(
          builder: (context) => VilleListScreen(), // Accueil par défaut avec la liste des villes
        );
      },
      home: VilleListScreen(), // L'écran d'accueil avec la liste des villes
    );
  }
}
