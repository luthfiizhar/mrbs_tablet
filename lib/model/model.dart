import 'package:flutter/material.dart';
import 'package:mrbs_tablet/model/room_class.dart';

class MrbsTabletModel extends ChangeNotifier {
  Room _room = Room();

  String _time = "";

  get roomId => _room.roomId;
  get roomName => _room.roomName;
  get roomAlias => _room.roomAlias;
  get roomType => _room.roomType;
  get time => _time;

  void setRoom(Room value) {
    _room = value;
    notifyListeners();
  }

  void setRoomId(String value) {
    _room.roomId = value;
    notifyListeners();
  }

  void setRoomName(String value, String alias, String type) {
    _room.roomName = value;
    _room.roomAlias = alias;
    _room.roomType = type;
    notifyListeners();
  }

  void setRoomStatus(String value) {
    _room.status = value;
    notifyListeners();
  }

  void setTime(String value) {
    _time = value;
    notifyListeners();
  }
}
