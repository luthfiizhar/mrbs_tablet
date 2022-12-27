import 'package:flutter/material.dart';
import 'package:mrbs_tablet/constant/color.dart';

class RoomEvent {
  RoomEvent({
    this.eventName = "",
    this.capacity = 0,
    this.from,
    this.to,
    this.background = eerieBlack,
    this.isDark = true,
    this.bookingID = "",
  });

  String? eventName;
  int? capacity;
  DateTime? from;
  DateTime? to;
  Color? background;
  bool isDark;
  String? bookingID;

  @override
  String toString() {
    return "eventName: $eventName, capacity: $capacity, from: ${from.toString()}, to: ${to.toString()}, color: ${background.toString()} ";
  }
}
