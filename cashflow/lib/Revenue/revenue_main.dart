import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cashflow/Revenue/Edit_input.dart';
import 'package:cashflow/Revenue/dialog.dart';
import 'package:cashflow/state_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:web_smooth_scroll/web_smooth_scroll.dart';

import '../appcolor.dart';

class RevenueMain extends StatefulWidget {
  const RevenueMain({super.key});

  @override
  State<RevenueMain> createState() => _RevenueMainState();
}

class _RevenueMainState extends State<RevenueMain> {
  final User? _user = FirebaseAuth.instance.currentUser;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.melon,
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("Properties")
              .where("UserID", isEqualTo: _user!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Expanded(flex: 1, child: Text('Welcome ${_user!.uid}')),
                  Expanded(
                    flex: 15,
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        CameraPosition _kGooglePlex = CameraPosition(
                          target: LatLng(snapshot.data!.docs[index].get('lat'),
                              snapshot.data!.docs[index].get('lng')),
                          zoom: 13,
                        );
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 400,
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return dialog_edit(context);
                                  },
                                );
                              },
                              child: Card(
                                  color: AppColors.dim_grey,
                                  shadowColor: AppColors.dim_grey,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Text(snapshot.data!.docs[index]
                                                  .get('cost')
                                                  .toString()),
                                              Text(snapshot.data!.docs[index]
                                                  .get('type')
                                                  .toString()),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 150,
                                            width: 200,
                                            child: GoogleMap(
                                              scrollGesturesEnabled: true,
                                              mapType: MapType.hybrid,
                                              initialCameraPosition:
                                                  _kGooglePlex,
                                              onMapCreated: (GoogleMapController
                                                  controller) {
                                                _controller
                                                    .complete(controller);
                                              },
                                              markers: {
                                                Marker(
                                                    markerId:
                                                        MarkerId("Rental"),
                                                    position: LatLng(
                                                        snapshot
                                                            .data!.docs[index]
                                                            .get('lat'),
                                                        snapshot
                                                            .data!.docs[index]
                                                            .get('lng')))
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: Text("No Uploads as Landlord"),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return ServiceDialog();
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

Widget dialog_edit(context) {
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    elevation: 10.0,
    child: Container(
      height: MediaQuery.of(context).size.height - 200,
      width: MediaQuery.of(context).size.height / 2 + 200,
      // height: 23.5.h,
      // height: 210,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Consumer<Counter>(builder: (context, user, _) {
        // _tabController.index = user.tab_index_dialog;
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.apricot,
                    AppColors.melon,
                    AppColors.Salmon_pink,
                    AppColors.oldrose,
                  ],
                ),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12.0),
                  topLeft: Radius.circular(12.0),
                ),
              ),
              child: Column(
                children: [
                  //-------------------------------------- Pack Title
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Upload Property Information',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NewYork',
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  Divider(color: AppColors.dim_grey),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream:
                    FirebaseFirestore.instance.collection("users").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Phone: ${snapshot.data!.docs[0].get('phone')}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.apricot),
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "House Type: ",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.apricot),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "K ",
                style: TextStyle(
                    fontWeight: FontWeight.w200,
                    fontSize: 25,
                    color: AppColors.apricot),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: CarouselSlider(
                  disableGesture: true,
                  options: CarouselOptions(height: 300.0),
                  items: [1, 2, 3].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration:
                                BoxDecoration(color: AppColors.dim_grey),
                            child: Text(i.toString()));
                      },
                    );
                  }).toList(),
                ),
              ),
            ),

            //------------------------------------    Buy Nowr

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Close")),
            )
          ],
        );
      }),
    ),
  );
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
