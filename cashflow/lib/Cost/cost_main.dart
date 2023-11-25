import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cashflow/appcolor.dart';
import 'package:cashflow/state_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CostMain extends StatefulWidget {
  const CostMain({super.key});

  @override
  State<CostMain> createState() => _CostMainState();
}

class _CostMainState extends State<CostMain> {
  final CapitalExCon = TextEditingController();
  final CogExCon = TextEditingController();

  final carcon = CarouselController();

  bool filer_search = false;

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  late Iterable<QueryDocumentSnapshot<Map<String, dynamic>>> filter;

  final List<String> items_cost_filter = [
    'K1000',
    'K2000',
    'K3000',
    'K4000',
    'K5000',
  ];
  final List<String> items_room_filter = [
    '1',
    '2',
    '3',
    '4',
    '5',
  ];
  final List<String> items_type_filter = [
    'House',
    'Apartment',
    'Duplex',
    'Bedsitter',
    'Land',
  ];

  String? selectedValue;
  String? selectedValue_room;
  String? selectedValue_type;

  String? filter_cost;
  String? filter_room = '10';
  String? filter_type;

  late StateSetter _setState;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-9.4790, 147.1494),
    zoom: 13,
  );

  late Set<Marker> markers = {};
  bool scrollmap = true;

  Future<void> readDataFromFirebase() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference<Map<String, dynamic>> collectionReference =
        firestore.collection('Properties');
    collectionReference.snapshots().listen((event) {
      setState(() {
        event.docs.forEach((element) {
          markers.add(Marker(
              position: LatLng(element.get("lat"), element.get('lat')),
              markerId: MarkerId(element.id)));
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    addCustomIcon();
    super.initState();
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/images/RenterPG_marker.png")
        .then(
      (icon) {
        setState(() {
          markerIcon = icon;
        });
      },
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> StreamFirebase() {
    return FirebaseFirestore.instance.collection("Properties").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Counter>(context);
    return Consumer<Counter>(builder: (context, prov, _) {
      return Scaffold(
          backgroundColor: AppColors.melon,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Stack(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 4, right: 4, bottom: 4),
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: StreamFirebase(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            filter = snapshot.data!.docs.where((element) =>
                                element.get("rooms") <= prov.rooms);

                            return StatefulBuilder(builder:
                                (BuildContext context,
                                    void Function(void Function()) setState) {
                              _setState = setState;
                              return Container(
                                decoration: BoxDecoration(
                                    color: AppColors.apricot,
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: GoogleMap(
                                    scrollGesturesEnabled: prov.disableMapMove,
                                    mapType: MapType.hybrid,
                                    initialCameraPosition: _kGooglePlex,
                                    onMapCreated:
                                        (GoogleMapController controller) {
                                      _controller.complete(controller);

                                      setState(() {
                                        filter.forEach(
                                          (element) {
                                            markers.add(Marker(
                                                position: LatLng(
                                                    element.get("lat"),
                                                    element.get('lng')),
                                                infoWindow: InfoWindow(
                                                    onTap: () {
                                                      List<String> urls = [];
                                                      for (int i = 0;
                                                          i < 6;
                                                          i++) {
                                                        try {
                                                          urls.add(element.get(
                                                              "photo_${i}"));
                                                        } on Exception catch (_) {}
                                                      }

                                                      provider
                                                          .SetDisableMapMove(
                                                              false);
                                                      showDialog(
                                                        barrierDismissible:
                                                            false,
                                                        context: context,
                                                        builder: (context) {
                                                          return dialog_photo(
                                                              provider,
                                                              urls,
                                                              element
                                                                  .get("cost"),
                                                              element
                                                                  .get("type"),
                                                              element.get(
                                                                  "UserID"));
                                                        },
                                                      );
                                                    },
                                                    title:
                                                        "K ${element.get('cost').toString()}",
                                                    snippet:
                                                        "Click Cost For Photos"),
                                                icon: markerIcon,
                                                onTap: () {},
                                                markerId:
                                                    MarkerId(element.id)));
                                          },
                                        );
                                      });
                                    },
                                    onTap: (argument) {},
                                    markers: markers,
                                  ),
                                ),
                              );
                            });
                          } else {
                            return Container();
                          }
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                hint: Row(
                                  children: [
                                    Icon(
                                      Icons.list,
                                      size: 16,
                                      color: Colors.yellow,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Cost',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.dim_grey,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                items: items_cost_filter
                                    .map((String item) =>
                                        DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.dim_grey,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ))
                                    .toList(),
                                value: selectedValue,
                                onChanged: (value) {
                                  setState(() {
                                    selectedValue = value;
                                  });
                                },
                                buttonStyleData: ButtonStyleData(
                                  height: 50,
                                  width: 160,
                                  padding: const EdgeInsets.only(
                                      left: 14, right: 14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: Colors.black26,
                                    ),
                                    color: AppColors.Salmon_pink,
                                  ),
                                  elevation: 2,
                                ),
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.arrow_forward_ios_outlined,
                                  ),
                                  iconSize: 14,
                                  iconEnabledColor: Colors.yellow,
                                  iconDisabledColor: Colors.grey,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 200,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: AppColors.apricot,
                                  ),
                                  offset: const Offset(-20, 0),
                                  scrollbarTheme: ScrollbarThemeData(
                                    radius: const Radius.circular(40),
                                    thickness: MaterialStateProperty.all(6),
                                    thumbVisibility:
                                        MaterialStateProperty.all(true),
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                hint: Row(
                                  children: [
                                    Icon(
                                      Icons.list,
                                      size: 16,
                                      color: Colors.yellow,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Rooms',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.dim_grey,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                items: items_room_filter
                                    .map((String item) =>
                                        DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.dim_grey,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ))
                                    .toList(),
                                value: selectedValue_room,
                                onChanged: (value) {
                                  setState(() {
                                    selectedValue_room = value;
                                  });
                                },
                                buttonStyleData: ButtonStyleData(
                                  height: 50,
                                  width: 160,
                                  padding: const EdgeInsets.only(
                                      left: 14, right: 14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: Colors.black26,
                                    ),
                                    color: AppColors.Salmon_pink,
                                  ),
                                  elevation: 2,
                                ),
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.arrow_forward_ios_outlined,
                                  ),
                                  iconSize: 14,
                                  iconEnabledColor: Colors.yellow,
                                  iconDisabledColor: Colors.grey,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 200,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: AppColors.apricot,
                                  ),
                                  offset: const Offset(-20, 0),
                                  scrollbarTheme: ScrollbarThemeData(
                                    radius: const Radius.circular(40),
                                    thickness: MaterialStateProperty.all(6),
                                    thumbVisibility:
                                        MaterialStateProperty.all(true),
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                hint: Row(
                                  children: [
                                    Icon(
                                      Icons.list,
                                      size: 16,
                                      color: Colors.yellow,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Type',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.dim_grey,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                items: items_type_filter
                                    .map((String item) =>
                                        DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.dim_grey,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ))
                                    .toList(),
                                value: selectedValue_type,
                                onChanged: (value) {
                                  setState(() {
                                    selectedValue_type = value;
                                  });
                                },
                                buttonStyleData: ButtonStyleData(
                                  height: 50,
                                  width: 160,
                                  padding: const EdgeInsets.only(
                                      left: 14, right: 14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: Colors.black26,
                                    ),
                                    color: AppColors.Salmon_pink,
                                  ),
                                  elevation: 2,
                                ),
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.arrow_forward_ios_outlined,
                                  ),
                                  iconSize: 14,
                                  iconEnabledColor: Colors.yellow,
                                  iconDisabledColor: Colors.grey,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 200,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: AppColors.apricot,
                                  ),
                                  offset: const Offset(-20, 0),
                                  scrollbarTheme: ScrollbarThemeData(
                                    radius: const Radius.circular(40),
                                    thickness: MaterialStateProperty.all(6),
                                    thumbVisibility:
                                        MaterialStateProperty.all(true),
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ElevatedButton(
                              onPressed: () {
                                provider.SetRooms(
                                    int.parse(selectedValue_room!));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.apricot,
                                minimumSize: const Size(88, 36),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                              ),
                              child: Text("Filter".toUpperCase()),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ));
    });
  }

  dialog_photo(provider, List<String> urls, cost, type, uid) {
    List<String> _urls = [];
    int im = 0;
    urls.forEach(
      (value) {
        if (value != '') {
          _urls.add(value);
          im = im + 1;
        }
      },
    );

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
                decoration: const BoxDecoration(
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
                    //----------------------------------------------- Features
                    // TabBar(
                    //   controller: _tabController,
                    //   tabs: [
                    //     Tab(icon: Icon(Icons.photo), text: 'Upload Photos'),
                    //     Tab(
                    //         icon: Icon(Icons.file_upload),
                    //         text: 'Upload Information'),
                    //     Tab(
                    //         icon: Icon(Icons.view_agenda),
                    //         text: 'Review Information'),
                    //   ],
                    // )
                  ],
                ),
              ),
              StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Phone: ${snapshot.data!.get('phone')}",
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
                  "House Type: ${type}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.apricot),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  "K ${cost.toString()}",
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
                    options: CarouselOptions(
                        height: MediaQuery.of(context).size.height / 4),
                    items: _urls.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              decoration:
                                  BoxDecoration(color: AppColors.dim_grey),
                              child: Image(image: NetworkImage(i)));
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

                      provider.SetDisableMapMove(true);
                    },
                    child: Text("Close")),
              )
            ],
          );
        }),
      ),
    );
  }
}
