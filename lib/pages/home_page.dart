import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:mrbs_tablet/api_request.dart';
import 'package:mrbs_tablet/constant/color.dart';
import 'package:mrbs_tablet/constant/text_style.dart';
import 'package:mrbs_tablet/model/event_class.dart';
import 'package:mrbs_tablet/model/model.dart';
import 'package:mrbs_tablet/model/room_class.dart';
import 'package:mrbs_tablet/pages/book_page.dart';
import 'package:mrbs_tablet/widgets/clock.dart';
import 'package:mrbs_tablet/widgets/dialogs/alert_dialog.dart';
import 'package:mrbs_tablet/widgets/dialogs/check_in_nip_dialog.dart';
import 'package:mrbs_tablet/widgets/dialogs/initiate_room_dialog.dart';
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

  bool isLoadingChangeStatus = true;
  bool isNextMeetingChange = false;

  String today = "";
  String status = "Avialable";

  String nip = "";

  String roomName = "";
  String roomType = "";
  String roomCapacity = "";

  String bookingId = "";

  String roomId = "MR-1";

  String summary = "";
  String empName = "";
  String empNip = "";
  String duration = "";
  String nextMeeting = "";

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

  submitCheckIn() {
    print(nip);
    setState(() {
      isLoadingChangeStatus = true;
    });

    checkIn(bookingId, nip).then(
      (value) {
        nip = "";
        print(value);
        if (value['Status'] == "200") {
          showDialog(
            context: context,
            builder: (context) => AlertDialogBlack(
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
            builder: (context) => AlertDialogBlack(
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
    ).onError((error, stackTrace) {});
  }

  submitCheckOut() {
    print(nip);
    setState(() {
      isLoadingChangeStatus = true;
    });

    checkOut(bookingId, nip).then(
      (value) {
        nip = "";
        print(value);
        if (value['Status'] == "200") {
          showDialog(
            context: context,
            builder: (context) => AlertDialogBlack(
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
            builder: (context) => AlertDialogBlack(
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
    ).onError((error, stackTrace) {});
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
    setState(() {
      var detail = Room.fromJson(Map<String, dynamic>.from(data as dynamic));

      Provider.of<MrbsTabletModel>(context, listen: false).setRoom(detail);
      status = detail.status!;
      bookingId = detail.bookingId!;
      summary = detail.summary!;
      duration = detail.duration!;
      empName = detail.empName!;
      empNip = detail.empNip!;
      print(detail);
      isLoadingChangeStatus = false;
    });
  }

  void nextMeetingListener(Object data) {
    setState(() {
      print(data);
      nextMeeting = data.toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    Wakelock.toggle(enable: true);

    today = DateFormat('yyyy-M-dd').format(DateTime.now());
    super.initState();
    mrbsRef.child('$roomId/StatusRoom').onValue.listen((event) {
      statusListener(event.snapshot.value!);
    });
    mrbsRef.child('$roomId/NextMeeting').onValue.listen((event) {
      nextMeetingListener(event.snapshot.value!);
    });
    getDetailRoom(roomId).then((value) async {
      print(value);

      setState(() {
        Provider.of<MrbsTabletModel>(context, listen: false)
            .setRoomName(value['Data']['RoomName']);
        roomName = value['Data']['RoomName'];
        roomType = value['Data']['RoomTypeName'];
        roomCapacity = value['Data']['MaxCapacity'].toString();
      });
    });
    // getData();
    // mrbsRef
    //     .child('MR-1')
    //     .orderByChild('Date')
    //     .equalTo('2022-12-20')
    //     .once()
    //     .then((value) {
    //   print('masuk');
    //   // var data = Event.fromJson(
    //   //     Map<String, dynamic>.from(value.snapshot.value as dynamic));
    //   String data = json.encode(value.snapshot.value);
    //   List<dynamic> listEvent = value.snapshot.value;
    //   var event = Event.fromJson(Map<String, dynamic>.from(data as dynamic));
    //   if (data != null) {
    //     print(event.bookingId);
    //   } else {
    //     print('data kosong');
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MrbsTabletModel>(builder: (context, model, child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: Container(
            // color: Colors.amber,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/BG.png'), fit: BoxFit.cover),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 30,
            ),
            child: Container(
              // color: Colors.blueGrey,
              height: double.infinity,
              width: double.infinity,
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(
                                roomType,
                                style: helveticaText.copyWith(
                                  fontSize: 24,
                                  color: scaffoldBg,
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                textAlign: TextAlign.right,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => InitiateRoomDialog(),
                                ).then((value) {
                                  // roomId = model.roomId;
                                  getDetailRoom(model.roomId)
                                      .then((value) async {
                                    print(value);

                                    setState(() {
                                      model.setRoomName(
                                          value['Data']['RoomName']);
                                      roomName = value['Data']['RoomName'];
                                      roomType = value['Data']['RoomTypeName'];
                                      roomCapacity = value['Data']
                                              ['MaxCapacity']
                                          .toString();
                                    });
                                  });
                                });
                              },
                              child: Text(
                                roomName,
                                style: arialText.copyWith(
                                  fontSize: 69,
                                  fontWeight: FontWeight.w900,
                                  color: scaffoldBg,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 180,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: scaffoldBg,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.people,
                                color: scaffoldBg,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                'Up to $roomCapacity',
                                style: helveticaText.copyWith(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w300,
                                  color: scaffoldBg,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 75,
                        ),
                        isLoadingChangeStatus
                            ? const Center(
                                child: SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: CircularProgressIndicator(
                                    color: greenAcent,
                                  ),
                                ),
                              )
                            : Builder(
                                builder: (context) {
                                  switch (status) {
                                    case "Available":
                                      return availableWidget();
                                    case "Waiting":
                                      return waitingWidget();
                                    case "In Use":
                                      return inUseWidget();
                                    default:
                                      return availableWidget();
                                  }
                                },
                              ),
                        // inUseWidget(),
                        // availableWidget(),
                        // waitingWidget(),
                        // Row(
                        //   children: [
                        //     ElevatedButton(
                        //       onPressed: () {
                        //         setStatusRoom();
                        //       },
                        //       child: Text('Get Data'),
                        //     ),
                        //   ],
                        // ),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     showDialog(
                        //       context: context,
                        //       builder: (context) => CheckInOutNipDialog(
                        //           setNip: setNip, submit: submitCheckIn),
                        //     );
                        //     // Navigator.push(
                        //     //     context,
                        //     //     MaterialPageRoute(
                        //     //       builder: (context) => BookingPage(
                        //     //         roomId: roomId,
                        //     //         roomName: roomName,
                        //     //       ),
                        //     //     )).then((value) {
                        //     //   setState(() {});
                        //     // });
                        //   },
                        //   child: Text('button test'),
                        // ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: CustomDigitalClock(
                      time: model.time,
                      checkDb: getData,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Next Meeting:',
                          style: helveticaText.copyWith(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: scaffoldBg,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: scaffoldBg, width: 1),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 8,
                          ),
                          child: Text(
                            nextMeeting,
                            style: helveticaText.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.w300,
                              color: scaffoldBg,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: scaffoldBg, width: 1),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 8,
                          ),
                          child: Text(
                            'View Schedule',
                            style: helveticaText.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.w300,
                              color: scaffoldBg,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: -50,
                    child: SizedBox(
                      width: 300,
                      height: 75,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SvgPicture.asset(
                          'assets/klg_logo_tagline_white.svg',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget inUseWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                status,
                style: arialText.copyWith(
                  fontSize: 125,
                  color: orangeAccent,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'By $empName - $empNip',
                style: helveticaText.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: scaffoldBg,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                summary,
                style: helveticaText.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w300,
                  color: scaffoldBg,
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            Text(
              duration,
              style: helveticaText.copyWith(
                fontSize: 72,
                fontWeight: FontWeight.w700,
                color: scaffoldBg,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.resolveWith<Color>((states) {
                  return orangeAccent.withOpacity(0.8);
                }),
                shape:
                    MaterialStateProperty.resolveWith<OutlinedBorder>((states) {
                  return RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80),
                  );
                }),
                padding:
                    MaterialStateProperty.resolveWith<EdgeInsets>((states) {
                  return const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 25,
                  );
                }),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => CheckInOutNipDialog(
                    setNip: setNip,
                    submit: submitCheckIn,
                    isIn: false,
                  ),
                );
                // setState(() {
                //   isLoadingChangeStatus = true;
                // });
                // print(bookingId);
                // checkIn(bookingId).then((value) {
                //   print(value);
                // }).onError((error, stackTrace) {});
              },
              child: Text(
                'Check Out',
                style: helveticaText.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: scaffoldBg,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget availableWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available',
              style: arialText.copyWith(
                fontSize: 120,
                color: scaffoldBg,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Not in use',
              style: helveticaText.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.w300,
                color: scaffoldBg,
              ),
            ),
          ],
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
              return greenAcent.withOpacity(0.8);
            }),
            shape: MaterialStateProperty.resolveWith<OutlinedBorder>((states) {
              return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80),
              );
            }),
            padding: MaterialStateProperty.resolveWith<EdgeInsets>((states) {
              return const EdgeInsets.symmetric(
                horizontal: 50,
                vertical: 25,
              );
            }),
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BookingPage(
                  roomId: roomId,
                  roomName: roomName,
                  today: DateTime.now(),
                ),
              ),
            );
          },
          child: Text(
            'Book Now',
            style: helveticaText.copyWith(
              fontSize: 56,
              fontWeight: FontWeight.w700,
              color: scaffoldBg,
              height: 1.3,
            ),
          ),
        )
      ],
    );
  }

  Widget waitingWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Waiting',
              style: arialText.copyWith(
                fontSize: 125,
                color: grayx11,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Booked by Luthfi Izhariman - 169742',
              style: helveticaText.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: scaffoldBg,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              summary,
              style: helveticaText.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.w300,
                color: scaffoldBg,
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.resolveWith<Color>((states) {
                  return greenAcent.withOpacity(0.8);
                }),
                shape:
                    MaterialStateProperty.resolveWith<OutlinedBorder>((states) {
                  return RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80),
                  );
                }),
                padding:
                    MaterialStateProperty.resolveWith<EdgeInsets>((states) {
                  return const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 25,
                  );
                }),
              ),
              onPressed: () {
                // setState(() {
                //   isLoadingChangeStatus = true;
                // });
                print(bookingId);
                showDialog(
                  context: context,
                  builder: (context) => CheckInOutNipDialog(
                      setNip: setNip, submit: submitCheckIn),
                );
                // checkIn(bookingId,nip).then((value) {
                //   print(value);
                // }).onError((error, stackTrace) {});
              },
              child: Text(
                'Check In',
                style: helveticaText.copyWith(
                  fontSize: 56,
                  fontWeight: FontWeight.w700,
                  color: scaffoldBg,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.resolveWith<Color>((states) {
                  return grayx11.withOpacity(0.8);
                }),
                shape:
                    MaterialStateProperty.resolveWith<OutlinedBorder>((states) {
                  return RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80),
                  );
                }),
                padding:
                    MaterialStateProperty.resolveWith<EdgeInsets>((states) {
                  return const EdgeInsets.symmetric(
                    horizontal: 55,
                    vertical: 15,
                  );
                }),
              ),
              onPressed: () {},
              child: Text(
                'Cancel Booking',
                style: helveticaText.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: scaffoldBg,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
