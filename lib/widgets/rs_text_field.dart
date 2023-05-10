import 'package:flutter/material.dart';

class RSTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? type;
  final bool isPassword;

  const RSTextField(
      {super.key,
      required this.label,
      required this.controller,
      this.type,
      this.isPassword = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      decoration: InputDecoration(
          label: Text(label), border: const OutlineInputBorder()),
    );
  }
}
