import 'dart:convert';

import 'package:dayalbusinesspartner/utils/app_decoration.dart';
import 'package:dayalbusinesspartner/utils/app_style.dart';
import 'package:dayalbusinesspartner/widgets/color_constant.dart';
import 'package:dayalbusinesspartner/widgets/size_utils.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SchemesPage extends StatefulWidget {
  const SchemesPage({Key? key});

  @override
  State<SchemesPage> createState() => _SchemesPageState();
}

class _SchemesPageState extends State<SchemesPage> {
  Map<String, dynamic> schemeData = {};

  @override
  void initState() {
    super.initState();
    fetchSchemeData().then((data) {
      setState(() {
        schemeData = data['data'];
      });
    });
  }

  final apiUrl = 'http://66.94.34.21:8090/getCurrentScheme';

  Future<Map<String, dynamic>> fetchSchemeData() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch scheme data');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (schemeData.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: getPadding(top: 30, left: 20),
            child: Text("Scheme Details:",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: AppStyle.txtInterBold24)),
        Expanded(
          child: Padding(
            padding: getPadding(left: 20, right: 20),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: schemeData.length,
              itemBuilder: (context, index) {
                final schemeName = schemeData.keys.toList()[index];
                final schemeItems = schemeData[schemeName];
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
                      Padding(
                        padding: getPadding(left: 20, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: getHorizontalSize(81),
                              margin: getMargin(bottom: 1),
                              child: Text(
                                "From",
                                maxLines: null,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtInterRegular12Bluegray900,
                              ),
                            ),
                            Container(
                              width: getHorizontalSize(81),
                              margin: getMargin(bottom: 1),
                              child: Text(
                                DateFormat('dd MMM yyyy').format(DateTime.parse(
                                  schemeItems[index]['scheme_from'],
                                )),
                                maxLines: null,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtInterRegular12Bluegray900,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: getPadding(left: 20, right: 10, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: getHorizontalSize(81),
                              margin: getMargin(bottom: 1),
                              child: Text(
                                "To",
                                maxLines: null,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtInterRegular12Bluegray900,
                              ),
                            ),
                            Container(
                              width: getHorizontalSize(81),
                              margin: getMargin(bottom: 1),
                              child: Text(
                                DateFormat('dd MMM yyyy').format(DateTime.parse(
                                  schemeItems[index]['scheme_to'],
                                )),
                                maxLines: null,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtInterRegular12Bluegray900,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: getPadding(all: 2),
                        decoration: AppDecoration.outlineGray400.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: double.maxFinite,
                              child: Container(
                                width: getHorizontalSize(326),
                                padding: getPadding(
                                    left: 14, top: 6, right: 14, bottom: 6),
                                decoration: AppDecoration.fillRed7000c.copyWith(
                                  borderRadius:
                                      BorderRadiusStyle.roundedBorder8,
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "$schemeName ",
                                        style: TextStyle(
                                          color: ColorConstant.blueGray900,
                                          fontSize: getFontSize(14.7),
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "( Dealer )",
                                        style: TextStyle(
                                          color: ColorConstant.blueGray900,
                                          fontSize: getFontSize(12.25),
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                            Padding(
                              padding: getPadding(left: 21, top: 9),
                              child: Text(
                                "Schemes",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtInterMedium12,
                              ),
                            ),
                            Padding(
                              padding: getPadding(left: 34, top: 11),
                              child: Column(
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: schemeItems.length,
                                    itemBuilder: (context, itemIndex) {
                                      final item = schemeItems[itemIndex];
                                      return Padding(
                                          padding: getPadding(
                                              left: 14, top: 11, right: 20),
                                          child: Row(children: [
                                            Padding(
                                              padding: getPadding(right: 20),
                                              child: Text(
                                                  " ${item['scheme_mt']} MT",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: AppStyle
                                                      .txtInterRegular10),
                                            ),
                                            const Spacer(),
                                            Text(item['item_name'],
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: AppStyle
                                                    .txtInterMedium12Bluegray900),
                                          ]));
                                    },
                                  ),
                                  const Divider(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
