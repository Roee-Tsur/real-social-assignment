import 'package:email_validator/email_validator.dart';

String? nonEmptyValidation(String? text, String name) {
  if (text == null || text.isEmpty) {
    return "please enter the $name";
  }
  return null;
}

String? emailValidation(String? text) {
  if (text == null || text.isEmpty) {
    return "please enter an email";
  }
  if (!EmailValidator.validate(text)) {
    return "this email is invalid";
  }
  return null;
}
