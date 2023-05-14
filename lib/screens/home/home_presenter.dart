import 'package:location/location.dart';
import 'package:real_social_assignment/screens/home/home_model.dart';

import 'home_view.dart';

class HomePresenter {
  late HomeView view;
  final HomeModel _model = HomeModel();
  Location location = Location();

  void onMenuItemSelected(MenuOption value) {
    if (value == MenuOption.signOut) {
      _model.signOut();
    }
  }

  void startUserListener(String userId) {
    _model.setUserListener(userId: userId, onUser: view.onUser);
  }

  Future<void> initLocation() async {
    final locationPermission = await location.requestPermission();
    if (locationPermission == PermissionStatus.denied ||
        locationPermission == PermissionStatus.deniedForever) {
      view.locationPermissionDenied();
    }

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    view.updateServiceAndPermissionStatus(serviceEnabled, locationPermission);
    if (serviceEnabled &&
        (locationPermission == PermissionStatus.granted ||
            locationPermission == PermissionStatus.grantedLimited)) {
      location.getLocation().then((value) {
        view.updateCurrentLocation(value);
      });
    }
  }

  Future<void> requestLocationPermission() async {
    final locationPermission = await location.requestPermission();
    if (isLocationPermissionGranted(locationPermission)) {
      initLocation();
    } else {
      view.locationPermissionDenied();
    }
  }

  bool isLocationPermissionGranted(PermissionStatus permissionStatus) =>
      permissionStatus == PermissionStatus.granted ||
      permissionStatus == PermissionStatus.grantedLimited;
}

enum MenuOption { signOut }
