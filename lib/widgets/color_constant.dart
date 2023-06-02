import 'dart:ui';
import 'package:flutter/material.dart';

class ColorConstant {
  static Color gray600 = fromHex('#828282');

  static Color gray400 = fromHex('#bcbcbc');

  static Color red700 = fromHex('#cf322b');

  static Color blueGray400 = fromHex('#888888');

  static Color blueGray600 = fromHex('#38658f');

  static Color red7000c = fromHex('#0ccf322a');

  static Color red70000c = fromHex('#fad7d7');

  static Color lime90051 = fromHex('#51927b00');

  static Color black9000c = fromHex('#0c000000');

  static Color blue50 = fromHex('#e7f3ff');

  static Color green500 = fromHex('#54b552');

  static Color gray100 = fromHex('#f4f4f4');

  static Color gray200 = fromHex('#d6c7c7');
  static Color gray300 = fromHex('#a8a3a3');

  static Color yellow400 = fromHex('#ffe262');

  static Color black90011 = fromHex('#11000000');

  static Color black900 = fromHex('#000000');

  static Color whiteA70001 = fromHex('#fffdfd');

  static Color yellow900 = fromHex('#cf6f2a');

  static Color blue400 = fromHex('#4e9ce4');

  static Color blueGray900 = fromHex('#313131');

  static Color blueGray001 = fromHex('#e3eef9');

  static Color blue200 = fromHex('#9aceff');

  static Color whiteA700 = fromHex('#ffffff');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
