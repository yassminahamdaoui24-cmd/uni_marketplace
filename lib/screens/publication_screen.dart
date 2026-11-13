import 'package:flutter/material.dart';

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
