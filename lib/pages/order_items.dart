import 'dart:convert';
import 'dart:developer';
import 'package:dayalbusinesspartner/utils/app_decoration.dart';
import 'package:dayalbusinesspartner/utils/app_style.dart';
import 'package:dayalbusinesspartner/utils/custom_image_view.dart';
import 'package:dayalbusinesspartner/widgets/color_constant.dart';
import 'package:dayalbusinesspartner/widgets/custom_button.dart';
import 'package:dayalbusinesspartner/widgets/custom_drop_down.dart';
import 'package:dayalbusinesspartner/widgets/custom_text_form_field.dart';
import 'package:dayalbusinesspartner/widgets/image_constant.dart';
import 'package:dayalbusinesspartner/widgets/size_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderIosOneScreen extends StatefulWidget {
  final String userType;
  final int id;
  const OrderIosOneScreen(
      {super.key, required this.userType, required this.id});

  @override
  State<OrderIosOneScreen> createState() => _OrderIosOneScreenState();
}

class _OrderIosOneScreenState extends State<OrderIosOneScreen> {
  List<String> dropdownItemList = [
    "50 Kg",
    "45 Kg",
    "40 Kg",
    "25 Kg",
    "20 Kg",
    "10 Kg",
    "5 Kg",
    "2 Kg",
    "1 Kg",
    "200 Gm",
    "20 Gm"
  ];

  TextEditingController weightController = TextEditingController();

  TextEditingController quantityController = TextEditingController();

  TextEditingController remarksController = TextEditingController();

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  List<dynamic> dealers = [];
  List<dynamic> products = [];
  Map<String, List<dynamic>> schemes = {};
  String name = '';
  String? selectedDealer;
  String? weight;

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

  Future<void> fetchData() async {
    final url = Uri.parse('http://66.94.34.21:8090/getDetailsForOrder');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({'id': '200'});

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        dealers = data['dealers'] ?? [];
        products = data['products'] ?? [];
        schemes = data['schemes'] ?? {};
        selectedDealer = null;
      });
    }
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
            width: double.maxFinite,
            // margin: getMargin(top: 12),
            padding: getPadding(left: 16, top: 25, right: 16, bottom: 25),
            decoration: AppDecoration.fillGray100
                .copyWith(borderRadius: BorderRadiusStyle.roundedBorder9),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    value: selectedDealer,
                    hint: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Select Dealer'),
                    ),
                    items: dealers.map<DropdownMenuItem<String>>(
                      (dealer) {
                        return DropdownMenuItem<String>(
                          value: dealer['dealer_id'].toString(),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(dealer['dealer_name']),
                          ),
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDealer = value;
                      });
                    },
                    dropdownColor: Colors.grey[200],
                    isExpanded: true,
                    underline: Container(),
                    icon: const Icon(Icons.arrow_drop_down),
                    elevation: 1,
                    focusColor: Colors.green,
                    focusNode: FocusNode(),
                  ),
                ),
                DefaultTabController(
                  length: 2, // Number of tabs
                  child: Column(
                    children: [
                      TabBar(
                        tabs: [
                          Tab(
                            child: Container(
                                color: Colors.red,
                                child: const Text('Product Item')),
                          ),
                          Tab(
                            child: Container(
                                color: Colors.amber,
                                child: const Text('Scheme Item')),
                          ),
                        ],
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: TabBarView(
                          children: [
                            Container(
                              child: ListView.builder(
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  final product = products[index];
                                  return Padding(
                                    padding: getPadding(bottom: 20),
                                    child: Container(
                                      height: 150,
                                      color: ColorConstant.whiteA700,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Container(
                                                height: getVerticalSize(92),
                                                width: getHorizontalSize(87),
                                                decoration: BoxDecoration(
                                                  color: ColorConstant.gray100,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          getHorizontalSize(6)),
                                                  border: Border.all(
                                                    color:
                                                        ColorConstant.gray600,
                                                    width: getHorizontalSize(1),
                                                  ),
                                                ),
                                                child: product != null
                                                    ? Image.network(
                                                        product[
                                                            'product_short_image'],
                                                        height:
                                                            getVerticalSize(77),
                                                        width:
                                                            getHorizontalSize(
                                                                90),
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                      )
                                                    : Container(
                                                        child:
                                                            const Text("N/A"),
                                                      ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: getPadding(top: 20),
                                                child: Text(
                                                    product?['product_name'] ??
                                                        '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: AppStyle
                                                        .txtInterMedium14),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              CustomDropDown(
                                                  // height: 30,
                                                  width: 93,
                                                  focusNode: FocusNode(),
                                                  icon: Padding(
                                                    padding: getPadding(
                                                        right: 10, top: 2),
                                                    child: CustomImageView(
                                                        svgPath: ImageConstant
                                                            .imgArrowdownBlueGray900),
                                                  ),
                                                  hintText: "weight",
                                                  items: dropdownItemList,
                                                  onChanged: (value) {
                                                    weight = value;
                                                  }),
                                            ],
                                          ),
                                          const Spacer(),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: getPadding(
                                                    right: 10, top: 5),
                                                child: SizedBox(
                                                  height: getVerticalSize(30),
                                                  width: getHorizontalSize(61),
                                                  child: CustomTextFormField(
                                                    controller:
                                                        quantityController,
                                                    hintText: "Quantity",
                                                    fontStyle:
                                                        TextFormFieldFontStyle
                                                            .InterMedium11,
                                                    textInputType:
                                                        TextInputType.number,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: getPadding(
                                                    right: 10,
                                                    bottom: 15,
                                                    top: 5),
                                                child: CustomButton(
                                                  height: getVerticalSize(27),
                                                  width: getHorizontalSize(61),
                                                  text: "Add",
                                                  variant: ButtonVariant
                                                      .FillYellow400,
                                                  shape: ButtonShape
                                                      .RoundedBorder4,
                                                  fontStyle: ButtonFontStyle
                                                      .InterRegular10,
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  onTap: () {},
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            // Content for the second tab (Scheme Item)
                            Container(
                              color: Colors.green,
                              child: const Center(
                                child: Text('Scheme Item Content'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }

  onTapArrowleft3(BuildContext context) {
    Navigator.pop(context);
  }
}
