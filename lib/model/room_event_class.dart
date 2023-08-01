import 'package:flutter/material.dart';
import 'package:mrbs_tablet/constant/color.dart';

class RoomEvent {
  RoomEvent({
    this.eventName = "",
    this.capacity = 0,
    DateTime? from,
    DateTime? to,
    this.background = eerieBlack,
    this.isDark = true,
    this.bookingID = "",
    this.empName = "",
    this.location = "",
    this.floor = "",
    this.roomName = "",
    this.duration = "",
    this.date = "",
    this.phoneNumber = "",
    this.avaya = "",
    this.email = "",
  })  : from = from ?? DateTime.now(),
        to = to ?? DateTime.now();

  String? eventName;
  int? capacity;
  DateTime? from;
  DateTime? to;
  Color? background;
  bool isDark;
  String? bookingID;
  String empName;
  String location;
  String floor;
  String roomName;
  String duration;
  String date;
  String avaya;
  String phoneNumber;
  String email;

  @override
  String toString() {
    return "eventName: $eventName, capacity: $capacity, from: ${from.toString()}, to: ${to.toString()}, color: ${background.toString()} ";
  }
}
