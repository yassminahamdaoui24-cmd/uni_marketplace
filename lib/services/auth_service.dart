class AuthResult {
  final bool success;
  final String message;
  final bool isEmailVerified;
  final bool isEmailNotVerified;
  final bool isOffline;

  const AuthResult({
    required this.success,
    required this.message,
    this.isEmailVerified = false,
    this.isEmailNotVerified = false,
    this.isOffline = false,
  });
}

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  bool _isAuthenticated = false;
  bool _isEmailVerified = false;
  String? _currentUserEmail;

  bool get isAuthenticated => _isAuthenticated;
  bool get isEmailVerified => _isEmailVerified;
  String? get currentUserEmail => _currentUserEmail;

  /// Inscription d'un nouvel étudiant
  Future<AuthResult> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    // TODO(Rihab): Remplacer par l'appel réel au Backend Auth
    await Future.delayed(const Duration(seconds: 1));

    _isAuthenticated = false;
    _isEmailVerified = false;
    _currentUserEmail = email.trim();

    return const AuthResult(
      success: true,
      message: 'Compte créé ! Vérifiez votre boîte mail universitaire.',
      isEmailVerified: false,
    );
  }

  /// Connexion avec e-mail et mot de passe
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    // TODO(Rihab): Remplacer par l'appel réel au Backend Auth
    await Future.delayed(const Duration(seconds: 1));

    final normalizedEmail = email.trim().toLowerCase();

    // Cas de test : hors ligne
    if (normalizedEmail == 'offline@ump.ac.ma') {
      return const AuthResult(
        success: false,
        message:
            'Aucune connexion Internet. Vérifiez votre réseau et réessayez.',
        isOffline: true,
      );
    }

    // Cas de test : e-mail non vérifié
    if (normalizedEmail == 'unverified@ump.ac.ma') {
      _isAuthenticated = false;
      _isEmailVerified = false;
      return const AuthResult(
        success: false,
        message: 'Votre e-mail n’est pas encore vérifié. Consultez votre boîte mail universitaire.',
        isEmailNotVerified: true,
      );
    }

    // Cas de test : identifiants incorrects
    if (password == '1234') {
      return const AuthResult(
        success: false,
        message: 'E-mail ou mot de passe incorrect.',
      );
    }

    _isAuthenticated = true;
    _isEmailVerified = true;
    _currentUserEmail = email.trim();

    return const AuthResult(
      success: true,
      message: 'Connexion réussie.',
      isEmailVerified: true,
    );
  }

  /// Réinitialisation du mot de passe
  Future<AuthResult> resetPassword({required String email}) async {
    // TODO(Rihab): Remplacer par l'appel réel au Backend Auth
    await Future.delayed(const Duration(seconds: 1));

    return AuthResult(
      success: true,
      message: 'Un lien de réinitialisation a été envoyé à ${email.trim()}.',
    );
  }

  /// Renvoi de l'e-mail de vérification
  Future<AuthResult> resendVerificationEmail({required String email}) async {
    // TODO(Rihab): Remplacer par l'appel réel au Backend Auth
    await Future.delayed(const Duration(seconds: 1));

    return const AuthResult(
      success: true,
      message: 'Un nouvel e-mail de vérification a été envoyé.',
    );
  }

  /// Déconnexion
  Future<void> logout() async {
    // TODO(Rihab): Remplacer par l'appel réel au Backend Auth
    await Future.delayed(const Duration(milliseconds: 300));
    _isAuthenticated = false;
    _isEmailVerified = false;
    _currentUserEmail = null;
  }
}
