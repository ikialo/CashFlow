import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cashflow/appcolor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  FirebaseStorage storage = FirebaseStorage.instance;

  final User? _user = FirebaseAuth.instance.currentUser;

  CollectionReference users =
      FirebaseFirestore.instance.collection('Properties');

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Consumer<Counter>(
              builder: (context, user, _) => ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    // if (index == 0) {
                    //   return Column(children: [
                    //     Expanded(
                    //         flex: 1,
                    //         child: Text(
                    //             "House Type: ${user.info.type.toString()} ")),
                    //     Expanded(
                    //         flex: 1,
                    //         child: Text(
                    //             "House Cost: ${user.info.cost.toString()} ")),
                    //     Expanded(
                    //         flex: 1,
                    //         child: Text(
                    //             "House Rooms: ${user.info.room.toString()} ")),
                    //     Expanded(
                    //       flex: 6,
                    //       child: Container(
                    //         height: 200,
                    //         width: 300,
                    //       ),
                    //     ),
                    //   ]);
                    // }
                    // if (index == 1) {
                    //   return GoogleMap(
                    //     mapType: MapType.hybrid,
                    //     initialCameraPosition: _kGooglePlex,
                    //     onMapCreated: (GoogleMapController controller) {
                    //       _controller.complete(controller);
                    //     },
                    //     markers: {
                    //       Marker(
                    //         markerId: MarkerId('Home'),
                    //         position: LatLng(user.info.lat, user.info.lng),
                    //       ),
                    //     },
                    //   );
                    // }

                    CameraPosition _kGooglePlex = CameraPosition(
                      target: LatLng(user.info.lat, user.info.lng),
                      zoom: 13,
                    );

                    if (index == 0) {
                      return Column(children: [
                        Text("House Type: ${user.info.type.toString()} "),
                        Text("House Cost: ${user.info.cost.toString()} "),
                        Text("House Rooms: ${user.info.room.toString()} "),
                        Container(
                          height: 200,
                          width: 300,
                          child: CarouselSlider(
                            disableGesture: true,
                            options: CarouselOptions(
                                height: MediaQuery.of(context).size.height / 4),
                            items: user.photos.map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5.0),
                                      decoration: BoxDecoration(
                                          color: AppColors.dim_grey),
                                      child: Image.memory(i));
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ]);
                    }
                    if (index == 1) {
                      return SizedBox(
                        height: 300,
                        width: 200,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 50.0, right: 50),
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
                      );
                    } else {
                      return //           const SizedBox(height: 15),
                          Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Center(
                            child: Container(
                              width: 200,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => Colors.blue)),
                                onPressed: () async {
                                  // If the form is valid, display a snackbar. In the real world,
                                  // you'd often call a server or save the information in a database.
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   const SnackBar(content: Text("")),
                                  // );

                                  String uniqID = users.doc().id;

                                  await users.doc(uniqID).set({
                                    'UserID': _user!.uid,
                                    'cost': user.info.cost, // John Doe
                                    'rooms': user.info.room,
                                    'lat': user.info.lat,
                                    "lng": user.info.lng,
                                    'type': user.info.type,
                                    'photo_0': '',
                                    'photo_1': '',
                                    'photo_2': '',
                                    'photo_3': '',
                                    'photo_4': '',
                                    'photo_5': '',
                                  }).then((value) async {
                                    var urls =
                                        await uploadFiles(user.photos, uniqID);

                                    urls.asMap().forEach((i, element) {
                                      users
                                          .doc(uniqID)
                                          .update({"photo_$i": element});
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Property Added")),
                                    );
                                  }).catchError((error) =>
                                      print("Failed to add user: $error"));

                                  Navigator.of(context).pop();
                                },
                                child: Text("Submit".toUpperCase()),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  })

              // Row(
              //   children: [
              //     Expanded(
              //       child:
              // Column(
              //         children: [
              //           Expanded(
              //               flex: 1,
              //               child:
              //                   Text("House Type: ${user.info.type.toString()} ")),
              //           Expanded(
              //               flex: 1,
              //               child:
              //                   Text("House Cost: ${user.info.cost.toString()} ")),
              //           Expanded(
              //               flex: 1,
              //               child:
              //                   Text("House Rooms: ${user.info.room.toString()} ")),
              //           Expanded(
              //             flex: 6,
              //             child: Container(
              //               height: 200,
              //               width: 300,
              //             ),
              //           ),
              //           const SizedBox(height: 15),
              //           SizedBox(
              //             width: double.infinity,
              //             child: Center(
              //               child: Container(
              //                 width: 200,
              //                 child: ElevatedButton(
              //                   style: ButtonStyle(
              //                       backgroundColor: MaterialStateColor.resolveWith(
              //                           (states) => Colors.blue)),
              //                   onPressed: () async {
              //                     // If the form is valid, display a snackbar. In the real world,
              //                     // you'd often call a server or save the information in a database.
              //                     // ScaffoldMessenger.of(context).showSnackBar(
              //                     //   const SnackBar(content: Text("")),
              //                     // );

              //                     // //TODO: load to firebase.
              //                     String uniqID = users.doc().id;

              //                     await users.doc(uniqID).set({
              //                       'UserID': _user!.uid,
              //                       'cost': user.info.cost, // John Doe
              //                       'rooms': user.info.room,
              //                       'lat': user.info.lat,
              //                       "lng": user.info.lng,
              //                       'type': user.info.type,
              //                       'photo_0': '',
              //                       'photo_1': '',
              //                       'photo_2': '',
              //                       'photo_3': '',
              //                       'photo_4': '',
              //                       'photo_5': '',
              //                     }).then((value) async {
              //                       var urls =
              //                           await uploadFiles(user.photos, uniqID);

              //                       urls.asMap().forEach((i, element) {
              //                         users
              //                             .doc(uniqID)
              //                             .update({"photo_$i": element});
              //                         print(element);
              //                       });

              //                       ScaffoldMessenger.of(context).showSnackBar(
              //                         const SnackBar(
              //                             content: Text("Property Added")),
              //                       );
              //                     }).catchError((error) =>
              //                         print("Failed to add user: $error"));

              //                     Navigator.of(context).pop();
              //                   },
              //                   child: Text("Submit".toUpperCase()),
              //                 ),
              //               ),
              //             ),
              //           )
              //         ],
              //       ),
              //     ),
              //     Expanded(
              //       child: Padding(
              //         padding: const EdgeInsets.all(12.0),
              //         child:
              // GoogleMap(
              //           mapType: MapType.hybrid,
              //           initialCameraPosition: _kGooglePlex,
              //           onMapCreated: (GoogleMapController controller) {
              //             _controller.complete(controller);
              //           },
              //           markers: {
              //             Marker(
              //               markerId: MarkerId('Home'),
              //               position: LatLng(user.info.lat, user.info.lng),
              //             ),
              //           },
              //         ),
              //       ),
              //     )
              //   ],
              // ),
              )),
    );
  }

  Future<List<String>> uploadFiles(List<Uint8List> _images, uid) async {
    List<String> imageUrls = [];

    // _images.asMap().forEach(
    //   (cnt, _image) async {
    //     if (_image.isNotEmpty) {
    //       imageUrls.add(await uploadFile(_image, cnt, uid));
    //     }
    //   },
    // );

    for (int i = 0; i < _images.length; i++) {
      if (_images[i].isNotEmpty) {
        imageUrls.add(await uploadFile(_images[i], i, uid));
      }
    }
    return imageUrls;
  }

  Future<String> uploadFile(Uint8List _image, int cnt, uid) async {
    final ref = storage.ref(_user!.uid).child(uid).child("${cnt}.jpg");
    UploadTask uploadTask = ref.putData(_image);

    // .then((p0) {
    //   print("program");
    // });
    // await uploadTask.onComplete;

    String imageUrl = await (await uploadTask).ref.getDownloadURL();

    return imageUrl;

    // return await storageReference.getDownloadURL();
  }
  // Future uploadFile() async {
  //   print("upload file");
  //   if (_photo == null) return;

  //   print("photo exists");
  //   final fileName = _photo;
  //   final destination = 'files';

  //   try {
  //     print("in try");
  //     final ref = storage.ref(destination).child('file.jpg');
  //     await ref.putData(_photo).then((p0) => print("uploaded"));
  //   } catch (e) {
  //     print("print");
  //     print(e);
  //   }
  // }
}
