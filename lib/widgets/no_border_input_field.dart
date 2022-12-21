import 'package:flutter/material.dart';
import 'package:mrbs_tablet/constant/color.dart';
import 'package:mrbs_tablet/constant/text_style.dart';

class NoBorderInputField extends StatelessWidget {
  NoBorderInputField({
    super.key,
    this.controller,
    this.suffixIcon,
    this.enable,
    this.onTap,
    this.onSave,
  });

  TextEditingController? controller;
  Widget? suffixIcon;
  bool? enable;
  void Function()? onTap;
  FormFieldSetter? onSave;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enable,
      onTap: onTap,
      onSaved: onSave,
      decoration: InputDecoration(
        isDense: true,
        isCollapsed: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        hintStyle: helveticaText.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.w300,
          color: eerieBlack,
        ),
        contentPadding: EdgeInsets.zero,
        // suffixIcon: suffixIcon,
      ),
      style: helveticaText.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w300,
        color: eerieBlack,
      ),
    );
  }
}
