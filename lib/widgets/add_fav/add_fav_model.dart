import 'package:real_social_assignment/services/database.dart';

import '../../models/place.dart';

class AddFavModel {
  void addPlace({required String userId, required Place place}) {
    DatabaseService().addPlace(userId: userId, place: place);
  }
}
