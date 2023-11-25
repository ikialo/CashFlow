import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Counter with ChangeNotifier, DiagnosticableTreeMixin {
  int _count = 0;
  int _tab_index_dialog = 0;
  bool _diableMapMove = true;
  Information _info = Information(0, 0, 'House');
  List<Uint8List> _photos = [];
  MapInfo _mapInfo = MapInfo(-9.4790, 147.1494);
  int _rooms = 10;

  int get count => _count;
  List<Uint8List> get photos => _photos;
  Information get info => _info;
  int get tab_index_dialog => _tab_index_dialog;
  bool get disableMapMove => _diableMapMove;
  MapInfo get mapinfo => _mapInfo;
  int get rooms => _rooms;

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

  void SetMapInfo(mapinfo) {
    _mapInfo = mapinfo;
    notifyListeners();
  }

  void SetRooms(rooms) {
    _rooms = rooms;
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
  double cost = 0;
  int room = 0;
  String type = "House";

  Information(double cost, int room, String type) {
    this.cost = cost;
    this.room = room;
    this.type = type;
  }
}

class MapInfo {
  double lat = 0;
  double lng = 0;

  MapInfo(double lat, double lng) {
    this.lat = lat;
    this.lng = lng;
  }
}
