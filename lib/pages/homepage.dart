import 'dart:convert';
import 'dart:developer';
import 'package:dayalbusinesspartner/pages/coupon_page.dart';
import 'package:dayalbusinesspartner/pages/dashboard.dart';
import 'package:dayalbusinesspartner/pages/dealer_setails.dart';
import 'package:dayalbusinesspartner/pages/drawer.dart';
import 'package:dayalbusinesspartner/pages/orders.dart';
import 'package:dayalbusinesspartner/pages/payment_details.dart';
import 'package:dayalbusinesspartner/utils/app_decoration.dart';
import 'package:dayalbusinesspartner/widgets/color_constant.dart';
import 'package:dayalbusinesspartner/widgets/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final String userType;
  final int id;
  const HomePage({Key? key, required this.userType, required this.id})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTab = 0;
  String name = '';
  String address = "";
  String district = "";
  String region = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

  final List _pages = <Widget>[];
  void initializePages() {
    _pages.add(Dashboard(id: widget.id));
    _pages.add(const Orders());
    _pages.add(PaymentDetails(
      id: widget.id,
      userType: widget.userType,
    ));
    _pages.add(DealerDetails(id: widget.id));
    _pages.add(const CouponPage());
  }

  @override
  void initState() {
    super.initState();
    initializePages();
    fetchProfileData();
  }

  _changeTab(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      return Scaffold(
        key: _scaffoldKey,
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
                    IconButton(
                      icon: const CircleAvatar(
                        radius: 24.0,
                        backgroundImage: NetworkImage(
                            'https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425_1280.png'),
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
            Expanded(
              child: ClipRRect(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: double.maxFinite,
                  // margin: getMargin(top: 12),
                  padding: getPadding(left: 0, top: 10, right: 0, bottom: 0),
                  decoration: AppDecoration.fillblueGray001
                      .copyWith(borderRadius: BorderRadiusStyle.roundedBorder9),
                  child: _pages[_selectedTab],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedTab,
          onTap: (index) => _changeTab(index),
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
                icon: ColorFiltered(
                  colorFilter: _selectedTab == 0
                      ? ColorFilter.mode(ColorConstant.red700, BlendMode.srcIn)
                      : ColorFilter.mode(
                          ColorConstant.gray600, BlendMode.srcIn),
                  child: SvgPicture.asset("assets/images/Vector (1).svg",
                      width: 350, height: 20, fit: BoxFit.fill),
                ),
                label: "Home"),
            BottomNavigationBarItem(
                icon: ColorFiltered(
                  colorFilter: _selectedTab == 1
                      ? ColorFilter.mode(ColorConstant.red700, BlendMode.srcIn)
                      : ColorFilter.mode(
                          ColorConstant.gray600, BlendMode.srcIn),
                  child: SvgPicture.asset("assets/images/Vector (2).svg",
                      width: 350, height: 20, fit: BoxFit.fill),
                ),
                label: "About"),
            BottomNavigationBarItem(
                icon: ColorFiltered(
                  colorFilter: _selectedTab == 2
                      ? ColorFilter.mode(ColorConstant.red700, BlendMode.srcIn)
                      : ColorFilter.mode(
                          ColorConstant.gray600, BlendMode.srcIn),
                  child: SvgPicture.asset("assets/images/Vector (5).svg",
                      width: 350, height: 20, fit: BoxFit.fill),
                ),
                label: "Product"),
            BottomNavigationBarItem(
                icon: ColorFiltered(
                  colorFilter: _selectedTab == 3
                      ? ColorFilter.mode(ColorConstant.red700, BlendMode.srcIn)
                      : ColorFilter.mode(
                          ColorConstant.gray600, BlendMode.srcIn),
                  child: SvgPicture.asset("assets/images/Vector (4).svg",
                      width: 350, height: 20, fit: BoxFit.fill),
                ),
                label: "Contact"),
            BottomNavigationBarItem(
                icon: ColorFiltered(
                  colorFilter: _selectedTab == 4
                      ? ColorFilter.mode(ColorConstant.red700, BlendMode.srcIn)
                      : ColorFilter.mode(
                          ColorConstant.gray600, BlendMode.srcIn),
                  child: SvgPicture.asset("assets/images/Vector (3).svg",
                      width: 350, height: 20, fit: BoxFit.fill),
                ),
                label: "Settings"),
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
    });
  }
}
