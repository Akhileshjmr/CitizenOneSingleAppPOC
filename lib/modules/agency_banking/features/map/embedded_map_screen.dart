import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class EmbeddedMapScreen extends StatefulWidget {
  final double lat;
  final double lng;

  const EmbeddedMapScreen({super.key, required this.lat, required this.lng});

  @override
  State<EmbeddedMapScreen> createState() => _EmbeddedMapScreenState();
}

class _EmbeddedMapScreenState extends State<EmbeddedMapScreen> {
  late CameraPosition _initialCameraPosition;
  GoogleMapController? _mapController;
  bool _permissionGranted = false;

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = CameraPosition(
      target: LatLng(widget.lat, widget.lng),
      zoom: 15,
    );
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    final status = await Permission.location.request();

    if (status.isGranted) {
      setState(() {
        _permissionGranted = true;
      });
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
      // Don't crash — just show info.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enable location in settings.")),
      );
    } else {
      // Permission denied
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permission denied.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Map Location")),
      body: _permissionGranted
          ? GoogleMap(
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: (controller) {
                _mapController = controller;
              },
              markers: {
                Marker(
                  markerId: const MarkerId("target"),
                  position: LatLng(widget.lat, widget.lng),
                  infoWindow: const InfoWindow(title: "Selected Location"),
                ),
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            )
          : const Center(
              child: Text("Location permission not granted."),
            ),
    );
  }
}
