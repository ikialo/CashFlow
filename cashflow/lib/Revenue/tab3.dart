import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../state_manager.dart';

class TabThree extends StatefulWidget {
  const TabThree({super.key});

  @override
  State<TabThree> createState() => _TabThreeState();
}

class _TabThreeState extends State<TabThree> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-9.4790, 147.1494),
    zoom: 13,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Consumer<Counter>(
          builder: (context, user, _) => Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                        flex: 1,
                        child:
                            Text("House Type: ${user.info.type.toString()} ")),
                    Expanded(
                        flex: 1,
                        child:
                            Text("House Cost: ${user.info.cost.toString()} ")),
                    Expanded(
                        flex: 1,
                        child:
                            Text("House Rooms: ${user.info.room.toString()} ")),
                    Expanded(
                      flex: 6,
                      child: Container(
                        height: 200,
                        width: 300,
                        child: LayoutGrid(
                          columnGap: 1,
                          rowGap: 1,
                          areas: '''
                                                                      1 3 5
                                                                      2 4 6
                                                                    ''',
                          // A number of extension methods are provided for concise track sizing
                          columnSizes: [99.px, 99.px, 99.px],
                          rowSizes: [
                            99.px,
                            99.px,
                          ],
                          children: [
                            // Column 1
                            gridArea('1').containing(user.photos[0].isEmpty
                                ? Image.asset('assets/images/placeholder.png')
                                : Image.memory(user.photos[0])),
                            gridArea('2').containing(user.photos[1].isEmpty
                                ? Image.asset('assets/images/placeholder.png')
                                : Image.memory(user.photos[1])),
                            // Column 2
                            gridArea('3').containing(user.photos[2].isEmpty
                                ? Image.asset('assets/images/placeholder.png')
                                : Image.memory(user.photos[2])),
                            gridArea('4').containing(user.photos[3].isEmpty
                                ? Image.asset('assets/images/placeholder.png')
                                : Image.memory(user.photos[3])),
                            // Column 3

                            gridArea('5').containing(user.photos[4].isEmpty
                                ? Image.asset('assets/images/placeholder.png')
                                : Image.memory(user.photos[4])),
                            gridArea('6').containing(user.photos[5].isEmpty
                                ? Image.asset('assets/images/placeholder.png')
                                : Image.memory(user.photos[5])),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GoogleMap(
                    mapType: MapType.hybrid,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    markers: {
                      Marker(
                        markerId: MarkerId('Home'),
                        position: LatLng(user.info.lat, user.info.lng),
                      ),
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
