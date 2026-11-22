import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../widgets/custom_button.dart';
import '../widgets/auth_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    setState(() {
      _nameError = null;
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty) {
      setState(() => _nameError = 'Veuillez entrer votre nom complet');
      return;
    }
    if (email.isEmpty || !email.contains('@')) {
      setState(
        () => _emailError = 'Veuillez entrer un e-mail universitaire valide',
      );
      return;
    }
    if (password.length < 6) {
      setState(
        () => _passwordError =
            'Le mot de passe doit contenir au moins 6 caractères',
      );
      return;
    }
    if (password != confirmPassword) {
      setState(
        () => _confirmPasswordError = 'Les mots de passe ne correspondent pas',
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulation création de compte (en attendant Firebase Auth)
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Compte créé ! Vérifiez votre boîte mail universitaire pour activer votre compte.',
        ),
      ),
    );
    Navigator.pushReplacementNamed(context, '/connexion');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.beige,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.brunFonce),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Créer un compte',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.brunFonce,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Rejoignez la communauté étudiante UniMarket',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.brunFonce.withValues(alpha: 0.75),
                  ),
                ),
                const SizedBox(height: 24),

                // Nom complet
                AuthTextField(
                  label: 'Nom complet',
                  hint: 'Ex: Douae El Amrani',
                  controller: _nameController,
                  prefixIcon: Icons.person_outline_rounded,
                  errorText: _nameError,
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 14),

                // Email universitaire
                AuthTextField(
                  label: 'Adresse e-mail universitaire',
                  hint: 'prenom.nom@ump.ac.ma',
                  controller: _emailController,
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  errorText: _emailError,
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 14),

                // Mot de passe
                AuthTextField(
                  label: 'Mot de passe',
                  controller: _passwordController,
                  prefixIcon: Icons.lock_outline_rounded,
                  isPassword: true,
                  errorText: _passwordError,
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 14),

                // Confirmation mot de passe
                AuthTextField(
                  label: 'Confirmer le mot de passe',
                  controller: _confirmPasswordController,
                  prefixIcon: Icons.lock_reset_rounded,
                  isPassword: true,
                  errorText: _confirmPasswordError,
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 24),

                // Bouton S'inscrire
                _isLoading
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.terracotta,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: null,
                        child: const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppTheme.creme,
                          ),
                        ),
                      )
                    : CustomButton(
                        text: "S'inscrire",
                        onPressed: _handleRegister,
                      ),
                const SizedBox(height: 20),

                // Lien vers Connexion
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Déjà un compte ? ',
                      style: TextStyle(
                        color: AppTheme.brunFonce.withValues(alpha: 0.8),
                      ),
                    ),
                    GestureDetector(
                      onTap: _isLoading
                          ? null
                          : () => Navigator.pushReplacementNamed(
                              context,
                              '/connexion',
                            ),
                      child: const Text(
                        'Se connecter',
                        style: TextStyle(
                          color: AppTheme.terracotta,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
