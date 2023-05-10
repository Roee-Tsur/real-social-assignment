import 'package:real_social_assignment/services/auth.dart';

class AuthModel {
  Future<bool> signInWithGoogle() {
    return AuthService().signInWithGoogle();
  }

  Future<bool> signInWithEmail({required String email, required String password}) {
    return AuthService().signInWithEmail(email: email, password: password);
  }

  Future<bool> signUpWithEmail({required String email, required String password}) {
    return AuthService().signUpWithEmail(email: email, password: password);
  }
}
