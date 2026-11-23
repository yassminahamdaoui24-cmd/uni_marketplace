import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../widgets/auth_text_field.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const Color _background = Color(0xFFF5EBDD);
  static const Color _brown = Color(0xFF824C35);
  static const Color _orange = Color(0xFFC98249);

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

    // Validation Frontend
    if (email.isEmpty) {
      setState(() {
        _emailError = 'Veuillez entrer votre e-mail universitaire';
      });
      return;
    }

    if (!email.contains('@')) {
      setState(() {
        _emailError = "Format d'e-mail invalide";
      });
      return;
    }

    if (password.isEmpty) {
      setState(() {
        _passwordError = 'Veuillez entrer votre mot de passe';
      });
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

    Navigator.pushReplacementNamed(context, '/catalogue');
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

  Widget _buildStatusBanner({
    required IconData icon,
    required Color color,
    required Color backgroundColor,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: color, fontSize: 12),
                ),
              ),
            ],
          ),
          if (actionLabel != null && onAction != null)
            TextButton(
              onPressed: onAction,
              child: Text(
                actionLabel,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final topSpace = (constraints.maxHeight * 0.07).clamp(20.0, 60.0);
            final buttonSpace = (constraints.maxHeight * 0.07).clamp(
              28.0,
              64.0,
            );
            final signupSpace = (constraints.maxHeight * 0.07).clamp(
              30.0,
              68.0,
            );

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: topSpace),

                      _buildLogo(),

                      const SizedBox(height: 32),

                      const Text(
                        'Connectez-vous',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _brown,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Etat Offline
                      if (_isOffline)
                        _buildStatusBanner(
                          icon: Icons.wifi_off_rounded,
                          color: Colors.red.shade700,
                          backgroundColor: Colors.red.shade50,
                          message: 'Pas de connexion Internet.\nVérifiez votre connexion et réessayez.',
                        ),

                      if (_emailNotVerified)
                        Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEDB8),
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(
                              color: const Color(0xFFE4A13C),
                              width: 1.2,
                            ),
                          ),
                          child: Column(
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.warning_amber_rounded,
                                    color: Color(0xFFD9534F),
                                    size: 21,
                                  ),
                                  SizedBox(width: 7),
                                  Text(
                                    'Email non vérifié',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF3E2922),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Veuillez vérifier votre adresse e-mail\nuniversitaire.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  height: 1.4,
                                  color: Color(0xFF824C35),
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextButton(
                                onPressed: () {
                                  // Rihab connectera le renvoi au Backend.
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Renvoi de l'e-mail en attente du Backend.",
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Renvoyer l'email",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF824C35),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      if (_errorMessage != null)
                        _buildStatusBanner(
                          icon: Icons.error_outline_rounded,
                          color: Colors.red.shade700,
                          backgroundColor: Colors.red.shade50,
                          message: _errorMessage!,
                        ),

                      AuthTextField(
                        figmaStyle: true,
                        label: 'Adresse e-mail universitaire',
                        controller: _emailController,
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        errorText: _emailError,
                        enabled: !_isLoading,
                      ),

                      const SizedBox(height: 12),

                      AuthTextField(
                        figmaStyle: true,
                        label: 'Mot de passe',
                        controller: _passwordController,
                        prefixIcon: Icons.lock_outline_rounded,
                        isPassword: true,
                        errorText: _passwordError,
                        enabled: !_isLoading,
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    barrierColor: Colors.black.withValues(
                                      alpha: 0.35,
                                    ),
                                    builder: (sheetContext) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          bottom: MediaQuery.viewInsetsOf(
                                            sheetContext,
                                          ).bottom,
                                        ),
                                        child: const ForgotPasswordSheet(),
                                      );
                                    },
                                  );
                                },
                          child: const Text(
                            'Mot de passe oubli\u00E9 ?',
                            style: TextStyle(
                              color: _orange,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: buttonSpace),

                      // Bouton Connexion + Loading
                      Center(
                        child: SizedBox(
                          width: 205,
                          height: 46,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _orange,
                              disabledBackgroundColor: _orange,
                              foregroundColor: Colors.white,
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
                                    'Se connecter',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      SizedBox(height: signupSpace),

                      // Navigation Inscription
                      const Text(
                        'Pas encore de compte ?',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: _brown),
                      ),

                      const SizedBox(height: 2),

                      Center(
                        child: TextButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  Navigator.pushNamed(context, '/inscription');
                                },
                          child: const Text(
                            "S'inscrire",
                            style: TextStyle(
                              color: _orange,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
