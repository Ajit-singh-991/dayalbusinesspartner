import 'dart:convert';

import 'package:dayalbusinesspartner/pages/order_items.dart';
import 'package:dayalbusinesspartner/utils/app_decoration.dart';
import 'package:dayalbusinesspartner/utils/app_style.dart';
import 'package:dayalbusinesspartner/widgets/color_constant.dart';
import 'package:dayalbusinesspartner/widgets/size_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderIosTwoScreen extends StatefulWidget {
  final String userType;
  final int id;
  final int ordernum;
  final String orderdate;
  final int orderid;
  const OrderIosTwoScreen({
    Key? key,
    required this.id,
    required this.userType,
    required this.orderdate,
    required this.ordernum,
    required this.orderid,
  }) : super(key: key);

  @override
  State<OrderIosTwoScreen> createState() => _OrderIosTwoScreenState();
}

class _OrderIosTwoScreenState extends State<OrderIosTwoScreen> {
  String name = '';
  Map<String, List<Map<String, dynamic>>> modifiedOrderDetails = {};
  List<Map<String, dynamic>> schemeData = [];

  void fetchData() async {
    final url = Uri.parse('http://66.94.34.21:8090/getOrderDetails');
    final requestBody = json.encode({
      'id': widget.id.toString(),
      'orderId': widget.orderid.toString(),
      //'orderId': widget.orderid.toString(),
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
        final orderData = decodedData['orderData'];
        if (orderData != null && orderData is Map<String, dynamic>) {
          modifiedOrderDetails = Map.fromEntries(orderData.entries.map((entry) {
            final dealerName = entry.key;
            final orderList = entry.value;
            if (orderList is List) {
              return MapEntry(
                  dealerName, orderList.cast<Map<String, dynamic>>());
            }
            return MapEntry(dealerName, []);
          }));
        }

        final schemeDataList = decodedData['schemeData'];
        if (schemeDataList != null && schemeDataList is List) {
          schemeData = schemeDataList.cast<Map<String, dynamic>>();
        }
        setState(() {
          name = decodedData['name'] ?? '';
        });
      }
    }
  }

