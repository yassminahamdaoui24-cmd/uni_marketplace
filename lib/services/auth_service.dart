
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  AuthService();

  static final AuthService instance = AuthService();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Vérification du domaine universitaire
  bool _isAllowedEmail(String email) {
    return email.trim().toLowerCase().endsWith('@ump.ac.ma');
  }

  // Inscription
  Future<UserCredential?> verifierEmail({
    required String nom,
    required String prenom,
    required String email,
    required String telephone,
    required String password,
  }) async {
    if (!_isAllowedEmail(email)) {
      print('Adresse email non autorisée');
      return null;
    }

    try {
      // 1. Création du compte Firebase Authentication
      final credential = await _auth.createUserWithEmailAndPassword(
         email: email.trim().toLowerCase(),
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        return null;
      }

      // 2. Création du profil dans Firestore
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'uid': user.uid,
          'nom': nom.trim(),
          'prenom': prenom.trim(),
          'email': email.trim().toLowerCase(),
          'telephone': telephone.trim(),
          'role': 'etudiant',
          'estSuspendu': false,
          'dateInscription': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        print('Erreur lors de la sauvegarde du profil : $e');

        try {
          await user.delete();
        } catch (deleteError) {
          print('Erreur lors de la suppression du compte : $deleteError');
        }

        return null;
      }

      // 3. Envoi de l'email de vérification
      await user.sendEmailVerification();

      return credential;

    } on FirebaseAuthException catch (e) {
      print(AuthErrors.getMessage(e));
      return null;
    }
  }

  // Connexion utilisée par le Frontend de Douae
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
        await _auth.signOut();

        return const AuthResult(
          success: false,
          message: 'Votre e-mail n’est pas encore vérifié.',
          isEmailNotVerified: true,
        );
      }

      return const AuthResult(
        success: true,
        message: 'Connexion réussie.',
        isEmailVerified: true,
      );

    } on FirebaseAuthException catch (e) {
      return AuthResult(
        success: false,
        message: AuthErrors.getMessage(e),
        isOffline: e.code == 'network-request-failed',
      );
    }
  }

  // Ancienne méthode de connexion conservée
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

      await _auth.signOut();
      return null;

    } on FirebaseAuthException catch (e) {
      print(AuthErrors.getMessage(e));
      return null;
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Vérification de l'email
  Future<bool> checkEmailVerified() async {
    final user = _auth.currentUser;

    if (user == null) {
      return false;
    }

    await user.reload();

    return _auth.currentUser?.emailVerified ?? false;
  }

  // Renvoi de l'email de vérification
  Future<void> resendVerificationEmail() async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    await user.reload();

    final currentUser = _auth.currentUser;

    if (currentUser != null && !currentUser.emailVerified) {
      await currentUser.sendEmailVerification();
    }
  }

  // Réinitialisation du mot de passe
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(
      email: email.trim(),
    );
  } 
}
