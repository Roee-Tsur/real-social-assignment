import 'package:flutter/material.dart';
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
  Location location = Location();
  bool serviceEnabled = false;
  User? user;
  bool locationPermissionGranted = false;

  @override
  void initState() {
    DatabaseService().listenToUser(
      userId: widget.userId,
      onUser: (user) => setState(() {
        this.user = user;
      }),
    );
    Permission.locationWhenInUse.request().then((value) {
      setState(() {
        locationPermissionGranted = value.isGranted;
      });
      location.serviceEnabled().then((isEnabled) {
        serviceEnabled = isEnabled;
        if (!isEnabled) {
          location.requestService().then((isActive) {
            serviceEnabled = isActive;
          });
        }
      });
    });

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
          accessToken: "pk.eyJ1Ijoicm9lZXRzdXIiLCJhIjoiY2xoaTV1Y241MDRtbDNmcGhpODR4NDloOSJ9.wL3-GnuJ63LDA9-8DYX4Ew",
          initialCameraPosition: CameraPosition(target: LatLng(10, 10))),
    );
  }
}
