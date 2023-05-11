import 'package:real_social_assignment/screens/home/home_model.dart';

import 'home_view.dart';

class HomePresenter {
  late HomeView view;
  final HomeModel _model = HomeModel();

  void onMenuItemSelected(MenuOption value) {
    if (value == MenuOption.signOut) {
      _model.signOut();
    }
  }
}

enum MenuOption { signOut }
