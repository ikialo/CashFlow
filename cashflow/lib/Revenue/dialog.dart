import 'dart:typed_data';

import 'package:cashflow/Revenue/tab2.dart';
import 'package:cashflow/Revenue/tab3.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';

import '../state_manager.dart';

class ServiceDialog extends StatefulWidget {
  const ServiceDialog({super.key});

  @override
  State<ServiceDialog> createState() => _ServiceDialogState();
}

class _ServiceDialogState extends State<ServiceDialog>
    with TickerProviderStateMixin {
  FirebaseStorage storage = FirebaseStorage.instance;

  late TabController _tabController;

  late List<Uint8List> _photo;
  late StateSetter _setState;

  static const cellRed = Color(0xffc73232);
  static const cellMustard = Color(0xffd7aa22);
  static const cellGrey = Color(0xffcfd4e0);
  static const cellBlue = Color(0xff1553be);
  static const background = Color(0xff242830);

  late ScrollController _scrollController;
  @override
  void initState() {
    // TODO: implement initState
    _photo = [
      Uint8List(0),
      Uint8List(0),
      Uint8List(0),
      Uint8List(0),
      Uint8List(0),
      Uint8List(0)
    ];

    _tabController = TabController(
        length: 3,
        vsync: this,
        initialIndex: 0,
        animationDuration: const Duration(milliseconds: 500));

    _scrollController = ScrollController();
    super.initState();
  }

  Future imgFromGallery() async {
    _photo = [
      Uint8List(0),
      Uint8List(0),
      Uint8List(0),
      Uint8List(0),
      Uint8List(0),
      Uint8List(0)
    ];
    print("error");
    List<Uint8List>? imageFiles = await ImagePickerWeb.getMultiImagesAsBytes();

    _setState(() {
      if (imageFiles != null) {
        int cnt = 0;
        imageFiles.forEach(
          (element) {
            _photo[cnt] = element;

            cnt++;
          },
        );

        print("photo was retrieved");
        //uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  // Future imgFromCamera() async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.camera);

  //   setState(() {
  //     if (pickedFile != null) {
  //       _photo = File(pickedFile.path);
  //       uploadFile();
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }

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

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      //imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: buyDialog(context),
    );
  }

  buyDialog(BuildContext context) {
    final provider = Provider.of<Counter>(context);

    return StatefulBuilder(builder: (context, setState) {
      _setState = setState;
      String contentText = "Upload Images";
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 10.0,
        child: Expanded(
          child: Container(
            height: MediaQuery.of(context).size.height - 200,
            // height: 23.5.h,
            // height: 210,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Consumer<Counter>(builder: (context, user, _) {
              _tabController.index = user.tab_index_dialog;
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.yellowAccent.shade100,
                          Colors.yellow,
                          Colors.yellow.shade600,
                          Colors.yellow.shade800,
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
                        Divider(color: Colors.yellow.shade800),
                        //----------------------------------------------- Features
                        TabBar(
                          controller: _tabController,
                          tabs: [
                            Tab(icon: Icon(Icons.photo), text: 'Upload Photos'),
                            Tab(
                                icon: Icon(Icons.file_upload),
                                text: 'Upload Information'),
                            Tab(
                                icon: Icon(Icons.view_agenda),
                                text: 'Review Information'),
                          ],
                        )
                      ],
                    ),
                  ),
                  //------------------------------------    Buy Now

                  Container(
                    height: 400,
                    child: Scaffold(
                      body: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _tabController,
                        children: [
                          Container(
                              child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _showPicker(context);
                                },
                                child: Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.blue,
                                    ), //Border.all
                                    borderRadius: BorderRadius.circular(15),
                                  ), //BoxDecoration

                                  child: Row(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Icon(Icons.camera),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text("Upload")
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 300,
                                width: 600,
                                child: LayoutGrid(
                                  columnGap: 1,
                                  rowGap: 1,
                                  areas: '''
                                                          1 3 5
                                                          2 4 6
                                                        ''',
                                  // A number of extension methods are provided for concise track sizing
                                  columnSizes: [199.px, 199.px, 199.px],
                                  rowSizes: [
                                    149.px,
                                    149.px,
                                  ],
                                  children: [
                                    // Column 1
                                    gridArea('1').containing(_photo[0].isEmpty
                                        ? Image.asset(
                                            'assets/images/placeholder.png')
                                        : Image.memory(_photo[0])),
                                    gridArea('2').containing(_photo[1].isEmpty
                                        ? Image.asset(
                                            'assets/images/placeholder.png')
                                        : Image.memory(_photo[1])),
                                    // Column 2
                                    gridArea('3').containing(_photo[2].isEmpty
                                        ? Image.asset(
                                            'assets/images/placeholder.png')
                                        : Image.memory(_photo[2])),
                                    gridArea('4').containing(_photo[3].isEmpty
                                        ? Image.asset(
                                            'assets/images/placeholder.png')
                                        : Image.memory(_photo[3])),
                                    // Column 3

                                    gridArea('5').containing(_photo[4].isEmpty
                                        ? Image.asset(
                                            'assets/images/placeholder.png')
                                        : Image.memory(_photo[4])),
                                    gridArea('6').containing(_photo[5].isEmpty
                                        ? Image.asset(
                                            'assets/images/placeholder.png')
                                        : Image.memory(_photo[5])),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    provider.setPhoto(_photo);
                                    _tabController.index = 1;
                                  },
                                  child: Text("Next"))
                            ],
                          )),
                          TabTwo(),
                          TabThree()
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      );
    });
  }
}
