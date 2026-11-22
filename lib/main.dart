import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app_theme.dart';
import 'firebase_options.dart';

import 'presentation/pages/welcome_page.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/register_page.dart';
import 'presentation/pages/forgot_password_page.dart';

import 'presentation/pages/bienvenue_screen.dart';
import 'presentation/pages/connexion_screen.dart';
import 'presentation/pages/inscription_screen.dart';
import 'presentation/pages/catalogue_screen.dart';
import 'presentation/pages/detail_annonce_screen.dart';
import 'presentation/pages/publication_screen.dart';
import 'presentation/pages/mes_annonces_screen.dart';
import 'presentation/pages/favoris_screen.dart';
import 'presentation/pages/profil_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        '/bienvenue': (context) => const WelcomePage(),
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
