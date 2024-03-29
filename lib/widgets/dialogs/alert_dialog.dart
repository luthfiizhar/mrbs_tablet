import 'package:flutter/material.dart';
import 'package:mrbs_tablet/constant/color.dart';
import 'package:mrbs_tablet/constant/text_style.dart';
import 'package:mrbs_tablet/widgets/buttons/regular_button.dart';

class AlertDialogBlack extends StatelessWidget {
  const AlertDialogBlack({
    required this.title,
    required this.contentText,
    this.isSuccess = true,
  });

  final String? title;
  final String? contentText;
  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: eerieBlack,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 560,
          minWidth: 385,
          minHeight: 200,
          maxHeight: double.infinity,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 20,
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
                          style: titlePage.copyWith(
                            color: isSuccess ? greenAcent : orangeAccent,
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
                          style: bodyText.copyWith(
                            color: culturedWhite,
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
                    // TransparentButtonWhite(
                    //   text: 'Cancel',
                    //   onTap: () {
                    //     Navigator.of(context).pop(false);
                    //   },
                    //   padding: ButtonSize().mediumSize(),
                    // ),

                    WhiteRegularButton(
                      text: 'OK',
                      onTap: () {
                        Navigator.pop(context);
                      },
                      padding: ButtonSize().mediumSize(),
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
  }
}

class AlertDialogWhite extends StatelessWidget {
  const AlertDialogWhite({
    required this.title,
    required this.contentText,
    this.isSuccess = true,
  });

  final String? title;
  final String? contentText;
  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 560,
          minWidth: 385,
          minHeight: 200,
          maxHeight: double.infinity,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 20,
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
                          style: titlePage.copyWith(
                            color: isSuccess ? greenAcent : orangeAccent,
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
                          style: bodyText.copyWith(
                            color: eerieBlack,
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
                    // TransparentButtonWhite(
                    //   text: 'Cancel',
                    //   onTap: () {
                    //     Navigator.of(context).pop(false);
                    //   },
                    //   padding: ButtonSize().mediumSize(),
                    // ),

                    RegularButton(
                      text: 'OK',
                      onTap: () {
                        Navigator.pop(context);
                      },
                      padding: ButtonSize().mediumSize(),
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
  }
}

class AlertDialogWhiteCustomContent extends StatelessWidget {
  const AlertDialogWhiteCustomContent({
    required this.title,
    required this.content,
    this.isSuccess = true,
  });

  final String? title;
  final Widget? content;
  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 750,
          minWidth: 600,
          minHeight: 200,
          // maxHeight: double.infinity,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            right: 50,
            left: 50,
            top: 45,
            bottom: 35,
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // const SizedBox(
                    //   height: 5,
                    // ),
                    Text(
                      title!,
                      style: titlePage.copyWith(
                        color: isSuccess ? greenAcent : orangeAccent,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    content!,
                    const SizedBox(
                      height: 175,
                    ),
                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.end,
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: [
                    //       // SizedBox(),
                    //       // TransparentButtonWhite(
                    //       //   text: 'Cancel',
                    //       //   onTap: () {
                    //       //     Navigator.of(context).pop(false);
                    //       //   },
                    //       //   padding: ButtonSize().mediumSize(),
                    //       // ),
                    //       // const Expanded(child: SizedBox()),
                    //       RegularButton(
                    //         text: 'OK',
                    //         onTap: () {
                    //           Navigator.pop(context);
                    //         },
                    //         padding: ButtonSize().longSize(),
                    //         fontSize: 24,
                    //         disabled: false,
                    //       ),
                    //     ],
                    //   ),
                    // ),
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
                    // TransparentButtonWhite(
                    //   text: 'Cancel',
                    //   onTap: () {
                    //     Navigator.of(context).pop(false);
                    //   },
                    //   padding: ButtonSize().mediumSize(),
                    // ),

                    RegularButton(
                      text: 'OK',
                      onTap: () {
                        Navigator.pop(context);
                      },
                      padding: ButtonSize().longSize(),
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
  }
}
