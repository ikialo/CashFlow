import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Counter with ChangeNotifier, DiagnosticableTreeMixin {
  int _count = 0;
  int _tab_index_dialog = 0;
  bool _diableMapMove = true;
  Information _info = Information(0, 0, 0, 0, 'House');
  List<Uint8List> _photos = [
    Uint8List(0),
    Uint8List(0),
    Uint8List(0),
    Uint8List(0),
    Uint8List(0),
    Uint8List(0)
  ];

  int get count => _count;
  List<Uint8List> get photos => _photos;

  Information get info => _info;
  int get tab_index_dialog => _tab_index_dialog;

  bool get disableMapMove => _diableMapMove;

  void increment() {
    _count++;
    notifyListeners();
  }

  void setPhoto(photos) {
    _photos = photos;
    notifyListeners();
  }

  void setInfo(info) {
    _info = info;
    notifyListeners();
  }

  void tabIndexDialog(tab_index_dialog) {
    _tab_index_dialog = tab_index_dialog;
    notifyListeners();
  }

  void SetDisableMapMove(diableMapMove) {
    _diableMapMove = diableMapMove;
    notifyListeners();
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('count', count));
  }
}

class Information {
  double lat = 0;
  double lng = 0;
  double cost = 0;
  int room = 0;
  String type = "House";

  Information(double lat, double lng, double cost, int room, String type) {
    this.lat = lat;
    this.lng = lng;
    this.cost = cost;
    this.room = room;
    this.type = type;
  }
}
