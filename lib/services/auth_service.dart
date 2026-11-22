
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_errors.dart';

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

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool get isAuthenticated =>
      _auth.currentUser != null && _auth.currentUser!.emailVerified;

  bool get isEmailVerified =>
      _auth.currentUser?.emailVerified ?? false;

  String? get currentUserEmail => _auth.currentUser?.email;

  bool _isAllowedEmail(String email) {
    return email.trim().toLowerCase().endsWith('@ump.ac.ma');
  }

  AuthResult _handleError(FirebaseAuthException e) {
    return AuthResult(
      success: false,
      message: AuthErrors.getMessage(e),
      isOffline: e.code == 'network-request-failed',
    );
  }

  // Inscription
  Future<AuthResult> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();

    if (!_isAllowedEmail(normalizedEmail)) {
      return const AuthResult(
        success: false,
        message: 'Seules les adresses email @ump.ac.ma sont autorisées.',
      );
    }

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        return const AuthResult(
          success: false,
          message: 'Impossible de créer le compte.',
        );
      }

      await user.updateDisplayName(fullName.trim());
      await user.sendEmailVerification();

      return const AuthResult(
        success: true,
        message: 'Compte créé ! Vérifiez votre boîte mail universitaire.',
        isEmailVerified: false,
      );
    } on FirebaseAuthException catch (e) {
      return _handleError(e);
    }
  }

  // Connexion
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      await credential.user?.reload();

      final user = _auth.currentUser;

      if (user == null) {
        return const AuthResult(
          success: false,
          message: 'Impossible de récupérer votre compte.',
        );
      }

      if (!user.emailVerified) {
        return const AuthResult(
          success: false,
          message: 'Votre e-mail n’est pas encore vérifié. Consultez votre boîte mail universitaire.',
          isEmailNotVerified: true,
        );
      }

      return const AuthResult(
        success: true,
        message: 'Connexion réussie.',
        isEmailVerified: true,
      );
    } on FirebaseAuthException catch (e) {
      return _handleError(e);
    }
  }

  // Réinitialisation du mot de passe
  Future<AuthResult> resetPassword({
    required String email,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: email.trim(),
      );

      return const AuthResult(
        success: true,
        message: 'Un lien de réinitialisation a été envoyé.',
      );
    } on FirebaseAuthException catch (e) {
      return _handleError(e);
    }
  }

  // Renvoi de l'e-mail de vérification
  Future<AuthResult> resendVerificationEmail({
    required String email,
  }) async {
    try {
      final user = _auth.currentUser;

      if (user == null ||
          user.email?.toLowerCase() != email.trim().toLowerCase()) {
        return const AuthResult(
          success: false,
          message: 'Veuillez vous reconnecter pour renvoyer l’e-mail de vérification.',
        );
      }

      await user.reload();

      final currentUser = _auth.currentUser;

      if (currentUser == null) {
        return const AuthResult(
          success: false,
          message: 'Compte introuvable.',
        );
      }

      if (currentUser.emailVerified) {
        return const AuthResult(
          success: true,
          message: 'Votre adresse e-mail est déjà vérifiée.',
          isEmailVerified: true,
        );
      }

      await currentUser.sendEmailVerification();

      return const AuthResult(
        success: true,
        message: 'Un nouvel e-mail de vérification a été envoyé.',
      );
    } on FirebaseAuthException catch (e) {
      return _handleError(e);
    }
  }

  // Déconnexion
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Méthodes conservées pour compatibilité avec l'ancienne version
  Future<UserCredential?> verifier_email(
    String email,
    String password,
  ) async {
    if (!_isAllowedEmail(email)) {
      print('Adresse email non autorisée');
      return null;
    }

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      await credential.user?.sendEmailVerification();
      return credential;
    } on FirebaseAuthException catch (e) {
      print(AuthErrors.getMessage(e));
      return null;
    }
  }

  Future<UserCredential?> signIn(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      await credential.user?.reload();

      if (_auth.currentUser?.emailVerified == true) {
        return credential;
      }

      return null;
    } on FirebaseAuthException catch (e) {
      print(AuthErrors.getMessage(e));
      return null;
    }
  }

  Future<void> signOut() async {
    await logout();
  }
}
