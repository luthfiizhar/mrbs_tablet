import 'package:flutter/material.dart';
import 'package:mrbs_tablet/constant/color.dart';
import 'package:mrbs_tablet/constant/text_style.dart';

class ButtonSize {
  EdgeInsetsGeometry longSize() {
    return const EdgeInsets.symmetric(horizontal: 80, vertical: 20);
  }

  EdgeInsetsGeometry mediumSize() {
    return const EdgeInsets.symmetric(horizontal: 50, vertical: 20);
  }

  EdgeInsetsGeometry smallSize() {
    return const EdgeInsets.symmetric(horizontal: 32, vertical: 20);
  }

  EdgeInsetsGeometry scheduleButton() {
    return const EdgeInsets.symmetric(horizontal: 59, vertical: 13);
  }

  EdgeInsetsGeometry loginButotn() {
    return const EdgeInsets.symmetric(horizontal: 32, vertical: 17);
  }

  EdgeInsetsGeometry itemQtyButton() {
    return const EdgeInsets.symmetric(horizontal: 0, vertical: 0);
  }
}

class WhiteRegularButton extends StatelessWidget {
  const WhiteRegularButton({
    required this.text,
    this.fontSize = 16,
    this.onTap,
    required this.disabled,
    this.padding,
  });

  final String? text;
  final double? fontSize;
  final VoidCallback? onTap;
  final bool? disabled;
  final EdgeInsetsGeometry? padding;

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed
    };
    if (states.any(interactiveStates.contains)) {
      return culturedWhite;
    }
    return disabled! ? grayx11 : eerieBlack;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: disabled! ? null : onTap,
      style: ButtonStyle(
        splashFactory: NoSplash.splashFactory,
        foregroundColor: MaterialStateProperty.resolveWith(getColor),
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          return disabled! ? platinum : culturedWhite;
        }),
        shape: MaterialStateProperty.resolveWith<OutlinedBorder?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.5),
                side: BorderSide(color: culturedWhite, width: 1),
              );
            }
            return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7.5),
            );
          },
        ),
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) return eerieBlack;
            if (states.contains(MaterialState.hovered)) return platinum;
            return null;
          },
        ),
        textStyle: MaterialStateProperty.resolveWith<TextStyle>(
          (states) {
            return const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            );
          },
        ),
        padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry?>(
          (states) {
            return padding;
          },
        ),
      ),
      child: Text(text!),
    );
  }
}

class RegularButton extends StatelessWidget {
  RegularButton({
    required this.text,
    this.fontSize,
    this.onTap,
    required this.disabled,
    this.padding,
    this.fontWeight = FontWeight.w700,
    this.radius = 7.5,
  });

  final String? text;
  final double? fontSize;
  final VoidCallback? onTap;
  bool? disabled = false;
  final EdgeInsetsGeometry? padding;
  FontWeight fontWeight;
  double radius;

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed
    };
    if (states.any(interactiveStates.contains)) {
      return eerieBlack;
    }
    return culturedWhite;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: disabled! ? null : onTap,
      style: ButtonStyle(
        splashFactory: NoSplash.splashFactory,
        foregroundColor: MaterialStateProperty.resolveWith(getColor),
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          return disabled! ? grayx11 : eerieBlack;
        }),
        shape: MaterialStateProperty.resolveWith<OutlinedBorder?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
                side: BorderSide(color: eerieBlack, width: 1),
              );
            }
            return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            );
          },
        ),
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) return culturedWhite;
            if (states.contains(MaterialState.hovered)) return davysGray;
            return null;
          },
        ),
        textStyle: MaterialStateProperty.resolveWith<TextStyle>(
          (states) {
            return TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              fontFamily: 'Helvetica',
              height: 1.15,
            );
          },
        ),
        padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry?>(
          (states) {
            return padding;
          },
        ),
      ),
      child: Text(text!),
    );
  }
}

class TransparentBorderedWhiteButton extends StatelessWidget {
  const TransparentBorderedWhiteButton({
    super.key,
    this.text,
    this.fontSize,
    this.disabled = false,
    this.onTap,
    this.padding,
  });

  final String? text;
  final double? fontSize;
  final VoidCallback? onTap;
  final bool? disabled;
  final EdgeInsetsGeometry? padding;

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed
    };
    if (states.any(interactiveStates.contains)) {
      return eerieBlack;
    }
    return disabled! ? platinum : culturedWhite;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: disabled! ? null : onTap,
      style: ButtonStyle(
        splashFactory: NoSplash.splashFactory,
        foregroundColor: MaterialStateProperty.resolveWith(getColor),
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          return disabled! ? grayx11 : const Color.fromARGB(0, 0, 0, 0);
        }),
        shape: MaterialStateProperty.resolveWith<OutlinedBorder?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.5),
                side: BorderSide(color: eerieBlack, width: 1),
              );
            }
            return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7.5),
              side: BorderSide(
                color: culturedWhite,
                width: 1,
              ),
            );
          },
        ),
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) return culturedWhite;
            // if (states.contains(MaterialState.hovered))
            //   return Colors.transparent;
            return null;
          },
        ),
        textStyle: MaterialStateProperty.resolveWith<TextStyle>(
          (states) {
            return helveticaText.copyWith(
              fontFamily: 'Helvetica',
              fontSize: fontSize,
              fontWeight: FontWeight.w300,
            );
          },
        ),
        padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry?>(
          (states) {
            return padding;
          },
        ),
        elevation: MaterialStateProperty.resolveWith<double?>((states) {
          // if (states.contains(MaterialState.hovered)) {
          //   return 0.2;
          // }
          return 0;
        }),
      ),
      child: Text(text!),
    );
  }
}

class TransparentBorderedBlackButton extends StatelessWidget {
  const TransparentBorderedBlackButton({
    super.key,
    this.text,
    this.fontSize = 16,
    this.disabled = false,
    this.onTap,
    this.padding,
  });

  final String? text;
  final double? fontSize;
  final VoidCallback? onTap;
  final bool? disabled;
  final EdgeInsetsGeometry? padding;

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed
    };
    if (states.any(interactiveStates.contains)) {
      return culturedWhite;
    }
    return disabled! ? platinum : eerieBlack;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: disabled! ? null : onTap,
      style: ButtonStyle(
        splashFactory: NoSplash.splashFactory,
        foregroundColor: MaterialStateProperty.resolveWith(getColor),
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          return disabled! ? grayx11 : const Color.fromARGB(0, 0, 0, 0);
        }),
        shape: MaterialStateProperty.resolveWith<OutlinedBorder?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.5),
                side: BorderSide(color: eerieBlack, width: 1),
              );
            }
            return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7.5),
              side: BorderSide(
                color: eerieBlack,
                width: 1,
              ),
            );
          },
        ),
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) return eerieBlack;
            // if (states.contains(MaterialState.hovered))
            //   return Colors.transparent;
            return null;
          },
        ),
        textStyle: MaterialStateProperty.resolveWith<TextStyle>(
          (states) {
            return helveticaText.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            );
          },
        ),
        padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry?>(
          (states) {
            return padding;
          },
        ),
        elevation: MaterialStateProperty.resolveWith<double?>((states) {
          // if (states.contains(MaterialState.hovered)) {
          //   return 0.2;
          // }
          return 0;
        }),
      ),
      child: Text(text!),
    );
  }
}
