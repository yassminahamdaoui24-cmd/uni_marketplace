
import 'package:firebase_auth/firebase_auth.dart';

class AuthErrors {
  static String getMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Cette adresse email est déjà utilisée.';

      case 'invalid-email':
        return 'Adresse email invalide.';

      case 'weak-password':
        return 'Le mot de passe est trop faible.';

      case 'user-not-found':
        return 'Aucun compte trouvé avec cette adresse email.';

      case 'wrong-password':
        return 'Mot de passe incorrect.';

      case 'invalid-credential':
        return 'Email ou mot de passe incorrect.';

      case 'too-many-requests':
        return 'Trop de tentatives. Réessayez plus tard.';

      case 'network-request-failed':
        return 'Problème de connexion Internet.';

      default:
        return 'Une erreur est survenue. Veuillez réessayer.';
    }
  }
}
