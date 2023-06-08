import 'dart:convert';
import 'dart:developer';

import 'package:dayalbusinesspartner/utils/app_decoration.dart';
import 'package:dayalbusinesspartner/utils/app_style.dart';
import 'package:dayalbusinesspartner/widgets/color_constant.dart';
import 'package:dayalbusinesspartner/widgets/custom_button.dart';
import 'package:dayalbusinesspartner/widgets/custom_text_form_field.dart';
import 'package:dayalbusinesspartner/widgets/size_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class EnquiryForm extends StatefulWidget {
  final String userType;
  final int id;

  const EnquiryForm({super.key, required this.userType, required this.id});

  @override
  State<EnquiryForm> createState() => _EnquiryFormState();
}

class _EnquiryFormState extends State<EnquiryForm> {
  TextEditingController fullnameController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController messageController = TextEditingController();

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
              child: Form(
                  key: _formKey,
                  child: Container(
                      width: double.maxFinite,
                      child: Container(
                          width: double.maxFinite,
                          margin: getMargin(top: 12),
                          padding: getPadding(
                              left: 16, top: 34, right: 16, bottom: 34),
                          decoration: AppDecoration.fillGray100.copyWith(
                              borderRadius: BorderRadiusStyle.roundedBorder8),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: getPadding(left: 6),
                                    child: Text("Send us Message:",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle.txtInterBold24)),
                                CustomTextFormField(
                                    focusNode: FocusNode(),
                                    controller: fullnameController,
                                    hintText: "*Full Name",
                                    margin: getMargin(top: 10)),
                                CustomTextFormField(
                                    focusNode: FocusNode(),
                                    controller: phoneController,
                                    hintText: "*Phone No.",
                                    margin: getMargin(top: 9),
                                    textInputType: TextInputType.phone),
                                CustomTextFormField(
                                    focusNode: FocusNode(),
                                    controller: emailController,
                                    hintText: "*Email",
                                    margin: getMargin(top: 9),
                                    textInputType: TextInputType.emailAddress),
                                CustomTextFormField(
                                    focusNode: FocusNode(),
                                    controller: messageController,
                                    hintText: "*Message",
                                    margin: getMargin(top: 9),
                                    padding: TextFormFieldPadding.PaddingT43,
                                    textInputAction: TextInputAction.done,
                                    maxLines: 5),
                                CustomButton(
                                    height: getVerticalSize(47),
                                    text: "Send",
                                    margin: getMargin(top: 13, bottom: 5),
                                    variant: ButtonVariant.OutlineRed700,
                                    shape: ButtonShape.RoundedBorder8,
                                    padding: ButtonPadding.PaddingAll13,
                                    fontStyle:
                                        ButtonFontStyle.InterRegular16WhiteA700)
                              ])))),
            ),
          ],
        ),
       );
  }

  onTapArrowleft3(BuildContext context) {
    Navigator.pop(context);
  }
}
