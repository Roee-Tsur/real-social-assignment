import 'package:real_social_assignment/services/auth.dart';

class HomeModel {
  void signOut() {
    AuthService().signOut();
  }
}
