import 'package:flutter/material.dart';
import 'package:mrbs_tablet/constant/color.dart';
import 'package:mrbs_tablet/constant/text_style.dart';

class RegularInputField extends StatelessWidget {
  RegularInputField({
    super.key,
    this.focusNode,
    this.controller,
    this.hintText,
    this.maxLines = 1,
    this.keyBoardType,
    this.onSave,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.validator,
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 15, vertical: 8.5),
    this.fontSize = 22,
  });

  FocusNode? focusNode;
  TextEditingController? controller;
  String? hintText;
  int? maxLines;
  TextInputType? keyBoardType;
  FormFieldSetter? onSave;
  FormFieldValidator? validator;
  TextCapitalization textCapitalization;
  TextAlign textAlign;
  EdgeInsets contentPadding;
  double fontSize;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      maxLines: maxLines,
      keyboardType: keyBoardType,
      onSaved: onSave,
      validator: validator,
      textCapitalization: textCapitalization,
      decoration: InputDecoration(
        fillColor: white,
        filled: true,
        // isCollapsed: true,
        // isDense: true,
        focusColor: eerieBlack,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: greenAcent,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: orangeAccent,
            width: 2,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        contentPadding: contentPadding,
        hintStyle: helveticaText.copyWith(
          fontSize: fontSize,
          fontWeight: FontWeight.w300,
        ),
        hintText: hintText,
      ),
      style: helveticaText.copyWith(
        fontSize: fontSize,
        fontWeight: FontWeight.w300,
      ),
      textAlign: textAlign,
    );
  }
}
