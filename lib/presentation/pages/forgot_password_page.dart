
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/auth_text_field.dart';
import '../../services/auth_service.dart';

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
  State<ForgotPasswordSheet> createState() =>
      _ForgotPasswordSheetState();
}

class _ForgotPasswordSheetState extends State<ForgotPasswordSheet> {
  static const Color _background = Color(0xFFF8F1E8);
  static const Color _brown = Color(0xFF3E2922);
  static const Color _orange = Color(0xFFC98249);

  final TextEditingController _emailController =
      TextEditingController();

  String? _emailError;
  bool _isLoading = false;
  bool _formValidated = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (_isLoading) return;

    final email = _emailController.text.trim();

    final validEmail =
        RegExp(r'^[^@\s]+@ump\.ac\.ma$', caseSensitive: false)
            .hasMatch(email);

    setState(() {
      _emailError = validEmail
          ? null
          : 'Veuillez entrer une adresse e-mail universitaire valide';
      _formValidated = false;
    });

    if (!validEmail) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await AuthService.instance.resetPassword(email);

      if (!mounted) return;

      setState(() {
        _formValidated = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Lien de réinitialisation envoyé. Vérifiez votre boîte e-mail.',
          ),
          backgroundColor: _brown,
        ),
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('RESET PASSWORD ERROR: ${e.code} - ${e.message}');

      if (!mounted) return;

      String message;

      switch (e.code) {
        case 'user-not-found':
          message = 'Aucun compte associé à cette adresse e-mail.';
          break;
        case 'invalid-email':
          message = 'Adresse e-mail invalide.';
          break;
        case 'too-many-requests':
          message = 'Trop de tentatives. Réessayez plus tard.';
          break;
        case 'network-request-failed':
          message = 'Problème de connexion. Vérifiez votre réseau.';
          break;
        default:
          message = 'Erreur lors de l’envoi du lien. Réessayez.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: _brown,
        ),
      );
    } catch (e) {
      debugPrint('RESET PASSWORD ERROR: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Une erreur inattendue est survenue.'),
          backgroundColor: _brown,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 500),
      decoration: const BoxDecoration(
        color: _background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
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
                'Mot de passe oublié ?',
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
                'pour recevoir un lien de réinitialisation.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: _brown,
                ),
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
                  'Lien envoyé. Consultez votre boîte e-mail.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _brown,
                    fontSize: 12,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Center(
                child: SizedBox(
                  width: 205,
                  height: 46,
                  child: ElevatedButton(
                    onPressed:
                        _isLoading ? null : _handleResetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _orange,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _isLoading ? 'Envoi en cours...' : 'Envoyer le lien',
                      style: const TextStyle(
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
