// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:developer';
import 'package:dayalbusinesspartner/utils/app_decoration.dart';
import 'package:dayalbusinesspartner/utils/app_style.dart';
import 'package:dayalbusinesspartner/widgets/color_constant.dart';
import 'package:dayalbusinesspartner/widgets/size_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class OrderIosTwoScreen extends StatefulWidget {
  final String userType;
  final int id;
  final int ordernum;
  final String orderdate;
  final int orderid;
  const OrderIosTwoScreen(
      {super.key,
        required this.id,
        required this.userType,
        required this.orderdate,
        required this.ordernum,
      required this.orderid});

  @override
  State<OrderIosTwoScreen> createState() => _OrderIosTwoScreenState();
}

class _OrderIosTwoScreenState extends State<OrderIosTwoScreen> {
  TextEditingController group196Controller = TextEditingController();

  TextEditingController group198Controller = TextEditingController();

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  String name = '';
  List<dynamic> fullMessages = [];

  // void fetchData() async {
  //   final url = Uri.parse('http://66.94.34.21:8090/getOrderDetails');
  //   final requestBody = json.encode({
  //     'id': '17',
  //     'orderId': '9454',
  //   });
  //   final response = await http.post(url,
  //       headers: {"Content-Type": "application/json"}, body: requestBody);

  //   if (response.statusCode == 200) {
  //     final responseBody = response.body;
  //     if (responseBody.isNotEmpty) {
  //       final decodedData = json.decode(responseBody);
  //       if (decodedData['status'] == true) {
  //         final messages = decodedData['data']
  //             .map((item) => item['full_message'].toString())
  //             .toList();

  //         final parsedMessages = messages.map((message) {
  //           final document = parse(message);
  //           return parse(document.body!.text).documentElement!.text;
  //         }).toList();

  //         setState(() {
  //           fullMessages = parsedMessages;
  //           log("=======++++$fullMessages");
  //         });
  //         return;
  //       }
  //     }
  //   }

  //   setState(() {
  //     fullMessages = ['Failed to fetch data'];
  //   });
  // }

  void fetchData() async {
    final url = Uri.parse('http://66.94.34.21:8090/getOrderDetails');
    final requestBody = json.encode({
      'id': widget.id,
      'orderId': widget.orderid,
    });
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: requestBody,
    );

    if (response.statusCode == 200) {
      final responseBody = response.body;
      if (responseBody.isNotEmpty) {
        final decodedData = json.decode(responseBody);
        if (decodedData['status'] == true) {
          final messages = decodedData['data']
              .map((item) => item['full_message'].toString())
              .toList();
          // final unescape = HtmlUnescape();
          // final parsedMessages = messages.map((message) {
          //   final document = parse(message);
          //   final plainText = parse(document.body!.text).documentElement!.text;
          //   return unescape
          //       .convert(plainText.replaceAll(RegExp(r'<[^>]+>'), ' '));
          // }).toList();

          setState(() {
            fullMessages = messages;
            log("=======++++$fullMessages");
          });
          return;
        }
      }
    }
  }

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
    fetchData();
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
              height: MediaQuery.of(context).size.height * 0.9,
              width: double.maxFinite,
              // margin: getMargin(top: 12),
              padding: getPadding(left: 16, top: 25, right: 16, bottom: 0),
              decoration: AppDecoration.outlineBlue200
                  .copyWith(borderRadius: BorderRadiusStyle.roundedBorder9),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: getPadding(
                        top: 10,
                      ),
                      child: Text("Order Details:",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtInterBold24)),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: double.maxFinite,
                    child: fullMessages.isNotEmpty
                        ? ListView.builder(
                            itemCount: fullMessages.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: ListTile(
                                  title: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: getPadding(top: 20),
                                        child: Text(
                                          "Order Date : ${DateFormat('dd MMM yyyy').format(DateTime.parse(widget.orderdate))}",
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 16,
                                            color: ColorConstant.black900,
                                            fontWeight: FontWeight.w400,
                                            height: 1,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Order Number : ${widget.ordernum.toString()}",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 16,
                                          color: ColorConstant.black900,
                                          fontWeight: FontWeight.w400,
                                          height: 1,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      // Text(
                                      //   fullMessages[index],
                                      //   style:
                                      //       const TextStyle(fontSize: 15.0),
                                      // ),
                                      Center(
                                        child: SingleChildScrollView(
                                          child: Html(
                                            data:fullMessages[0].toString()
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Text(
                              'No data available',
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.white),
                            ),
                          ),
                  ),
                ],
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
