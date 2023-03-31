import 'package:flutter/material.dart';
import 'package:mrbs_tablet/api_request.dart';
import 'package:mrbs_tablet/constant/color.dart';
import 'package:mrbs_tablet/constant/text_style.dart';
import 'package:mrbs_tablet/model/check_in.dart';
import 'package:mrbs_tablet/model/model.dart';
import 'package:mrbs_tablet/widgets/buttons/regular_button.dart';
import 'package:mrbs_tablet/widgets/buttons/text_button.dart';
import 'package:mrbs_tablet/widgets/dialogs/alert_dialog.dart';
import 'package:mrbs_tablet/widgets/dialogs/confirmation_dialog.dart';
import 'package:mrbs_tablet/widgets/regular_input_field.dart';
import 'package:provider/provider.dart';

class CheckNipAdminDialog extends StatefulWidget {
  CheckNipAdminDialog({
    super.key,
  });

  @override
  State<CheckNipAdminDialog> createState() => _CheckNipAdminDialogState();
}

class _CheckNipAdminDialogState extends State<CheckNipAdminDialog> {
  ReqAPI apiReq = ReqAPI();
  final formKey = GlobalKey<FormState>();
  TextEditingController _nip = TextEditingController();

  String nip = "";

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(Provider.of<MrbsTabletModel>(context, listen: false).roomId);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
          maxWidth: 575,
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
                    'Confirmation',
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
                          Navigator.of(context).pop(false);
                        },
                        fontSize: 24,
                        padding: ButtonSize().mediumSize(),
                      ),
                      const SizedBox(
                        width: 35,
                      ),
                      isLoading
                          ? Padding(
                              padding: ButtonSize().mediumSize(),
                              child: const CircularProgressIndicator(
                                color: eerieBlack,
                              ),
                            )
                          : RegularButton(
                              text: 'Enter',
                              disabled: false,
                              onTap: () async {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  // await widget.setNip!(nip, widget.isIn);
                                  // Navigator.of(context).pop();

                                  setState(() {
                                    isLoading = true;
                                  });
                                  apiReq.checkNipAdmin(nip).then((value) {
                                    if (value['Status'].toString() == "200") {
                                      Navigator.of(context).pop(true);
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialogWhite(
                                          title: value["Title"],
                                          contentText: value["Message"],
                                          isSuccess: false,
                                        ),
                                      );
                                    }
                                  }).onError((error, stackTrace) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialogWhite(
                                        title: "Error checkNipAdmin",
                                        contentText: error.toString(),
                                        isSuccess: false,
                                      ),
                                    );
                                  });
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
