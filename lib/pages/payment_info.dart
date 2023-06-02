import 'dart:convert';
import 'dart:developer';

import 'package:dayalbusinesspartner/utils/app_decoration.dart';
import 'package:dayalbusinesspartner/utils/app_style.dart';
import 'package:dayalbusinesspartner/utils/custom_image_view.dart';
import 'package:dayalbusinesspartner/utils/customsnackbar.dart';
import 'package:dayalbusinesspartner/widgets/color_constant.dart';
import 'package:dayalbusinesspartner/widgets/custom_button.dart';
import 'package:dayalbusinesspartner/widgets/custom_drop_down.dart';
import 'package:dayalbusinesspartner/widgets/custom_text_form_field.dart';
import 'package:dayalbusinesspartner/widgets/date_form_field.dart';
import 'package:dayalbusinesspartner/widgets/image_constant.dart';
import 'package:dayalbusinesspartner/widgets/size_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:one_context/one_context.dart';

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
  List<String> dropdownItemList = ["RTGS", "NEFT", "Cash"];
  TextEditingController _bankController = TextEditingController();

  TextEditingController amountController = TextEditingController();

  TextEditingController remarksController = TextEditingController();

  final TextEditingController _dateController = TextEditingController();

  String name = '';
  DateTime? selectedDate;
  String paidviac = "";
  String? selectedImageName;
  String pickedimagePath = "";

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
                        DateFormField(
                          focusNode: FocusNode(),
                          controller: _dateController,
                          hintText: 'Select a date',
                          margin: getMargin(top: 9),
                          context: context,
                        ),
                        CustomTextFormField(
                            focusNode: FocusNode(),
                            controller: amountController,
                            hintText: "*Amount",
                            margin: getMargin(top: 9)),
                        CustomTextFormField(
                            focusNode: FocusNode(),
                            controller: _bankController,
                            hintText: "*Bank Name",
                            margin: getMargin(top: 9)),
                        CustomDropDown(
                            focusNode: FocusNode(),
                            icon: Container(
                                margin: getMargin(left: 30, right: 37),
                                child: CustomImageView(
                                    svgPath:
                                        ImageConstant.imgArrowdownGray400)),
                            hintText: "*Paid Via",
                            items: dropdownItemList,
                            margin: getMargin(top: 9),
                            onChanged: (value) {
                              paidviac = value;
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
                                      child: Text(selectedImageName ?? "Image",
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
                                    fontStyle:
                                        ButtonFontStyle.InterRegular15WhiteA700,
                                    onTap: () async {
                                      final pickedImage = await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.gallery);
                                      if (pickedImage != null) {
                                        String imagePath = pickedImage.path;
                                        String imageName =
                                            imagePath.split('/').last;
                                        setState(() {
                                          selectedImageName = imageName;
                                          pickedimagePath = imagePath;
                                        });
                                      }
                                    },
                                  )
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

  Future<void> updateData(String payDate, String amount, String payVia,
      String image, String remark, String bank) async {
    const paymenturl = 'http://66.94.34.21:9000/payment';
    Map<String, dynamic> requestBody = {
      "pay_date": payDate,
      "amount": amount,
      "pay_via": payVia,
      "image": image,
      "remark": remark,
      "bank": bank,
      "id": widget.id
    };

    String jsonBody = json.encode(requestBody);

    try {
      http.Response response = await http.post(
        Uri.parse(paymenturl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        log('Data updated successfully');
      } else {
        log('Failed to update data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      log('Error occurred while updating data: $error');
    }
  }

  onTapDone(BuildContext context) {
    String payDate = _dateController.text;
    String amount = amountController.text;
    String payVia = paidviac;
    String image = pickedimagePath;
    String remark = remarksController.text;
    String bank = _bankController.text;

    updateData(payDate, amount, payVia, image, remark, bank);
    OneContext().hideCurrentSnackBar();
    OneContext().showSnackBar(
        builder: (context) => ShowSnackBar()
            .customBar("Updated Sucessfully".toString(), context!, true));
    Navigator.pop(context);
  }

  onTapArrowleft3(BuildContext context) {
    Navigator.pop(context);
  }
}
