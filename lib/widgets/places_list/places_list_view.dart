import 'package:real_social_assignment/models/place.dart';

abstract class PlacesListView {
  void placeAdded(Place place) {}

  void placeRemoved(Place place) {}
}
