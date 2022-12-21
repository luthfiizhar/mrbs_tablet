class Booking {
  Booking({
    this.roomId = "",
    this.summary,
    this.description,
    this.startDate,
    this.endDate,
    this.meetingType,
    this.amenities,
    this.attendants,
    this.foodAmenities,
    this.daysWeek,
    this.empNip = "",
  });

  String roomId;
  String? summary;
  String? description;
  String empNip;
  DateTime? startDate;
  DateTime? endDate;
  String? meetingType;
  List? amenities;
  List? attendants;
  List? foodAmenities;
  List? daysWeek;

  // Booking.fromJSon(Map<String, dynamic> json)
  //     : roomId = json['RoomID'],
  //       summary = json['Summary'],
  //       description = json['Descriptions'],
  //       startDate = json['StartDate'],
  //       endDate = json['EndDate'],
  //       recursive = json['Recursive'],
  //       repeatInterval = json['RepeatInterval'],
  //       repeatEndDate = json['RepeatEndDate'],
  //       meetingType = json['MeetingType'],
  //       attendantsNumber = json["AttendantsNumber"],
  //       amenities = json['Amenities'],
  //       attendants = json['Attendants'];

  Map<String, dynamic> toJson() => {
        '"RoomID"': '"$roomId"',
        '"Summary"': '"$summary"',
        '"Description"': '"$description"',
        '"StartDate"': '"${startDate.toString().substring(0, 19)}"',
        '"EndDate"': '"${endDate.toString().substring(0, 19)}"',
        '"Days"': daysWeek.toString(),
        '"MeetingType"': '"$meetingType"',
        '"Amenities"': amenities.toString(),
        '"Attendants"': attendants.toString(),
        '"FoodAmenities"': foodAmenities.toString(),
      };
}
