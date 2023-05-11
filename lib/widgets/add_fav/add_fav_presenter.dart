import 'package:mapbox_search/mapbox_search.dart';
import 'package:real_social_assignment/models/place.dart';
import 'package:real_social_assignment/widgets/add_fav/add_fav_model.dart';

import 'add_fav_view.dart';

class AddFavPresenter {
  final _model = AddFavModel();
  late final AddFavView view;

  void placeSelected({required MapBoxPlace place, required String userId}) {
    final newPlace = Place.fromMapBox(place);
    _model.addPlace(userId: userId, place: newPlace);
  }
}
