import 'package:flutter/material.dart';

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
