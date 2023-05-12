import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:real_social_assignment/models/user.dart';
import 'package:real_social_assignment/utils/map.dart';
import 'package:real_social_assignment/widgets/add_fav/add_fav_view_impl.dart';
import 'package:real_social_assignment/screens/home/home_presenter.dart';
import 'package:real_social_assignment/screens/home/home_view.dart';
import 'package:real_social_assignment/services/database.dart';
import 'package:real_social_assignment/utils/assets.dart';
import 'package:real_social_assignment/utils/config.dart';
import 'package:real_social_assignment/utils/design.dart';

import '../../models/place.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  final presenter = HomePresenter();
  HomeScreen(this.userId, {super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> implements HomeView {
  Location location = Location();
  LocationData? currentLocation;

  bool serviceEnabled = false;
  bool locationPermissionGranted = false;
  bool isStyleLoaded = false;
  MapboxMapController? mapController;

  bool isCameraPositionInitialized = false;
  bool isSymbolsInitialized = false;

  User? user;

  @override
  void initState() {
    widget.presenter.view = this;
    widget.presenter.startUserListener(
      widget.userId,
    );

    initLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!locationPermissionGranted || !serviceEnabled) {
      return const Scaffold();
    }

    if (!isCameraPositionInitialized &&
        mapController != null &&
        currentLocation != null) {
      mapController!.animateCamera(getCameraUpdate(
          lat: currentLocation!.latitude!, lon: currentLocation!.longitude!));
      setState(() {
        isCameraPositionInitialized = true;
      });
    }

    if (isStyleLoaded &&
        !isSymbolsInitialized &&
        mapController != null &&
        currentLocation != null) {
      mapController!.addSymbols(
        [
          getCurrentLocationSymbol(currentLocation!),
          ...user!.places.map((place) => getFavPlaceSymbol(place)).toList()
        ],
      );
      setState(() {
        isSymbolsInitialized = true;
      });
    }

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          shape: appBarShape,
          actions: [
            PopupMenuButton<MenuOption>(
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: MenuOption.signOut,
                  child: Text("Sign Out"),
                ),
              ],
              onSelected: widget.presenter.onMenuItemSelected,
              icon: const Icon(Icons.menu),
            )
          ],
        ),
        body: MapboxMap(
          accessToken: Config.MAP_BOX_PUBLIC_API_KEY,
          //default initial camera position is tel aviv
          initialCameraPosition: const CameraPosition(
              target: LatLng(32.075982, 34.787155),
              zoom: Config.defaultZoom - 1),
          // marking this as true makes the app crash on Navigator.pop()
          myLocationEnabled: false,
          onStyleLoadedCallback: onStyleLoaded,
          onMapCreated: onMapCreated,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: onFABClick,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  @override
  void onUser(user) => setState(() {
        this.user = user;
      });

  Future<void> initLocation() async {
    locationPermissionGranted =
        await Permission.locationWhenInUse.request().isGranted;
    if (!locationPermissionGranted) {
      Fluttertoast.showToast(msg: 'No location permission');
      return;
    }

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        Fluttertoast.showToast(msg: "No location service");
        return;
      }
    }
    location.getLocation().then((value) {
      setState(() {
        currentLocation = value;
      });
    });
  }

  void onMapCreated(MapboxMapController controller) {
    setState(() {
      mapController = controller;
    });
    if (currentLocation != null && !isCameraPositionInitialized) {
      if (currentLocation!.latitude != null &&
          currentLocation!.longitude != null) {}
    }
  }

  void onStyleLoaded() {
    setState(() {
      isStyleLoaded = true;
    });
  }

  Future<void> onFABClick() async {
    if (user == null || currentLocation == null) {
      return;
    }
    final results = await showModalBottomSheet(
      context: context,
      builder: (context) {
        return AddFavWidget(
          user: user!,
          currentLocation: currentLocation!,
        );
      },
    );

    if (results == null) {
      return;
    }

    if (results is Place) {
      mapController!.addSymbol(getFavPlaceSymbol(results));
      mapController!
          .animateCamera(getCameraUpdate(lat: results.lat, lon: results.lon));
    }
  }
}
