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
import 'package:intl/intl.dart';

class OrderIosOneScreen extends StatefulWidget {
  final String userType;
  final int id;
  const OrderIosOneScreen(
      {super.key, required this.userType, required this.id});

  @override
  State<OrderIosOneScreen> createState() => _OrderIosOneScreenState();
}

class _OrderIosOneScreenState extends State<OrderIosOneScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController controllerText = TextEditingController();
  late TabController _tabController;
  Map<String, dynamic> schemeData = {};
  List<String> selectedScheme = [];
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

  List<TextEditingController> quantityControllers = [];

  TextEditingController remarksController = TextEditingController();

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  List<dynamic> dealers = [];
  List<dynamic> products = [];
  Map<String, List<dynamic>> schemes = {};
  String name = '';
  String? selectedDealer;
  String? weight;
  String selectedDealerId = '';
  List<Map<String, dynamic>> selectedProducts = [];

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
    fetchSchemeData().then((data) {
      setState(() {
        schemeData = data['data'];
      });
    });
    _tabController = TabController(length: 2, vsync: this);
    fetchProfileData();
    fetchData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        // schemeData = data['schemes'] ?? {};
        selectedDealer = null;
      });
    }
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
                        selectedDealerId = selectedDealer.toString();
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
                  initialIndex: 0,
                  length: 2,
                  child: Column(
                    children: [
                      TabBar(
                        indicator: BoxDecoration(color: Colors.transparent),
                        tabs: [
                          Tab(
                            child: Expanded(
                                child: CustomButton(
                              height: getVerticalSize(33),
                              text: "Product Item",
                              margin: getMargin(right: 4),
                              variant: _tabController.index == 0
                                  ? ButtonVariant.FillYellow400
                                  : ButtonVariant.FillWhiteA700,
                              shape: ButtonShape.RoundedBorder8,
                              fontStyle: _tabController.index == 0
                                  ? ButtonFontStyle.InterRegular12
                                  : ButtonFontStyle.InterRegular12Gray600,
                            )),
                          ),
                          Tab(
                            child: Expanded(
                              child: CustomButton(
                                height: getVerticalSize(33),
                                text: "Scheme Item",
                                margin: getMargin(left: 4),
                                variant: _tabController.index == 1
                                    ? ButtonVariant.FillYellow400
                                    : ButtonVariant.FillWhiteA700,
                                shape: ButtonShape.RoundedBorder8,
                                fontStyle: _tabController.index == 1
                                    ? ButtonFontStyle.InterRegular12
                                    : ButtonFontStyle.InterRegular12Gray600,
                              ),
                            ),
                          ),
                        ],
                        onTap: (index) {
                          setState(() {
                            _tabController.index = index;
                          });
                        },
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: TabBarView(
                          children: [
                            Container(
                              child: ListView.builder(
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  if (index >= quantityControllers.length) {
                                    quantityControllers
                                        .add(TextEditingController());
                                  }
                                  final quantityController =
                                      quantityControllers[index];
                                  final product = products[index];
                                  bool isSelected = false;
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
                                                  onTap: () {
                                                    setState(() {
                                                      isSelected = !isSelected;

                                                      if (isSelected) {
                                                        int selectedWeightValue =
                                                            int.parse(weight!
                                                                .replaceAll(
                                                                    RegExp(
                                                                        r'\D'),
                                                                    ''));
                                                        int quantity = int.parse(
                                                            quantityController
                                                                .text);
                                                        double totalWeightMT =
                                                            selectedWeightValue *
                                                                quantity /
                                                                1000;
                                                        log('Total Weight: $totalWeightMT');
                                                        Map<String, dynamic>
                                                            productMap = {
                                                          selectedDealerId: [
                                                            {
                                                              'pId': product[
                                                                  'product_id'],
                                                              'qty': quantity
                                                                  .toString(),
                                                              'unit': weight!,
                                                            }
                                                          ]
                                                        };
                                                        selectedProducts
                                                            .add(productMap);
                                                      }
                                                    });
                                                  },
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
                              color: ColorConstant.whiteA700,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: schemeData.length,
                                itemBuilder: (context, index) {
                                  final schemeName =
                                      schemeData.keys.toList()[index];
                                  final schemeItems = schemeData[schemeName];
                                  return Container(
                                    margin: getMargin(top: 6),
                                    padding: getPadding(
                                        left: 20,
                                        top: 16,
                                        right: 20,
                                        bottom: 16),
                                    decoration: AppDecoration.fillWhiteA700
                                        .copyWith(
                                            borderRadius: BorderRadiusStyle
                                                .roundedBorder8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              getPadding(left: 20, right: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: getHorizontalSize(81),
                                                margin: getMargin(bottom: 1),
                                                child: Text(
                                                  "From",
                                                  maxLines: null,
                                                  textAlign: TextAlign.left,
                                                  style: AppStyle
                                                      .txtInterRegular12Bluegray900,
                                                ),
                                              ),
                                              Container(
                                                width: getHorizontalSize(81),
                                                margin: getMargin(bottom: 1),
                                                child: Text(
                                                  DateFormat('dd MMM yyyy')
                                                      .format(DateTime.parse(
                                                    schemeItems[index]
                                                        ['scheme_from'],
                                                  )),
                                                  maxLines: null,
                                                  textAlign: TextAlign.left,
                                                  style: AppStyle
                                                      .txtInterRegular12Bluegray900,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: getPadding(
                                              left: 20, right: 10, bottom: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: getHorizontalSize(81),
                                                margin: getMargin(bottom: 1),
                                                child: Text(
                                                  "To",
                                                  maxLines: null,
                                                  textAlign: TextAlign.left,
                                                  style: AppStyle
                                                      .txtInterRegular12Bluegray900,
                                                ),
                                              ),
                                              Container(
                                                width: getHorizontalSize(81),
                                                margin: getMargin(bottom: 1),
                                                child: Text(
                                                  DateFormat('dd MMM yyyy')
                                                      .format(DateTime.parse(
                                                    schemeItems[index]
                                                        ['scheme_to'],
                                                  )),
                                                  maxLines: null,
                                                  textAlign: TextAlign.left,
                                                  style: AppStyle
                                                      .txtInterRegular12Bluegray900,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: getPadding(all: 2),
                                          decoration: AppDecoration
                                              .outlineGray400
                                              .copyWith(
                                                  borderRadius:
                                                      BorderRadiusStyle
                                                          .roundedBorder8),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: double.maxFinite,
                                                child: Container(
                                                  width: getHorizontalSize(326),
                                                  padding: getPadding(
                                                      left: 14,
                                                      top: 6,
                                                      right: 14,
                                                      bottom: 6),
                                                  decoration: AppDecoration
                                                      .fillRed7000c
                                                      .copyWith(
                                                    borderRadius:
                                                        BorderRadiusStyle
                                                            .roundedBorder8,
                                                  ),
                                                  child: RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: "$schemeName ",
                                                          style: TextStyle(
                                                            color: ColorConstant
                                                                .blueGray900,
                                                            fontSize:
                                                                getFontSize(
                                                                    14.7),
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: "( Dealer )",
                                                          style: TextStyle(
                                                            color: ColorConstant
                                                                .blueGray900,
                                                            fontSize:
                                                                getFontSize(
                                                                    12.25),
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: getPadding(
                                                    left: 21, top: 9),
                                                child: Text(
                                                  "Schemes",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style:
                                                      AppStyle.txtInterMedium12,
                                                ),
                                              ),
                                              Padding(
                                                padding: getPadding(
                                                    left: 34, top: 11),
                                                child: Column(
                                                  children: [
                                                    ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      itemCount:
                                                          schemeItems.length,
                                                      itemBuilder:
                                                          (context, itemIndex) {
                                                        final item =
                                                            schemeItems[
                                                                itemIndex];
                                                        return CheckboxListTile(
                                                          title: Padding(
                                                              padding:
                                                                  getPadding(
                                                                      left: 6,
                                                                      top: 11,
                                                                      right:
                                                                          20),
                                                              child: Row(
                                                                  children: [
                                                                    Padding(
                                                                      padding: getPadding(
                                                                          right:
                                                                              20),
                                                                      child: Text(
                                                                          " ${item['scheme_mt']} MT",
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          textAlign: TextAlign
                                                                              .left,
                                                                          style:
                                                                              AppStyle.txtInterMedium12Bluegray900),
                                                                    ),
                                                                    const Spacer(),
                                                                    Text(
                                                                        item[
                                                                            'item_name'],
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        textAlign:
                                                                            TextAlign
                                                                                .left,
                                                                        style: AppStyle
                                                                            .txtInterMedium12Bluegray900),
                                                                  ])),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              if (value ==
                                                                  true) {
                                                                selectedScheme
                                                                    .add(item[
                                                                        'item_name']);
                                                                controllerText
                                                                        .text =
                                                                    selectedScheme
                                                                        .join(
                                                                            ', ');
                                                              } else {
                                                                selectedScheme
                                                                    .remove(item[
                                                                        'item_name']);
                                                                controllerText
                                                                        .text =
                                                                    selectedScheme
                                                                        .join(
                                                                            ', ');
                                                              }
                                                            });
                                                          },
                                                          value: selectedScheme
                                                              .contains(item[
                                                                  'item_name']),
                                                        );
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ))
        ],
      ),
      floatingActionButton: CustomButton(
          height: getVerticalSize(54),
          width: getHorizontalSize(175),
          text: "Done".toUpperCase(),
          margin: getMargin(top: 50, bottom: 37),
          padding: ButtonPadding.PaddingAll19,
          fontStyle: ButtonFontStyle.InterMedium13,
          onTap: () {
            List<String> selectedSchemes = selectedScheme;
            Map<String, dynamic> json = generateJSON(
                selectedDealerId, selectedProducts, selectedSchemes);
            print(json);
            // onTapDone(context);
          }),
    );
  }

  onTapArrowleft3(BuildContext context) {
    Navigator.pop(context);
  }

  Map<String, dynamic> generateJSON(
    String selectedDealerId,
    List<Map<String, dynamic>> selectedProducts,
    List<String> selectedSchemes,
  ) {
    List<Map<String, dynamic>> schemeList = [
      {selectedDealerId: selectedSchemes}
    ];

    List<Map<String, dynamic>> productsList = [
      {selectedDealerId: selectedProducts}
    ];

    Map<String, dynamic> json = {
      'scheme': schemeList,
      'products': productsList,
    };

    log('the json is======== $json');
    return json;
  }
}
