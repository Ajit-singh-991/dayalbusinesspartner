import 'dart:convert';
import 'dart:developer';

import 'package:dayalbusinesspartner/utils/app_decoration.dart';
import 'package:dayalbusinesspartner/utils/app_style.dart';
import 'package:dayalbusinesspartner/utils/custom_image_view.dart';
import 'package:dayalbusinesspartner/widgets/color_constant.dart';
import 'package:dayalbusinesspartner/widgets/custom_button.dart';
import 'package:dayalbusinesspartner/widgets/custom_drop_down.dart';
import 'package:dayalbusinesspartner/widgets/custom_text_form_field.dart';
import 'package:dayalbusinesspartner/widgets/image_constant.dart';
import 'package:dayalbusinesspartner/widgets/size_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderIosOneScreen extends StatefulWidget {
  final String userType;
  final int id;
  const OrderIosOneScreen(
      {super.key, required this.userType, required this.id});

  @override
  State<OrderIosOneScreen> createState() => _OrderIosOneScreenState();
}

class _OrderIosOneScreenState extends State<OrderIosOneScreen> {
  List<String> dropdownItemList = ["Item One", "Item Two", "Item Three"];

  TextEditingController weightController = TextEditingController();

  TextEditingController weightoneController = TextEditingController();

  TextEditingController remarksController = TextEditingController();

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();
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
        child: Container(
            width: double.maxFinite,
            child: Container(
                width: double.maxFinite,
                margin: getMargin(top: 12),
                padding: getPadding(left: 16, top: 18, right: 16, bottom: 18),
                decoration: AppDecoration.fillGray100
                    .copyWith(borderRadius: BorderRadiusStyle.roundedBorder8),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomDropDown(
                          focusNode: FocusNode(),
                          icon: Container(
                              margin: getMargin(left: 30, right: 37),
                              child: CustomImageView(
                                  svgPath:
                                      ImageConstant.imgArrowdownBlueGray900)),
                          hintText: "Dealer 1",
                          items: dropdownItemList,
                          onChanged: (value) {}),
                      Padding(
                          padding: getPadding(top: 16),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: CustomButton(
                                        height: getVerticalSize(33),
                                        text: "Product Item",
                                        margin: getMargin(right: 4),
                                        variant: ButtonVariant.FillYellow400,
                                        shape: ButtonShape.RoundedBorder8,
                                        fontStyle:
                                            ButtonFontStyle.InterRegular12)),
                                Expanded(
                                    child: CustomButton(
                                        height: getVerticalSize(33),
                                        text: "Scheme Item",
                                        margin: getMargin(left: 4),
                                        variant: ButtonVariant.FillWhiteA700,
                                        shape: ButtonShape.RoundedBorder8,
                                        fontStyle: ButtonFontStyle
                                            .InterRegular12Gray600))
                              ])),
                      Container(
                          margin: getMargin(top: 17),
                          padding: getPadding(
                              left: 13, top: 7, right: 13, bottom: 7),
                          decoration: AppDecoration.fillWhiteA700.copyWith(
                              borderRadius: BorderRadiusStyle.roundedBorder8),
                          child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    height: getSize(82),
                                    width: getSize(82),
                                    child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Align(
                                              alignment: Alignment.center,
                                              child: Container(
                                                  height: getVerticalSize(82),
                                                  width:
                                                      getHorizontalSize(77),
                                                  decoration: BoxDecoration(
                                                      color: ColorConstant
                                                          .gray100,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              getHorizontalSize(
                                                                  6)),
                                                      border: Border.all(
                                                          color: ColorConstant
                                                              .gray600,
                                                          width:
                                                              getHorizontalSize(
                                                                  1))))),
                                          CustomImageView(
                                              imagePath: ImageConstant
                                                  .imgDayalsuperaction,
                                              height: getVerticalSize(76),
                                              width: getHorizontalSize(82),
                                              alignment: Alignment.center)
                                        ])),
                                Container(
                                    height: getVerticalSize(61),
                                    width: getHorizontalSize(244),
                                    margin: getMargin(
                                        top: 10, right: 2, bottom: 11),
                                    child: Stack(
                                        alignment: Alignment.bottomRight,
                                        children: [
                                          CustomButton(
                                              height: getVerticalSize(20),
                                              width: getHorizontalSize(59),
                                              text: "10 kg",
                                              margin: getMargin(bottom: 17),
                                              variant: ButtonVariant
                                                  .OutlineBlack900,
                                              shape:
                                                  ButtonShape.RoundedBorder4,
                                              padding:
                                                  ButtonPadding.PaddingT3,
                                              fontStyle: ButtonFontStyle
                                                  .InterMedium11,
                                              suffixWidget: Container(
                                                  margin: getMargin(left: 8),
                                                  decoration: BoxDecoration(
                                                      color: ColorConstant
                                                          .gray600),
                                                  child: CustomImageView(
                                                      svgPath: ImageConstant
                                                          .imgVectorGray600)),
                                              alignment:
                                                  Alignment.bottomLeft),
                                          CustomButton(
                                              height: getVerticalSize(27),
                                              width: getHorizontalSize(61),
                                              text: "Add",
                                              variant:
                                                  ButtonVariant.FillYellow400,
                                              shape:
                                                  ButtonShape.RoundedBorder4,
                                              fontStyle: ButtonFontStyle
                                                  .InterRegular10,
                                              alignment:
                                                  Alignment.bottomRight),
                                          Align(
                                              alignment: Alignment.topCenter,
                                              child: Container(
                                                  width:
                                                      getHorizontalSize(244),
                                                  margin:
                                                      getMargin(bottom: 34),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                            padding:
                                                                getPadding(
                                                                    bottom:
                                                                        6),
                                                            child: Text(
                                                                "Dayal Super Action",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: AppStyle
                                                                    .txtInterMedium16)),
                                                        CustomButton(
                                                            height:
                                                                getVerticalSize(
                                                                    27),
                                                            width:
                                                                getHorizontalSize(
                                                                    61),
                                                            text: "Quantity",
                                                            variant:
                                                                ButtonVariant
                                                                    .FillGray100,
                                                            shape: ButtonShape
                                                                .RoundedBorder4,
                                                            fontStyle:
                                                                ButtonFontStyle
                                                                    .InterRegular10Gray400)
                                                      ])))
                                        ]))
                              ])),
                      Container(
                          margin: getMargin(top: 12),
                          padding: getPadding(
                              left: 15, top: 7, right: 15, bottom: 7),
                          decoration: AppDecoration.fillWhiteA700.copyWith(
                              borderRadius: BorderRadiusStyle.roundedBorder8),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Card(
                                    clipBehavior: Clip.antiAlias,
                                    elevation: 0,
                                    margin: EdgeInsets.all(0),
                                    color: ColorConstant.gray100,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: ColorConstant.gray600,
                                            width: getHorizontalSize(1)),
                                        borderRadius:
                                            BorderRadiusStyle.roundedBorder8),
                                    child: Container(
                                        height: getVerticalSize(82),
                                        width: getHorizontalSize(77),
                                        padding:
                                            getPadding(left: 15, right: 15),
                                        decoration: AppDecoration
                                            .outlineGray600
                                            .copyWith(
                                                borderRadius:
                                                    BorderRadiusStyle
                                                        .roundedBorder8),
                                        child: Stack(children: [
                                          CustomImageView(
                                              imagePath: ImageConstant
                                                  .imgDayalshakti2,
                                              height: getVerticalSize(82),
                                              width: getHorizontalSize(46),
                                              alignment: Alignment.center)
                                        ]))),
                                Padding(
                                    padding: getPadding(
                                        left: 7, top: 10, bottom: 28),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text("Dayal Shakti",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style:
                                                  AppStyle.txtInterMedium16),
                                          CustomTextFormField(
                                              width: getHorizontalSize(61),
                                              focusNode: FocusNode(),
                                              controller: weightController,
                                              hintText: "50 kg",
                                              margin: getMargin(top: 3),
                                              variant: TextFormFieldVariant
                                                  .OutlineBlack900,
                                              shape: TextFormFieldShape
                                                  .RoundedBorder4,
                                              padding: TextFormFieldPadding
                                                  .PaddingT3,
                                              fontStyle:
                                                  TextFormFieldFontStyle
                                                      .InterMedium11,
                                              suffix: Container(
                                                  margin: getMargin(
                                                      left: 7,
                                                      top: 8,
                                                      right: 9,
                                                      bottom: 8),
                                                  decoration: BoxDecoration(
                                                      color: ColorConstant
                                                          .gray600),
                                                  child: CustomImageView(
                                                      svgPath: ImageConstant
                                                          .imgVectorGray600)),
                                              suffixConstraints:
                                                  BoxConstraints(
                                                      maxHeight:
                                                          getVerticalSize(
                                                              20)))
                                        ])),
                                Spacer(),
                                Padding(
                                    padding: getPadding(top: 10, bottom: 11),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          CustomButton(
                                              height: getVerticalSize(27),
                                              width: getHorizontalSize(61),
                                              text: "Quantity",
                                              variant:
                                                  ButtonVariant.FillGray100,
                                              shape:
                                                  ButtonShape.RoundedBorder4,
                                              fontStyle: ButtonFontStyle
                                                  .InterRegular10Gray400),
                                          CustomButton(
                                              height: getVerticalSize(27),
                                              width: getHorizontalSize(61),
                                              text: "Add",
                                              margin: getMargin(top: 7),
                                              variant:
                                                  ButtonVariant.FillYellow400,
                                              shape:
                                                  ButtonShape.RoundedBorder4,
                                              fontStyle: ButtonFontStyle
                                                  .InterRegular10)
                                        ]))
                              ])),
                      Container(
                          margin: getMargin(top: 12),
                          padding: getPadding(
                              left: 9, top: 7, right: 9, bottom: 7),
                          decoration: AppDecoration.fillWhiteA700.copyWith(
                              borderRadius: BorderRadiusStyle.roundedBorder8),
                          child: Row(children: [
                            Container(
                                height: getVerticalSize(82),
                                width: getHorizontalSize(90),
                                child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                              height: getVerticalSize(82),
                                              width: getHorizontalSize(77),
                                              decoration: BoxDecoration(
                                                  color:
                                                      ColorConstant.gray100,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          getHorizontalSize(
                                                              6)),
                                                  border: Border.all(
                                                      color: ColorConstant
                                                          .gray600,
                                                      width:
                                                          getHorizontalSize(
                                                              1))))),
                                      CustomImageView(
                                          imagePath: ImageConstant
                                              .imgDayalanmolsuper,
                                          height: getVerticalSize(77),
                                          width: getHorizontalSize(90),
                                          alignment: Alignment.bottomCenter)
                                    ])),
                            Padding(
                                padding: getPadding(top: 10, bottom: 28),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    children: [
                                      Text("Dayal Anmol Super",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle.txtInterMedium16),
                                      CustomTextFormField(
                                          width: getHorizontalSize(54),
                                          focusNode: FocusNode(),
                                          controller: weightoneController,
                                          hintText: "25 kg",
                                          margin: getMargin(top: 3),
                                          variant: TextFormFieldVariant
                                              .OutlineBlack900,
                                          shape: TextFormFieldShape
                                              .RoundedBorder4,
                                          padding:
                                              TextFormFieldPadding.PaddingT3,
                                          fontStyle: TextFormFieldFontStyle
                                              .InterMedium11,
                                          suffix: Container(
                                              margin: getMargin(
                                                  left: 5,
                                                  top: 8,
                                                  right: 6,
                                                  bottom: 8),
                                              decoration: BoxDecoration(
                                                  color:
                                                      ColorConstant.gray600),
                                              child: CustomImageView(
                                                  svgPath: ImageConstant
                                                      .imgVectorGray600)),
                                          suffixConstraints: BoxConstraints(
                                              maxHeight: getVerticalSize(20)))
                                    ])),
                            Padding(
                                padding:
                                    getPadding(left: 38, top: 10, bottom: 11),
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    children: [
                                      CustomButton(
                                          height: getVerticalSize(27),
                                          width: getHorizontalSize(61),
                                          text: "Quantity",
                                          variant: ButtonVariant.FillGray100,
                                          shape: ButtonShape.RoundedBorder4,
                                          fontStyle: ButtonFontStyle
                                              .InterRegular10Gray400),
                                      CustomButton(
                                          height: getVerticalSize(27),
                                          width: getHorizontalSize(61),
                                          text: "Add",
                                          margin: getMargin(top: 7),
                                          variant:
                                              ButtonVariant.FillYellow400,
                                          shape: ButtonShape.RoundedBorder4,
                                          fontStyle:
                                              ButtonFontStyle.InterRegular10)
                                    ]))
                          ])),
                      CustomTextFormField(
                          focusNode: FocusNode(),
                          controller: remarksController,
                          hintText: "Remarks",
                          margin: getMargin(top: 14),
                          variant: TextFormFieldVariant.FillWhiteA700,
                          textInputAction: TextInputAction.done),
                      CustomButton(
                          height: getVerticalSize(54),
                          width: getHorizontalSize(175),
                          text: "Done".toUpperCase(),
                          margin: getMargin(top: 50, bottom: 7),
                          padding: ButtonPadding.PaddingAll19,
                          fontStyle: ButtonFontStyle.InterMedium13,
                          onTap: () {
                            // onTapDone(context);
                          })
                    ]))),
      ),
    ],
      ),
    );
  }

  onTapArrowleft3(BuildContext context) {
    Navigator.pop(context);
  }
}
