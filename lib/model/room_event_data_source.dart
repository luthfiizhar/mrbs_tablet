import 'package:flutter/material.dart';
import 'package:mrbs_tablet/model/room_event_class.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class RoomEventDataSource extends CalendarDataSource {
  // RoomEventDataSource(
  //     List<Appointment> source, List<CalendarResource> resourceColl) {
  //   appointments = source;
  //   resources = resourceColl;
  // }
  RoomEventDataSource(List<RoomEvent> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  // @override
  // String getStartTimeZone(int index) {
  //   return appointments![index].startTimeZone;
  // }

  // @override
  // String getEndTimeZone(int index) {
  //   return appointments![index].endTimeZone;
  // }

  // @override
  // Color getColor(int index) {
  //   return appointments![index].background;
  // }

  // @override
  // List<Object> getResourceIds(int index) {
  //   return appointments![index].resourceIds;
  // }

  // @override
  // String getRecurrenceRule(int index) {
  //   return appointments![index].recurrenceRule;
  // }
}
