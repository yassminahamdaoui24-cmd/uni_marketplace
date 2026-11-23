import 'package:flutter/material.dart';

class EmailVerificationPage extends StatefulWidget {
  final String? email;

  const EmailVerificationPage({super.key, this.email});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  static const Color _background = Color(0xFFF5EBDD);
  static const Color _brown = Color(0xFF824C35);
  static const Color _darkBrown = Color(0xFF3E2922);
  static const Color _orange = Color(0xFFC98249);

  String get _displayEmail {
    final arguments = ModalRoute.of(context)?.settings.arguments;

    String? routeEmail;
    if (arguments is String) {
      routeEmail = arguments;
    }

    final email = widget.email ?? routeEmail;

    if (email == null || email.trim().isEmpty) {
      return 'votre adresse e-mail universitaire';
    }

    return email.trim();
  }

  void _handleResendEmail() {
    // FRONTEND UNIQUEMENT
    // Rihab connectera resendVerificationEmail()
    // au Backend.

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Le renvoi de l'e-mail sera disponible "
          "apres la connexion au Backend.",
        ),
        backgroundColor: _brown,
      ),
    );
  }

  void _handleVerified() {
    // FRONTEND UNIQUEMENT
    // Rihab connectera checkEmailVerified().
    // Ici, le bouton retourne uniquement vers Connexion.

    Navigator.pushNamedAndRemoveUntil(context, '/connexion', (route) => false);
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Image.asset(
          'assets/images/Frame.png',
          width: 84,
          height: 83,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 2),
        Image.asset(
          'assets/images/UniMarket.png',
          width: 110,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 2),
        Image.asset('assets/images/Place.png', width: 46, fit: BoxFit.contain),
      ],
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    bool outlined = false,
  }) {
    return SizedBox(
      width: 240,
      height: 48,
      child: outlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: _orange,
                side: const BorderSide(color: _orange, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: _orange,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: _brown),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildLogo(),

                  const SizedBox(height: 42),

                  Container(
                    width: 78,
                    height: 78,
                    decoration: BoxDecoration(
                      color: _orange.withValues(alpha: 0.13),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.mark_email_unread_rounded,
                      color: _brown,
                      size: 38,
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    'V\u00e9rifiez votre bo\u00eete e-mail',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _brown,
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Consultez votre adresse e-mail '
                    'universitaire pour v\u00e9rifier '
                    'votre compte.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: _darkBrown,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    _displayEmail,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _brown,
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'Cliquez sur le lien de confirmation '
                    'dans votre e-mail pour activer '
                    'votre compte avant de vous connecter.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: _darkBrown,
                    ),
                  ),

                  const SizedBox(height: 45),

                  _buildButton(
                    text: "J'ai v\u00e9rifi\u00e9",
                    onPressed: _handleVerified,
                  ),

                  const SizedBox(height: 14),

                  _buildButton(
                    text: "Renvoyer l'e-mail",
                    onPressed: _handleResendEmail,
                    outlined: true,
                  ),

                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/inscription');
                    },
                    child: const Text(
                      'Utiliser une autre adresse e-mail',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: _brown,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
