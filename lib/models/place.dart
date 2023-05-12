import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mapbox_search/mapbox_search.dart';

class Place {
  late double lat;
  late double lon;
  late String name;

  Place({required this.lat, required this.lon, required this.name});

  Place.fromMapBox(MapBoxPlace place) {
    lat = place.geometry!.coordinates![1];
    lon = place.geometry!.coordinates![0];
    name = place.placeName ?? place.matchingText ?? '';
  }

  get shortName {
    String newName = name;
    if (name.length > 15) {
      newName = newName.substring(0, 15);
      newName += "...";
    }
    return newName;
  }

  static Place fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    if (data == null) {
      throw "error in fromFirestore Place";
    }
    return Place(
        lat: data[PlaceFieldName.lat],
        lon: data[PlaceFieldName.lon],
        name: data[PlaceFieldName.name]);
  }

  static Map<String, Object?> toFirestore(Place? place, SetOptions? options) {
    if (place == null) {
      return {};
    }
    return {
      PlaceFieldName.lon: place.lon,
      PlaceFieldName.lat: place.lat,
      PlaceFieldName.name: place.name
    };
  }
}

class PlaceFieldName {
  static const lat = 'lat';
  static const lon = 'lon';
  static const name = "name";
}
