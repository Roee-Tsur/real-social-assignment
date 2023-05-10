import 'package:flutter/material.dart';
import 'package:real_social_assignment/services/auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text("sign out"),
      onPressed: () => AuthService().signOut(),
    );
  }
}
