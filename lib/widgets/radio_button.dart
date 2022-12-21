import 'package:flutter/material.dart';
import 'package:mrbs_tablet/constant/color.dart';
import 'package:mrbs_tablet/constant/text_style.dart';

class CustomRadioButton extends StatelessWidget {
  CustomRadioButton({
    super.key,
    this.label,
    this.group,
    this.onChanged,
    this.value,
    this.filled = true,
  });

  String? label;
  String? value;
  ValueChanged? onChanged;
  bool filled;
  // RadioModel? group;
  String? group;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged!;
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(1),
            decoration: const BoxDecoration(
              color: eerieBlack,
              shape: BoxShape.circle,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: filled ? white : null,
                shape: BoxShape.circle,
              ),
              width: 20,
              height: 20,
              child: Transform.scale(
                scale: 1.2,
                child: Radio(
                  value: value,
                  groupValue: group!,
                  onChanged: onChanged,
                  // hoverColor: davysGray,
                  splashRadius: 10,
                  activeColor: eerieBlack,
                  fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.selected)) {
                      return eerieBlack;
                    }
                    return white;
                  }),
                  overlayColor: MaterialStateProperty.resolveWith<Color>(
                    (states) {
                      // if (states.contains(MaterialState.hovered)) {
                      //   return davysGray;
                      // }
                      return white;
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              label!,
              style: helveticaText.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w300,
                color: eerieBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RadioModel {
  RadioModel({
    this.isSelected,
    this.text,
    this.value,
  });

  bool? isSelected;
  String? text;
  String? value;
}
