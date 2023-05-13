import 'package:location_platform_interface/location_platform_interface.dart';
import 'package:real_social_assignment/models/user.dart';

abstract class HomeView {
  onUser(User user);

  void locationPermissionDenied() {}

  void updateCurrentLocation(LocationData value) {}

  void updateServiceAndPermissionStatus(bool serviceEnabled, PermissionStatus locationPermission) {}
}
