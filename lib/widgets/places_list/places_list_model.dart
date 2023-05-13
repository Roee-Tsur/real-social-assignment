import 'package:mapbox_search/mapbox_search.dart';
import 'package:real_social_assignment/services/database.dart';

import '../../models/place.dart';
import '../../utils/config.dart';

class PlacesListModel {
  final placeSearch = PlacesSearch(
    apiKey: Config.MAP_BOX_PUBLIC_API_KEY,
  );

  Future<void> addPlace({required String userId, required Place place}) {
    return DatabaseService().addPlace(userId: userId, place: place);
  }

  Future<void> deletePlace({required String userId, required Place place}) {
    return DatabaseService().deletePlace(userId: userId, place: place);
  }

  Future<List<MapBoxPlace>?> getPlaces(String text) {
    return placeSearch.getPlaces(text);
  }
}
