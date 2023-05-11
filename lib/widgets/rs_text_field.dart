import 'package:flutter/material.dart';

class RSTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? type;
  final bool isPassword;
  final BoxConstraints? constraints;
  final FocusNode? focusNode;

  const RSTextField(
      {super.key,
      required this.label,
      required this.controller,
      this.type,
      this.isPassword = false,
      this.constraints,
      this.focusNode});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      focusNode: focusNode,
      decoration: InputDecoration(
          label: Text(label),
          constraints: constraints,
          border: const OutlineInputBorder()),
    );
  }
}
