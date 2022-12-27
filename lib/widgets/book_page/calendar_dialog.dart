import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:mrbs_tablet/api_request.dart';
import 'package:mrbs_tablet/constant/color.dart';
import 'package:mrbs_tablet/constant/text_style.dart';
import 'package:mrbs_tablet/model/model.dart';
import 'package:mrbs_tablet/model/room_event_class.dart';
import 'package:mrbs_tablet/model/room_event_data_source.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarDialog extends StatefulWidget {
  const CalendarDialog({super.key});

  @override
  State<CalendarDialog> createState() => _CalendarDialogState();
}

class _CalendarDialogState extends State<CalendarDialog> {
  String roomId = "";
  CalendarController _calendar = CalendarController();
  bool isDark = true;

  String today = "";

  List timeList = [];
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

  setDataToCalendar(dynamic result) {
    setState(() {
      int i = 0;
      for (var element in result) {
        print('loop');
        if (i % 7 == 0) {
          indexWarna = 0;
        }
        if (indexWarna > 3) {
          isDark = false;
        }
        events!.appointments!.add(
          RoomEvent(
            from: DateTime.parse(element['StartDateTime']),
            to: DateTime.parse(element['EndDateTime']),
            background: colors[indexWarna],
            isDark: isDark,
            bookingID: element['BookingID'],
            eventName: element['Summary'],
          ),
        );
        i++;
        indexWarna++;
      }

      print(events!.appointments!.toString());
    });
  }

  Future getRoomData() async {
    var box = await Hive.openBox('RoomInfo');
    var room = box.get('roomId');
    // box.put('roomName', name);
    setState(() {
      roomId = room;
    });
  }

  @override
  void initState() {
    super.initState();
    var todayDateTime = DateTime.now();
    today = DateFormat('EEEE, d MMMM y').format(todayDateTime);
    getRoomData().then((value) {
      getTabletSchedule(roomId).then((value) async {
        dynamic result = value['Data'];
        await setDataToCalendar(result);
        events!.notifyListeners(
            CalendarDataSourceAction.reset, events!.appointments!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 40,
        right: 40,
        top: 40,
        bottom: 40,
      ),
      height: 800,
      width: 510,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   '${Provider.of<MrbsTabletModel>(context).roomType}',
          //   style: helveticaText.copyWith(
          //     fontSize: 24,
          //     fontWeight: FontWeight.w300,
          //     color: davysGray,
          //   ),
          // ),
          // const SizedBox(
          //   height: 15,
          // ),
          Text(
            '${Provider.of<MrbsTabletModel>(context).roomAlias} Schedule',
            style: const TextStyle(
              fontFamily: 'Helvetica',
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: eerieBlack,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            today,
            style: const TextStyle(
              fontFamily: 'Helvetica',
              fontSize: 18,
              fontWeight: FontWeight.w300,
              color: davysGray,
            ),
          ),
          const SizedBox(
            height: 20,
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
                timeSlotViewSettings: TimeSlotViewSettings(
                  timeFormat: 'H:mm',
                  startHour: 5.5,
                  endHour: 19.5,
                  timeInterval: Duration(
                    minutes: 30,
                  ),
                  timeIntervalHeight: 75,
                  timeTextStyle: helveticaText.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: davysGray,
                  ),
                ),
                headerDateFormat: 'yMMMMd',
                todayHighlightColor: orangeAccent,
                viewNavigationMode: ViewNavigationMode.none,
                headerHeight: 0,
                viewHeaderHeight: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget appointmentBuilder(BuildContext context,
      CalendarAppointmentDetails calendarAppointmentDetails) {
    final RoomEvent appointment = calendarAppointmentDetails.appointments.first;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(10),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: appointment.background,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
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
