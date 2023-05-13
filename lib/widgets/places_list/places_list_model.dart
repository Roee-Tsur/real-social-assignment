import 'package:real_social_assignment/services/database.dart';

import '../../models/place.dart';

class PlacesListModel {
  Future<void> addPlace({required String userId, required Place place}) {
    return DatabaseService().addPlace(userId: userId, place: place);
  }

  Future<void> deletePlace({required String userId, required Place place}) {
    return DatabaseService().deletePlace(userId: userId, place: place);
  }
}
