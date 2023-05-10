import 'package:flutter/material.dart';

import 'sign_up_presenter.dart';
import 'sign_up_view.dart';

class SignUpScreen extends StatelessWidget implements SignUpView {
  SignUpScreen({super.key});
  final presenter = SignUpPresenter();

  @override
  Widget build(BuildContext context) {
    presenter.view = this;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () => presenter
                      .signUpWithGoogleClicked()
                      .then((value) => Navigator.pop(context)),
                  child: const Text("Sign up with Google")),
              const Text("Or"),
            ]),
      ),
    );
  }
}
