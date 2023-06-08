import 'dart:convert';

import 'package:dayalbusinesspartner/pages/order_details.dart';
import 'package:dayalbusinesspartner/widgets/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Orders extends StatefulWidget {
  final String userType;
  final int id;
  const Orders({Key? key, required this.userType, required this.id})
      : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<bool> numberTruthList = [true, true, true, true, true, true];
  List<dynamic> orders = [];

  @override
  void initState() {
    super.initState();
    getMyOrders().then((response) {
      setState(() {
        orders = response['data'];
      });
    }).catchError((error) {
      print(error);
      // Handle error scenario
    });
  }

  Future<Map<String, dynamic>> getMyOrders() async {
    String url = 'http://66.94.34.21:8090/getMyOrders';
    Map<String, String> headers = {'Content-Type': 'application/json'};

    Map<String, dynamic> body = {"id": widget.id};

    final response = await http.post(Uri.parse(url),
        headers: headers, body: jsonEncode(body));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result;
    } else {
      throw Exception(
          'Failed to get orders. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstant.blueGray001,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 5),
                child: Text(
                  'My Orders',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24,
                    color: Colors.black,
                    height: 1,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                flex: 9,
                child: ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Card(
                      elevation: 3,
                      child: ListTile(
                          visualDensity: const VisualDensity(vertical: 3),
                          dense: true,
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Order Number : ${order['od_id']}',
                                style: const TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 12,
                                  color: Colors.grey,
                                  height: 1,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                DateFormat('dd MMM yyyy').format(
                                    DateTime.parse(order['msg_get_date'])),
                                style: const TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 16,
                                  color: Colors.black,
                                  height: 1,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                'Qty : ${order['qty']} MT',
                                style: const TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 12,
                                  color: Colors.grey,
                                  height: 1,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                          trailing: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 25,
                                  width: 100,
                                  child: TextButton(
                                    onPressed: () {},
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          side: const BorderSide(
                                              width: 1, color: Colors.red),
                                        ),
                                      ),
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                              (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.pressed)) {
                                          return ColorConstant
                                              .red7000c; // Customize the color when the button is pressed
                                        } else if (order['status'] == 'V') {
                                          return ColorConstant
                                              .green7c; // Customize the color for status 'V'
                                        } else if (order['status'] == 'P') {
                                          return ColorConstant.red7c; // Customize the color for status 'P'
                                        } else if (order['status'] == 'O') {
                                          return ColorConstant
                                              .green7c; // Customize the color for status 'O'
                                        } else if (order['status'] == 'I') {
                                          return ColorConstant
                                              .blue7c; // Customize the color for status 'I'
                                        } else if (order['status'] == 'D') {
                                          return ColorConstant
                                              .green7c; // Customize the color for status 'D'
                                        } else if (order['status'] == 'A') {
                                          return ColorConstant
                                              .red7c; // Customize the color for status 'A'
                                        } else {
                                          return ColorConstant
                                              .red7c; // Default color for other statuses
                                        }
                                      }),
                                      side: MaterialStateProperty.resolveWith<
                                              BorderSide>(
                                          (Set<MaterialState> states) {
                                        // Customize the border color based on states and status
                                        if (states
                                            .contains(MaterialState.pressed)) {
                                          return  BorderSide(
                                              width: 2,
                                              color: ColorConstant
                                              .red7000c); // Customize the border when the button is pressed
                                        } else if (order['status'] == 'V') {
                                          return BorderSide(
                                              width: 2,
                                              color: ColorConstant
                                              .green7c); // Customize the border for status 'V'
                                        } else if (order['status'] == 'P') {
                                          return  BorderSide(
                                              width: 2,
                                              color: ColorConstant.red7c); // Customize the border for status 'P'
                                        } else if (order['status'] == 'O') {
                                          return  BorderSide(
                                              width: 2,
                                              color: ColorConstant
                                              .green7c); // Customize the border for status 'O'
                                        } else if (order['status'] == 'I') {
                                          return  BorderSide(
                                              width: 2,
                                              color:  ColorConstant
                                              .blue7c); // Customize the border for status 'I'
                                        } else if (order['status'] == 'D') {
                                          return  BorderSide(
                                              width: 2,
                                              color: ColorConstant
                                              .green7c); // Customize the border for status 'D'
                                        } else if (order['status'] == 'A') {
                                          return  BorderSide(
                                              width: 2,
                                              color: ColorConstant
                                              .red7c); // Customize the border for status 'A'
                                        } else {
                                          return  BorderSide(
                                              width: 2,
                                              color: ColorConstant
                                              .red7c); // Default border for other statuses
                                        }
                                      }),
                                    ),
                                    child: (order['status'] == 'V')
                                        ? const Text(
                                            'Vehicle Out',
                                            style: TextStyle(
                                              fontFamily: 'Arial',
                                              fontSize: 10,
                                              color: Colors.white,
                                              height: 1,
                                            ),
                                            textAlign: TextAlign.left,
                                          )
                                        : (order['status'] == 'P')
                                            ? const Text(
                                                'Pending',
                                                style: TextStyle(
                                                  fontFamily: 'Arial',
                                                  fontSize: 10,
                                                  color: Colors.white,
                                                  height: 1,
                                                ),
                                                textAlign: TextAlign.left,
                                              )
                                            : (order['status'] == 'O')
                                                ? const Text(
                                                    'Payment OK',
                                                    style: TextStyle(
                                                      fontFamily: 'Arial',
                                                      fontSize: 10,
                                                      color: Colors.white,
                                                      height: 1,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  )
                                                : (order['status'] == 'I')
                                                    ? const Text(
                                                        'Truck Arrange',
                                                        style: TextStyle(
                                                          fontFamily: 'Arial',
                                                          fontSize: 10,
                                                          color: Colors.white,
                                                          height: 1,
                                                        ),
                                                        textAlign:
                                                            TextAlign.left,
                                                      )
                                                    : (order['status'] == 'D')
                                                        ? const Text(
                                                            'Invoice Ready',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Arial',
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.white,
                                                              height: 1,
                                                            ),
                                                            textAlign:
                                                                TextAlign.left,
                                                          )
                                                        : (order['status'] ==
                                                                'A')
                                                            ? const Text(
                                                                'Approval Pending',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Arial',
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .white,
                                                                  height: 1,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                              )
                                                            : const Text(
                                                                'Cancelled',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Arial',
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .white,
                                                                  height: 1,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                              ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                SizedBox(
                                  height: 25,
                                  width: 100,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OrderIosTwoScreen(
                                                    id: widget.id,
                                                    userType: widget.userType,
                                                    orderdate:
                                                        order['msg_get_date'],
                                                    ordernum: order['od_id'],
                                                  )));
                                    },
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          side: const BorderSide(
                                              width: 1, color: Colors.red),
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      'view Details',
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 10,
                                        color: Colors.grey,
                                        height: 1,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    );
                    // : const SizedBox(
                    //     height: 0,
                    //     width: 0,
                    //   );
                  },
                ),
                //         child: ListView.builder(
                //   itemCount: orders.length,
                //   itemBuilder: (context, index) {
                //     final order = orders[index];
                //     return ListTile(
                //       title: Text('Order ID: ${order['od_id']}'),
                //       subtitle: Text('Order No: ${order['order_no']}'),
                //       trailing: Text('Quantity: ${order['qty']}'),
                //     );
                //   },
                // ),
              ),
            ]));
  }
}
