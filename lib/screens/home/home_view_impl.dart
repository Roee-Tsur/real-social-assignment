import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:real_social_assignment/models/user.dart';
import 'package:real_social_assignment/services/database.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  const HomeScreen(this.userId, {super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final double defaultZoom = 10.5;

  Location location = Location();
  LocationData? currentLocation;

  bool serviceEnabled = false;
  bool locationPermissionGranted = false;
  bool isStyleLoaded = false;
  MapboxMapController? mapController;
  bool isCameraPositionInitialized = false;

  User? user;

  @override
  void initState() {
    DatabaseService().listenToUser(
      userId: widget.userId,
      onUser: (user) => setState(() {
        this.user = user;
      }),
    );
    initLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!locationPermissionGranted) {
      return const Text("no permission");
    }
    if (!serviceEnabled) {
      return const Text("service disabled");
    }

    return Scaffold(
      appBar: AppBar(),
      body: MapboxMap(
        accessToken:
            "pk.eyJ1Ijoicm9lZXRzdXIiLCJhIjoiY2xoaTV1Y241MDRtbDNmcGhpODR4NDloOSJ9.wL3-GnuJ63LDA9-8DYX4Ew",
        //default initial camera position is tel aviv
        initialCameraPosition: CameraPosition(
            target: const LatLng(32.075982, 34.787155), zoom: defaultZoom - 1),
        myLocationEnabled: true,
        onStyleLoadedCallback: () {
          setState(() {
            isStyleLoaded = true;
          });
        },
        onMapCreated: (controller) {
          mapController = controller;
          if (currentLocation != null && !isCameraPositionInitialized) {
            if (currentLocation!.latitude != null &&
                currentLocation!.longitude != null) {
              controller.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                      zoom: defaultZoom,
                      target: LatLng(currentLocation!.latitude!,
                          currentLocation!.longitude!))));
            }
          }
        },
      ),
    );
  }

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
      if (value.latitude != null && value.longitude != null) {
        if (mapController != null) {
          mapController!.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  zoom: defaultZoom,
                  target: LatLng(value.latitude!, value.longitude!))));
        }
        setState(() {
          currentLocation = value;
        });
      }
    });
  }
}
