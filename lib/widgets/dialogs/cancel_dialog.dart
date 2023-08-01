import 'package:flutter/material.dart';
import 'package:mrbs_tablet/api_request.dart';
import 'package:mrbs_tablet/constant/color.dart';
import 'package:mrbs_tablet/constant/text_style.dart';
import 'package:mrbs_tablet/model/booking_class.dart';
import 'package:mrbs_tablet/widgets/buttons/regular_button.dart';
import 'package:mrbs_tablet/widgets/buttons/text_button.dart';
import 'package:mrbs_tablet/widgets/dialogs/alert_dialog.dart';
import 'package:mrbs_tablet/widgets/regular_input_field.dart';

class CancelEventDialog extends StatefulWidget {
  CancelEventDialog({
    super.key,
    this.bookingId = "",
  });

  String bookingId;

  @override
  State<CancelEventDialog> createState() => _CancelEventDialogState();
}

class _CancelEventDialogState extends State<CancelEventDialog> {
  final formKey = GlobalKey<FormState>();

  TextEditingController _nip = TextEditingController();

  late Booking booking;

  String nip = "";

  ReqAPI apiReq = ReqAPI();

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 200,
          maxHeight: 450,
          minWidth: 450,
          maxWidth: 665,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.only(
            left: 50,
            right: 40,
            top: 45,
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Cancel Confirmation',
                    style: helveticaText.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: eerieBlack,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Enter your NIP to continue',
                    style: helveticaText.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: eerieBlack,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  RegularInputField(
                    controller: _nip,
                    hintText: 'NIP here ...',
                    fontSize: 24,
                    // textAlign: TextAlign.center,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 20,
                    ),
                    onSave: (newValue) {
                      nip = newValue;
                    },
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TransparentButtonBlack(
                        text: 'Cancel',
                        disabled: false,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        fontSize: 24,
                        padding: ButtonSize().mediumSize(),
                      ),
                      const SizedBox(
                        width: 35,
                      ),
                      isLoading
                          ? const CircularProgressIndicator()
                          : RegularButton(
                              text: 'Enter',
                              disabled: false,
                              onTap: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  print(widget.bookingId);
                                  // Navigator.of(context).pop();

                                  //CANCEL EVENT FUNCTION
                                  apiReq
                                      .cancelBooking(widget.bookingId, nip)
                                      .then((value) {
                                    print(value);
                                    setState(() {
                                      isLoading = false;
                                    });
                                    if (value['Status'] == "200") {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialogWhite(
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
                                        builder: (context) => AlertDialogWhite(
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
                                      builder: (context) => AlertDialogWhite(
                                        title: 'Failed connect to API',
                                        contentText: error.toString(),
                                        isSuccess: false,
                                      ),
                                    ).then((value) {
                                      Navigator.of(context).pop(false);
                                    });
                                  });
                                  //END CANCEL FUNCTION
                                }
                              },
                              fontSize: 24,
                              padding: ButtonSize().mediumSize(),
                            )
                    ],
                  ),
                  const SizedBox(
                    height: 35,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
