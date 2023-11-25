import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../state_manager.dart';

class TabMap extends StatefulWidget {
  const TabMap({super.key});

  @override
  State<TabMap> createState() => _TabMapState();
}

class _TabMapState extends State<TabMap> {
  late LatLng _latLng;
  double lat = 0;
  double lng = 0;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-9.4790, 147.1494),
    zoom: 13,
  );
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Counter>(context);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: Container(
              child: GoogleMap(
                mapType: MapType.hybrid,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                markers: {
                  Marker(
                    markerId: MarkerId('Home'),
                    position: LatLng(lat, lng),
                  ),
                },
                onTap: (argument) {
                  setState(() {
                    lat = argument.latitude;
                    lng = argument.longitude;
                  });
                },
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Center(
              child: Container(
                width: 200,
                child: ElevatedButton(
                  onPressed: () async {
                    if (lat == 0.0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Select Propertity Location On Map")),
                      );
                    }

                    provider.SetMapInfo(MapInfo(lat, lng));
                    provider.tabIndexDialog(3);
                  },
                  child: Text("Next".toUpperCase()),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
