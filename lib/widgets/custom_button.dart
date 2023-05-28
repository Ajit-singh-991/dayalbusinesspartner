// ignore_for_file: must_be_immutable, constant_identifier_names

import 'package:dayalbusinesspartner/widgets/color_constant.dart';
import 'package:dayalbusinesspartner/widgets/size_utils.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {super.key, this.shape,
      this.padding,
      this.variant,
      this.fontStyle,
      this.alignment,
      this.margin,
      this.onTap,
      this.width,
      this.height,
      this.text,
      this.prefixWidget,
      this.suffixWidget});

  ButtonShape? shape;

  ButtonPadding? padding;

  ButtonVariant? variant;

  ButtonFontStyle? fontStyle;

  Alignment? alignment;

  EdgeInsetsGeometry? margin;

  VoidCallback? onTap;

  double? width;

  double? height;

  String? text;

  Widget? prefixWidget;

  Widget? suffixWidget;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment!,
            child: _buildButtonWidget(),
          )
        : _buildButtonWidget();
  }

  _buildButtonWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: TextButton(
        onPressed: onTap,
        style: _buildTextButtonStyle(),
        child: _buildButtonWithOrWithoutIcon(),
      ),
    );
  }

  _buildButtonWithOrWithoutIcon() {
    if (prefixWidget != null || suffixWidget != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // prefixWidget ?? SizedBox(),
          Text(
            text ?? "",
            textAlign: TextAlign.start,
            style: _setFontStyle(),
          ),
          suffixWidget ?? const SizedBox(),
        ],
      );
    } else {
      return Text(
        text ?? "",
        textAlign: TextAlign.start,
        style: _setFontStyle(),
      );
    }
  }

  _buildTextButtonStyle() {
    return TextButton.styleFrom(
      fixedSize: Size(
        width ?? double.maxFinite,
        height ?? 40,
      ),
      padding: _setPadding(),
      backgroundColor: _setColor(),
      side: _setTextButtonBorder(),
      shape: RoundedRectangleBorder(
        borderRadius: _setBorderRadius(),
      ),
    );
  }

  _setPadding() {
    switch (padding) {
      case ButtonPadding.PaddingAll13:
        return const EdgeInsets.all(
          13,
        );
      case ButtonPadding.PaddingT16:
        return const EdgeInsets.fromLTRB(
         13,
        16,
        13,
        16,
        );
      case ButtonPadding.PaddingAll16:
        return const EdgeInsets.all(
         16,
        );
      case ButtonPadding.PaddingT3:
        return const EdgeInsets.fromLTRB(3,3,0,3
        );
      case ButtonPadding.PaddingAll19:
        return const EdgeInsets.all(
           19,
        );
      case ButtonPadding.PaddingT19:
        return const EdgeInsets.fromLTRB(0,19,19,19
        );
      case ButtonPadding.PaddingT15:
        return const EdgeInsets.fromLTRB(15,15,0,15
        );
      case ButtonPadding.PaddingT5:
        return const EdgeInsets.fromLTRB(0,5,5,5
        );
      case ButtonPadding.PaddingAll4:
        return const EdgeInsets.all(
           4,
        );
      default:
        return const EdgeInsets.all(
           9,
        );
    }
  }

  _setColor() {
    switch (variant) {
      case ButtonVariant.OutlineGray600:
        return const Color(0xffBDBDBD);
      case ButtonVariant.OutlineLime90051:
        return const Color(0xffffee58);
      case ButtonVariant.OutlineRed700:
        return const Color(0xffd32f2f);
      case ButtonVariant.FillYellow400:
        return const Color(0xffffee58);
      case ButtonVariant.FillWhiteA700:
        return const Color(0xfff5f5f5);
      case ButtonVariant.OutlineBlack900:
        return const Color(0xffBDBDBD);
      case ButtonVariant.FillGray100:
        return const Color(0xffBDBDBD);
      case ButtonVariant.OutlineGray400:
        return const Color(0xfff5f5f5);
      case ButtonVariant.FillGray400:
        return Colors.grey[400];
      case ButtonVariant.OutlineGreen500:
        return const Color(0xffBDBDBD);
      case ButtonVariant.OutlineRed700_1:
        return const Color(0xffBDBDBD);
      case ButtonVariant.OutlineBluegray600:
        return const Color(0xffBDBDBD);
      case ButtonVariant.OutlineYellow900:
        return const Color(0xffBDBDBD);
      case ButtonVariant.OutlineGray600_1:
        return null;
      default:
        return const Color(0xffd32f2f);
    }
  }

  _setTextButtonBorder() {
    switch (variant) {
      case ButtonVariant.OutlineGray600:
        return BorderSide(
          color: ColorConstant.gray600,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariant.OutlineLime90051:
        return BorderSide(
          color: ColorConstant.lime90051,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariant.OutlineRed700:
        return BorderSide(
          color: ColorConstant.red700,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariant.OutlineBlack900:
        return BorderSide(
          color: ColorConstant.black900,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariant.OutlineGray400:
        return BorderSide(
          color: ColorConstant.gray400,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariant.OutlineGreen500:
        return BorderSide(
          color: ColorConstant.green500,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariant.OutlineGray600_1:
        return BorderSide(
          color: ColorConstant.gray600,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariant.OutlineRed700_1:
        return BorderSide(
          color: ColorConstant.red700,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariant.OutlineBluegray600:
        return BorderSide(
          color: ColorConstant.blueGray600,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariant.OutlineYellow900:
        return BorderSide(
          color: ColorConstant.yellow900,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariant.FillRed700:
      case ButtonVariant.FillYellow400:
      case ButtonVariant.FillWhiteA700:
      case ButtonVariant.FillGray100:
      case ButtonVariant.FillGray400:
        return null;
      default:
        return null;
    }
  }

  _setBorderRadius() {
    switch (shape) {
      case ButtonShape.RoundedBorder8:
        return BorderRadius.circular(
          getHorizontalSize(
            8.00,
          ),
        );
      case ButtonShape.RoundedBorder4:
        return BorderRadius.circular(
          getHorizontalSize(
            4.00,
          ),
        );
      case ButtonShape.RoundedBorder14:
        return BorderRadius.circular(
          getHorizontalSize(
            14.00,
          ),
        );
      case ButtonShape.Square:
        return BorderRadius.circular(0);
      default:
        return BorderRadius.circular(
          getHorizontalSize(
            26.00,
          ),
        );
    }
  }

  _setFontStyle() {
    switch (fontStyle) {
      case ButtonFontStyle.InterRegular16:
        return TextStyle(
          color: ColorConstant.gray400,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        );
      case ButtonFontStyle.InterRegular16Bluegray900:
        return TextStyle(
          color: ColorConstant.blueGray900,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        );
      case ButtonFontStyle.InterRegular16WhiteA700:
        return TextStyle(
          color: ColorConstant.whiteA700,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        );
      case ButtonFontStyle.InterRegular12:
        return TextStyle(
          color: ColorConstant.blueGray900,
          fontSize: getFontSize(
            12,
          ),
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        );
      case ButtonFontStyle.InterRegular12Gray600:
        return TextStyle(
          color: ColorConstant.gray600,
          fontSize: getFontSize(
            12,
          ),
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        );
      case ButtonFontStyle.InterMedium11:
        return TextStyle(
          color: ColorConstant.gray600,
          fontSize: getFontSize(
            11,
          ),
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        );
      case ButtonFontStyle.InterRegular10:
        return TextStyle(
          color: ColorConstant.blueGray900,
          fontSize: getFontSize(
            10,
          ),
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        );
      case ButtonFontStyle.InterRegular10Gray400:
        return TextStyle(
          color: ColorConstant.gray400,
          fontSize: getFontSize(
            10,
          ),
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        );
      case ButtonFontStyle.InterMedium13:
        return TextStyle(
          color: ColorConstant.whiteA700,
          fontSize: getFontSize(
            13,
          ),
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        );
      case ButtonFontStyle.InterRegular15:
        return TextStyle(
          color: ColorConstant.gray400,
          fontSize: getFontSize(
            15,
          ),
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        );
      case ButtonFontStyle.InterRegular15WhiteA700:
        return TextStyle(
          color: ColorConstant.whiteA700,
          fontSize: getFontSize(
            15,
          ),
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        );
      case ButtonFontStyle.InterRegular885:
        return TextStyle(
          color: ColorConstant.whiteA700,
          fontSize: getFontSize(
            8.85,
          ),
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        );
      case ButtonFontStyle.InterRegular10Green500:
        return TextStyle(
          color: ColorConstant.green500,
          fontSize: getFontSize(
            10,
          ),
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        );
      case ButtonFontStyle.InterRegular10Gray600:
        return TextStyle(
          color: ColorConstant.gray600,
          fontSize: getFontSize(
            10,
          ),
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        );
      case ButtonFontStyle.InterRegular10Red700:
        return TextStyle(
          color: ColorConstant.red700,
          fontSize: getFontSize(
            10,
          ),
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        );
      case ButtonFontStyle.InterRegular10Bluegray600:
        return TextStyle(
          color: ColorConstant.blueGray600,
          fontSize: getFontSize(
            10,
          ),
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        );
      case ButtonFontStyle.InterRegular10Yellow900:
        return TextStyle(
          color: ColorConstant.yellow900,
          fontSize: getFontSize(
            10,
          ),
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        );
      default:
        return TextStyle(
          color: ColorConstant.whiteA700,
          fontSize: getFontSize(
            20,
          ),
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        );
    }
  }
}

enum ButtonShape {
  Square,
  CircleBorder26,
  RoundedBorder8,
  RoundedBorder4,
  RoundedBorder14,
}

enum ButtonPadding {
  PaddingAll13,
  PaddingT16,
  PaddingAll16,
  PaddingAll9,
  PaddingT3,
  PaddingAll19,
  PaddingT19,
  PaddingT15,
  PaddingT5,
  PaddingAll4,
}

enum ButtonVariant {
  FillRed700,
  OutlineGray600,
  OutlineLime90051,
  OutlineRed700,
  FillYellow400,
  FillWhiteA700,
  OutlineBlack900,
  FillGray100,
  OutlineGray400,
  FillGray400,
  OutlineGreen500,
  OutlineGray600_1,
  OutlineRed700_1,
  OutlineBluegray600,
  OutlineYellow900,
}

enum ButtonFontStyle {
  InterRegular20,
  InterRegular16,
  InterRegular16Bluegray900,
  InterRegular16WhiteA700,
  InterRegular12,
  InterRegular12Gray600,
  InterMedium11,
  InterRegular10,
  InterRegular10Gray400,
  InterMedium13,
  InterRegular15,
  InterRegular15WhiteA700,
  InterRegular885,
  InterRegular10Green500,
  InterRegular10Gray600,
  InterRegular10Red700,
  InterRegular10Bluegray600,
  InterRegular10Yellow900,
}
