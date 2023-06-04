import 'dart:convert';
import 'dart:developer';

import 'package:dayalbusinesspartner/Supplier/dashboard_home.dart';
import 'package:dayalbusinesspartner/pages/homepage.dart';
import 'package:dayalbusinesspartner/pages/otherpage.dart'; // Import the other page
import 'package:dayalbusinesspartner/utils/CustomTextStyle.dart';
import 'package:dayalbusinesspartner/utils/customsnackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_context/one_context.dart';
import 'package:http/http.dart' as http;

class OtpPage extends StatefulWidget {
  final String mobile;
  final String domain;
  final String userType;
  final int otpp;
  final int id;

  const OtpPage({
    Key? key,
    required this.mobile,
    required this.domain,
    required this.userType,
    required this.otpp,
    required this.id,
  }) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  TextEditingController otpController = TextEditingController();
  late int otppass;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.red,
      body: Stack(
        children: <Widget>[
          Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.red,
                ),
              ),
              Expanded(
                flex: 8,
                child: ClipRect(
                  child: Container(
                    width: width,
                    height: height,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(70),
                        topRight: Radius.circular(70),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 100.0),
                          child: Text(
                            "DAYAL",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            bottom: 5, // Space between underline and text
                          ),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey,
                                width: 2.0, // Underline thickness
                              ),
                            ),
                          ),
                          child: const Text(
                            "BUSINESS PARTNER",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'OTP Sent to your mobile no. ',
                                ),
                                const TextSpan(
                                  text: ' +91 - ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(text: widget.mobile.toString()),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 50.0,
                            horizontal: 20,
                          ),
                          child: TextField(
                            maxLength: 6,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: otpController,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: 'Enter OTP',
                              hintStyle: const TextStyle(fontSize: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              filled: true,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 50.0,
                            horizontal: 10,
                          ),
                          child: SizedBox(
                            height: 50,
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () {
                                if (int.parse(otpController.text) ==
                                        widget.otpp ||
                                    int.parse(otpController.text) == otppass) {
                                  OneContext().hideCurrentSnackBar();
                                  OneContext().showSnackBar(
                                    builder: (context) =>
                                        ShowSnackBar().customBar(
                                      "Otp verified Successfully",
                                      context!,
                                      true,
                                    ),
                                  );
                                  Future.delayed(
                                    const Duration(seconds: 2),
                                    () {
                                      if (widget.userType == 'dealer') {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) => DashHomePage(
                                              id: widget.id,
                                              userType: widget.userType,
                                            ),
                                          ),
                                        );
                                      } else {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) => HomePage(
                                              id: widget.id,
                                              userType: widget.userType,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  );
                                } else {
                                  OneContext().hideCurrentSnackBar();
                                  OneContext().showSnackBar(
                                    builder: (context) =>
                                        ShowSnackBar().customBar(
                                      "Please Enter correct Otp",
                                      context!,
                                    ),
                                  );
                                }
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: const BorderSide(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              child: const Text("SUBMIT"),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "If you didn't receive OTP ?",
                                style: CustomTextStyle.textFormFieldMedium,
                              ),
                              TextButton(
                                onPressed: () {
                                  const apiURL =
                                      'http://66.94.34.21:8090/login';
                                  final requestBody = {
                                    'mobile': widget.mobile,
                                    'domain': widget.domain,
                                  };

                                  http
                                      .post(
                                    Uri.parse(apiURL),
                                    headers: {
                                      "Content-Type": "application/json",
                                    },
                                    body: json.encode(requestBody),
                                  )
                                      .then(
                                    (response) {
                                      if (response.statusCode == 200) {
                                        final responseData =
                                            json.decode(response.body);
                                        final bool status =
                                            responseData['status'];
                                        final String msg = responseData['msg'];
                                        final int otp = responseData['otp'];
                                        // final int id = responseData['id'];
                                        final String userType =
                                            responseData['usertype'];
                                        log("===========$msg+++++");
                                        log("===========$status+++++");
                                        log("===========$otp+++++");
                                        log("===========$userType+++++");
                                        if (msg == 'success') {
                                          OneContext().hideCurrentSnackBar();
                                          OneContext().showSnackBar(
                                            builder: (context) =>
                                                ShowSnackBar().customBar(
                                              msg.toString(),
                                              context!,
                                              true,
                                            ),
                                          );
                                          setState(() {
                                            otppass = otp;
                                          });
                                        } else if (!status &&
                                            msg == 'user not found') {
                                          OneContext().hideCurrentSnackBar();
                                          OneContext().showSnackBar(
                                            builder: (context) =>
                                                ShowSnackBar().customBar(
                                              msg.toString(),
                                              context!,
                                            ),
                                          );
                                        } else {
                                          OneContext().hideCurrentSnackBar();
                                          OneContext().showSnackBar(
                                            builder: (context) =>
                                                ShowSnackBar().customBar(
                                              msg.toString(),
                                              context!,
                                            ),
                                          );
                                        }
                                      } else {
                                        OneContext().hideCurrentSnackBar();
                                        OneContext().showSnackBar(
                                          builder: (context) =>
                                              ShowSnackBar().customBar(
                                            "Something went wrong",
                                            context!,
                                          ),
                                        );
                                      }
                                    },
                                  ).catchError(
                                    (error) {
                                      OneContext().hideCurrentSnackBar();
                                      OneContext().showSnackBar(
                                        builder: (context) =>
                                            ShowSnackBar().customBar(
                                          "Status false you are not registered with us",
                                          context!,
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  "Resend OTP",
                                  style: CustomTextStyle
                                      .textFormFieldSemiBoldColored,
                                  selectionColor: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'assets/images/dayalgroup.png',
                height: 100,
                width: 150,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
