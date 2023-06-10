import 'dart:convert';
import 'dart:developer';

import 'package:dayalbusinesspartner/utils/app_style.dart';
import 'package:dayalbusinesspartner/widgets/color_constant.dart';
import 'package:dayalbusinesspartner/widgets/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class DealerDetails extends StatefulWidget {
  final int id;

  const DealerDetails({Key? key, required this.id}) : super(key: key);

  @override
  State<DealerDetails> createState() => _DealerDetailsState();
}

class _DealerDetailsState extends State<DealerDetails> {
  final String apiUrl = 'http://66.94.34.21:8090/getMyDealers';
  List<bool> _expandedStates = [];
  List<dynamic> dealersList = [];
  String total = '';
  String dayal = '';

  @override
  void initState() {
    super.initState();
    initializeExpandedStates();
    fetchCountData();
  }

  void initializeExpandedStates() {
    setState(() {
      _expandedStates = List<bool>.generate(dealersList.length, (_) => false);
    });
  }

  Future<void> fetchCountData() async {
    const profileUrl = 'http://66.94.34.21:8090/getDealerCounts';
    final requestBody = {
      'id': widget.id,
    };
    final response = await http.post(
      Uri.parse(profileUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(requestBody),
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      log('========= $responseData++++');
      final totalData = responseData['total'] as Map<String, dynamic>;
      final dayalData = responseData['dayal'] as Map<String, dynamic>;

      final totalCount = totalData['count'] as int;
      final dayalCount = dayalData['count'] as int;

      setState(() {
        // Update the state with the extracted counts
        total = totalCount.toString();
        dayal = dayalCount.toString();
      });

      await fetchDealerDetails();
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<void> fetchDealerDetails() async {
    final Map<String, dynamic> requestBody = {"id": widget.id};
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final dealers = data['data'];
      setState(() {
        dealersList = dealers;
        initializeExpandedStates();
      });
    } else {
      throw Exception('Failed to fetch dealer details');
    }
  }

  void _toggleExpanded(int index) {
    setState(() {
      _expandedStates[index] = !_expandedStates[index];
    });
  }

  Widget _buildDealerCard(int index) {
    final dealer = dealersList[index];
    print('========${dealer['dealer_pic']}');
    // final dealerPic = dealer[0]['dealer_pic'];
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: () => _toggleExpanded(index),
        child: SizedBox(
          height: _expandedStates[index] ? 300 : 80,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (!_expandedStates[index])
                ListTile(
                  leading:  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 30, 0),
                    child: CircleAvatar(
                      radius: 24.0,
                      backgroundImage: (dealer['dealer_pic'] == '')? const NetworkImage(
                          'https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425_1280.png'):NetworkImage(
                                  'https://dayalsoftware.com/upload/dealer/${dealer['dealer_pic']}'),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  title: Text(
                    '${dealer['contact_person']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${dealer['village']}'),
                  trailing: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 30, 0),
                    child: SvgPicture.asset(
                      "assets/images/Vector (6).svg",
                      width: 350,
                      height: 20,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              if (_expandedStates[index])
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: getPadding(left: 100, top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50.0,
                              backgroundImage: (dealer['dealer_pic'] == '')? const NetworkImage(
                          'https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425_1280.png'):NetworkImage(
                                  'https://dayalsoftware.com/upload/dealer/${dealer['dealer_pic']}'),
                              backgroundColor: Colors.white,
                            ),
                            const SizedBox(
                              width: 80,
                            ),
                            SvgPicture.asset(
                              "assets/images/Vector (9).svg",
                              height: 15,
                              fit: BoxFit.fill,
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Text(
                          '${dealer['contact_person']}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      ),
                      Center(
                        child: Text(
                          '${dealer['village']}',
                          style: TextStyle(color: ColorConstant.gray600),
                        ),
                      ),
                      const Divider(
                        thickness: 2,
                      ),
                      Text(
                        'Shop Name : ${dealer['dealer_name']}',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ColorConstant.gray600),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text('Phone no : +91-${dealer['contact_no']}',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstant.gray600)),
                          const SizedBox(
                            width: 50,
                          ),
                          SizedBox(
                            height: 30,
                            width: 76,
                            child: ElevatedButton(
                              onPressed: () async {
                                Uri url = Uri(
                                    scheme: 'tel', path: dealer['contact_no']);
                                await launchUrl(url);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorConstant.red700,
                                  shape: const StadiumBorder()),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/Vector (8).svg",
                                    height: 12,
                                    fit: BoxFit.fill,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text(
                                    'Call',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.fromLTRB(30, 50, 20, 10),
              child: Text(
                "My Dealers:",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.w900),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: getHorizontalSize(168),
              margin: getMargin(left: 30, top: 9),
              child: Text(
                "Total Dealer : $total\nTotal Dayal Dealer : $dayal",
                maxLines: null,
                textAlign: TextAlign.left,
                style: AppStyle.txtInterRegular157,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: dealersList.length,
              itemBuilder: (context, index) {
                return _buildDealerCard(index);
              },
            ),
          ),
        ],
      ),
    );
  }
}
