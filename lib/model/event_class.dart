class Event {
  Event({
    this.bookingId = "",
    this.roomId = "",
    this.summary = "",
    this.startTime = "",
    this.endTime = "",
    this.date = "",
    this.empName = "",
    this.empNip = "",
    this.status = "",
    this.duration = "",
  });
  String? bookingId;
  String? roomId;
  String? summary;
  String? startTime;
  String? endTime;
  String? date;
  String? empName;
  String? empNip;
  String? status;
  String? duration;

  Event.fromJson(Map<String, dynamic> response) {
    bookingId = response['BookingID'];
    empNip = response['EmpNIP'];
    empName = response['EmpName'];
    // endTime = response['EndTime'];
    roomId = response['RoomID'];
    // startTime = response['StartTime'];
    status = response['Status'];
    summary = response['Summary'];
  }

  Map<String, dynamic> toJson() {
    return {
      'BookingID': bookingId,
      'StartTime': startTime,
      'EndTime': endTime,
      'EmpNIP': empNip,
      'EmpName': empName,
      'RoomID': roomId,
      'Status': status,
      'Summary': summary,
    };
  }

  @override
  String toString() {
    return toJson().toString();
    //return "{'BookingID': $bookingId,'EmpNIP': $empNip,'EmpName': $empName,'EndTime': $endTime,'RoomID': $roomId,'StartTime': $startTime,'Status': $status,'Summary': $summary,}";
  }
}
