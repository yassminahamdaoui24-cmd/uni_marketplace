
import 'package:flutter/material.dart';

import '../widgets/auth_text_field.dart';
import '../../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  static const Color _background = Color(0xFFF5EBDD);
  static const Color _brown = Color(0xFF824C35);
  static const Color _orange = Color(0xFFC98249);

  final _nameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  String? _nameError;
  String? _firstNameError;
  String? _phoneError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _nameController.dispose();
    _firstNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_isLoading) return;

    final name = _nameController.text.trim();
    final firstName = _firstNameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmation = _confirmPasswordController.text;

    setState(() {
      _nameError = name.isEmpty
          ? 'Veuillez entrer votre nom'
          : null;

      _firstNameError = firstName.isEmpty
          ? 'Veuillez entrer votre prénom'
          : null;

      _phoneError = phone.isEmpty
          ? 'Veuillez entrer votre téléphone'
          : null;

      _emailError =
          !RegExp(r'^[^@\s]+@ump\.ac\.ma$',
                  caseSensitive: false)
              .hasMatch(email)
          ? 'Veuillez utiliser votre adresse e-mail universitaire UMP'
          : null;

      _passwordError = password.length < 6
          ? 'Le mot de passe doit contenir au moins 6 caractères'
          : null;

      if (confirmation.isEmpty) {
        _confirmPasswordError =
            'Veuillez confirmer votre mot de passe';
      } else if (password != confirmation) {
        _confirmPasswordError =
            'Les mots de passe ne correspondent pas';
      } else {
        _confirmPasswordError = null;
      }
    });

    if (_nameError != null ||
        _firstNameError != null ||
        _phoneError != null ||
        _emailError != null ||
        _passwordError != null ||
        _confirmPasswordError != null) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final credential =
          await AuthService.instance.verifierEmail(
        nom: name,
        prenom: firstName,
        email: email,
        telephone: phone,
        password: password,
      );

      if (!mounted) return;

      if (credential != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Compte créé ! Vérifiez votre boîte mail universitaire.',
            ),
          ),
        );

        Navigator.pushReplacementNamed(
           context,
           '/verification-email',
           arguments: email.trim(),
);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Échec de la création du compte. '
              'Vérifiez votre adresse e-mail et réessayez.',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Une erreur est survenue : $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? error,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
  }) {
    return AuthTextField(
      figmaStyle: true,
      label: label,
      controller: controller,
      prefixIcon: icon,
      keyboardType: keyboardType,
      isPassword: isPassword,
      errorText: error,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: _brown),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
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
                      Image.asset(
                        'assets/images/Place.png',
                        width: 46,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    'Créez votre compte',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _brown,
                    ),
                  ),

                  const SizedBox(height: 26),

                  _buildField(
                    label: 'Votre Nom',
                    controller: _nameController,
                    icon: Icons.person_outline,
                    error: _nameError,
                  ),

                  const SizedBox(height: 9),

                  _buildField(
                    label: 'Votre Prénom',
                    controller: _firstNameController,
                    icon: Icons.person_outline,
                    error: _firstNameError,
                  ),

                  const SizedBox(height: 9),

                  _buildField(
                    label: 'Votre Téléphone',
                    controller: _phoneController,
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    error: _phoneError,
                  ),

                  const SizedBox(height: 9),

                  _buildField(
                    label: 'Adresse e-mail universitaire',
                    controller: _emailController,
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    error: _emailError,
                  ),

                  const SizedBox(height: 9),

                  _buildField(
                    label: 'Mot de passe',
                    controller: _passwordController,
                    icon: Icons.lock_outline,
                    isPassword: true,
                    error: _passwordError,
                  ),

                  const SizedBox(height: 9),

                  _buildField(
                    label: 'Confirmer le mot de passe',
                    controller: _confirmPasswordController,
                    icon: Icons.lock_outline,
                    isPassword: true,
                    error: _confirmPasswordError,
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: SizedBox(
                      width: 205,
                      height: 46,
                      child: ElevatedButton(
                        onPressed:
                            _isLoading ? null : _handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _orange,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: _orange,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                "S'inscrire",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Déjà un compte ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: _brown,
                    ),
                  ),

                  Center(
                    child: TextButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              Navigator.pushReplacementNamed(
                                context,
                                '/connexion',
                              );
                            },
                      child: const Text(
                        'Se connecter',
                        style: TextStyle(
                          color: _orange,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
