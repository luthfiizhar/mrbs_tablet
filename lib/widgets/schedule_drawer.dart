import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:mrbs_tablet/api_request.dart';
import 'package:mrbs_tablet/constant/color.dart';
import 'package:mrbs_tablet/constant/text_style.dart';
import 'package:mrbs_tablet/model/model.dart';
import 'package:mrbs_tablet/model/room_event_class.dart';
import 'package:mrbs_tablet/model/room_event_data_source.dart';
import 'package:mrbs_tablet/widgets/dialogs/alert_dialog.dart';
import 'package:mrbs_tablet/widgets/dialogs/detail_event_dialog.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ScheduleDrawer extends StatefulWidget {
  ScheduleDrawer({
    super.key,
    this.scaffoldKey,
    this.roomId = "",
  });

  final GlobalKey<ScaffoldState>? scaffoldKey;
  String roomId;

  @override
  State<ScheduleDrawer> createState() => _ScheduleDrawerState();
}

class _ScheduleDrawerState extends State<ScheduleDrawer> {
  ReqAPI apiReq = ReqAPI();
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
  bool isDark = true;

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
            empName: element['EmpName'],
            phoneNumber: element['PhoneNumber'],
            avaya: element['Avaya'],
            email: element['Email'],
            duration: element['Duration'],
            floor: element['AreaName'],
            date: element['Date'],
            roomName: element['RoomName'],
            location: element['RoomName'],
          ),
        );
        i++;
        indexWarna++;
      }

      print(events!.appointments!.toString());
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var todayDateTime = DateTime.now();
    today = DateFormat('EEEE, d MMMM y').format(todayDateTime);

    apiReq.getTabletSchedule(widget.roomId).then((value) async {
      print("GET SCHEDULE --> $value");
      if (value['Status'].toString() == "200") {
        dynamic result = value['Data'];
        await setDataToCalendar(result);
        events!.notifyListeners(
            CalendarDataSourceAction.reset, events!.appointments!);
        // SchedulerBinding.instance.addPostFrameCallback((duration) {
        //   setState(() {});
        // });
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialogWhite(
            title: value['Title'],
            contentText: value['Message'],
            isSuccess: false,
          ),
        );
      }
    }).onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (context) => AlertDialogWhite(
          title: 'Error',
          contentText: error.toString(),
          isSuccess: false,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 500,
        maxWidth: 500,
        // maxHeight: 800,
      ),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: 40,
              right: 40,
              top: 40,
              bottom: 40,
            ),
            decoration: const BoxDecoration(
              color: white,
              // borderRadius: BorderRadius.circular(10),
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
                  height: 15,
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
                  height: 15,
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
                            CalendarElement.calendarCell) {}
                        if (calendarTapDetails.targetElement ==
                            CalendarElement.appointment) {
                          print(calendarTapDetails.appointments);
                          showDialog(
                            context: context,
                            builder: (context) => DetailEventDialog(
                              roomEvent: calendarTapDetails.appointments!.first,
                            ),
                          );
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
                        timeInterval: const Duration(
                          minutes: 30,
                        ),
                        timeIntervalHeight: 100,
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
          ),
          Positioned(
            top: 25,
            right: 30,
            child: InkWell(
              onTap: () {
                widget.scaffoldKey!.currentState!.closeEndDrawer();
              },
              child: const ImageIcon(
                AssetImage('assets/icons/icon_close.png'),
              ),
            ),
          )
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
