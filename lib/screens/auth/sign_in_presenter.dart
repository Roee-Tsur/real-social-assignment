import 'package:real_social_assignment/screens/auth/sign_in_view.dart';

import 'auth_model.dart';

class SignInPresenter {
  late SignInView view;
  late AuthModel model;

  SignInPresenter() {
    model = AuthModel();
  }

  Future<void> signInWithGoogleClicked() async {
    await model.signInWithGoogle();
  }
}
