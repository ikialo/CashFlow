import 'dart:typed_data';

import 'package:cashflow/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';

class TabOne extends StatefulWidget {
  const TabOne({super.key});

  @override
  State<TabOne> createState() => _TabOneState();
}

class _TabOneState extends State<TabOne> {
  List<Uint8List> _photo = [];
  late StateSetter _setState;

  @override
  void initState() {
    _photo = [
      Uint8List(0),
      Uint8List(0),
      Uint8List(0),
      Uint8List(0),
      Uint8List(0),
      Uint8List(0)
    ];

    super.initState();
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
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

  Future imgFromGallery() async {
    _photo = [
      Uint8List(0),
      Uint8List(0),
      Uint8List(0),
      Uint8List(0),
      Uint8List(0),
      Uint8List(0)
    ];
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

        //uploadFile();
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Counter>(context);

    return Container(
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
                  ? Image.asset('assets/images/placeholder.png')
                  : Image.memory(_photo[0])),
              gridArea('2').containing(_photo[1].isEmpty
                  ? Image.asset('assets/images/placeholder.png')
                  : Image.memory(_photo[1])),
              // Column 2
              gridArea('3').containing(_photo[2].isEmpty
                  ? Image.asset('assets/images/placeholder.png')
                  : Image.memory(_photo[2])),
              gridArea('4').containing(_photo[3].isEmpty
                  ? Image.asset('assets/images/placeholder.png')
                  : Image.memory(_photo[3])),
              // Column 3

              gridArea('5').containing(_photo[4].isEmpty
                  ? Image.asset('assets/images/placeholder.png')
                  : Image.memory(_photo[4])),
              gridArea('6').containing(_photo[5].isEmpty
                  ? Image.asset('assets/images/placeholder.png')
                  : Image.memory(_photo[5])),
            ],
          ),
        ),
        ElevatedButton(
            onPressed: () {
              provider.setPhoto(_photo);
              provider.tabIndexDialog(1);
            },
            child: Text("Next"))
      ],
    ));
  }
}
