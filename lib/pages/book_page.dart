import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mrbs_tablet/api_request.dart';
import 'package:mrbs_tablet/constant/color.dart';
import 'package:mrbs_tablet/constant/text_style.dart';
import 'package:mrbs_tablet/model/booking_class.dart';
import 'package:mrbs_tablet/model/model.dart';
import 'package:mrbs_tablet/widgets/book_page/end_time_picker.dart';
import 'package:mrbs_tablet/widgets/book_page/facility_item_container.dart';
import 'package:mrbs_tablet/widgets/book_page/select_facility_dialog.dart';
import 'package:mrbs_tablet/widgets/book_page/select_food_dialog.dart';
import 'package:mrbs_tablet/widgets/book_page/start_time_picker.dart';
import 'package:mrbs_tablet/widgets/dialogs/alert_dialog.dart';
import 'package:mrbs_tablet/widgets/dialogs/booking_page_input_nip.dart';
import 'package:mrbs_tablet/widgets/no_border_input_field.dart';
import 'package:mrbs_tablet/widgets/radio_button.dart';
import 'package:mrbs_tablet/widgets/regular_input_field.dart';
import 'package:provider/provider.dart';

class BookingPage extends StatefulWidget {
  BookingPage({
    super.key,
    required this.roomId,
    required this.roomName,
    this.today,
  });

  final String roomName;
  final String roomId;
  DateTime? today;

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _eventName = TextEditingController();
  TextEditingController _eventDesc = TextEditingController();
  TextEditingController _startTime = TextEditingController();
  TextEditingController _endTime = TextEditingController();

  FocusNode eventNameNode = FocusNode();
  FocusNode eventDescNode = FocusNode();

  String roomName = "";
  String eventName = "";
  String eventDesc = "";
  String selectedType = 'Internal';
  String startTime = "";
  String endTime = "";
  // List amenitiesList = [];
  // List foodAmenitiesList = [];
  DateTime selectedDate = DateTime.now();

  List<Amenities> listAmenities = [];
  List<FoodAmenities> listFoods = [];
  List roomDetail = [];
  List resultPicture = [];
  List resultAmenities = [];
  List resultFoodAmenities = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var minute = widget.today!.minute;
    var hour = widget.today!.hour;
    var endMinute;
    if (minute >= 0 && minute < 15) {
      minute =
          TimeOfDay.fromDateTime(widget.today!).replacing(minute: 0).minute;
      startTime = "${hour.toString().padLeft(2, '0')}:$minute";
    } else if (minute > 15 && minute <= 30) {
      minute =
          TimeOfDay.fromDateTime(widget.today!).replacing(minute: 15).minute;
      startTime = "${hour.toString().padLeft(2, '0')}:$minute";
    } else if (minute > 30 && minute <= 45) {
      minute =
          TimeOfDay.fromDateTime(widget.today!).replacing(minute: 30).minute;
      startTime = "${hour.toString().padLeft(2, '0')}:$minute";
    } else if (minute > 45 && minute <= 60) {
      minute =
          TimeOfDay.fromDateTime(widget.today!).replacing(minute: 45).minute;
      // hour = hour + 1;
      // startTime =
      //     "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
    }
    endMinute = minute + 15;
    if (endMinute == 60) {
      hour = hour + 1;
      endMinute = 00;
    }
    // startTime = DateFormat('H:mm').format(widget.today!);
    endTime =
        "${hour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}";
    _startTime.text = startTime;
    _endTime.text = endTime;

