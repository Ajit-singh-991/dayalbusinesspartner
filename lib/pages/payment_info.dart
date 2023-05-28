import 'dart:convert';
import 'dart:developer';

import 'package:dayalbusinesspartner/utils/app_decoration.dart';
import 'package:dayalbusinesspartner/utils/app_style.dart';
import 'package:dayalbusinesspartner/utils/custom_image_view.dart';
import 'package:dayalbusinesspartner/widgets/color_constant.dart';
import 'package:dayalbusinesspartner/widgets/custom_button.dart';
import 'package:dayalbusinesspartner/widgets/custom_text_form_field.dart';
import 'package:dayalbusinesspartner/widgets/image_constant.dart';
import 'package:dayalbusinesspartner/widgets/size_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ignore_for_file: must_be_immutable
class AddPayDetailsIosPage extends StatefulWidget {
  final String userType;
  final int id;
  const AddPayDetailsIosPage(
      {super.key, required this.userType, required this.id});

  @override
  State<AddPayDetailsIosPage> createState() => _AddPayDetailsIosPageState();
}

class _AddPayDetailsIosPageState extends State<AddPayDetailsIosPage> {
  TextEditingController dateController = TextEditingController();

  TextEditingController amountController = TextEditingController();

  TextEditingController remarksController = TextEditingController();

  String name = '';

  Future<void> fetchProfileData() async {
    const profileurl = 'http://66.94.34.21:8090/getProfile';
    final requestBody = {
      'usertype': widget.userType,
      'id': widget.id,
    };
    final response = await http.post(Uri.parse(profileurl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody));
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      log('========= $responseData++++');
      final data = responseData['data'] as List;
      final firstItem = data.first;
      final nameFromResponse = firstItem['name'];
      setState(() {
        name = nameFromResponse;
        log("===============$name++++++++++");
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.red700,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.12,
            color: ColorConstant.red700,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        onTapArrowleft3(context);
                      },
                      icon: const Icon(
                        CupertinoIcons.arrow_left,
                        color: Colors.white,
                      )),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Center(
                        child: Text(
                      'Hello $name',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    )),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: CircleAvatar(
                      radius: 24.0,
                      backgroundImage: NetworkImage(
                          'https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425_1280.png'),
                      backgroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ClipRect(
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: double.maxFinite,
                  // margin: getMargin(top: 12),
                  padding: getPadding(left: 16, top: 25, right: 16, bottom: 25),
                  decoration: AppDecoration.fillGray100
                      .copyWith(borderRadius: BorderRadiusStyle.roundedBorder9),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                            padding: getPadding(left: 6, top: 6),
                            child: Text("Add New Details:",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtInterBold24)),
                        CustomTextFormField(
                            focusNode: FocusNode(),
                            controller: dateController,
                            hintText: "*Payment Date",
                            margin: getMargin(top: 13)),
                        CustomTextFormField(
                            focusNode: FocusNode(),
                            controller: amountController,
                            hintText: "*Amount",
                            margin: getMargin(top: 9)),
                        CustomButton(
                            height: getVerticalSize(50),
                            text: "Paid Via",
                            margin: getMargin(top: 7),
                            variant: ButtonVariant.OutlineGray400,
                            shape: ButtonShape.RoundedBorder8,
                            padding: ButtonPadding.PaddingT15,
                            fontStyle: ButtonFontStyle.InterRegular15,
                            suffixWidget: Container(
                                margin: getMargin(left: 250),
                                child: CustomImageView(
                                    svgPath:
                                        ImageConstant.imgArrowdownGray400)),
                            onTap: () {
                              onTapPaidvia(context);
                            }),
                        Container(
                            margin: getMargin(top: 8),
                            padding: getPadding(all: 7),
                            decoration: AppDecoration.outlineGray4001.copyWith(
                                borderRadius: BorderRadiusStyle.roundedBorder8),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                      padding: getPadding(
                                          left: 18, top: 7, bottom: 6),
                                      child: Text("*Image",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle
                                              .txtInterRegular15Gray400)),
                                  CustomButton(
                                      height: getVerticalSize(33),
                                      width: getHorizontalSize(126),
                                      text: "Upload",
                                      variant: ButtonVariant.FillGray400,
                                      shape: ButtonShape.RoundedBorder4,
                                      fontStyle: ButtonFontStyle
                                          .InterRegular15WhiteA700)
                                ])),
                        CustomTextFormField(
                            focusNode: FocusNode(),
                            controller: remarksController,
                            hintText: "Remarks",
                            margin: getMargin(top: 9),
                            textInputAction: TextInputAction.done),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: CustomButton(
                              height: getVerticalSize(54),
                              width: getHorizontalSize(175),
                              text: "Done".toUpperCase(),
                              padding: ButtonPadding.PaddingAll19,
                              fontStyle: ButtonFontStyle.InterMedium13,
                              onTap: () {
                                onTapDone(context);
                              },
                              alignment: Alignment.centerRight),
                        )
                      ])),
            ),
          ),
        ],
      ),
    );
  }

  onTapPaidvia(BuildContext context) {
    // Navigator.pushNamed(context, AppRoutes.addPayDetailsIosOneScreen);
  }

  onTapDone(BuildContext context) {
    // Navigator.pushNamed(context, AppRoutes.paymentIosScreen);
  }

  onTapArrowleft3(BuildContext context) {
    Navigator.pop(context);
  }
}
