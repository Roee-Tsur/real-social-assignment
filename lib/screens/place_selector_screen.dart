import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:real_social_assignment/models/place.dart';
import 'package:real_social_assignment/utils/config.dart';
import 'package:real_social_assignment/utils/design.dart';
import 'package:real_social_assignment/utils/map.dart';
import 'package:real_social_assignment/utils/validators.dart';
import 'package:real_social_assignment/widgets/rs_text_field.dart';

import '../utils/colors.dart';

//this page has no presenter/model because it has not business logic, only ui logic
//on pop should return Place or null
class PlaceSelectorScreen extends StatefulWidget {
  PlaceSelectorScreen({super.key, required this.currentLocation});

  final LocationData currentLocation;
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  State<PlaceSelectorScreen> createState() => _PlaceSelectorScreenState();
}

class _PlaceSelectorScreenState extends State<PlaceSelectorScreen> {
  bool isStyleLoaded = false;
  MapboxMapController? mapController;
  LatLng? selectedLocation;

  @override
  Widget build(BuildContext context) {
    if (isStyleLoaded && mapController != null) {
      // if current location symbol not added, add it
      if (!mapController!.symbols.any((element) {
        final elementLon = element.options.geometry!.longitude;
        final elementLat = element.options.geometry!.latitude;
        final currentLon = widget.currentLocation.longitude;
        final currentLat = widget.currentLocation.latitude;
        return elementLon == currentLon && elementLat == currentLat;
      })) {
        mapController!
            .addSymbol(getCurrentLocationSymbol(widget.currentLocation));
      }
    }

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          shape: appBarShape,
          backgroundColor: mainColor,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: selectedLocation == null ? Colors.grey : null,
            onPressed: onFabClick,
            child: const Icon(Icons.done)),
        body: MapboxMap(
            accessToken: Config.MAP_BOX_PUBLIC_API_KEY,
            initialCameraPosition: CameraPosition(
                zoom: Config.defaultZoom,
                target: LatLng(widget.currentLocation.latitude!,
                    widget.currentLocation.longitude!)),
            onStyleLoadedCallback: () {
              setState(() {
                isStyleLoaded = true;
              });
            },
            onMapCreated: (controller) {
              setState(() {
                mapController = controller;
              });
            },
            onMapLongClick: onLongClick),
      ),
    );
  }

  Future<void> onFabClick() async {
    String? placeName = await showDialog<String?>(
        context: context, builder: placeNameDialogBuilder);

    if (placeName == null) {
      Fluttertoast.showToast(
          msg: "to save place you need to give it a name",
          toastLength: Toast.LENGTH_LONG);
      return;
    }

    Navigator.pop(
        context, Place.fromLatLon(latLng: selectedLocation!, name: placeName));
  }

  void onLongClick(Point<double> point, LatLng coordinates) {
    if (selectedLocation != null) {
      try {
        mapController!.removeSymbol(mapController!.symbols.firstWhere(
            (element) => element.options.geometry == selectedLocation));
      } catch (e) {
        //if theres an error its because somehow the selected symbol is not in the symbols list
      }
    }
    selectedLocation = coordinates;
    mapController!.addSymbol(getSelectedLocationSymbol(selectedLocation!));
    setState(() {});
  }

  Widget placeNameDialogBuilder(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Padding(
          padding: const EdgeInsets.all(globalPadding),
          child: Form(
            key: widget.formKey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Name your place",
                        style: TextStyle(fontSize: 24)),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: RSTextField(
                          label: 'Name',
                          controller: widget.nameController,
                          autoFocus: true,
                          validator: (text) => nonEmptyValidation(text, "name"),
                        ))
                  ],
                ),
                FloatingActionButton(
                  backgroundColor: mainColor,
                  onPressed: () {
                    if (widget.formKey.currentState != null &&
                        widget.formKey.currentState!.validate()) {
                      Navigator.pop(context, widget.nameController.text);
                    }
                  },
                  child: const Icon(Icons.done),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
