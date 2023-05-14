import 'package:flutter/material.dart';
import 'package:real_social_assignment/utils/design.dart';

import '../../../utils/colors.dart';
import '../../../utils/validators.dart';
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
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Center(
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
                            onPressed: () => presenter
                                .signUpWithGoogleClicked()
                                .then((value) =>
                                    value ? Navigator.pop(context) : null),
                            child: const Text("Sign up with Google",
                                style: TextStyle(color: mainColor))),
                      ),
                      const Text(
                        "Or",
                        style: TextStyle(fontSize: 18),
                      ),
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
                      //empty container to make space between text fields and signup button
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
                                presenter
                                    .signUpWithEmailClicked(
                                        email: emailController.text,
                                        password: passwordController.text)
                                    .then((value) =>
                                        value ? Navigator.pop(context) : null);
                              }
                            },
                            child: const Text("Sign up")),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(globalPadding),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back)),
            ),
          ],
        ),
      ),
    );
  }
}
