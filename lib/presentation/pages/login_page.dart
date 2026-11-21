import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../widgets/custom_button.dart';
import '../widgets/auth_text_field.dart';
import '../../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isOffline = false;
  bool _emailNotVerified = false;
  String? _errorMessage;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() {
      _errorMessage = null;
      _emailError = null;
      _passwordError = null;
      _isOffline = false;
      _emailNotVerified = false;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Validation des champs
    if (email.isEmpty) {
      setState(
        () => _emailError = 'Veuillez entrer votre e-mail universitaire',
      );
      return;
    }
    if (!email.contains('@')) {
      setState(() => _emailError = 'Format d’e-mail invalide');
      return;
    }
    if (password.isEmpty) {
      setState(() => _passwordError = 'Veuillez entrer votre mot de passe');
      return;
    }

    setState(() => _isLoading = true);

    final result = await AuthService.instance.login(
      email: email,
      password: password,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.isOffline) {
      setState(() => _isOffline = true);
      return;
    }

    if (result.isEmailNotVerified) {
      setState(() => _emailNotVerified = true);
      return;
    }

    if (!result.success) {
      setState(() => _errorMessage = result.message);
      return;
    }

    // Connexion réussie -> Catalogue
    Navigator.pushReplacementNamed(context, '/catalogue');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.beige,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo & Titre UniMarket
                Container(
                  height: 76,
                  width: 76,
                  decoration: BoxDecoration(
                    color: AppTheme.terracotta.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.storefront_rounded,
                    size: 40,
                    color: AppTheme.terracotta,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'UniMarket',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.brunFonce,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Connectez-vous avec votre compte étudiant',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.brunFonce.withValues(alpha: 0.75),
                  ),
                ),
                const SizedBox(height: 24),

                // État Offline (Figma login-offline)
                if (_isOffline)
                  _buildStatusBanner(
                    icon: Icons.wifi_off_rounded,
                    color: Colors.orange.shade800,
                    backgroundColor: Colors.orange.shade50,
                    message: 'Aucune connexion Internet. Vérifiez votre réseau et réessayez.',
                  ),

                // État Email Non Vérifié (Figma login-email non verifie)
                if (_emailNotVerified)
                  _buildStatusBanner(
                    icon: Icons.mark_email_unread_outlined,
                    color: AppTheme.terracotta,
                    backgroundColor: AppTheme.creme,
                    message: 'Votre e-mail n’est pas encore vérifié. Consultez votre boîte mail universitaire.',
                    actionLabel: 'Renvoyer',
                    onAction: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('E-mail de vérification renvoyé !'),
                        ),
                      );
                    },
                  ),

                // État Erreur (Figma login-error)
                if (_errorMessage != null)
                  _buildStatusBanner(
                    icon: Icons.error_outline_rounded,
                    color: Colors.red.shade800,
                    backgroundColor: Colors.red.shade50,
                    message: _errorMessage!,
                  ),

                // Champ Email
                AuthTextField(
                  label: 'Adresse e-mail universitaire',
                  hint: 'prenom.nom@ump.ac.ma',
                  controller: _emailController,
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  errorText: _emailError,
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 16),

                // Champ Mot de passe (avec icône œil)
                AuthTextField(
                  label: 'Mot de passe',
                  controller: _passwordController,
                  prefixIcon: Icons.lock_outline_rounded,
                  isPassword: true,
                  errorText: _passwordError,
                  enabled: !_isLoading,
                ),

                // Lien Mot de passe oublié
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _isLoading
                        ? null
                        : () =>
                              Navigator.pushNamed(context, '/forgot-password'),
                    child: const Text(
                      'Mot de passe oublié ?',
                      style: TextStyle(
                        color: AppTheme.terracotta,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Bouton Se connecter / État Loading (Figma LOGIN -loading)
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
                        text: 'Se connecter',
                        onPressed: _handleLogin,
                      ),
                const SizedBox(height: 24),

                // Lien vers Inscription
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Pas encore de compte ? ',
                      style: TextStyle(
                        color: AppTheme.brunFonce.withValues(alpha: 0.8),
                      ),
                    ),
                    GestureDetector(
                      onTap: _isLoading
                          ? null
                          : () => Navigator.pushNamed(context, '/inscription'),
                      child: const Text(
                        "S'inscrire",
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

  Widget _buildStatusBanner({
    required IconData icon,
    required Color color,
    required Color backgroundColor,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message, style: TextStyle(color: color, fontSize: 13)),
          ),
          if (actionLabel != null && onAction != null)
            TextButton(
              onPressed: onAction,
              child: Text(
                actionLabel,
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}
