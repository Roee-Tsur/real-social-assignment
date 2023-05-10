import 'package:real_social_assignment/services/auth.dart';

class AuthModel {
  Future<void> signInWithGoogle() {
    return AuthService().signInWithGoogle();
  }
}
