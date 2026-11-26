import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  static const Color _background = Color(0xFFF5EBDD);
  static const Color _brown = Color(0xFF824C35);
  static const Color _darkBrown = Color(0xFF3E2922);
  static const Color _orange = Color(0xFFC98249);

  Widget _buildLogo() {
    return Column(
      children: [
        Image.asset(
          'assets/images/Frame.png',
          width: 110,
          height: 110,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 4),
        Image.asset(
          'assets/images/UniMarket.png',
          width: 145,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 4),
        Image.asset('assets/images/Place.png', width: 60, fit: BoxFit.contain),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Logo original UniMarket + Place
              _buildLogo(),

              const SizedBox(height: 25),

              // Description de l'application
              const Text(
                'Achetez et vendez vos fournitures, livres '
                'et équipements entre étudiants '
                'de votre université.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, height: 1.5, color: _darkBrown),
              ),

              const Spacer(flex: 3),

              // Bouton Se connecter
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/connexion');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _orange,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Se connecter',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Bouton Créer un compte
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/inscription');
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _brown,
                    side: const BorderSide(color: _brown, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Créer un compte',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
