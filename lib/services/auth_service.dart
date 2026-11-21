import 'package:firebase_auth/firebase_auth.dart';
import 'auth_errors.dart';
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
Future<UserCredential?> verifier_email(
    String email, String password) async {

  if (email.endsWith("@ump.ac.ma")) {

    final c = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return c;
  } else {
    print("Adresse email non autorisée");
    return null;
  }
}

Future<UserCredential?> signIn(String email, String password) async {
  try {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;

    if (user != null && user.emailVerified) {
      return credential;
    }

    await _auth.signOut();
    return null;

  } on FirebaseAuthException catch (e) {
    print(AuthErrors.getMessage(e));
    return null;
  }
}
Future<void> signOut() async {
  await _auth.signOut();
}
}
