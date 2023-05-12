import 'package:real_social_assignment/services/auth.dart';
import 'package:real_social_assignment/services/database.dart';

import '../../models/user.dart';

class HomeModel {
  void signOut() {
    AuthService().signOut();
  }

  void setUserListener({required userId, required Function(User user) onUser}) {
    DatabaseService().listenToUser(userId: userId, onUser: onUser);
  }
}
