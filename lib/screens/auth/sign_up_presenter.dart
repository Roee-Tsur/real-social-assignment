import 'auth_model.dart';
import 'sign_up_view.dart';

class SignUpPresenter {
  late SignUpView view;
  late AuthModel _model;

  SignUpPresenter() {
    _model = AuthModel();
  }

  Future<bool> signUpWithGoogleClicked() async {
    return _model.signInWithGoogle();
  }

  Future<bool> signUpWithEmailClicked(
      {required String email, required String password}) {
    return _model.signUpWithEmail(email: email, password: password);
  }
}
