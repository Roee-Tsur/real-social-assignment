import 'package:flutter/material.dart';

import 'sign_in_presenter.dart';
import 'sign_in_view.dart';
import 'sign_up_view_impl.dart';

class SignInScreen extends StatelessWidget implements SignInView {
  SignInScreen({super.key});
  final presenter = SignInPresenter();

  @override
  Widget build(BuildContext context) {
    presenter.view = this;
    return Scaffold(
      appBar: AppBar(
          shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(16)))),
      body: Center(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () => presenter.signInWithGoogleClicked,
                  child: const Text("Sign in with Google")),
              const Text("Or"),
              TextButton(
                  onPressed: (() => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      )),
                  child: const Text("Sign up"))
            ]),
      ),
    );
  }
}