  Future<void> fetchProfileData() async {
    const profileurl = 'http://66.94.34.21:8090/getProfile';
    final requestBody = {
      'usertype': widget.userType,
      'id': widget.id.toString(),
    };
    final response = await http.post(
      Uri.parse(profileurl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(requestBody),
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final data = responseData['data'] as List;
      if (data.isNotEmpty) {
        final firstItem = data.first;
        final nameFromResponse = firstItem['name'];
        setState(() {
          name = nameFromResponse;
        });
      }
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
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width,
              // margin: getMargin(top: 12),
              padding: getPadding(left: 0, top: 10, right: 0, bottom: 0),
              decoration: AppDecoration.fillblueGray001
                  .copyWith(borderRadius: BorderRadiusStyle.roundedBorder9),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: getPadding(top: 30),
                      child: Text("Order Details:",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtInterBold24)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: modifiedOrderDetails.length,
                      itemBuilder: (context, index) {
                        final dealerName =
                            modifiedOrderDetails.keys.elementAt(index);
                        final orderData =
                            modifiedOrderDetails[dealerName] ?? [];

                        var dealerId = orderData[0]['dealer_id'];
                        // final scheme = schemeData.firstWhere((scheme) => scheme['dealer_id'] == dealerId,
                        //     orElse: () => {});
                        var myListFiltered = schemeData
                            .where((e) =>
                                e['dealer_id'].toString() ==
                                dealerId.toString())
                            .toList();

                        if (myListFiltered.length > 0) {
                          print("###" +
                              dealerId.toString() +
                              "####" +
                              myListFiltered.length.toString());
                        } else {
                          print("###" +
                              dealerId.toString() +
                              "####" +
                              myListFiltered.length.toString());
                        }
                        // final schemeName =
                        // scheme != null ? scheme['scheme_name'] : 'No Scheme'

                        int totalMT = orderData
                            .map((item) => item['qty_in_bags'])
                            .reduce((a, b) => a + b);

                        return Padding(
                          padding: getPadding(
                            left: 20,
                            right: 20,
                          ),
                          child: OrderCard(
                              dealerName: dealerName,
                              orderData: orderData,
                              orderid: widget.orderid,
                              schemeData: myListFiltered,
                              totalMT: totalMT.toString(), id: widget.id, userType: widget.userType,),
                        );
                      },
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

class OrderCard extends StatelessWidget {
  final String dealerName;
  final String totalMT;
  final List<Map<String, dynamic>> orderData;
  final int orderid;
  final String userType;
  final int id;
  final List<Map<String, dynamic>> schemeData;
  const OrderCard(
      {super.key,
      required this.dealerName,
      required this.orderData,
      required this.orderid,
      required this.schemeData,
      required this.totalMT, required this.userType, required this.id});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: getMargin(top: 6),
      padding: getPadding(left: 20, top: 16, right: 20, bottom: 16),
      decoration: AppDecoration.fillWhiteA700
          .copyWith(borderRadius: BorderRadiusStyle.roundedBorder8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: getHorizontalSize(81),
                  margin: getMargin(bottom: 1),
                  child: Text("Order Number",
                      maxLines: null,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtInterRegular12Bluegray900)),
              Container(
                  width: getHorizontalSize(64),
                  margin: getMargin(bottom: 1),
                  child: Text(orderid.toString(),
                      maxLines: null,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtInterRegular12Bluegray900)),
            ],
          ),
          Container(
            padding: getPadding(all: 2),
            decoration: AppDecoration.outlineGray400
                .copyWith(borderRadius: BorderRadiusStyle.roundedBorder8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: double.maxFinite,
                  child: Container(
                      width: getHorizontalSize(326),
                      padding:
                          getPadding(left: 14, top: 6, right: 14, bottom: 6),
                      decoration: AppDecoration.fillRed7000c.copyWith(
                          borderRadius: BorderRadiusStyle.roundedBorder8),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: "$dealerName ",
                                      style: TextStyle(
                                          color: ColorConstant.blueGray900,
                                          fontSize:
                                              getFontSize(14.700000762939453),
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600)),
                                  TextSpan(
                                      text: "( Dealer )",
                                      style: TextStyle(
                                          color: ColorConstant.blueGray900,
                                          fontSize:
                                              getFontSize(12.250000953674316),
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400))
                                ]),
                                textAlign: TextAlign.left)
                          ])),
                ),
                Padding(
                    padding: getPadding(left: 21, top: 9),
                    child: Text("Products",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtInterMedium12)),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: orderData.length,
                  itemBuilder: (context, index) {
                    final product = orderData[index];
                    return Column(
                      children: [
                        Padding(
                            padding: getPadding(left: 34, top: 11),
                            child: Row(children: [
                              Text(product['product_name'],
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtInterMedium12Bluegray900),
                              Padding(
                                  padding: getPadding(left: 11, top: 1),
                                  child: Text(product['packing'].toString(),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppStyle.txtInterRegular10)),
                              const Spacer(),
                              Padding(
                                padding: getPadding(right: 20),
                                child: Text(" ${product['qty_in_bags']} bags",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtInterRegular10),
                              ),
                            ])),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                                padding: getPadding(top: 9),
                                child: Divider(
                                    height: getVerticalSize(1),
                                    thickness: getVerticalSize(1),
                                    color: ColorConstant.gray400,
                                    indent: getHorizontalSize(30),
                                    endIndent: getHorizontalSize(11)))),
                      ],
                    );
                  },
                ),
                schemeData.length > 0
                    ? Padding(
                        padding: getPadding(left: 21, top: 17),
                        child: Text("Scheme",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtInterMedium12))
                    : Container(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: schemeData.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Padding(
                            padding: getPadding(left: 34, top: 11),
                            child: Row(children: [
                              Text(schemeData[index]['item_name'].toString(),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtInterMedium12Bluegray900),
                              const Spacer(),
                              schemeData[index]['status'].toString() == 'V'
                                  ? Padding(
                                      padding: getPadding(right: 20),
                                      child: Text(
                                          schemeData[index]['no_of_out_item']
                                                  .toString() +
                                              " Pcs",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle.txtInterRegular10),
                                    )
                                  : Padding(
                                      padding: getPadding(right: 20),
                                      child: Text(
                                          schemeData[index]['no_of_items']
                                                  .toString() +
                                              " Pcs",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle.txtInterRegular10),
                                    ),
                            ])),
                      ],
                    );
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: getHorizontalSize(326),
                  padding: getPadding(left: 14, top: 6, right: 14, bottom: 6),
                  decoration: AppDecoration.fillblueGray001.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder8,
                  ),
                  child: Column(
                    children: [
                      Padding(
                          padding: getPadding(left: 10, top: 5),
                          child: Row(children: [
                            Text("Total Bags/ Total MT",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtBalooMedium16Gray600),
                            const Spacer(),
                            Padding(
                              padding: getPadding(right: 5),
                              child: Text(totalMT + " Bags",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtBalooMedium16Gray600),
                            ),
                          ])),
                    ],
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
              onTap: () {
                onTapTxtAddedit(context);
              },
              child: Padding(
                  padding: getPadding(top: 68, bottom: 7),
                  child: Text("Add",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtInterMedium13Blue400)))
        ],
      ),
    );
  }

  onTapTxtAddedit(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) =>  OrderIosOneScreen(id: id, userType: userType,)));
  }
}
