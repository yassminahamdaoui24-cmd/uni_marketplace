import 'package:flutter/material.dart';

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

