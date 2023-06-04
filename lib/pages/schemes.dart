import 'dart:convert';

import 'package:dayalbusinesspartner/widgets/color_constant.dart';
import 'package:dayalbusinesspartner/widgets/size_utils.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SchemesPage extends StatefulWidget {
  const SchemesPage({super.key});

  @override
  State<SchemesPage> createState() => _SchemesPageState();
}

class _SchemesPageState extends State<SchemesPage> {
  List<dynamic> schemes = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    const url = 'http://66.94.34.21:8090/getCurrentScheme';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        schemes = responseData['data'];
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFe3eef9),
      resizeToAvoidBottomInset: true,
      body: ListView.builder(
        itemCount: schemes.length,
        itemBuilder: (context, index) {
          final scheme = schemes[index];
          return Padding(
            padding: getPadding(left: 10, right: 10, bottom: 5),
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Card(
                  elevation: 10,
                  child: Padding(
                    padding: getPadding(top: 10, left: 10, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          scheme['scheme_name'],
                          style: TextStyle(
                              color: ColorConstant.black900,
                              fontFamily: "Inter",
                              fontSize: 22,
                              fontWeight: FontWeight.w500),
                        ),
                        Padding(
                          padding: getPadding(top: 10, bottom: 10),
                          child: Text(
                            "Validity: ${DateFormat('dd MMM yyyy').format(DateTime.parse(scheme['scheme_from']))} - ${DateFormat('dd MMM yyyy').format(DateTime.parse(scheme['scheme_to']))}",
                            style: TextStyle(
                                color: ColorConstant.black900,
                                fontFamily: "Inter",
                                fontSize: 16,
                                fontWeight: FontWeight.w200),
                          ),
                        ),
                        Text(
                          scheme['scheme_description'],
                          style: TextStyle(
                              color: ColorConstant.black900,
                              fontFamily: "Inter",
                              fontSize: 20,
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  )),
            ),
          );
        },
      ),
    );
  }
}
