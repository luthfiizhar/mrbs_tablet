import 'package:flutter/material.dart';
import 'package:mrbs_tablet/api_request.dart';
import 'package:mrbs_tablet/constant/color.dart';
import 'package:mrbs_tablet/constant/text_style.dart';
import 'package:mrbs_tablet/model/booking_class.dart';
import 'package:mrbs_tablet/widgets/buttons/text_button.dart';
import 'package:mrbs_tablet/widgets/dialogs/alert_dialog.dart';
import 'package:mrbs_tablet/widgets/regular_input_field.dart';

class InputNipBookingDialog extends StatefulWidget {
  InputNipBookingDialog({
    super.key,
    required this.booking,
  });

  Booking booking;

  @override
  State<InputNipBookingDialog> createState() => _InputNipBookingDialogState();
}

class _InputNipBookingDialogState extends State<InputNipBookingDialog> {
  final formKey = GlobalKey<FormState>();

  TextEditingController _nip = TextEditingController();

  late Booking booking;

  String nip = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.booking.toJson());
    booking = widget.booking;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nip.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 380,
          maxHeight: 410,
          minWidth: 600,
          maxWidth: 640,
        ),
        child: Listener(
          onPointerDown: (_) {
            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
          },
          child: Container(
            decoration: BoxDecoration(
              color: tabletBg,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'Please enter your ',
                              style: helveticaText.copyWith(
                                fontSize: 32,
                                fontWeight: FontWeight.w300,
                                color: white,
                              ),
                              children: [
                                TextSpan(
                                  text: 'NIP ',
                                  style: helveticaText.copyWith(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                    color: white,
                                  ),
                                ),
                                TextSpan(
                                  text: 'to continue ',
                                  style: helveticaText.copyWith(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w300,
                                    color: white,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          RegularInputField(
                            maxLines: 1,
                            hintText: 'NIP here ...',
                            textAlign: TextAlign.center,
                            validator: (value) =>
                                value == "" ? "NIP is required" : null,
                            onSave: (newValue) {
                              nip = newValue;
                            },
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 80,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                      color: sonicSilver,
                    ),
                    child: Row(children: [
                      Expanded(
                        child: TransparentButtonWhite(
                          text: 'Cancel',
                          disabled: false,
                          onTap: () {
                            Navigator.of(context).pop(false);
                          },
                          fontSize: 32,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const VerticalDivider(
                        color: tabletBg,
                      ),
                      Expanded(
                        child: TransparentButtonWhite(
                          text: 'Enter',
                          disabled: false,
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              booking.empNip = nip;

                              //BOOKING FUNCTION
                              bookingRoom(booking).then((value) {
                                print(value);
                                if (value['Status'] == "200") {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialogBlack(
                                      title: value['Title'],
                                      contentText: value['Message'],
                                      isSuccess: true,
                                    ),
                                  ).then((value) {
                                    Navigator.of(context).pop(true);
                                  });
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialogBlack(
                                      title: value['Title'],
                                      contentText: value['Message'],
                                      isSuccess: false,
                                    ),
                                  ).then((value) {
                                    Navigator.of(context).pop(false);
                                  });
                                }
                              }).onError((error, stackTrace) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialogBlack(
                                    title: 'Failed connect to API',
                                    contentText: error.toString(),
                                    isSuccess: false,
                                  ),
                                ).then((value) {
                                  Navigator.of(context).pop(false);
                                });
                              });
                              //END BOOKING FUNCTION
                            }
                          },
                          fontSize: 32,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
