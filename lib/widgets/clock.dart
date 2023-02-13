import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mrbs_tablet/constant/color.dart';
import 'package:mrbs_tablet/constant/text_style.dart';
import 'package:mrbs_tablet/model/model.dart';
import 'package:provider/provider.dart';

class CustomDigitalClock extends StatefulWidget {
  CustomDigitalClock({super.key, this.time = "", this.checkDb});

  String time;
  Function? checkDb;

  @override
  State<CustomDigitalClock> createState() => _CustomDigitalClockState();
}

class _CustomDigitalClockState extends State<CustomDigitalClock> {
  String _timeString = "";
  String date = "";

  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.time = _formatDateTime(DateTime.now());
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    // Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    date = _formatDay(DateTime.now());
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    if (mounted) {
      setState(() {
        // if (now.minute == 45 && now.second == 0) {
        //   print('menit 45');
        //   widget.checkDb!();
        // }
        widget.time = formattedDateTime;
        Provider.of<MrbsTabletModel>(context, listen: false)
            .setTime(formattedDateTime);
      });
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  String _formatDay(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.time,
            style: helveticaText.copyWith(
              fontSize: 56,
              fontWeight: FontWeight.w700,
              color: eerieBlack,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            date,
            style: helveticaText.copyWith(
              fontSize: 32,
              fontWeight: FontWeight.w300,
              color: davysGray,
            ),
          ),
        ],
      ),
    );
  }
}
