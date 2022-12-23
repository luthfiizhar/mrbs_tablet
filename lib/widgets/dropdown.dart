import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:mrbs_tablet/constant/color.dart';
import 'package:mrbs_tablet/constant/text_style.dart';

class BlackDropdown extends StatelessWidget {
  BlackDropdown({
    required this.items,
    this.hintText,
    this.focusNode,
    this.validator,
    this.onChanged,
    this.suffixIcon,
    required this.enabled,
    this.onTap,
    this.value,
    this.customHeights,
    this.fontSize = 18,
    this.padding =
        const EdgeInsets.only(right: 15, left: 15, top: 0, bottom: 12),
  });

  final List<DropdownMenuItem<dynamic>>? items;
  final String? hintText;
  final FocusNode? focusNode;
  final ValueChanged? onChanged;
  final FormFieldValidator? validator;
  final Widget? suffixIcon;
  final bool? enabled;
  final VoidCallback? onTap;
  final dynamic value;
  final List<double>? customHeights;
  final double? fontSize;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
      buttonHeight: 39,
      value: value,
      focusNode: focusNode!,
      items: items,
      customItemsHeights: customHeights,
      onChanged: onChanged,
      isExpanded: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: davysGray,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: davysGray,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: davysGray,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: grayx11,
            width: 1,
          ),
        ),
        fillColor: enabled!
            ? focusNode!.hasFocus
                ? white
                : Colors.transparent
            : platinum,
        filled: true,
        isDense: true,
        isCollapsed: true,
        focusColor: culturedWhite,
        hintText: hintText,
        hintStyle: helveticaText.copyWith(
          fontSize: fontSize!,
          fontWeight: FontWeight.w300,
          color: lightGray,
        ),
        contentPadding: padding!,
        // suffixIcon: suffixIcon,
        suffixIconColor: eerieBlack,
      ),
      icon: suffixIcon,
      hint: Text(
        hintText!,
        style: helveticaText.copyWith(
          fontSize: fontSize!,
          fontWeight: FontWeight.w300,
          color: sonicSilver,
        ),
      ),
      // buttonPadding: EdgeInsets.only(
      //   right: 5,
      //   left: 5,
      //   top: 0,
      //   bottom: 0,
      // ),
      style: helveticaText.copyWith(
        fontSize: fontSize!,
        fontWeight: FontWeight.w300,
      ),
      // buttonDecoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(5),
      //   border: Border.all(
      //     color: eerieBlack,
      //     width: 1,
      //   ),
      //   color: culturedWhite,
      // ),
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: sonicSilver,
          width: 1,
        ),
        color: white,
      ),
      // offset: const Offset(0, -20),
    );
    return DropdownButtonFormField(
      isExpanded: true,
      focusNode: focusNode,
      items: items,
      onChanged: onChanged,
      // onTap: onTap,
      icon: SizedBox(),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: davysGray,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: davysGray,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: davysGray,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: grayx11,
            width: 1,
          ),
        ),
        fillColor: enabled! ? culturedWhite : platinum,
        filled: true,
        // isDense: true,
        isCollapsed: true,
        focusColor: culturedWhite,
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w300,
          color: eerieBlack,
        ),
        contentPadding: const EdgeInsets.only(
          right: 15,
          left: 15,
          top: 20,
          bottom: 18,
        ),
        suffixIcon: suffixIcon,
        suffixIconColor: eerieBlack,
      ),
      validator: validator,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w300,
        color: eerieBlack,
      ),
      borderRadius: BorderRadius.circular(5),
      dropdownColor: culturedWhite,
    );
  }
}
