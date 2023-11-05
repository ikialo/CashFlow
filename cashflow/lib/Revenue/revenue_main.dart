import 'dart:html';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cashflow/Revenue/dialog.dart';
import 'package:cashflow/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:web_smooth_scroll/web_smooth_scroll.dart';

class RevenueMain extends StatefulWidget {
  const RevenueMain({super.key});

  @override
  State<RevenueMain> createState() => _RevenueMainState();
}

class _RevenueMainState extends State<RevenueMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
