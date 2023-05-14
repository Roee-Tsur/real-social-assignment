import 'package:flutter/material.dart';
import 'package:real_social_assignment/utils/colors.dart';
import 'package:real_social_assignment/utils/design.dart';
import 'package:real_social_assignment/utils/validators.dart';
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
    return SafeArea(
      child: Scaffold(
        body: Center(
          heightFactor: 1.5,
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6),
            child: Form(
              key: formKey,
              child: AuthCard(
                children: [
                  ButtonContainer(
                    child: OutlinedButton(
                      style: const ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: uiBorderRadius))),
                      onPressed: presenter.signInWithGoogleClicked,
                      child: const Text(
                        "Sign in with Google",
                        style: TextStyle(color: mainColor),
                      ),
                    ),
                  ),
                  const Text(
                    "Or",
                    style: TextStyle(fontSize: 18),
                  ),
                  RSTextField(
                      label: "Email",
                      controller: emailController,
                      type: TextInputType.emailAddress,
                      validator: emailValidation),
                  RSTextField(
                    label: "Password",
                    controller: passwordController,
                    isPassword: true,
                    validator: (text) => nonEmptyValidation(text, "password"),
                  ),
                  //empty container to make space between text fields and login button
                  Container(),
                  ButtonContainer(
                    child: ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(mainColor),
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: uiBorderRadius))),
                        onPressed: () {
                          if (formKey.currentState != null &&
                              formKey.currentState!.validate()) {
                            FocusScope.of(context).unfocus();
                            presenter.signInWithEmailClicked(
                                email: emailController.text,
                                password: passwordController.text);
                          }
                        },
                        child: const Text("Login")),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: (() => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()),
                          )),
                      child: const Text(
                        "Sign up",
                        style: TextStyle(color: mainColor),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
