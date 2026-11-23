import 'package:flutter/material.dart';

import '../widgets/auth_text_field.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF5EBDD),
      body: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ForgotPasswordSheet(),
        ),
      ),
    );
  }
}

class ForgotPasswordSheet extends StatefulWidget {
  const ForgotPasswordSheet({super.key});

  @override
  State<ForgotPasswordSheet> createState() => _ForgotPasswordSheetState();
}

class _ForgotPasswordSheetState extends State<ForgotPasswordSheet> {
  static const Color _background = Color(0xFFF8F1E8);
  static const Color _brown = Color(0xFF3E2922);
  static const Color _orange = Color(0xFFC98249);

  final TextEditingController _emailController = TextEditingController();

  String? _emailError;
  bool _formValidated = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleResetPassword() {
    final email = _emailController.text.trim();

    final validEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);

    setState(() {
      _emailError = validEmail
          ? null
          : 'Veuillez entrer une adresse e-mail valide';

      _formValidated = validEmail;
    });

    if (!validEmail) return;

    // FRONTEND UNIQUEMENT
    // Rihab connectera resetPassword(email) au Backend.
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 500),
      decoration: const BoxDecoration(
        color: _background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D0C5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Mot de passe oubli\u00E9 ?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: _brown,
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                'Entrez votre adresse e-mail universitaire '
                'pour recevoir un lien de r\u00E9initialisation.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, height: 1.5, color: _brown),
              ),

              const SizedBox(height: 25),

              AuthTextField(
                figmaStyle: true,
                label: 'Adresse e-mail universitaire',
                controller: _emailController,
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                errorText: _emailError,
              ),

              if (_formValidated) ...[
                const SizedBox(height: 12),
                const Text(
                  'Adresse e-mail valide. '
                  'Envoi du lien en attente de connexion au Backend.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _brown, fontSize: 12),
                ),
              ],

              const SizedBox(height: 24),

              Center(
                child: SizedBox(
                  width: 205,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: _handleResetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _orange,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Envoyer le lien',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
