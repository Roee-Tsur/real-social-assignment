import 'package:real_social_assignment/screens/auth/sign_in_view.dart';

import 'auth_model.dart';

class SignInPresenter {
  late SignInView view;
  late AuthModel _model;

  SignInPresenter() {
    _model = AuthModel();
  }

  Future<void> signInWithGoogleClicked() async {
    await _model.signInWithGoogle();
  }

  void signInWithEmailClicked(
      {required String email, required String password}) {
    _model.signInWithEmail(email: email, password: password);
  }
}
