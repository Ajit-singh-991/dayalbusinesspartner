import 'dart:convert';
import 'dart:developer';

import 'package:dayalbusinesspartner/utils/app_decoration.dart';
import 'package:dayalbusinesspartner/widgets/color_constant.dart';
import 'package:dayalbusinesspartner/widgets/size_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductDetailsPage extends StatefulWidget {
  final dynamic product;
  final String userType;
  final int id;
  const ProductDetailsPage(
      {super.key, this.product, required this.userType, required this.id});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  String name = '';
  bool firstButtonSelected = false;
  bool secondButtonSelected = false;

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
                  Image.asset(
                      "assets/images/dayalgroup.png",
                    ),
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
              height: MediaQuery.of(context).size.height * 0.6,
              width: double.maxFinite,
              // margin: getMargin(top: 12),
              padding: getPadding(left: 0, top: 10, right: 0, bottom: 0),
              decoration: AppDecoration.fillblueGray001
                  .copyWith(borderRadius: BorderRadiusStyle.roundedBorder9),
              child: Padding(
                padding: getPadding(top: 20, left: 20, right: 20),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:
                          getPadding(top: 20, bottom: 20, right: 20, left: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: getPadding(
                              top: 20,
                              bottom: 20,
                            ),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFFf4f4f4),
                              ),
                              child: Image.network(
                                widget.product['main_image'].toString(),
                                filterQuality: FilterQuality.high,
                                fit: BoxFit.cover,
                                scale: 1,
                              ),
                            ),
                          ),
                          Text(
                            widget.product['product_name'].toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontFamily: "Baloo",
                                fontWeight: FontWeight.w900,
                                fontSize: 30),
                          ),
                          const SizedBox(height: 20,),
                          Row(
                            children: [
                              Padding(
                                padding: getPadding(right: 10),
                                child: SizedBox(
                                  height: 70,
                                  width: 150,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        firstButtonSelected = true;
                                        secondButtonSelected = false;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: firstButtonSelected
                                          ? ColorConstant.red70000c
                                          : ColorConstant.gray100,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              12), // <-- Radius
                                          side: BorderSide(
                                              color: firstButtonSelected
                                                  ? ColorConstant.red700
                                                  : ColorConstant.gray400)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: getPadding(
                                            top: 15,
                                            bottom: 0,
                                          ),
                                          child: Text(
                                            "पैकिंग: ${widget.product['packing'].toString()}",
                                            style: TextStyle(
                                                color: ColorConstant.gray300,
                                                fontFamily: "Baloo"),
                                          ),
                                        ),
                                        Text(
                                          "MRP: ₹${widget.product['price'].toString()}",
                                          style: TextStyle(
                                              color: firstButtonSelected
                                                  ? ColorConstant.black900
                                                  : ColorConstant.gray300,
                                              fontFamily: "Inter",
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 70,
                                width: 150,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      firstButtonSelected = false;
                                      secondButtonSelected = true;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: secondButtonSelected
                                        ? ColorConstant.red70000c
                                        : ColorConstant.gray100,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            12), // <-- Radius
                                        side: BorderSide(
                                            color: secondButtonSelected
                                                ? ColorConstant.red700
                                                : ColorConstant.gray400)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: getPadding(
                                          top: 15,
                                          bottom: 0,
                                        ),
                                        child: Text(
                                          "पैकिंग: ${widget.product['packing'].toString()}",
                                          style: TextStyle(
                                              color: ColorConstant.gray300,
                                              fontFamily: "Baloo"),
                                        ),
                                      ),
                                      Text(
                                        "MRP: ₹${widget.product['price'].toString()}",
                                        style: TextStyle(
                                            color: secondButtonSelected
                                                ? ColorConstant.black900
                                                : ColorConstant.gray300,
                                            fontFamily: "Inter",
                                            fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          
                          Text(
                            "लाभ",
                            style: TextStyle(
                                color: ColorConstant.black900,
                                fontFamily: "Baloo",fontSize: 30),
                          ),
                          Text(
                            widget.product['advantage'].toString(),
                            style: TextStyle(
                                color: ColorConstant.gray300,
                                fontFamily: "Baloo"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )),
          )
        ],
      ),
       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: getPadding(bottom: 20),
        child: FloatingActionButton(
          // isExtended: true,
          backgroundColor: ColorConstant.red700,
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
          // isExtended: true,
          child: const Icon(Icons.clear),
        ),
      ),
    );
  }

  onTapArrowleft3(BuildContext context) {
    Navigator.pop(context);
  }
}
