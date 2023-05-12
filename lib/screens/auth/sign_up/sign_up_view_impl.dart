import 'package:flutter/material.dart';
import 'package:real_social_assignment/utils/design.dart';

import '../../../utils/valodators.dart';
import '../../../widgets/rs_text_field.dart';
import 'sign_up_presenter.dart';
import 'sign_up_view.dart';

class SignUpScreen extends StatelessWidget implements SignUpView {
  SignUpScreen({super.key});
  final presenter = SignUpPresenter();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    presenter.view = this;
    return Scaffold(
      appBar: AppBar(
        shape: appBarShape,
      ),
      body: Center(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () => presenter
                      .signUpWithGoogleClicked()
                      .then((value) => value ? Navigator.pop(context) : null),
                  child: const Text("Sign up with Google")),
              const Text("Or"),
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: formKey,
                  child: Column(
                    children: [
                      RSTextField(
                        label: "Email",
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        validator: emailValidation,
                      ),
                      RSTextField(
                          label: "Password",
                          controller: passwordController,
                          isPassword: true,
                          validator: (text) =>
                              nonEmptyValidation(text, "password")),
                      ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState != null &&
                                formKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();

                              presenter
                                  .signUpWithEmailClicked(
                                      email: emailController.text,
                                      password: passwordController.text)
                                  .then((value) =>
                                      value ? Navigator.pop(context) : null);
                            }
                          },
                          child: const Text("Sign up"))
                    ],
                  )),
            ]),
      ),
    );
  }
}
