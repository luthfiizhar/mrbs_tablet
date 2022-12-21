import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mrbs_tablet/api_request.dart';
import 'package:mrbs_tablet/constant/color.dart';
import 'package:mrbs_tablet/constant/text_style.dart';
import 'package:mrbs_tablet/model/booking_class.dart';
import 'package:mrbs_tablet/model/model.dart';
import 'package:mrbs_tablet/widgets/buttons/text_button.dart';
import 'package:mrbs_tablet/widgets/dialogs/alert_dialog.dart';
import 'package:mrbs_tablet/widgets/regular_input_field.dart';
import 'package:provider/provider.dart';

class InitiateRoomDialog extends StatefulWidget {
  InitiateRoomDialog({
    super.key,
  });

  @override
  State<InitiateRoomDialog> createState() => _InitiateRoomDialogState();
}

class _InitiateRoomDialogState extends State<InitiateRoomDialog> {
  final formKey = GlobalKey<FormState>();

  TextEditingController _roomId = TextEditingController();

  String roomId = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _roomId.dispose();
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
          child: Consumer<MrbsTabletModel>(builder: (context, model, child) {
            return Container(
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
                                text: 'Enter ',
                                style: helveticaText.copyWith(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w300,
                                  color: white,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Room ID ',
                                    style: helveticaText.copyWith(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700,
                                      color: white,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'to put in this device ',
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
                              controller: _roomId,
                              maxLines: 1,
                              hintText: 'Room ID here ...',
                              textAlign: TextAlign.center,
                              validator: (value) =>
                                  value == "" ? "Room ID is required" : null,
                              onSave: (newValue) {
                                roomId = newValue;
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
                            text: 'Save',
                            disabled: false,
                            onTap: () async {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                var box = Hive.box('room');
                                box.put('roomId', roomId);
                                model.setRoomId(roomId);
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
            );
          }),
        ),
      ),
    );
  }
}
