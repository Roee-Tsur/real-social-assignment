import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:real_social_assignment/utils/design.dart';
import 'package:real_social_assignment/utils/valodators.dart';
import 'package:real_social_assignment/widgets/rs_text_field.dart';

import 'sign_in_presenter.dart';
import 'sign_in_view.dart';
import '../sign_up/sign_up_view_impl.dart';

class SignInScreen extends StatelessWidget implements SignInView {
  SignInScreen({super.key});
  final presenter = SignInPresenter();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    presenter.view = this;
    return Scaffold(
      appBar: AppBar(shape: appBarShape),
      body: Center(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: presenter.signInWithGoogleClicked,
                  child: const Text("Sign in with Google")),
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
                          validator: emailValidation),
                      RSTextField(
                        label: "Password",
                        controller: passwordController,
                        isPassword: true,
                        validator: (text) =>
                            nonEmptyValidation(text, "password"),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState != null &&
                                formKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();

                              presenter.signInWithEmailClicked(
                                  email: emailController.text,
                                  password: passwordController.text);
                            }
                          },
                          child: const Text("Login"))
                    ],
                  )),
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
