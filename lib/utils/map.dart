import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../models/place.dart';
import 'assets.dart';
import 'config.dart';

SymbolOptions getCurrentLocationSymbol(LocationData currentLocation) {
  return SymbolOptions(
      textField: "current location",
      textSize: 12,
      textOffset: const Offset(0, -1.5),
      geometry: LatLng(currentLocation.latitude!, currentLocation.longitude!),
      iconImage: AssetPaths.currentLocation,
      iconSize: 0.2);
}

SymbolOptions getFavPlaceSymbol(Place place) {
  return SymbolOptions(
      textField: place.shortName,
      textSize: 12,
      textOffset: const Offset(0, -2),
      geometry: LatLng(place.lat, place.lon),
      iconImage: AssetPaths.marker,
      iconSize: 0.2,
      );
}

SymbolOptions getSelectedLocationSymbol(LatLng selectedLocation) {
  return SymbolOptions(
      textField: "Selected place",
      textSize: 12,
      textOffset: const Offset(0, -2),
      geometry: selectedLocation,
      iconImage: AssetPaths.selectMarker,
      iconSize: 0.2,
      );
}

CameraUpdate getCameraUpdate({required double lat, required double lon}) {
  return CameraUpdate.newCameraPosition(
      CameraPosition(zoom: Config.defaultZoom, target: LatLng(lat, lon)));
}
