import 'package:flutter/material.dart';
import 'package:mrbs_tablet/constant/color.dart';
import 'package:mrbs_tablet/constant/text_style.dart';
import 'package:mrbs_tablet/model/model.dart';
import 'package:mrbs_tablet/widgets/buttons/regular_button.dart';
import 'package:mrbs_tablet/widgets/regular_input_field.dart';
import 'package:provider/provider.dart';

class CheckInOutNipDialog extends StatefulWidget {
  CheckInOutNipDialog({
    super.key,
    this.submit,
    this.setNip,
    this.roomId = "",
    this.isIn = true,
  });

  Function? setNip;
  Function? submit;
  String roomId;
  bool isIn;

  @override
  State<CheckInOutNipDialog> createState() => _CheckInOutNipDialogState();
}

class _CheckInOutNipDialogState extends State<CheckInOutNipDialog> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _nip = TextEditingController();

  String nip = "";

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
          minHeight: 300,
          maxHeight: 400,
          minWidth: 450,
          maxWidth: 640,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: culturedWhite,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 35,
            vertical: 30,
          ),
          child: Stack(
            children: [
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Input yout NIP',
                      style: helveticaText.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: eerieBlack,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Please input your NIP before check in/check out in this room.',
                      style: helveticaText.copyWith(
                        fontSize: 20,
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
                      textAlign: TextAlign.center,
                      onSave: (newValue) {
                        nip = newValue;
                      },
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: RegularButton(
                  disabled: false,
                  text: 'Submit',
                  padding: ButtonSize().longSize(),
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      await widget.setNip!(nip, widget.isIn);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
