// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dayalbusinesspartner/pages/product_details_page.dart';
import 'package:dayalbusinesspartner/pages/summary_page.dart';
import 'package:dayalbusinesspartner/widgets/color_constant.dart';
import 'package:dayalbusinesspartner/widgets/size_utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  final int id;
  final String userType;
  const Dashboard({Key? key, required this.id, required this.userType})
      : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final CarouselController _controller = CarouselController();
  int _current = 0;
  String ledger = '0';
  String total = '';
  String dayal = '';
  int _monthIndex = DateTime.now().month - 1;
  dynamic _monthlySales;
  dynamic _monthlyTarget;
  dynamic _annualSales;
  dynamic _annualTarget;
  bool _isLoading = false;
  bool _Loading = false;
  String userName = '';
  String contactNumber = '';

  final List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'April',
    'May',
    'June',
    'July',
    'Aug',
    'Sept',
    'Oct',
    'Nov',
    'Dec',
  ];

  void _changeMonth(int increment) {
    setState(() {
      _monthIndex += increment;
      if (_monthIndex < 0) {
        _monthIndex = 11;
      } else if (_monthIndex > 11) {
        _monthIndex = 0;
      }
    });
    _fetchData();
  }

  Future<void> fetchledgerdata() async {
    const profileurl = 'http://66.94.34.21:8090/getLedger';
    final requestBody = {'id': widget.id};

    final response = await http.post(
      Uri.parse(profileurl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      log('========= $responseData++++');

      final data = responseData['data'] as List<dynamic>;

      if (data.isNotEmpty) {
        final firstItem = data.first;
        final balanceFromResponse = firstItem['out_standing'];
        var roundedLedger = balanceFromResponse.toStringAsFixed(0);
        print("roundedLedger >>" + roundedLedger.toString());
        setState(() {
          ledger = roundedLedger.toString();
        });
      } else {
        setState(() {
          ledger = '0';
        });
      }
    } else {
      throw Exception('Failed to fetch data');
    }
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

      final totalData = responseData['total'] as Map<String, dynamic>;
      final dayalData = responseData['dayal'] as Map<String, dynamic>;

      final totalCount = totalData['count'] as int;
      final dayalCount = dayalData['count'] as int;

      setState(() {
        // Update the state with the extracted counts
        total = totalCount.toString();
        dayal = dayalCount.toString();
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    const monthlySalesUrl = 'http://66.94.34.21:8090/getMonthlySalesTarget';
    final requestBody = {
      "id": widget.id,
      "month": _monthIndex + 1,
      "year": DateTime.now().year,
    };

    final response = await http.post(
      Uri.parse(monthlySalesUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status']) {
        setState(() {
          _monthlySales =
              data['sales'] != null ? data['sales']['mnt_sales'].toInt() : null;
          _monthlyTarget =
              data['target'] != null ? data['target']['tar_qty'].toInt() : null;
          _isLoading = false;
        });
      } else {
        // API request failed, handle the error accordingly
        String errorMessage = data['msg'];
        log('API Error: $errorMessage');
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _monthlySales = null;
        _monthlyTarget = null;
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchAnnualData() async {
    setState(() {
      _Loading = true;
    });
    const annualSalesUrl = 'http://66.94.34.21:8090/getAnnualSalesTarget';
    final requestBody = {"id": widget.id};

    final response = await http.post(
      Uri.parse(annualSalesUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status']) {
        setState(() {
          _annualSales =
              data['sales'] != null ? data['sales']['sales'].toInt() : null;
          _annualTarget =
              data['target'] != null ? data['target']['target'].toInt() : null;
          _Loading = false;
        });
      } else {
        // API request failed, handle the error accordingly
        String errorMessage = data['msg'];
        log('API Error: $errorMessage');
        setState(() {
          _Loading = false;
        });
      }
    } else {
      setState(() {
        _annualSales = null;
        _annualTarget = null;
        _Loading = false;
      });
    }
  }

  Widget _buildTextWidget(String label, dynamic value) {
    if (value != null) {
      return Padding(
        padding: getPadding(left: 20, top: 5, right: 20),
        child: Text(
          '$label: $value MT',
          maxLines: null,
          // overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w400,
              fontSize: 16,
              fontFamily: "Inter"),
        ),
      );
    } else {
      return Padding(
        padding: getPadding(left: 30),
        child: Text(
          '$label: 0 MT',
          maxLines: null,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: const TextStyle(
              color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 15),
        ),
      );
    }
  }

  Future<void> fetchCompanyPersonData() async {
    const apiUrl = 'http://66.94.34.21:8090/getCompanyPerson';
    final requestBody = {
      'id': widget.id,
      'domain': 'cf',
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final data = responseData['data'] as List<dynamic>;

      if (data.isNotEmpty) {
        final userData = data.first;
        setState(() {
          userName = userData['fullname'];
          contactNumber = userData['contact_no'];
        });
      } else {
        setState(() {
          // Handle no data case
          userName = 'No data available';
          contactNumber = 'No data available';
        });
      }
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchledgerdata();
    fetchCountData();
    _fetchData();
    _fetchAnnualData();
    fetchCompanyPersonData();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFe3eef9),
      resizeToAvoidBottomInset: true,
      body: Builder(
        builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Container(
                      height: (height / 6) + 100,
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                          height: height / 3,
                          child: FutureBuilder(
                              future: _fetchBanners(),
                              builder: (context,
                                  AsyncSnapshot<List<dynamic>> projectSnap) {
                                if (projectSnap.data == null) {
                                  return Container();
                                } else {
                                  List<dynamic> bannerList = projectSnap.data!;

                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(children: [
                                      CarouselSlider(
                                        items: bannerList.map((i) {
                                          return Builder(
                                            builder: (BuildContext context) {
                                              return Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0.0),
                                                decoration: const BoxDecoration(
                                                    color: Colors.transparent),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Card(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    14))),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          14)),
                                                          image: DecorationImage(
                                                              image:
                                                                  NetworkImage(i[
                                                                      'image']),
                                                              fit: BoxFit
                                                                  .cover)),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }).toList(),
                                        carouselController: _controller,
                                        options: CarouselOptions(
                                          autoPlay: true,
                                          enlargeCenterPage: true,
                                          aspectRatio: 2.0,
                                          viewportFraction: 1,
                                          autoPlayInterval: const Duration(
                                              milliseconds: 10000),
                                          onPageChanged: (index, reason) {
                                            setState(() {
                                              _current = index;
                                            });
                                          },
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: bannerList
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          return GestureDetector(
                                            onTap: () => _controller
                                                .animateToPage(entry.key),
                                            child: Container(
                                              width: 10.0,
                                              height: 10.0,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 4.0),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.grey
                                                      .withOpacity(
                                                          _current == entry.key
                                                              ? 0.9
                                                              : 0.4)),
                                            ),
                                          );
                                        }).toList(),
                                      )
                                    ]),
                                  );
                                }
                              }))),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 160,
                        width: 180,
                        child: Card(
                          elevation: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: width,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: ColorConstant.red700,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 10.0),
                                  child: Text(
                                    'बही खाता',
                                    style: TextStyle(
                                      fontFamily: 'Baloo',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      height: 1,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: getPadding(left: 30),
                                child: Text(
                                  '₹ ${NumberFormat('##,##,###').format(int.parse(ledger))} Dr',
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Inter",
                                      fontSize: 16),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: getPadding(
                                          top: 20, right: 0, left: 30),
                                      child: Text(
                                        "Ledger Download",
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontFamily: "Inter",
                                            color: ColorConstant.blue400),
                                      ),
                                    ),
                                    Padding(
                                      padding: getPadding(left: 20),
                                      child: SvgPicture.asset(
                                        "assets/images/download.svg",
                                        height: 30,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 160,
                        width: 180,
                        child: Card(
                          elevation: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: width,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: ColorConstant.red700,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 10.0),
                                  child: Text(
                                    'डीलर संख्या',
                                    style: TextStyle(
                                      fontFamily: 'Baloo',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      height: 1,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: getPadding(left: 30),
                                child: Text(
                                  "कुल      : $total\nदयाल    : $dayal",
                                  maxLines: null,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Baloo",
                                      fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 160,
                        width: 180,
                        child: Card(
                          elevation: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: width,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: ColorConstant.red700,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.white,
                                      ),
                                      onPressed: () => _changeMonth(-1),
                                    ),
                                    Text(
                                      _months[_monthIndex],
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                      ),
                                      onPressed: () => _changeMonth(1),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              _isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : _buildTextWidget('Sale ', _monthlySales),
                              _isLoading
                                  ? const SizedBox()
                                  : _buildTextWidget('Tar ', _monthlyTarget),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 160,
                        width: 180,
                        child: Card(
                          elevation: 3,
                          child: Column(
                            children: [
                              Container(
                                width: width,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: ColorConstant.red700,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 10.0),
                                  child: Text(
                                    'Annual',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      height: 1,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              _Loading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : _buildTextWidget('Sale ', _annualSales),
                              _Loading
                                  ? const SizedBox()
                                  : _buildTextWidget('Tar ', _annualTarget),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => SummaryPage(
                                        id: widget.id,
                                        userType: widget.userType,
                                      ),
                                    ));
                                  },
                                  child: Text(
                                    "Summary",
                                    style: TextStyle(
                                        color: ColorConstant.blue400,
                                        fontFamily: "Inter",
                                        fontSize: 14),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      width: width,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.amber,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 10.0),
                        child: Text(
                          'दयाल पशु आहार',
                          style: TextStyle(
                            fontFamily: 'Baloo',
                            fontSize: 18,
                            color: Colors.black,
                            height: 1,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 150),
                        child: FutureBuilder(
                            future: _fetchProducts(),
                            builder: (context,
                                AsyncSnapshot<List<dynamic>> projectSnap) {
                              if (projectSnap.data == null) {
                                return Container();
                              } else {
                                projectSnap.data!.shuffle();
                                return ListView.builder(
                                  itemCount: projectSnap.data?.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return SizedBox(
                                      height: 150,
                                      width: 150, // card height
                                      child: Card(
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Center(
                                          child: Container(
                                            width: 150,
                                            height: 150,
                                            margin: const EdgeInsets.all(10),
                                            padding: const EdgeInsets.all(5),
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFf4f4f4),
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductDetailsPage(
                                                      product: projectSnap
                                                          .data![index],
                                                      id: widget.id,
                                                      userType: widget.userType,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Image.network(projectSnap
                                                  .data![index]['image']
                                                  .toString()),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            })),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      width: width,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.amber,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 10.0),
                        child: Text(
                          'दयाल फीड सप्लीमेंट',
                          style: TextStyle(
                            fontFamily: 'Baloo',
                            fontSize: 18,
                            color: Colors.black,
                            height: 1,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 150),
                        child: FutureBuilder(
                            future: _fetchProductsfeeds(),
                            builder: (context,
                                AsyncSnapshot<List<dynamic>> projectSnap) {
                              if (projectSnap.data == null) {
                                return Container();
                              } else {
                                projectSnap.data!.shuffle();
                                return ListView.builder(
                                  itemCount: projectSnap.data?.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return SizedBox(
                                      height: 150,
                                      width: 150, // card height
                                      child: Card(
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Center(
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductDetailsPage(
                                                    product: projectSnap
                                                        .data![index],
                                                    id: widget.id,
                                                    userType: widget.userType,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: 150,
                                              height: 150,
                                              margin: const EdgeInsets.all(10),
                                              padding: const EdgeInsets.all(5),
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFf4f4f4),
                                              ),
                                              child: Image.network(projectSnap
                                                  .data![index]['image']
                                                  .toString()),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            })),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Card(
                      elevation: 3,
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://picsum.photos/200"), // No matter how big it is, it won't overflow
                        ),
                        title: Text(userName),
                        subtitle: const Text('Sales Person'),
                        trailing: ElevatedButton(
                          onPressed: () async {
                            Uri url = Uri(scheme: 'tel', path: contactNumber);
                            await launchUrl(url);
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder()),
                          child: const Text('Call'),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<List<dynamic>> _fetchBanners() async {
    final response =
        await http.get(Uri.parse('http://66.94.34.21:9000/getBanners'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['data'];
      return jsonResponse;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  Future<List<dynamic>> _fetchProducts() async {
    const url = 'http://66.94.34.21:9000/getFilterProducts';
    //var state = await getValueFromLocalMemory("state");

    Map data = {'state': 'Uttar Pradesh', 'category': 1};

    var body = json.encode(data);
    // Await the http get response, then decode the json-formatted response.
    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['data'];
      return jsonResponse;
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<String> getValueFromLocalMemory(String key) async {
    var pref = await SharedPreferences.getInstance();
    var value = pref.getString(key) ?? "";
    return value;
  }

    Future<List<dynamic>> _fetchProductsfeeds() async {
    const url = 'http://66.94.34.21:9000/getFilterProducts';
    //var state = await getValueFromLocalMemory("state");

    Map data = {'state': 'Uttar Pradesh', 'category': 4};

    var body = json.encode(data);
    // Await the http get response, then decode the json-formatted response.
    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['data'];
      return jsonResponse;
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<String> getValueFromLocalMemoryfeeds(String key) async {
    var pref = await SharedPreferences.getInstance();
    var value = pref.getString(key) ?? "";
    return value;
  }
}
