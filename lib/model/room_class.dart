class Room {
  Room({
    this.roomId = "",
    this.roomName = "",
    this.roomType = "",
    this.roomAlias = "",
    this.status = "",
    this.empName = "",
    this.empNip = "",
    this.duration = "",
    this.summary = "",
    this.bookingId = "",
  });

  String? bookingId;
  String? roomId;
  String? roomAlias;
  String? roomName;
  String? status;
  String? empName;
  String? empNip;
  String? duration;
  String? summary;
  String? roomType;

  Room.fromJson(Map<String, dynamic> response) {
    bookingId = response['BookingID'];
    empNip = response['EmpNIP'];
    empName = response['EmpName'];
    // endTime = response['EndTime'];
    roomId = response['RoomID'];
    // startTime = response['StartTime'];
    status = response['Status'];
    summary = response['Summary'];
    duration = response['Duration'];
  }

  Map<String, dynamic> toJson() {
    return {
      'BookingID': bookingId,
      'EmpName': empName,
      'RoomID': roomId,
      'Status': status,
      'Summary': summary,
      'Duration': duration
    };
  }

  @override
  String toString() {
    return toJson().toString();
    //return "{'BookingID': $bookingId,'EmpNIP': $empNip,'EmpName': $empName,'EndTime': $endTime,'RoomID': $roomId,'StartTime': $startTime,'Status': $status,'Summary': $summary,}";
  }
}
