import 'package:flutter/material.dart';

class RSTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? type;
  final bool isPassword;
  final BoxConstraints? constraints;
  final FocusNode? focusNode;
  final String? Function(String? text)? validator;
  final bool autoFocus;

  const RSTextField(
      {super.key,
      required this.label,
      required this.controller,
      this.type,
      this.isPassword = false,
      this.constraints,
      this.focusNode,
      this.validator,
      this.autoFocus = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      focusNode: focusNode,
      validator: validator,
      autofocus: autoFocus,
      decoration: InputDecoration(
          label: Text(label),
          contentPadding:
              const EdgeInsets.symmetric(vertical: -10, horizontal: 10),
          constraints: constraints,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)))),
    );
  }
}
