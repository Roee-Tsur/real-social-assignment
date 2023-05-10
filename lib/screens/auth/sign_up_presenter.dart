import 'auth_model.dart';
import 'sign_up_view.dart';

class SignUpPresenter {
  late SignUpView view;
  late AuthModel model;

  SignUpPresenter() {
    model = AuthModel();
  }

  Future<void> signUpWithGoogleClicked() async {
    await model.signInWithGoogle();
  }
}
