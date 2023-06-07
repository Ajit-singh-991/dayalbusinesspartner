import 'dart:convert';
import 'dart:developer';

import 'package:dayalbusinesspartner/utils/app_decoration.dart';
import 'package:dayalbusinesspartner/widgets/color_constant.dart';
import 'package:dayalbusinesspartner/widgets/size_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DetailsPage extends StatefulWidget {
  final Map<String, dynamic> payment;
  final String userType;
  final int id;
  const DetailsPage(
      {super.key,
      required this.payment,
      required this.userType,
      required this.id});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
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
            child: ClipRRect(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                // margin: getMargin(top: 12),
                padding: getPadding(left: 0, top: 10, right: 0, bottom: 0),
                decoration: AppDecoration.fillblueGray001
                    .copyWith(borderRadius: BorderRadiusStyle.roundedBorder9),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 50, 20, 10),
                        child: Text(
                          "Payment Details:",
                          style: TextStyle(
                              color: ColorConstant.black900,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'lato'),
                        ),
                      ),
                      Card(
                        color: ColorConstant.black90011,
                        // margin: const EdgeInsets.symmetric(
                        //     horizontal: 20, vertical: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: ColorConstant.whiteA700,
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                              width: 3,
                              color: ColorConstant.whiteA700,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: getPadding(top: 20),
                                child: SvgPicture.asset(
                                    "assets/images/Vector.svg",
                                    height: 100,
                                    fit: BoxFit.fill),
                              ),
                              Padding(
                                padding: getPadding(top: 10, bottom: 20),
                                child: SvgPicture.asset(
                                    "assets/images/Payment done.svg",
                                    width: 300,
                                    height: 25,
                                    fit: BoxFit.fill),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(0),
                                child: Text(
                                  '₹ ${NumberFormat('##,##,###').format(int.parse(widget.payment['amount']))}',
                                  style: TextStyle(
                                      fontSize: 36,
                                      color: ColorConstant.black900,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  DateFormat('dd MMM yyyy').format(
                                      DateTime.parse(
                                          widget.payment['pay_date'])),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: ColorConstant.black900,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'lato',
                                      fontSize: 16),
                                ),
                              ),
                              Expanded(
                                  child: Align(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          30, 5, 0, 0),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              "assets/images/Ellipse 4.svg",
                                              width: 200,
                                              height: 7,
                                              fit: BoxFit.fill),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Payment Released",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: ColorConstant.gray600,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Inter',
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            30, 5, 0, 0),
                                        child: SvgPicture.asset(
                                            "assets/images/Line 13.svg",
                                            width: 350,
                                            height: 50,
                                            fit: BoxFit.fill),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          30, 5, 0, 20),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              "assets/images/Ellipse 4.svg",
                                              width: 200,
                                              height: 7,
                                              fit: BoxFit.fill),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Paid via ${widget.payment['pay_mode']}',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: ColorConstant.gray600,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Inter',
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  onTapArrowleft3(BuildContext context) {
    Navigator.pop(context);
  }
}
