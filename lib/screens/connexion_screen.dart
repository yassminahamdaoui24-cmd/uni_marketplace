import 'package:flutter/material.dart';

class ConnexionScreen extends StatelessWidget {
  const ConnexionScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Écran Connexion (Public)',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/catalogue'),
              child: const Text('Se connecter (Démo -> Catalogue)'),
            ),
          ],
        ),
      ),
    );
  }
}
