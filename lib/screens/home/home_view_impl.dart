import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:real_social_assignment/models/user.dart';
import 'package:real_social_assignment/utils/colors.dart';
import 'package:real_social_assignment/utils/map.dart';
import 'package:real_social_assignment/widgets/places_list/places_list_view_impl.dart';
import 'package:real_social_assignment/screens/home/home_presenter.dart';
import 'package:real_social_assignment/screens/home/home_view.dart';
import 'package:real_social_assignment/utils/config.dart';
import 'package:real_social_assignment/utils/design.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  const HomeScreen(this.userId, {super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> implements HomeView {
  LocationData? currentLocation;
  final presenter = HomePresenter();

  bool? serviceEnabled;
  PermissionStatus? locationPermission;
  bool isStyleLoaded = false;
  MapboxMapController? mapController;

  bool isCameraPositionInitialized = false;
  bool isPlaceSymbolsInitialized = false;

  User? user;

  @override
  void initState() {
    presenter.view = this;
    presenter.startUserListener(
      widget.userId,
    );

    presenter.initLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (locationPermission == null || serviceEnabled == null) {
      return const Scaffold();
    }

    if (!serviceEnabled!) {
      return const Scaffold(
        body: Center(
            child: Text(
          "Your location service is disabled!\nEnable location services and restart the app",
          textAlign: TextAlign.center,
        )),
      );
    }

    if (locationPermission == PermissionStatus.deniedForever) {
      return const Scaffold(
          body: Center(
              child: Text(
                  "You need to give the app location permission for it to work\nfind the app in your settings to give the app permission",
                  textAlign: TextAlign.center)));
    }

    if (locationPermission == PermissionStatus.denied) {
      return Scaffold(
        body: InkWell(
            onTap: presenter.requestLocationPermission,
            child: const Center(
                child: Text(
              "You need to give the app location permission for it to work\nclick anywhere to give the app permission",
              textAlign: TextAlign.center,
            ))),
      );
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
        !isPlaceSymbolsInitialized &&
        mapController != null &&
        currentLocation != null &&
        user != null) {
      mapController!.addSymbols(
        [
          getCurrentLocationSymbol(currentLocation!),
          ...user!.places.map((place) => getFavPlaceSymbol(place)).toList()
        ],
      );
      setState(() {
        isPlaceSymbolsInitialized = true;
      });
    }

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          shape: appBarShape,
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: mainColor,
          actions: [
            PopupMenuButton<MenuOption>(
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: MenuOption.signOut,
                  child: Text("Sign Out"),
                ),
              ],
              onSelected: presenter.onMenuItemSelected,
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
          backgroundColor: mainColor,
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
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return PlacesListWidget(
          user: user!,
          currentLocation: currentLocation!,
          onPlaceAdded: (place) {
            mapController!.addSymbol(getFavPlaceSymbol(place));
            mapController!
                .animateCamera(getCameraUpdate(lat: place.lat, lon: place.lon));
          },
          onPlaceRemoved: (place) {
            final symbol = mapController!.symbols.firstWhere((element) =>
                element.options.geometry == getFavPlaceSymbol(place).geometry);
            mapController!.removeSymbol(symbol);
          },
        );
      },
    );
  }

  @override
  void locationPermissionDenied() {
    Fluttertoast.showToast(msg: 'No location permission');
  }

  @override
  void updateCurrentLocation(LocationData value) {
    setState(() {
      currentLocation = value;
    });
  }

  @override
  void updateServiceAndPermissionStatus(
      bool serviceEnabled, PermissionStatus locationPermission) {
    setState(() {
      this.serviceEnabled = serviceEnabled;
      this.locationPermission = locationPermission;
    });
  }
}
