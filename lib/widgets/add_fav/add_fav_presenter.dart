import 'package:mapbox_search/mapbox_search.dart';
import 'package:real_social_assignment/models/place.dart';
import 'package:real_social_assignment/widgets/add_fav/add_fav_model.dart';

import 'add_fav_view.dart';

class AddFavPresenter {
  final _model = AddFavModel();
  late final AddFavView view;

  Future<void> placeSelected(
      {Place? place, MapBoxPlace? mapBoxPlace, required String userId}) async {
    assert(place != null || mapBoxPlace != null);
    place ??= Place.fromMapBox(mapBoxPlace!);
    await _model.addPlace(userId: userId, place: place);
    view.closeSheet(place);
  }
}
