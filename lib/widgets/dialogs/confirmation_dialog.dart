import 'package:flutter/material.dart';
import 'package:mrbs_tablet/constant/color.dart';
import 'package:mrbs_tablet/constant/text_style.dart';
import 'package:mrbs_tablet/widgets/buttons/regular_button.dart';
import 'package:mrbs_tablet/widgets/buttons/text_button.dart';

class ConfirmDialogWhite extends StatelessWidget {
  const ConfirmDialogWhite({
    required this.title,
    required this.contentText,
    required this.onConfirm,
  });

  final String? title;
  final String? contentText;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: culturedWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 300,
          maxHeight: 450,
          minWidth: 665,
          maxWidth: 665,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 50,
            right: 50,
            top: 45,
            bottom: 30,
          ),
          child: Stack(
            children: [
              Container(
                // color: Colors.amber,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Wrap(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title!,
                          style: helveticaText.copyWith(
                            fontSize: 36,
                            color: eerieBlack,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Wrap(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          contentText!,
                          style: helveticaText.copyWith(
                            color: eerieBlack,
                            fontWeight: FontWeight.w300,
                            fontSize: 24,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: [
                    //     // SizedBox(),
                    //     TransparentButtonWhite(
                    //       text: 'Cancel',
                    //       onTap: () {},
                    //       padding: ButtonSize().smallSize(),
                    //     ),
                    //     const SizedBox(
                    //       width: 15,
                    //     ),
                    //     WhiteRegularButton(
                    //       text: 'Confirm',
                    //       onTap: () {},
                    //       padding: ButtonSize().smallSize(),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // SizedBox(),
                    TransparentButtonBlack(
                      text: 'Cancel',
                      fontSize: 24,
                      onTap: () {
                        Navigator.of(context).pop(false);
                      },
                      padding: ButtonSize().mediumSize(),
                      disabled: false,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    RegularButton(
                      text: 'Confirm',
                      onTap: onConfirm,
                      padding: ButtonSize().mediumSize(),
                      fontSize: 24,
                      disabled: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
