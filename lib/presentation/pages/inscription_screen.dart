import 'package:flutter/material.dart';

class InscriptionScreen extends StatelessWidget {
  const InscriptionScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inscription')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Écran Inscription (Public)',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/catalogue'),
              child: const Text("S'inscrire (Démo -> Catalogue)"),
            ),
          ],
        ),
      ),
    );
  }
}