    getDetailRoomWithAmenities(widget.roomId).then((value) {
      print(value);
      setState(() {
        roomName = value['Data']['RoomName'];
        resultAmenities = value['Data']['Amenities'];
        for (var element in resultAmenities) {
          if (element['Default'] > 0) {
            listAmenities.add(
              Amenities(
                amenitiesId: element['AmenitiesID'],
                amenitiesName: element['AmenitiesName'],
                photo: element['ImageURL'],
                qty: element['Default'],
              ),
            );
          }
        }
        resultFoodAmenities = value['Data']['FoodAmenities'];
      });
    });
    eventNameNode.addListener(() {
      setState(() {});
    });
    eventDescNode.addListener(() {
      setState(() {});
    });
  }

  setStartTime(String value) {
    setState(() {
      startTime = value;
      _startTime.text = startTime;
    });
  }

  setEndTime(String value) {
    setState(() {
      endTime = value;
      _endTime.text = endTime;
    });
  }

  setListFacility(List<Amenities> value, List<Amenities> value2) {
    // print('value');
    // print(value);
    setState(() {
      for (var i = 0; i < resultAmenities.length; i++) {
        for (var j = 0; j < value2.length; j++) {
          if (resultAmenities[i]['AmenitiesID'] == value2[j].amenitiesId) {
            // resultAmenities[i]['Default'] = value[j].qty;
            resultAmenities[i]['Amount'] = value2[j].qty;
          }
        }
      }
      listAmenities = value;
    });
  }

  setListFood(List<FoodAmenities> value, List<FoodAmenities> value2) {
    setState(() {
      for (var i = 0; i < resultFoodAmenities.length; i++) {
        for (var j = 0; j < value2.length; j++) {
          if (resultFoodAmenities[i]['FoodAmenitiesID'].toString() ==
              value2[j].amenitiesId.toString()) {
            resultFoodAmenities[i]['Amount'] = value2[j].qty;
            // resultFoodAmenities[i]['Default'] = value[j].qty;
          }
        }
      }
      listFoods = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);
    print(MediaQuery.of(context).size.height);
    return Consumer<MrbsTabletModel>(builder: (context, model, child) {
      return SafeArea(
        child: Listener(
          onPointerDown: (_) {
            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: white,
            resizeToAvoidBottomInset: false,
            body: ConstrainedBox(
              constraints: BoxConstraints(
                // minHeight: MediaQuery.of(context).size.height,
                // maxHeight: MediaQuery.of(context).size.height,
                minWidth: MediaQuery.of(context).size.width,
                maxWidth: MediaQuery.of(context).size.width,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 50,
                  horizontal: 70,
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Booking Form ',
                            style: helveticaText.copyWith(
                              fontSize: 48,
                              fontWeight: FontWeight.w700,
                              color: eerieBlack,
                              height: 1.15,
                            ),
                            children: [
                              TextSpan(
                                text: '| $roomName',
                                style: helveticaText.copyWith(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w300,
                                  color: eerieBlack,
                                  height: 1.15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Form(
                                key: formKey,
                                child: inputSection1(),
                              ),
                            ),
                            const SizedBox(
                              width: 60,
                            ),
                            SizedBox(
                              width: 460,
                              child: inputSection2(),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 90,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (states) {
                                return eerieBlack;
                              }),
                              shape: MaterialStateProperty.resolveWith<
                                  OutlinedBorder>((states) {
                                return RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                );
                              }),
                              textStyle:
                                  MaterialStateProperty.resolveWith<TextStyle>(
                                      (states) {
                                return helveticaText.copyWith(
                                  fontSize: 42,
                                  fontWeight: FontWeight.w700,
                                  color: scaffoldBg,
                                );
                              }),
                              padding:
                                  MaterialStateProperty.resolveWith<EdgeInsets>(
                                      (states) {
                                return const EdgeInsets.symmetric(
                                  horizontal: 100,
                                  vertical: 17,
                                );
                              }),
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                var todayString = DateFormat('yyyy-M-dd')
                                    .format(widget.today!);

                                Booking booking = Booking();
                                booking.roomId = model.roomId;
                                booking.startDate = DateTime.parse(
                                    "$todayString $startTime:00");
                                booking.endDate =
                                    DateTime.parse("$todayString $endTime:00");
                                booking.summary = eventName;
                                booking.description = eventDesc;
                                List tempAmen = [];
                                for (var element in listAmenities) {
                                  tempAmen.add({
                                    '"AmenitiesID"': element.amenitiesId,
                                    '"Amount"': element.qty
                                  });
                                }
                                List tempFood = [];
                                for (var element in listFoods) {
                                  tempFood.add({
                                    '"FoodAmenitiesID"': element.amenitiesId,
                                    '"Amount"': element.qty
                                  });
                                }
                                booking.amenities = tempAmen;
                                booking.foodAmenities = tempFood;
                                booking.attendants = [];

                                showDialog(
                                  context: context,
                                  builder: (context) => InputNipBookingDialog(
                                    booking: booking,
                                  ),
                                ).then((value) {
                                  if (value) {
                                    Navigator.of(context).pop();
                                  }
                                });
                                //BOOKING FUNCTION
                                // bookingRoom(booking).then((value) {
                                //   print(value);
                                //   if (value['Status'] == "200") {
                                //     showDialog(
                                //       context: context,
                                //       builder: (context) => AlertDialogBlack(
                                //         title: value['Title'],
                                //         contentText: value['Message'],
                                //         isSuccess: true,
                                //       ),
                                //     );
                                //   } else {
                                //     showDialog(
                                //       context: context,
                                //       builder: (context) => AlertDialogBlack(
                                //         title: value['Title'],
                                //         contentText: value['Message'],
                                //         isSuccess: false,
                                //       ),
                                //     );
                                //   }
                                // }).onError((error, stackTrace) {
                                //   showDialog(
                                //     context: context,
                                //     builder: (context) => AlertDialogBlack(
                                //       title: 'Failed connect to API',
                                //       contentText: error.toString(),
                                //       isSuccess: false,
                                //     ),
                                //   );
                                // });
                                //END BOOKING FUNCTION
                              }
                            },
                            child: const Text(
                              'Book Now',
                            ),
                          ),
                        )
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Icon(
                          Icons.close,
                          color: eerieBlack,
                          size: 45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget inputSection1() {
    return Column(
      children: [
        inputField(
          true,
          'Event Name',
          Expanded(
            child: RegularInputField(
              controller: _eventName,
              hintText: 'Name here ...',
              maxLines: 1,
              keyBoardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              onSave: (newValue) {
                eventName = newValue;
              },
              validator: (value) =>
                  value == "" ? "Event Name is Required" : null,
            ),
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        inputField(
          false,
          'Event Description',
          Expanded(
            child: RegularInputField(
              controller: _eventDesc,
              hintText: 'Desc here ...',
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              onSave: (newValue) {
                eventDesc = newValue;
              },
            ),
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        inputField(
          true,
          'Meeting Start',
          Row(
            children: [
              SizedBox(
                width: 65,
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => PickStartTimeDialog(
                        roomName: roomName,
                        selectedDate: selectedDate,
                        selectedTime: startTime,
                        setStartTime: setStartTime,
                      ),
                    );
                  },
                  child: NoBorderInputField(
                    enable: false,
                    controller: _startTime,
                    onTap: () {},
                    suffixIcon: const Icon(
                      Icons.keyboard_arrow_down_sharp,
                      color: eerieBlack,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              const Icon(
                Icons.keyboard_arrow_down_sharp,
                size: 24,
                color: eerieBlack,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        inputField(
          true,
          'Meeting End',
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => PickEndTimeDialog(
                  selectedDate: DateTime.now(),
                  selectedTime: startTime,
                  startTime: startTime,
                  setEndTime: setEndTime,
                ),
              );
            },
            child: Row(
              children: [
                SizedBox(
                  width: 65,
                  child: NoBorderInputField(
                    enable: false,
                    controller: _endTime,
                    suffixIcon: const Icon(
                      Icons.keyboard_arrow_down_sharp,
                      color: eerieBlack,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                const Icon(
                  Icons.keyboard_arrow_down_sharp,
                  size: 24,
                  color: eerieBlack,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        inputField(
          true,
          'Type',
          SizedBox(
            width: 300,
            height: 30,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                CustomRadioButton(
                  label: 'Internal',
                  value: 'Internal',
                  group: selectedType,
                  onChanged: (value) {
                    setState(() {
                      selectedType = value;
                    });
                  },
                ),
                const SizedBox(
                  width: 30,
                ),
                CustomRadioButton(
                  label: 'External',
                  value: 'External',
                  group: selectedType,
                  onChanged: (value) {
                    setState(() {
                      selectedType = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget inputSection2() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Room Facilities',
          style: helveticaText.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            color: eerieBlack,
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        Container(
          height: 120,
          width: double.infinity,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: [
              Center(
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => SelectAmenitiesDialog(
                        listAmen: resultAmenities,
                        setListAmenities: setListFacility,
                      ),
                    ).then((value) {
                      print('facility');
                      print(resultAmenities);
                      setState(() {});
                    });
                  },
                  child: DottedBorder(
                    borderType: BorderType.Circle,
                    color: eerieBlack,
                    dashPattern: const [10, 4],
                    radius: const Radius.circular(50),
                    child: const SizedBox(
                      // color: greenAcent,
                      width: 100,
                      height: 100,
                      child: Center(
                        child: Icon(
                          Icons.add_circle_outline_sharp,
                          size: 30,
                          color: eerieBlack,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ListView.builder(
                itemCount: listAmenities.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return FacilityItemContainer(
                    img: listAmenities[index].photo!,
                    unit: listAmenities[index].qty!,
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        Text(
          'Food & Beverages',
          style: helveticaText.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            color: eerieBlack,
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        Container(
          height: 120,
          width: double.infinity,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: [
              Center(
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => SelectFoodDialog(
                        listFood: resultFoodAmenities,
                        setListFood: setListFood,
                      ),
                    ).then((value) {
                      print('food');
                      print(resultFoodAmenities);
                      setState(() {});
                    });
                  },
                  child: DottedBorder(
                    borderType: BorderType.Circle,
                    color: eerieBlack,
                    dashPattern: const [10, 4],
                    radius: const Radius.circular(50),
                    child: const SizedBox(
                      // color: greenAcent,
                      width: 100,
                      height: 100,
                      child: Center(
                        child: Icon(
                          Icons.add_circle_outline_sharp,
                          size: 30,
                          color: eerieBlack,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ListView.builder(
                itemCount: listFoods.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return FacilityItemContainer(
                    img: listFoods[index].photo!,
                    unit: listFoods[index].qty!,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget inputField(bool isOneLine, String label, Widget widget) {
    return Row(
      crossAxisAlignment:
          isOneLine ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 200,
          child: Text(
            label,
            style: helveticaText.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              height: 1.15,
              color: eerieBlack,
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        widget,
      ],
    );
  }
}

class Amenities {
  Amenities({
    this.amenitiesId,
    this.amenitiesName,
    this.qty = 0,
    this.photo = "",
  });

  String? amenitiesId;
  String? amenitiesName;
  String? photo;
  int? qty;

  Amenities.fromJSon(Map<String, dynamic> json)
      : amenitiesName = json['AmenitiesName'],
        amenitiesId = json['AmenitisID'];

  Map<String, dynamic> toJson() => {
        'AmenitiesID': amenitiesId ?? "",
        // 'AmenitiesName': amenitiesName ?? "",
        'Amount': qty
      };

  @override
  String toString() {
    // TODO: implement toString
    return "{AmenitiesID : $amenitiesId, AmenitiesName : $amenitiesName, Default : $qty, ImageURL : $photo}";
  }
}

class FoodAmenities {
  FoodAmenities({
    this.amenitiesId,
    this.amenitiesName,
    this.qty = 0,
    this.photo = "",
  });

  String? amenitiesId;
  String? amenitiesName;
  String? photo;
  int? qty;

  FoodAmenities.fromJSon(Map<String, dynamic> json)
      : amenitiesName = json['FoodAmenitiesName'],
        amenitiesId = json['FoodAmenitisID'];

  Map<String, dynamic> toJson() => {
        'FoodAmenitiesID': amenitiesId ?? "",
        // 'AmenitiesName': amenitiesName ?? "",
        'Amount': qty
      };

  @override
  String toString() {
    // TODO: implement toString
    return "{FoodAmenitiesId : $amenitiesId, FoodAmenitiesName : $amenitiesName, Amount : $qty, Photo : $photo}";
  }
}
