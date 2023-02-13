import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mrbs_tablet/api_request.dart';
import 'package:mrbs_tablet/constant/color.dart';
import 'package:mrbs_tablet/constant/text_style.dart';
import 'package:mrbs_tablet/model/event_class.dart';
import 'package:mrbs_tablet/model/facility.dart';
import 'package:mrbs_tablet/model/model.dart';
import 'package:mrbs_tablet/model/room_class.dart';
import 'package:mrbs_tablet/pages/book_page.dart';
import 'package:mrbs_tablet/widgets/buttons/regular_button.dart';
import 'package:mrbs_tablet/widgets/clock.dart';
import 'package:mrbs_tablet/widgets/dialogs/alert_dialog.dart';
import 'package:mrbs_tablet/widgets/dialogs/booking_page_input_nip.dart';
import 'package:mrbs_tablet/widgets/dialogs/check_in_nip_dialog.dart';
import 'package:mrbs_tablet/widgets/dialogs/initiate_room_dialog.dart';
import 'package:mrbs_tablet/widgets/dialogs/schedulre.dart';
import 'package:mrbs_tablet/widgets/schedule_drawer.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference mrbsRef = FirebaseDatabase.instance.ref();
  ReqAPI apiReq = ReqAPI();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  bool isLoadingChangeStatus = true;
  bool isNextMeetingChange = false;

  String today = "";
  String status = "Available";

  String nip = "";

  String roomName = "";
  String roomAlias = "";
  String roomType = "";
  String roomCapacity = "";

  String bookingId = "";
  String bookingOrigin = "MRBS";

  String roomId = "MR-22";

  String summary = "";
  String empName = "";
  String empNip = "";
  String duration = "";
  String nextMeetingSummary = "";
  String nextMeetingBookingID = "";
  String nextMeetingDuration = "";
  String nextMeetingEmpName = "";
  String nextMeetingEmpNip = "";
  String nextMeetingRoomId = "";

  List defaultFacility = [];
  List<Widget> listIconFacility = const [
    ImageIcon(
      AssetImage('assets/icons/icon_tv.png'),
    ),
    ImageIcon(
      AssetImage('assets/icons/icon_video_cam.png'),
    ),
    ImageIcon(
      AssetImage('assets/icons/icon_google.png'),
    ),
  ];

  Future getData() async {
    DatabaseEvent event =
        await mrbsRef.child('MR-1').orderByChild('Date').equalTo(today).once();
    var snapshot = event.snapshot;
    List eventList = [];
    List<Event> eventData = [];

    for (var element in snapshot.children) {
      eventList.add(element.value);
    }
    for (var element in eventList) {
      eventData.add(
        Event(
          bookingId: element['BookingID'],
          roomId: element['RoomID'],
          date: element['Date'],
          empName: element['EmpName'],
          empNip: element['EmpNIP'],
          startTime: element['StartTime'],
          endTime: element['EndTime'],
          status: element['Status'],
          summary: element['Summary'],
        ),
      );
    }
    eventData.sort((a, b) => a.startTime!.compareTo(b.startTime!));
    var data = eventData.where((element) =>
        DateTime.parse(element.startTime!).compareTo(DateTime.now()) > 0);
    Provider.of<MrbsTabletModel>(context, listen: false)
        .setRoomId(eventData.first.roomId!);
    print(data.toString());
  }

  Future checkRoomId() async {
    var box = await Hive.openBox('room');
    var roomId = box.get('roomId') != "" ? box.get('roomId') : "";

    return roomId;
  }

  Future saveRoomData(String id, String name) async {
    var box = await Hive.openBox('room');
    box.put('roomId', id);
    box.put('roomName', name);
  }

  Future getRoomData() async {
    var box = await Hive.openBox('RoomInfo');
    var room = box.get('roomId');
    // box.put('roomName', name);
    // print(room);
    setState(() {
      roomId = room;
      print("RoomID -> $roomId");
    });
    return room;
  }

  submitCheckIn() {
    print(nip);
    setState(() {
      isLoadingChangeStatus = true;
    });

    // apiReq.checkIn(bookingId, nip).then(
    //   (value) {
    //     nip = "";
    //     print(value);
    //     if (value['Status'] == "200") {
    //       showDialog(
    //         context: context,
    //         builder: (context) => AlertDialogWhite(
    //           title: value['Title'],
    //           contentText: value['Message'],
    //         ),
    //       );
    //     } else {
    //       setState(() {
    //         isLoadingChangeStatus = false;
    //       });
    //       showDialog(
    //         context: context,
    //         builder: (context) => AlertDialogWhite(
    //           title: value['Title'],
    //           contentText: value['Message'],
    //           isSuccess: false,
    //         ),
    //       );
    //     }
    //     // setState(() {
    //     //   isLoadingChangeStatus = false;
    //     // });
    //   },
    // ).onError((error, stackTrace) {
    //   showDialog(
    //     context: context,
    //     builder: (context) => AlertDialogWhite(
    //       title: 'Error',
    //       contentText: error.toString(),
    //       isSuccess: false,
    //     ),
    //   );
    // });
  }

  submitCheckOut() {
    print(nip);
    setState(() {
      isLoadingChangeStatus = true;
    });

    apiReq.checkOut(bookingId, nip).then(
      (value) {
        nip = "";
        print(value);
        if (value['Status'] == "200") {
          showDialog(
            context: context,
            builder: (context) => AlertDialogWhite(
              title: value['Title'],
              contentText: value['Message'],
            ),
          );
        } else {
          setState(() {
            isLoadingChangeStatus = false;
          });
          showDialog(
            context: context,
            builder: (context) => AlertDialogWhite(
              title: value['Title'],
              contentText: value['Message'],
              isSuccess: false,
            ),
          );
        }
        // setState(() {
        //   isLoadingChangeStatus = false;
        // });
      },
    ).onError((error, stackTrace) {
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

  setNip(String value, bool isCheckin) {
    nip = value;
    print(nip);
    if (isCheckin) {
      submitCheckIn();
    } else {
      submitCheckOut();
    }
  }
  // Future setStatusRoom() async {
  //   DatabaseEvent event =
  //       await mrbsRef.child('MR-1').orderByChild('Date').equalTo(today).once();
  //   var snapshot = event.snapshot;
  //   List eventList = [];
  //   List<Event> eventData = [];

  //   for (var element in snapshot.children) {
  //     eventList.add(element.value);
  //   }
  //   for (var element in eventList) {
  //     eventData.add(
  //       Event(
  //         bookingId: element['BookingID'],
  //         roomId: element['RoomID'],
  //         date: element['Date'],
  //         empName: element['EmpName'],
  //         empNip: element['EmpNIP'],
  //         startTime: element['StartTime'],
  //         endTime: element['EndTime'],
  //         status: element['Status'],
  //         summary: element['Summary'],
  //       ),
  //     );
  //   }
  //   Provider.of<MrbsTabletModel>(context, listen: false)
  //       .setRoomId(eventData.first.roomId!);

  //   print(eventData.toString());
  // }

  void statusListener(Object data) {
    if (mounted) {
      setState(() {
        var detail = Room.fromJson(Map<String, dynamic>.from(data as dynamic));

        // Provider.of<MrbsTabletModel>(context, listen: false).setRoom(detail);
        status = detail.status!;
        bookingId = detail.bookingId!;
        summary = detail.summary!;
        duration = detail.duration!;
        empName = detail.empName!;
        empNip = detail.empNip!;

        isLoadingChangeStatus = false;
        print(detail);
      });
    }
  }

  void nextMeetingListener(Object data) {
    if (mounted) {
      setState(() {
        print(data);
        var detail = Room.fromJson(Map<String, dynamic>.from(data as dynamic));
        summary = detail.summary!;
        bookingId = detail.bookingId!;
        duration = detail.duration!;
        empName = detail.empName!;
        roomId = detail.roomId!;
        bookingOrigin = detail.bookingOrigin!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Wakelock.toggle(enable: true);
    getRoomData().then((value) {
      print(value);
      today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      mrbsRef.child('$roomId/StatusRoom').onValue.listen((event) {
        statusListener(event.snapshot.value!);
      });
      mrbsRef.child('$roomId/NextMeeting').onValue.listen((event) {
        nextMeetingListener(event.snapshot.value!);
      });
      apiReq.getDetailRoom(roomId).then((value) async {
        print(value);
        setState(() {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            // auth = Provider.of<Auth>(context, listen: false);
            Provider.of<MrbsTabletModel>(context, listen: false).setRoomName(
                value['Data']['RoomName'],
                value['Data']['RoomAlias'] ?? "",
                value['Data']['RoomTypeName']);
          });

          roomName = value['Data']['RoomAlias'] ?? "";
          roomType = value['Data']['RoomTypeName'];
          roomCapacity = value['Data']['MaxCapacity'].toString();
          defaultFacility = value['Data']['DefaultAmenities'];
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MrbsTabletModel>(builder: (context, model, child) {
      return Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        endDrawer: ScheduleDrawer(
          scaffoldKey: scaffoldKey,
          roomId: roomId,
        ),
        body: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: Container(
              color: white,
              // decoration: const BoxDecoration(
              //   image: DecorationImage(
              //       image: AssetImage('assets/BG.png'), fit: BoxFit.cover),
              // ),
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
                vertical: 30,
              ),
              child: Container(
                // color: Colors.blueGrey,
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    header(),
                    const SizedBox(
                      height: 75,
                    ),
                    roomInfo(),
                    const SizedBox(
                      height: 30,
                    ),
                    Builder(
                      builder: (context) {
                        switch (roomType) {
                          case "Meeting Room":
                            return Column(
                              children: [
                                statusInfo(),
                                const SizedBox(
                                  height: 30,
                                ),
                                timeInfo(),
                              ],
                            );
                          case "Auditorium":
                            return statusInfoAudi();
                          default:
                            return Column(
                              children: [
                                statusInfo(),
                                const SizedBox(
                                  height: 30,
                                ),
                                timeInfo(),
                              ],
                            );
                        }
                      },
                    ),
                  ],
                ),
                // child: Stack(
                //   children: [
                //     Center(
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.start,
                //             children: [
                //               SizedBox(
                //                 width: 100,
                //                 child: Text(
                //                   roomType,
                //                   style: helveticaText.copyWith(
                //                     fontSize: 24,
                //                     color: scaffoldBg,
                //                     height: 1.3,
                //                   ),
                //                   maxLines: 2,
                //                   textAlign: TextAlign.right,
                //                 ),
                //               ),
                //               const SizedBox(
                //                 width: 20,
                //               ),
                //               InkWell(
                //                 onTap: () {
                //                   showDialog(
                //                     context: context,
                //                     builder: (context) => InitiateRoomDialog(),
                //                   ).then((value) {
                //                     // roomId = model.roomId;
                //                     getDetailRoom(model.roomId)
                //                         .then((value) async {
                //                       print(value);

                //                       setState(() {
                //                         model.setRoomName(
                //                             value['Data']['RoomName']);
                //                         roomName = value['Data']['RoomName'];
                //                         roomType = value['Data']['RoomTypeName'];
                //                         roomCapacity = value['Data']
                //                                 ['MaxCapacity']
                //                             .toString();
                //                       });
                //                     });
                //                   });
                //                 },
                //                 child: Text(
                //                   roomName,
                //                   style: arialText.copyWith(
                //                     fontSize: 69,
                //                     fontWeight: FontWeight.w900,
                //                     color: scaffoldBg,
                //                   ),
                //                 ),
                //               )
                //             ],
                //           ),
                //           const SizedBox(
                //             height: 5,
                //           ),
                //           Container(
                //             width: 180,
                //             height: 45,
                //             decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(30),
                //               border: Border.all(
                //                 color: scaffoldBg,
                //               ),
                //             ),
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               crossAxisAlignment: CrossAxisAlignment.center,
                //               children: [
                //                 const Icon(
                //                   Icons.people,
                //                   color: scaffoldBg,
                //                 ),
                //                 const SizedBox(
                //                   width: 15,
                //                 ),
                //                 Text(
                //                   'Up to $roomCapacity',
                //                   style: helveticaText.copyWith(
                //                     fontSize: 24,
                //                     fontWeight: FontWeight.w300,
                //                     color: scaffoldBg,
                //                   ),
                //                 )
                //               ],
                //             ),
                //           ),
                //           const SizedBox(
                //             height: 75,
                //           ),
                //           isLoadingChangeStatus
                //               ? const Center(
                //                   child: SizedBox(
                //                     height: 100,
                //                     width: 100,
                //                     child: CircularProgressIndicator(
                //                       color: greenAcent,
                //                     ),
                //                   ),
                //                 )
                //               : Builder(
                //                   builder: (context) {
                //                     switch (status) {
                //                       case "Available":
                //                         return availableWidget();
                //                       case "Waiting":
                //                         return waitingWidget();
                //                       case "In Use":
                //                         return inUseWidget();
                //                       default:
                //                         return availableWidget();
                //                     }
                //                   },
                //                 ),
                //           // inUseWidget(),
                //           // availableWidget(),
                //           // waitingWidget(),
                //           // Row(
                //           //   children: [
                //           //     ElevatedButton(
                //           //       onPressed: () {
                //           //         setStatusRoom();
                //           //       },
                //           //       child: Text('Get Data'),
                //           //     ),
                //           //   ],
                //           // ),
                //           // ElevatedButton(
                //           //   onPressed: () {
                //           //     showDialog(
                //           //       context: context,
                //           //       builder: (context) => CheckInOutNipDialog(
                //           //           setNip: setNip, submit: submitCheckIn),
                //           //     );
                //           //     // Navigator.push(
                //           //     //     context,
                //           //     //     MaterialPageRoute(
                //           //     //       builder: (context) => BookingPage(
                //           //     //         roomId: roomId,
                //           //     //         roomName: roomName,
                //           //     //       ),
                //           //     //     )).then((value) {
                //           //     //   setState(() {});
                //           //     // });
                //           //   },
                //           //   child: Text('button test'),
                //           // ),
                //         ],
                //       ),
                //     ),
                //     Positioned(
                //       bottom: 0,
                //       left: 0,
                //       child: CustomDigitalClock(
                //         time: model.time,
                //         checkDb: getData,
                //       ),
                //     ),
                //     Positioned(
                //       bottom: 0,
                //       right: 0,
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.end,
                //         children: [
                //           Text(
                //             'Next Meeting:',
                //             style: helveticaText.copyWith(
                //               fontSize: 32,
                //               fontWeight: FontWeight.w700,
                //               color: scaffoldBg,
                //             ),
                //           ),
                //           const SizedBox(
                //             height: 15,
                //           ),
                //           Container(
                //             decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(20),
                //               border: Border.all(color: scaffoldBg, width: 1),
                //             ),
                //             padding: const EdgeInsets.symmetric(
                //               horizontal: 25,
                //               vertical: 8,
                //             ),
                //             child: Text(
                //               nextMeeting,
                //               style: helveticaText.copyWith(
                //                 fontSize: 22,
                //                 fontWeight: FontWeight.w300,
                //                 color: scaffoldBg,
                //               ),
                //             ),
                //           ),
                //           const SizedBox(
                //             height: 15,
                //           ),
                //           Container(
                //             decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(20),
                //               border: Border.all(color: scaffoldBg, width: 1),
                //             ),
                //             padding: const EdgeInsets.symmetric(
                //               horizontal: 25,
                //               vertical: 8,
                //             ),
                //             child: Text(
                //               'View Schedule',
                //               style: helveticaText.copyWith(
                //                 fontSize: 22,
                //                 fontWeight: FontWeight.w300,
                //                 color: scaffoldBg,
                //               ),
                //             ),
                //           )
                //         ],
                //       ),
                //     ),
                //     Positioned(
                //       top: 10,
                //       right: -50,
                //       child: SizedBox(
                //         width: 300,
                //         height: 75,
                //         child: FittedBox(
                //           fit: BoxFit.cover,
                //           child: SvgPicture.asset(
                //             'assets/klg_logo_tagline_white.svg',
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget header() {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 185,
                height: 60,
                child: Image.asset(
                  'assets/navbarlogo.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(
                height: 35,
                child: VerticalDivider(
                  color: davysGray,
                  thickness: 1,
                ),
              ),
              const SizedBox(
                width: 13,
              ),
              Text(
                'Meeting Room Booking System',
                style: helveticaText.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: davysGray,
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => InitiateRoomDialog(),
              );
            },
            child: const Icon(
              Icons.settings_outlined,
              color: eerieBlack,
              size: 40,
            ),
          )
        ],
      ),
    );
  }

  Widget roomInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      // color: greenAcent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            roomName,
            style: helveticaText.copyWith(
              fontSize: 128,
              color: eerieBlack,
              fontWeight: FontWeight.w900,
              height: 0,
              // backgroundColor: violetAccent,
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: eerieBlack),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 100,
                minHeight: 30,
                maxHeight: 30,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Visibility(
                    visible: defaultFacility.isEmpty ? false : true,
                    child: Row(
                      children: [
                        Wrap(
                          spacing: 10,
                          children: defaultFacility
                              .asMap()
                              .map(
                                (index, element) => MapEntry(
                                  index,
                                  listIconFacility[index],
                                ),
                              )
                              .values
                              .toList(),
                        ),
                        const SizedBox(
                          width: 18,
                        ),
                        const VerticalDivider(
                          color: davysGray,
                          thickness: 1,
                        ),
                        const SizedBox(
                          width: 18,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const ImageIcon(
                        AssetImage('assets/icons/icon_group.png'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        roomCapacity,
                        style: helveticaText.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  statusInfo() {
    return Builder(
      builder: (context) {
        switch (status) {
          case "Available":
            return availableWidget();
          case "In Use":
            return inUseWidget();
          case "Waiting":
            return waitingWidget();
          default:
            return availableWidget();
        }
      },
    );
  }

  Widget statusInfoAudi() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 140,
              width: 450,
              padding: const EdgeInsets.only(
                // top: 40,
                // left: 50,
                bottom: 20,
              ),
              decoration: BoxDecoration(
                color: status == "In Use" ? orangeAccent : greenAcent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  status,
                  style: blackHelveText.copyWith(
                    fontSize: 64,
                    color: white,
                    height: 0,
                    // backgroundColor: violetAccent,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 35,
                vertical: 15,
              ),
              child: CustomDigitalClock(
                time: Provider.of<MrbsTabletModel>(context).time,
              ),
            )
          ],
        ),
        Container(
          width: 700,
          height: 337,
          padding: const EdgeInsets.only(
            left: 40,
            right: 40,
            top: 35,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: platinum, width: 1),
            borderRadius: BorderRadius.circular(10),
            color: white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today Schedule:',
                style: helveticaText.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: eerieBlack,
                ),
              ),
              SizedBox(
                height: duration == "-" ? 40 : 22,
              ),
              duration == "-" || summary == "-" || empName == "-"
                  ? Text(
                      'No event for today. Please book at website to use this room.',
                      style: helveticaText.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                        color: davysGray,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          duration,
                          style: helveticaText.copyWith(
                            fontSize: 36,
                            fontWeight: FontWeight.w300,
                            color: davysGray,
                          ),
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                summary,
                                style: helveticaText.copyWith(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: davysGray,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                'by $empName',
                                style: helveticaText.copyWith(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w300,
                                  color: davysGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
              const SizedBox(
                height: 39,
              ),
              TransparentBorderedBlackButton(
                text: 'See Schedule',
                disabled: false,
                onTap: () {},
                padding: ButtonSize().scheduleButton(),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget inUseWidget() {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 140,
        maxHeight: 140,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: orangeAccent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  // top: 40,
                  left: 50,
                  bottom: 20,
                ),
                child: Text(
                  'In Use',
                  style: blackHelveText.copyWith(
                    fontSize: 64,
                    color: white,
                    height: 0,
                    // backgroundColor: violetAccent,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                //CHECK OUT
                showDialog(
                  context: context,
                  builder: (context) => CheckInOutNipDialog(
                    bookingId: bookingId,
                    setNip: setNip,
                    submit: submitCheckOut,
                    isIn: false,
                  ),
                );
              },
              child: Container(
                width: 350,
                decoration: const BoxDecoration(
                  color: eerieBlack,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Check Out',
                    style: helveticaText.copyWith(
                      fontSize: 48,
                      fontWeight: FontWeight.w300,
                      color: white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget availableWidget() {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 140,
        maxHeight: 140,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: greenAcent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  // top: 40,
                  left: 50,
                  bottom: 20,
                ),
                child: Text(
                  'Available',
                  style: blackHelveText.copyWith(
                    fontSize: 64,
                    color: white,
                    height: 0,
                    // backgroundColor: violetAccent,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BookingPage(
                      roomId: roomId,
                      roomName: roomName,
                      today: DateTime.now(),
                    ),
                  ),
                );
                // showDialog(
                //   context: context,
                //   builder: (context) => CheckInOutNipDialog(
                //     setNip: setNip,
                //     submit: () {},
                //   ),
                // );
              },
              child: Container(
                width: 350,
                decoration: const BoxDecoration(
                  color: eerieBlack,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Book Now',
                    style: helveticaText.copyWith(
                      fontSize: 48,
                      fontWeight: FontWeight.w300,
                      color: white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: [
    //     Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Text(
    //           'Available',
    //           style: arialText.copyWith(
    //             fontSize: 120,
    //             color: scaffoldBg,
    //             fontWeight: FontWeight.w900,
    //           ),
    //         ),
    //         const SizedBox(
    //           height: 10,
    //         ),
    //         Text(
    //           'Not in use',
    //           style: helveticaText.copyWith(
    //             fontSize: 32,
    //             fontWeight: FontWeight.w300,
    //             color: scaffoldBg,
    //           ),
    //         ),
    //       ],
    //     ),
    //     ElevatedButton(
    //       style: ButtonStyle(
    //         backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
    //           return greenAcent.withOpacity(0.8);
    //         }),
    //         shape: MaterialStateProperty.resolveWith<OutlinedBorder>((states) {
    //           return RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(80),
    //           );
    //         }),
    //         padding: MaterialStateProperty.resolveWith<EdgeInsets>((states) {
    //           return const EdgeInsets.symmetric(
    //             horizontal: 50,
    //             vertical: 25,
    //           );
    //         }),
    //       ),
    //       onPressed: () {
    //         Navigator.of(context).push(
    //           MaterialPageRoute(
    //             builder: (context) => BookingPage(
    //               roomId: roomId,
    //               roomName: roomName,
    //               today: DateTime.now(),
    //             ),
    //           ),
    //         );
    //       },
    //       child: Text(
    //         'Book Now',
    //         style: helveticaText.copyWith(
    //           fontSize: 56,
    //           fontWeight: FontWeight.w700,
    //           color: scaffoldBg,
    //           height: 1.3,
    //         ),
    //       ),
    //     )
    //   ],
    // );
  }

  Widget waitingWidget() {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 140,
        maxHeight: 140,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: yellow,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  // top: 40,
                  left: 50,
                  bottom: 20,
                ),
                child: Text(
                  'Waiting',
                  style: blackHelveText.copyWith(
                    fontSize: 64,
                    color: white,
                    height: 0,
                    // backgroundColor: violetAccent,
                  ),
                ),
              ),
            ),
            Container(
              width: 465,
              decoration: const BoxDecoration(
                color: eerieBlack,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        //CHECK IN
                        print(bookingId);
                        showDialog(
                          context: context,
                          builder: (context) => CheckInOutNipDialog(
                            setNip: setNip,
                            submit: submitCheckIn,
                            bookingId: bookingId,
                            bookingOrigin: bookingOrigin,
                          ),
                        );
                      },
                      child: Text(
                        'Check In',
                        style: helveticaText.copyWith(
                          fontSize: 48,
                          fontWeight: FontWeight.w300,
                          color: white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 48,
                    ),
                    const SizedBox(
                      height: 55,
                      child: VerticalDivider(
                        color: white,
                        thickness: 1,
                      ),
                    ),
                    const SizedBox(
                      width: 48,
                    ),
                    InkWell(
                      onTap: () {
                        print('Cancel');
                      },
                      child: const Icon(
                        Icons.close_sharp,
                        size: 50,
                        color: white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: [
    //     Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Text(
    //           'Waiting',
    //           style: arialText.copyWith(
    //             fontSize: 125,
    //             color: grayx11,
    //             fontWeight: FontWeight.w900,
    //           ),
    //         ),
    //         const SizedBox(
    //           height: 10,
    //         ),
    //         Text(
    //           'Booked by Luthfi Izhariman - 169742',
    //           style: helveticaText.copyWith(
    //             fontSize: 32,
    //             fontWeight: FontWeight.w700,
    //             color: scaffoldBg,
    //           ),
    //         ),
    //         const SizedBox(
    //           height: 10,
    //         ),
    //         Text(
    //           summary,
    //           style: helveticaText.copyWith(
    //             fontSize: 32,
    //             fontWeight: FontWeight.w300,
    //             color: scaffoldBg,
    //           ),
    //         ),
    //       ],
    //     ),
    //     Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         ElevatedButton(
    //           style: ButtonStyle(
    //             backgroundColor:
    //                 MaterialStateProperty.resolveWith<Color>((states) {
    //               return greenAcent.withOpacity(0.8);
    //             }),
    //             shape:
    //                 MaterialStateProperty.resolveWith<OutlinedBorder>((states) {
    //               return RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(80),
    //               );
    //             }),
    //             padding:
    //                 MaterialStateProperty.resolveWith<EdgeInsets>((states) {
    //               return const EdgeInsets.symmetric(
    //                 horizontal: 50,
    //                 vertical: 25,
    //               );
    //             }),
    //           ),
    //           onPressed: () {
    //             // setState(() {
    //             //   isLoadingChangeStatus = true;
    //             // });
    //             print(bookingId);
    //             showDialog(
    //               context: context,
    //               builder: (context) => CheckInOutNipDialog(
    //                   setNip: setNip, submit: submitCheckIn),
    //             );
    //             // checkIn(bookingId,nip).then((value) {
    //             //   print(value);
    //             // }).onError((error, stackTrace) {});
    //           },
    //           child: Text(
    //             'Check In',
    //             style: helveticaText.copyWith(
    //               fontSize: 56,
    //               fontWeight: FontWeight.w700,
    //               color: scaffoldBg,
    //             ),
    //           ),
    //         ),
    //         const SizedBox(
    //           height: 20,
    //         ),
    //         ElevatedButton(
    //           style: ButtonStyle(
    //             backgroundColor:
    //                 MaterialStateProperty.resolveWith<Color>((states) {
    //               return grayx11.withOpacity(0.8);
    //             }),
    //             shape:
    //                 MaterialStateProperty.resolveWith<OutlinedBorder>((states) {
    //               return RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(80),
    //               );
    //             }),
    //             padding:
    //                 MaterialStateProperty.resolveWith<EdgeInsets>((states) {
    //               return const EdgeInsets.symmetric(
    //                 horizontal: 55,
    //                 vertical: 15,
    //               );
    //             }),
    //           ),
    //           onPressed: () {},
    //           child: Text(
    //             'Cancel Booking',
    //             style: helveticaText.copyWith(
    //               fontSize: 32,
    //               fontWeight: FontWeight.w700,
    //               color: scaffoldBg,
    //             ),
    //           ),
    //         ),
    //       ],
    //     )
    //   ],
    // );
  }

  Widget timeInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(
              left: 35,
              top: 30,
              bottom: 26,
            ),
            child: CustomDigitalClock(
              time: Provider.of<MrbsTabletModel>(context).time,
            ),
          ),
        ),
        const SizedBox(
          width: 40,
        ),
        Container(
          width: 840,
          height: 167,
          padding: const EdgeInsets.only(
            top: 30,
            left: 40,
            right: 30,
            bottom: 22,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: platinum, width: 1),
            color: white,
          ),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: duration == "-"
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  duration == "-"
                      ? const SizedBox()
                      : Column(
                          children: [
                            Text(
                              duration,
                              style: helveticaText.copyWith(
                                fontSize: 40,
                                fontWeight: FontWeight.w300,
                                color: davysGray,
                              ),
                            ),
                            const SizedBox(
                              height: 13,
                            ),
                          ],
                        ),
                  TransparentBorderedBlackButton(
                    text: 'See Schedule',
                    disabled: false,
                    onTap: () {
                      // showDialog(
                      //   context: context,
                      //   builder: (context) => ScheduleDialog(),
                      // );
                      // Scaffold.of(context).openEndDrawer();
                      scaffoldKey.currentState!.openEndDrawer();
                    },
                    padding: ButtonSize().scheduleButton(),
                  )
                ],
              ),
              const SizedBox(
                width: 40,
              ),
              Expanded(
                child: summary == "-" || empName == "-"
                    ? Center(
                        child: Text(
                          'No event for today. Please book at website to use this room.',
                          style: helveticaText.copyWith(
                            fontSize: 28,
                            fontWeight: FontWeight.w300,
                            color: davysGray,
                            height: 1.4,
                          ),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            summary,
                            style: helveticaText.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: davysGray,
                            ),
                          ),
                          const SizedBox(
                            height: 13,
                          ),
                          Text(
                            'by $empName',
                            style: helveticaText.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                              color: davysGray,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
