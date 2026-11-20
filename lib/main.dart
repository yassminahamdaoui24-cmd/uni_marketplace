import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/register_page.dart';
import 'presentation/pages/forgot_password_page.dart';

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
        '/connexion': (context) => const LoginPage(),
        '/inscription': (context) => const RegisterPage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/catalogue': (context) => const CatalogueScreen(),
        '/detail': (context) => const DetailAnnonceScreen(),
        '/publication': (context) => const PublicationScreen(),
        '/mes-annonces': (context) => const MesAnnoncesScreen(),
        '/favoris': (context) => const FavorisScreen(),
        '/profil': (context) => const ProfilScreen(),
      },
    );
  }
}

class BienvenueScreen extends StatelessWidget {
  const BienvenueScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bienvenue')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Écran Bienvenue (Public)',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/connexion'),
              child: const Text('Aller vers Connexion'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/inscription'),
              child: const Text('Aller vers Inscription'),
            ),
          ],
        ),
      ),
    );
  }
}

class CatalogueScreen extends StatelessWidget {
  const CatalogueScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catalogue')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Écran Catalogue (Privé)',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/detail'),
              child: const Text("Détail d'annonce"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/publication'),
              child: const Text('Publier une annonce'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/mes-annonces'),
              child: const Text('Mes annonces'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/favoris'),
              child: const Text('Favoris'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/profil'),
              child: const Text('Profil'),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailAnnonceScreen extends StatelessWidget {
  const DetailAnnonceScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Détail d'annonce")),
      body: const Center(
        child: Text("Écran Détail d'annonce", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}

class PublicationScreen extends StatelessWidget {
  const PublicationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Publication')),
      body: const Center(
        child: Text(
          'Écran Publication (Privé)',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

class MesAnnoncesScreen extends StatelessWidget {
  const MesAnnoncesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes annonces')),
      body: const Center(
        child: Text(
          'Écran Mes annonces (Privé)',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

class FavorisScreen extends StatelessWidget {
  const FavorisScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favoris')),
      body: const Center(
        child: Text('Écran Favoris (Privé)', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Écran Profil (Privé)', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                '/bienvenue',
                (route) => false,
              ),
              child: const Text('Se déconnecter'),
            ),
          ],
        ),
      ),
    );
  }
}
