
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'presentation/pages/login_page.dart';
import 'presentation/pages/catalogue_screen.dart';

class AuthGate extends StatelessWidget {
  AuthGate({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {

        // Chargement de l'etat d'authentification
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Utilisateur non connecte
        if (!snapshot.hasData) {
          return LoginPage();
        }

        // Utilisateur connecte
        final user = snapshot.data!;

        // Verification de l'email
        if (!user.emailVerified) {
          return const Scaffold(
            body: Center(
              child: Text(
                'Veuillez verifier votre adresse email.',
              ),
            ),
          );
        }

        // Utilisateur connecte et email verifie
        return CatalogueScreen();
      },
    );
  }
}
