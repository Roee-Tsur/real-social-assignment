import 'package:cloud_firestore/cloud_firestore.dart';

class Place {
  double lat;
  double lon;

  Place({required this.lat, required this.lon});

  static Place fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    if (data == null) {
      throw "error in fromFirestore Place";
    }
    return Place(lat: data[PlaceFieldName.lat], lon: data[PlaceFieldName.lon]);
  }

  static Map<String, Object?> toFirestore(Place? user, SetOptions? options) {
    if (user == null) {
      return {};
    }
    return {PlaceFieldName.lon: user.lon, PlaceFieldName.lat: user.lat};
  }
}

class PlaceFieldName {
  static const lat = 'lat';
  static const lon = 'lon';
}
