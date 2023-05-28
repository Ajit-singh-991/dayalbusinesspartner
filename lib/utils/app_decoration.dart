import 'package:dayalbusinesspartner/widgets/color_constant.dart';
import 'package:dayalbusinesspartner/widgets/size_utils.dart';
import 'package:flutter/material.dart';

class AppDecoration {
  static BoxDecoration get txtOutlineGray600 => BoxDecoration(
        color: ColorConstant.gray100,
        border: Border.all(
          color: ColorConstant.gray600,
          width: getHorizontalSize(
            1,
          ),
        ),
      );
  static BoxDecoration get outlineBlack90011 => BoxDecoration(
        color: ColorConstant.whiteA700,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black90011,
            spreadRadius: getHorizontalSize(
              2,
            ),
            blurRadius: getHorizontalSize(
              2,
            ),
            offset: const Offset(
              7,
              11,
            ),
          ),
        ],
      );
  static BoxDecoration get outlineBlue200 => BoxDecoration(
        color: ColorConstant.blue50,
        border: Border.all(
          color: ColorConstant.blue200,
          width: getHorizontalSize(
            1,
          ),
        ),
      );
  static BoxDecoration get outlineRed700 => BoxDecoration(
        color: ColorConstant.red7000c,
        border: Border.all(
          color: ColorConstant.red700,
          width: getHorizontalSize(
            1,
          ),
        ),
      );
  static BoxDecoration get fillWhiteA700 => BoxDecoration(
        color: ColorConstant.whiteA700,
      );
  static BoxDecoration get outlineGray600 => BoxDecoration(
        color: ColorConstant.gray100,
        border: Border.all(
          color: ColorConstant.gray600,
          width: getHorizontalSize(
            1,
          ),
        ),
      );
  static BoxDecoration get fillRed7000c => BoxDecoration(
        color: ColorConstant.red7000c,
      );
  static BoxDecoration get outlineGray400 => BoxDecoration(
        color: ColorConstant.whiteA700,
        border: Border.all(
          color: ColorConstant.gray400,
          width: getHorizontalSize(
            1,
          ),
          strokeAlign: strokeAlignOutside,
        ),
      );
  static BoxDecoration get outlineBlack9000c3 => const BoxDecoration();
  static BoxDecoration get outlineGray4002 => BoxDecoration(
        color: ColorConstant.whiteA70001,
        border: Border.all(
          color: ColorConstant.gray400,
          width: getHorizontalSize(
            1,
          ),
        ),
      );
  static BoxDecoration get fillYellow400 => BoxDecoration(
        color: ColorConstant.yellow400,
      );
  static BoxDecoration get outlineBlack9000c2 => BoxDecoration(
        color: ColorConstant.whiteA700,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black9000c,
            spreadRadius: getHorizontalSize(
              2,
            ),
            blurRadius: getHorizontalSize(
              2,
            ),
            offset: const Offset(
              0,
              11,
            ),
          ),
        ],
      );
  static BoxDecoration get outlineBlack9000c => BoxDecoration(
        color: ColorConstant.whiteA700,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black9000c,
            spreadRadius: getHorizontalSize(
              2,
            ),
            blurRadius: getHorizontalSize(
              2,
            ),
            offset: const Offset(
              0,
              -2,
            ),
          ),
        ],
      );
  static BoxDecoration get outlineGray4001 => BoxDecoration(
        color: ColorConstant.whiteA700,
        border: Border.all(
          color: ColorConstant.gray400,
          width: getHorizontalSize(
            1,
          ),
        ),
      );
  static BoxDecoration get outlineBlack9000c1 => BoxDecoration(
        color: ColorConstant.whiteA700,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black9000c,
            spreadRadius: getHorizontalSize(
              2,
            ),
            blurRadius: getHorizontalSize(
              2,
            ),
            offset: const Offset(
              0,
              20,
            ),
          ),
        ],
      );
  static BoxDecoration get fillRed700 => BoxDecoration(
        color: ColorConstant.red700,
      );
  static BoxDecoration get fillGray100 => BoxDecoration(
        color: ColorConstant.gray100,
      );
      static BoxDecoration get fillblueGray001 => BoxDecoration(
        color: ColorConstant.blueGray001,
      );
}

class BorderRadiusStyle {
  static BorderRadius txtCircleBorder26 = BorderRadius.circular(
    getHorizontalSize(
      26,
    ),
  );
 static BorderRadius roundedBorder9 = const BorderRadius.only(
    topRight: Radius.circular(20),
    topLeft: Radius.circular(20),
  );
  static BorderRadius roundedBorder8 = BorderRadius.circular(
    getHorizontalSize(
      15,
    ),
  );

  static BorderRadius circleBorder23 = BorderRadius.circular(
    getHorizontalSize(
      23,
    ),
  );

  static BorderRadius roundedBorder4 = BorderRadius.circular(
    getHorizontalSize(
      4,
    ),
  );

  static BorderRadius circleBorder42 = BorderRadius.circular(
    getHorizontalSize(
      42,
    ),
  );
}

// Comment/Uncomment the below code based on your Flutter SDK version.

// For Flutter SDK Version 3.7.2 or greater.

double get strokeAlignInside => BorderSide.strokeAlignInside;

double get strokeAlignCenter => BorderSide.strokeAlignCenter;

double get strokeAlignOutside => BorderSide.strokeAlignOutside;

// For Flutter SDK Version 3.7.1 or less.

// StrokeAlign get strokeAlignInside => StrokeAlign.inside;
//
// StrokeAlign get strokeAlignCenter => StrokeAlign.center;
//
// StrokeAlign get strokeAlignOutside => StrokeAlign.outside;
