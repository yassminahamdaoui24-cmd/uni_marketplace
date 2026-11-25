import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

import 'screens/bienvenue_screen.dart';
import 'screens/connexion_screen.dart';
import 'screens/inscription_screen.dart';
import 'screens/catalogue_screen.dart';
import 'screens/recherche_screen.dart';
import 'screens/detail_annonce_screen.dart';
import 'screens/publication_screen.dart';
import 'screens/mes_annonces_screen.dart';
import 'screens/favoris_screen.dart';
import 'screens/profil_screen.dart';

void main() {
  runApp(const UniMarketplaceApp());
}

class UniMarketplaceApp extends StatelessWidget {
  const UniMarketplaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uni Marketplace',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/bienvenue',

      routes: {
        '/bienvenue': (context) => const BienvenueScreen(),
        '/connexion': (context) => const ConnexionScreen(),
        '/inscription': (context) => const InscriptionScreen(),
        

        '/catalogue': (context) => const CatalogueScreen(),
        '/recherche': (context) => const RechercheScreen(),
        '/detail': (context) => const DetailAnnonceScreen(),
        '/publication': (context) => const PublicationScreen(),
        '/mes-annonces': (context) => const MesAnnoncesScreen(),
        '/favoris': (context) => const FavorisScreen(),
        '/profil': (context) => const ProfilScreen(),
      },
    );
  }
}