import 'dart:convert';
import 'dart:developer';

import 'package:dayalbusinesspartner/pages/drawer.dart';
import 'package:dayalbusinesspartner/widgets/color_constant.dart';
import 'package:dayalbusinesspartner/widgets/size_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SummaryPage extends StatefulWidget {
  final String userType;
  final int id;

  const SummaryPage({Key? key, required this.id, required this.userType})
      : super(key: key);

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  List<Map<String, dynamic>> monthlyData = [];
  String name = '';
  String address = '';
  String district = '';
  String region = '';
  double lysSales = 0;
  int cysSales = 0;
  int cytTarget = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> fetchData() async {
    const url = 'http://66.94.34.21:8090/getSummary';
    final requestBody = {
      'id': widget.id,
    };
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(requestBody),
    );
    log("=========${response.statusCode}+++++++++++++++");
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData['status'] == true) {
        final cyData = responseData['CYT'][0] as Map<String, dynamic>;
        final cysData = responseData['CYS'][0] as Map<String, dynamic>;
        final lysData = responseData['LYS'][0] as Map<String, dynamic>;

        lysSales = lysData['total_yearly'];
        cysSales = cysData['total_yearly'];
        cytTarget = cyData['total_yearly'];

        List<String> months = [
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
          'Jan',
          'Feb',
          'Mar'
        ];

        monthlyData = months.map((month) {
          return {
            'month': month,
            'lysSales': lysData[month] ?? 0,
            'cysSales': cysData[month] ?? 0,
            'cytTarget': cyData[month] ?? 0,
          };
        }).toList();
        monthlyData = months.map((month) {
          return {
            'month': month,
            'lysSales': lysData[month] ?? 0,
            'cysSales': cysData[month] ?? 0,
            'cytTarget': cyData[month] ?? 0,
          };
        }).toList();
        setState(() {});
      }
    } else {
      throw Exception('Failed to fetch data');
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
      log("=data items==============$firstItem++++++++++");
      final nameFromResponse = firstItem['name'];
      final addressFromResponse = firstItem['place'];
      final districtFromResponse = firstItem['district'];
      final regionFromResponse = firstItem['region'];

      // fetchData();
      setState(() {
        name = nameFromResponse;
        log("===============$name++++++++++");
        address = addressFromResponse;
        log("===items--============$address++++++++++");
        district = districtFromResponse;
        log("===============$district++++++++++");
        region = regionFromResponse;
        log("===items--============$region++++++++++");
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ColorConstant.red700,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          // Header
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
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const CircleAvatar(
                      radius: 24.0,
                      backgroundImage: NetworkImage(
                        'https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425_1280.png',
                      ),
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                    },
                  ),
                ],
              ),
            ),
          ),
          // Table
          Expanded(
            child: Container(
              color: Colors.white,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: getPadding(top: 10, bottom: 10),
                        child: Center(
                            child: Text(
                          "Summary",
                          style: TextStyle(
                              color: ColorConstant.blueGray600,
                              fontFamily: "Inter",
                              fontSize: 24),
                        )),
                      ),
                      Table(
                        children: [
                          // Header row
                          TableRow(
                            decoration: BoxDecoration(
                                border: Border.all(),
                                color: ColorConstant.red7000c),
                            children: [
                              TableCell(
                                child: Container(height: 50),
                              ),
                              TableCell(
                                child: Container(
                                  height: 50,
                                  child: const Center(child: Text("LYS")),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  height: 50,
                                  child: const Center(child: Text("CYT")),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  height: 50,
                                  child: const Center(child: Text("CYS")),
                                ),
                              ),
                            ],
                          ),
                          // Monthly data rows
                          for (var data in monthlyData)
                            TableRow(
                              decoration: BoxDecoration(border: Border.all()),
                              children: [
                                TableCell(
                                  child: Container(
                                    decoration:
                                        BoxDecoration(border: Border.all()),
                                    height: 50,
                                    child: Center(child: Text(data['month'])),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    decoration:
                                        BoxDecoration(border: Border.all()),
                                    height: 50,
                                    child: Center(
                                        child:
                                            Text(data['lysSales'].toString())),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    decoration:
                                        BoxDecoration(border: Border.all()),
                                    height: 50,
                                    child: Center(
                                        child:
                                            Text(data['cytTarget'].toString())),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    decoration:
                                        BoxDecoration(border: Border.all()),
                                    height: 50,
                                    child: Center(
                                        child:
                                            Text(data['cysSales'].toString())),
                                  ),
                                ),
                              ],
                            ),
                          // Yearly data row
                          TableRow(
                            decoration: BoxDecoration(border: Border.all()),
                            children: [
                              TableCell(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(),
                                      color: ColorConstant.red7000c),
                                  height: 50,
                                  child: const Center(child: Text("Total")),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(),
                                      color: ColorConstant.red7000c),
                                  height: 50,
                                  child:
                                      Center(child: Text(lysSales.toString())),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(),
                                      color: ColorConstant.red7000c),
                                  height: 50,
                                  child:
                                      Center(child: Text(cytTarget.toString())),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(),
                                      color: ColorConstant.red7000c),
                                  height: 50,
                                  child:
                                      Center(child: Text(cysSales.toString())),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: SliderView(
          address: address,
          district: district,
          name: name,
          region: region,
        ),
      ),
    );
  }

  onTapArrowleft3(BuildContext context) {
    Navigator.pop(context);
  }
}
