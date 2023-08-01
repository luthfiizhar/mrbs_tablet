import 'package:flutter/material.dart';
import 'package:mrbs_tablet/constant/color.dart';
import 'package:mrbs_tablet/constant/text_style.dart';
import 'package:mrbs_tablet/model/room_event_class.dart';
import 'package:mrbs_tablet/widgets/buttons/regular_button.dart';

class DetailEventDialog extends StatelessWidget {
  DetailEventDialog({
    super.key,
    RoomEvent? roomEvent,
  }) : roomEvent = roomEvent ?? RoomEvent();

  RoomEvent roomEvent;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 900,
          maxWidth: 900,
          minHeight: 412,
        ),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(
                bottom: 55,
                top: 45,
                left: 50,
                right: 50,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    roomEvent.eventName!,
                    style: helveticaText.copyWith(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: eerieBlack,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Wrap(
                    spacing: 40,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 15,
                        children: [
                          const Icon(
                            Icons.apartment,
                            color: davysGray,
                          ),
                          Text(
                            "${roomEvent.location} - ${roomEvent.floor}",
                            style: helveticaText.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w300,
                              color: davysGray,
                            ),
                          ),
                        ],
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 15,
                        children: [
                          const Icon(
                            Icons.calendar_month_rounded,
                            color: davysGray,
                          ),
                          Text(
                            roomEvent.date,
                            style: helveticaText.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w300,
                              color: davysGray,
                            ),
                          ),
                        ],
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 15,
                        children: [
                          const Icon(
                            Icons.alarm,
                            color: davysGray,
                          ),
                          Text(
                            roomEvent.duration,
                            style: helveticaText.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w300,
                              color: davysGray,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    'Host Info',
                    style: helveticaText.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: eerieBlack,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Wrap(
                    direction: Axis.vertical,
                    spacing: 15,
                    children: [
                      Text(
                        roomEvent.empName,
                        style: helveticaText.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          color: davysGray,
                        ),
                      ),
                      Text(
                        roomEvent.email,
                        style: helveticaText.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                          color: davysGray,
                        ),
                      ),
                      Text(
                        "${roomEvent.avaya} / +${roomEvent.phoneNumber}",
                        style: helveticaText.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                          color: davysGray,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 30,
              right: 40,
              child: SizedBox(
                child: RegularButton(
                  text: "OK",
                  disabled: false,
                  fontSize: 24,
                  padding: ButtonSize().longSize(),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
