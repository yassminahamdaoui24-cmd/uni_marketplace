import 'package:flutter/material.dart';

import '../../app_theme.dart';

class EmailVerificationPage extends StatefulWidget {
  final String? email;

  const EmailVerificationPage({super.key, this.email});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  bool _isResending = false;

  Future<void> _resendEmail() async {
    setState(() => _isResending = true);

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() => _isResending = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Un nouvel e-mail de vérification a été envoyé.'),
        backgroundColor: AppTheme.terracotta,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeEmail = ModalRoute.of(context)?.settings.arguments as String?;
    final displayEmail = widget.email ?? routeEmail ?? 'votre adresse e-mail';

    return Scaffold(
      backgroundColor: AppTheme.beige,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.brunFonce),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              const Spacer(flex: 2),

              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppTheme.terracotta.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_unread_rounded,
                  size: 48,
                  color: AppTheme.terracotta,
                ),
              ),
              const SizedBox(height: 28),

              const Text(
                'Vérifiez votre boîte e-mail',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.brunFonce,
                ),
              ),
              const SizedBox(height: 14),

              Text(
                'Nous avons envoyé un lien de confirmation à :',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: AppTheme.brunFonce.withOpacity(0.75),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                displayEmail,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.brunFonce,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Cliquez sur le lien dans votre e-mail pour activer votre compte avant d’accéder aux annonces.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: AppTheme.brunFonce.withOpacity(0.7),
                ),
              ),

              const Spacer(flex: 3),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/connexion',
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.terracotta,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'J’ai vérifié, me connecter',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: _isResending ? null : _resendEmail,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.terracotta,
                    side: const BorderSide(
                      color: AppTheme.terracotta,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isResending
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppTheme.terracotta,
                          ),
                        )
                      : const Text(
                          'Renvoyer l’e-mail',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/inscription');
                },
                child: Text(
                  'Utiliser une autre adresse e-mail',
                  style: TextStyle(
                    color: AppTheme.brunFonce.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
