import 'package:flutter/material.dart';

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
