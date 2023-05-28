// ignore_for_file: must_be_immutable, constant_identifier_names

import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField(
      {super.key,
      this.shape,
      this.padding,
      this.variant,
      this.fontStyle,
      this.alignment,
      this.width,
      this.margin,
      this.controller,
      this.focusNode,
      this.isObscureText = false,
      this.textInputAction = TextInputAction.next,
      this.textInputType = TextInputType.text,
      this.maxLines,
      this.hintText,
      this.prefix,
      this.prefixConstraints,
      this.suffix,
      this.suffixConstraints,
      this.validator});

  TextFormFieldShape? shape;

  TextFormFieldPadding? padding;

  TextFormFieldVariant? variant;

  TextFormFieldFontStyle? fontStyle;

  Alignment? alignment;

  double? width;

  EdgeInsetsGeometry? margin;

  TextEditingController? controller;

  FocusNode? focusNode;

  bool? isObscureText;

  TextInputAction? textInputAction;

  TextInputType? textInputType;

  int? maxLines;

  String? hintText;

  Widget? prefix;

  BoxConstraints? prefixConstraints;

  Widget? suffix;

  BoxConstraints? suffixConstraints;

  FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: _buildTextFormFieldWidget(),
          )
        : _buildTextFormFieldWidget();
  }

  _buildTextFormFieldWidget() {
    return Container(
      width: width ?? double.maxFinite,
      margin: margin,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        style: _setFontStyle(),
        obscureText: isObscureText!,
        textInputAction: textInputAction,
        keyboardType: textInputType,
        maxLines: maxLines ?? 1,
        decoration: _buildDecoration(),
        validator: validator,
      ),
    );
  }

  _buildDecoration() {
    return InputDecoration(
      hintText: hintText ?? "",
      hintStyle: _setFontStyle(),
      border: _setBorderStyle(),
      enabledBorder: _setBorderStyle(),
      focusedBorder: _setBorderStyle(),
      disabledBorder: _setBorderStyle(),
      prefixIcon: prefix,
      prefixIconConstraints: prefixConstraints,
      suffixIcon: suffix,
      suffixIconConstraints: suffixConstraints,
      fillColor: _setFillColor(),
      filled: _setFilled(),
      isDense: true,
      contentPadding: _setPadding(),
    );
  }

  _setFontStyle() {
    switch (fontStyle) {
      case TextFormFieldFontStyle.InterRegular16:
        return TextStyle(
          color: Colors.grey[400],
          fontSize: 16,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        );
      case TextFormFieldFontStyle.BalooMedium22:
        return TextStyle(
          color: Colors.blueGrey[900],
          fontSize: 22,
          fontFamily: 'Baloo',
          fontWeight: FontWeight.w500,
        );
      case TextFormFieldFontStyle.InterRegular12:
        return const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        );
      case TextFormFieldFontStyle.InterMedium12:
        return TextStyle(
          color: Colors.grey[900],
          fontSize: 22,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        );
      case TextFormFieldFontStyle.InterMedium11:
        return TextStyle(
          color: Colors.grey[600],
          fontSize: 11,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        );
      default:
        return TextStyle(
          color: Colors.grey[400],
          fontSize: 15,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        );
    }
  }

  _setOutlineBorderRadius() {
    switch (shape) {
      case TextFormFieldShape.CircleBorder26:
        return BorderRadius.circular(26);
      case TextFormFieldShape.RoundedBorder14:
        return BorderRadius.circular(14);
      case TextFormFieldShape.RoundedBorder4:
        return BorderRadius.circular(4);
      default:
        return BorderRadius.circular(8);
    }
  }

  _setBorderStyle() {
    switch (variant) {
      case TextFormFieldVariant.OutlineGray600:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: const BorderSide(
            color: Color(0xffBDBDBD),
            width: 1,
          ),
        );
      case TextFormFieldVariant.FillYellow400:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide.none,
        );
      case TextFormFieldVariant.FillRed700:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide.none,
        );
      case TextFormFieldVariant.UnderLineGray400:
        return const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xffBDBDBD),
          ),
        );
      case TextFormFieldVariant.OutlineBlack900:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: const BorderSide(
            color: Color(0xDD000000),
            width: 1,
          ),
        );
      case TextFormFieldVariant.FillWhiteA700:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide.none,
        );
      case TextFormFieldVariant.None:
        return InputBorder.none;
      default:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: const BorderSide(
            color: Color(0xffBDBDBD),
            width: 1,
          ),
        );
    }
  }

  _setFillColor() {
    switch (variant) {
      case TextFormFieldVariant.OutlineGray600:
        return const Color(0xfff5f5f5);
      case TextFormFieldVariant.FillYellow400:
        return const Color(0xffffee58);
      case TextFormFieldVariant.FillRed700:
        return const Color(0xffd32f2f);
      case TextFormFieldVariant.OutlineBlack900:
        return const Color(0xffBDBDBD);
      case TextFormFieldVariant.FillWhiteA700:
        return const Color(0xb3ffffff);
      default:
        return const Color(0xb3ffffff);
    }
  }

  _setFilled() {
    switch (variant) {
      case TextFormFieldVariant.OutlineGray600:
        return true;
      case TextFormFieldVariant.FillYellow400:
        return true;
      case TextFormFieldVariant.FillRed700:
        return true;
      case TextFormFieldVariant.UnderLineGray400:
        return false;
      case TextFormFieldVariant.OutlineBlack900:
        return true;
      case TextFormFieldVariant.FillWhiteA700:
        return true;
      case TextFormFieldVariant.None:
        return false;
      default:
        return true;
    }
  }

  _setPadding() {
    switch (padding) {
      case TextFormFieldPadding.PaddingT43:
        return const EdgeInsets.fromLTRB(
          25,
          43,
          25,
          43,
        );
      case TextFormFieldPadding.PaddingAll4:
        return const EdgeInsets.all(
          4,
        );
      case TextFormFieldPadding.PaddingAll7:
        return const EdgeInsets.all( 7,
        );
      case TextFormFieldPadding.PaddingT3:
        return const EdgeInsets.fromLTRB(3,3,0,3
        );
      default:
        return const EdgeInsets.all(14,
        );
    }
  }
}

enum TextFormFieldShape {
  RoundedBorder8,
  CircleBorder26,
  RoundedBorder14,
  RoundedBorder4,
}

enum TextFormFieldPadding {
  PaddingAll14,
  PaddingT43,
  PaddingAll4,
  PaddingAll7,
  PaddingT3,
}

enum TextFormFieldVariant {
  None,
  OutlineGray400,
  OutlineGray600,
  FillYellow400,
  FillRed700,
  UnderLineGray400,
  OutlineBlack900,
  FillWhiteA700,
}

enum TextFormFieldFontStyle {
  InterRegular15,
  InterRegular16,
  BalooMedium22,
  InterRegular12,
  InterMedium12,
  InterMedium11,
}
