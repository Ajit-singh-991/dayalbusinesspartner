// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomTextStyle {
  static var textFormFieldRegular = const TextStyle(
      fontSize: 14,
      fontFamily: "Helvetica",
      color: Colors.black,
      fontWeight: FontWeight.w400);
      static var textFormFieldColored = const TextStyle(
      fontSize: 18,
      fontFamily: "Helvetica",
      color: Colors.redAccent,
      fontWeight: FontWeight.w400);

  static var textFormFieldLight =
  textFormFieldRegular.copyWith(fontWeight: FontWeight.w200);

  static var textFormFieldMedium =
  textFormFieldRegular.copyWith(fontWeight: FontWeight.w300);

  static var textFormFieldSemiBold =
  textFormFieldRegular.copyWith(fontWeight: FontWeight.w600);

  static var textFormFieldBold =
  textFormFieldRegular.copyWith(fontWeight: FontWeight.w700);

  static var textFormFieldBlack =
  textFormFieldRegular.copyWith(fontWeight: FontWeight.w900);

  static var textFormFieldSemiBoldColored =
  textFormFieldColored.copyWith(fontWeight: FontWeight.w500);
}
