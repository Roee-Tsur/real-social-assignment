import 'package:flutter/material.dart';
import 'package:real_social_assignment/services/auth.dart';
import 'package:real_social_assignment/services/database.dart';

class HomeScreen extends StatelessWidget {
  final String userId;
  const HomeScreen(this.userId, {super.key});

  @override
  Widget build(BuildContext context) {
    DatabaseService().listenToUser(userId);
    return ElevatedButton(
      child: const Text("sign out"),
      onPressed: () => AuthService().signOut(),
    );
  }
}
