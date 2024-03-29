import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mrbs_tablet/model/booking_class.dart';
import 'package:mrbs_tablet/model/check_in.dart';
import 'api_link.dart';

class ReqAPI {
  Future getDetailRoom(String roomId) async {
    var url = Uri.https(
        apiUrl, '/MRBS_Backend/public/api/tablet/room/detail/$roomId');
    Map<String, String> requestHeader = {
      'Content-Type': 'application/json',
    };
    try {
      var response = await http.get(url, headers: requestHeader);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future getDetailRoomWithAmenities(String roomId) async {
    print(roomId);
    var url = Uri.https(apiUrl, '/MRBS_Backend/public/api/tablet/room/$roomId');
    Map<String, String> requestHeader = {
      'Content-Type': 'application/json',
    };
    try {
      var response = await http.get(url, headers: requestHeader);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future checkIn(CheckIn checkin) async {
    // var url = Uri.https(
    //     apiUrl, '/MRBS_Backend/public/api/tablet/check-in/$bookingId/$nip');
    var url = Uri.https(apiUrl, '/MRBS_Backend/public/api/tablet/v2/check-in');

    Map<String, String> requestHeader = {
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
      "BookingID" : "${checkin.bookingId}",
      "EmpNIP" : "${checkin.empNIP}",
      "BookingOrigin" : "${checkin.bookingOrigin}",
      "RoomID" : "${checkin.roomId}"
    }
    """;
    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future checkOut(String bookingId, String nip) async {
    var url = Uri.https(
        apiUrl, '/MRBS_Backend/public/api/tablet/check-out/$bookingId/$nip');
    Map<String, String> requestHeader = {
      'Content-Type': 'application/json',
    };
    try {
      var response = await http.get(url, headers: requestHeader);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future cancelBooking(String bookingId, String nip) async {
    var url = Uri.https(
        apiUrl, '/MRBS_Backend/public/api/tablet/cancel/$bookingId/$nip');
    Map<String, String> requestHeader = {
      'Content-Type': 'application/json',
    };
    try {
      var response = await http.get(url, headers: requestHeader);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future bookingRoom(Booking booking) async {
    var url = Uri.https(apiUrl, '/MRBS_Backend/public/api/tablet-booking');
    Map<String, String> requestHeader = {
      'Content-Type': 'application/json',
    };

    var bodySend = """
  {
      "RoomID": "${booking.roomId}",
      "EmpNIP": "${booking.empNip}",
      "Summary": "${booking.summary}",
      "AdditionalNotes" : "",
      "Description": "${booking.description}",
      "StartDate": "${booking.startDate}",
      "EndDate": "${booking.endDate}",
      "MeetingType": "${booking.meetingType}",
      "AttendantsNumber": 1,
      "Amenities": ${booking.amenities},
      "Attendants": ${booking.attendants},
      "FoodAmenities": ${booking.foodAmenities}
    }
  """;
    print(bodySend);
    try {
      var response = await http.post(
        url,
        headers: requestHeader,
        body: bodySend,
      );

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future getRoomList() async {
    var url = Uri.https(apiUrl, '/MRBS_Backend/public/api/tablet/room-list');
    Map<String, String> requestHeader = {
      'Content-Type': 'application/json',
    };
    try {
      var response = await http.get(url, headers: requestHeader);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future getTabletSchedule(String roomId) async {
    var url =
        Uri.https(apiUrl, '/MRBS_Backend/public/api/tablet/schedule/$roomId');
    Map<String, String> requestHeader = {
      'Content-Type': 'application/json',
    };
    try {
      var response = await http.get(url, headers: requestHeader);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future startTimeSelector(String roomId) async {
    var url =
        Uri.https(apiUrl, '/MRBS_Backend/public/api/tablet/start-time/$roomId');
    Map<String, String> requestHeader = {
      'Content-Type': 'application/json',
    };
    try {
      var response = await http.get(url, headers: requestHeader);
      print(response.body);
      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future endTimeSelector(String roomId, String date, String startTime) async {
    var url = Uri.https(apiUrl, '/MRBS_Backend/public/api/tablet/end-time');
    Map<String, String> requestHeader = {
      'Content-Type': 'application/json',
    };
    var bodySend = """
    {
        "RoomID" : "$roomId",
        "Date" : "$date",
        "Start" : "$startTime"
    }
    """;
    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future checkNipAdmin(String nip) async {
    var url = Uri.https(apiUrl, '/MRBS_Backend/public/api/tablet/check-nip');
    Map<String, String> requestHeader = {
      'Content-Type': 'application/json',
    };
    var bodySend = """
    {
        "EmpNIP" : "$nip"
    }
    """;
    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }
}
