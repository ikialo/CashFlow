import 'dart:async';

import 'package:cashflow/state_manager.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class TabTwo extends StatefulWidget {
  const TabTwo({super.key});

  @override
  State<TabTwo> createState() => _TabTwoState();
}

class _TabTwoState extends State<TabTwo> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController name = TextEditingController();
  late TextEditingController number = TextEditingController();

  late MaterialStateColor _buttonColor;
  final List<String> items = [
    'House',
    'Apartment',
    'Duplex',
    'Bedsitter',
    'Land',
  ];
  String? selectedValue;
  late MaterialStatesController _statesController;

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
  void initState() {
    // TODO: implement initState
    _latLng = const LatLng(0.0, 0.0);
    _buttonColor = MaterialStateColor.resolveWith((states) => Colors.grey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Counter>(context);

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Monthly Rent';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          label: Text("Monthly Rental"),
                          prefixIcon: Icon(Icons.money)),
                    ),
                    TextFormField(
                      controller: number,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inter Number of Rooms';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          label: Text("How Many Rooms?"),
                          prefixIcon: Icon(Icons.meeting_room)),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonHideUnderline(
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
                                  color: Colors.yellow,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        items: items
                            .map((String item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
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
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.black26,
                            ),
                            color: Color.fromARGB(255, 0, 4, 255),
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
                            color: Color.fromARGB(255, 9, 140, 201),
                          ),
                          offset: const Offset(-20, 0),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: MaterialStateProperty.all(6),
                            thumbVisibility: MaterialStateProperty.all(true),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                          padding: EdgeInsets.only(left: 14, right: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Container(
                          width: 200,
                          child: ElevatedButton(
                            style: ButtonStyle(backgroundColor: _buttonColor),
                            onPressed: () async {
                              if (lat == 0.0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Select Propertity Location On Map")),
                                );
                              }
                              if (_formKey.currentState!.validate()) {
                                // If the form is valid, display a snackbar. In the real world,
                                // you'd often call a server or save the information in a database.
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   const SnackBar(content: Text("")),
                                // );

                                // //TODO: load to firebase.
                                // await users
                                //     .add({
                                //       'full_name': name.text, // John Doe
                                //       'phone': number.text, // Stokes and Sons
                                //     })
                                //     .then((value) => print("User Added"))
                                //     .catchError((error) =>
                                //         print("Failed to add user: $error"));

                                // Navigator.of(context).pushReplacement(
                                //   MaterialPageRoute(
                                //       builder: (context) => MyHomePage()),
                                // );

                                provider.setInfo(Information(
                                    lat,
                                    lng,
                                    double.parse(name.text),
                                    int.parse(number.text),
                                    selectedValue!));
                              }
                              provider.tabIndexDialog(2);
                            },
                            child: Text("Next".toUpperCase()),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Padding(
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
                        position: LatLng(lat, lng),
                      ),
                    },
                    onTap: (argument) {
                      setState(() {
                        lat = argument.latitude;
                        lng = argument.longitude;
                        _buttonColor = MaterialStateColor.resolveWith(
                            (states) => Colors.blue);
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Card(
                    elevation: 50,
                    shadowColor: Colors.black,
                    color: Color.fromARGB(255, 8, 128, 248),
                    child: SizedBox(
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Click Location of Property on the Map",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ), //SizedBox
                  ),
                ), //Card
              ],
            ),
          )
        ],
      ),
    );
  }
}
