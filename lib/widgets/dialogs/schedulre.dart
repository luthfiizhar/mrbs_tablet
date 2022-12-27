import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mrbs_tablet/constant/color.dart';
import 'package:mrbs_tablet/constant/text_style.dart';
import 'package:mrbs_tablet/model/model.dart';
import 'package:mrbs_tablet/model/room_event_class.dart';
import 'package:mrbs_tablet/model/room_event_data_source.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ScheduleDialog extends StatefulWidget {
  const ScheduleDialog({super.key});

  @override
  State<ScheduleDialog> createState() => _ScheduleDialogState();
}

class _ScheduleDialogState extends State<ScheduleDialog> {
  CalendarController _calendar = CalendarController();
  String today = "";

  List colors = [
    eerieBlack,
    davysGray,
    sonicSilver,
    spanishGray,
    grayx11,
    lightGray,
    platinum
  ];

  List contoh = ['1', '2', '3', '4', '5', '6', '7', '8'];
  int indexWarna = 0;

  RoomEventDataSource? events = RoomEventDataSource(<RoomEvent>[]);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var todayDateTime = DateTime.now();
    today = DateFormat('EEEE, d MMMM y').format(todayDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 500,
          maxWidth: 500,
          maxHeight: 800,
        ),
        child: Container(
          padding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 20,
            bottom: 20,
          ),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${Provider.of<MrbsTabletModel>(context).roomType}',
                style: helveticaText.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                  color: davysGray,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                '${Provider.of<MrbsTabletModel>(context).roomAlias}',
                style: const TextStyle(
                  fontFamily: 'Helvetica',
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  color: eerieBlack,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                today,
                style: const TextStyle(
                  fontFamily: 'Helvetica',
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                  color: davysGray,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                  // color: Colors.blue,
                  height: 380,
                  child: SfCalendar(
                    controller: _calendar,
                    onTap: (calendarTapDetails) {
                      if (calendarTapDetails.targetElement ==
                          CalendarElement.calendarCell) {
                        // print(calendarTapDetails.date);
                        // var hour = calendarTapDetails.date!.hour
                        //     .toString()
                        //     .padLeft(2, '0');
                        // var minute = calendarTapDetails.date!.minute
                        //     .toString()
                        //     .padLeft(2, '0');
                        // var startTime = "$hour:$minute";
                        // widget.setStartTime!(startTime);
                        // Navigator.pop(context);
                      }
                    },
                    appointmentBuilder: appointmentBuilder,
                    view: CalendarView.day,
                    initialDisplayDate: DateTime.now(),
                    dataSource: events,
                    timeSlotViewSettings: const TimeSlotViewSettings(
                      timeFormat: 'H:mm',
                      startHour: 5,
                      endHour: 20,
                      timeIntervalHeight: -1,
                      timeTextStyle: TextStyle(
                        fontFamily: 'Helvetica',
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: davysGray,
                      ),
                    ),
                    headerDateFormat: 'yMMMMd',
                    todayHighlightColor: eerieBlack,
                    viewNavigationMode: ViewNavigationMode.none,
                    headerHeight: 0,
                    viewHeaderHeight: 0,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget appointmentBuilder(BuildContext context,
      CalendarAppointmentDetails calendarAppointmentDetails) {
    final RoomEvent appointment = calendarAppointmentDetails.appointments.first;

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(10),
        height: double.infinity,
        width: 175,
        decoration: BoxDecoration(
          color: appointment.background,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              appointment.eventName!,
              style: TextStyle(
                fontFamily: 'Helvetica',
                fontSize: 14,
                color: appointment.isDark ? white : eerieBlack,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
