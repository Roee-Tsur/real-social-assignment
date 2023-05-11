import 'package:real_social_assignment/services/database.dart';

import '../../models/place.dart';

class AddFavModel {
  Future<void> addPlace({required String userId, required Place place}) {
    return DatabaseService().addPlace(userId: userId, place: place);
  }
}
