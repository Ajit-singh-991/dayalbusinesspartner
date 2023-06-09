import 'dart:convert';

import 'package:dayalbusinesspartner/pages/details_of_payments.dart';
import 'package:dayalbusinesspartner/pages/payment_info.dart';
import 'package:dayalbusinesspartner/widgets/color_constant.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaymentDetails extends StatefulWidget {
  final String userType;
  final int id;
  const PaymentDetails({super.key, required this.userType, required this.id});

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  List<dynamic> paymentDetails = [];

 
  Future<void> fetchPaymentDetails() async {
    const url = 'http://66.94.34.21:8090/getPaymentDetails';
    final requestBody = {"id": widget.id};

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        paymentDetails = responseData['data'];
      });
    } else {
      throw Exception('Failed to fetch payment details');
    }
  }
 @override
  void initState() {
    super.initState();
    fetchPaymentDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.blueGray001,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(30, 50, 20, 10),
            child: Text(
              "Payment Details:",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.w900),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: paymentDetails.length,
              itemBuilder: (context, index) {
                final payment = paymentDetails[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListTile(
                    leading:(payment['status'] == "C")
                        ? SizedBox(
                        height: 50.0,
                        width: 50.0, // fixed width and height
                        child: Image.asset("assets/images/done.png")
                    )
                        : (payment['status'] == "H")
                        ? SizedBox(
                        height: 40.0,
                        width: 40.0, // fixed width and height
                        child: Image.asset(("assets/images/hold.jpg"))
                    )
                        : (payment['status'] == "P")
                        ? SizedBox(
                        height: 40.0,
                        width: 40.0, // fixed width and height
                        child: Image.asset(("assets/images/pending.png"))
                    )
                        : (payment['status'] == "R")
                        ? SizedBox(
                        height: 40.0,
                        width: 40.0, // fixed width and height
                        child: Image.asset("assets/images/reject.jpg")
                    )
                        : Container(),
                    title: Text(
                      DateFormat('dd MMM yyyy')
                          .format(DateTime.parse(payment['pay_date']).toLocal()),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: ColorConstant.black900,
                          fontWeight: FontWeight.w500),
                    ),
                    trailing: IntrinsicWidth(
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '₹ ${NumberFormat('##,##,###').format(int.parse(payment['amount']))}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Paid via ${payment['pay_mode']}',
                                style: TextStyle(
                                    color: ColorConstant.gray400,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: ColorConstant.black900,
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsPage(payment: payment, id: widget.id, userType: widget.userType,),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),

          // const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(200, 10, 10, 30),
            child: SizedBox(
              height: 50,
              width: 180,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddPayDetailsIosPage(
                              id: widget.id,
                              userType: widget.userType,
                            )));
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<StadiumBorder>(
                          StadiumBorder(
                              side: BorderSide(
                    color: ColorConstant.red700,
                  )))),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/add_icon.png",
                        filterQuality: FilterQuality.high,
                        width: 20,
                        height: 20,
                      ),
                      const Text("ADD NEW DETAIL"),
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }
}
