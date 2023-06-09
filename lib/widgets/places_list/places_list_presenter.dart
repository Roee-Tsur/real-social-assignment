import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:real_social_assignment/models/place.dart';
import 'package:real_social_assignment/widgets/places_list/places_list_model.dart';

import 'places_list_view.dart';

class PlacesListPresenter {
  final _model = PlacesListModel();
  late final PlacesListView view;

  Future<void> placeSelected(
      {Place? place, MapBoxPlace? mapBoxPlace, required String userId}) async {
    assert(place != null || mapBoxPlace != null);
    place ??= Place.fromMapBox(mapBoxPlace!);
    await _model.addPlace(userId: userId, place: place);
    view.placeAdded(place);
  }

  Future<void> deletePlaceClicked(
      {required String userId, required Place place}) async {
    await _model.deletePlace(userId: userId, place: place);
    view.placeRemoved(place);
  }

  Future<Iterable<MapBoxPlace>> placesSearchOptionsBuilder(
      TextEditingValue textEditingValue) async {
    final places = await _model.getPlaces(textEditingValue.text);
    return places ?? [];
  }
}
