import 'dart:convert';
import 'dart:developer';

import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:dayalbusinesspartner/pages/otppage.dart';
import 'package:dayalbusinesspartner/pages/splash_screen.dart';
import 'package:dayalbusinesspartner/utils/customsnackbar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_context/one_context.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  TextEditingController mobileController = TextEditingController();
  late String _domain;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.red,
      body: Stack(children: <Widget>[
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
                          topRight: Radius.circular(70))),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 100.0),
                        child: Text(
                          "DAYAL",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
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
                        ))),
                        child: const Text(
                          "BUSINESS PARTNER",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 50.0, horizontal: 20),
                        child: TextFormField(
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: mobileController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: 'Enter a registered contact number',
                            hintStyle: const TextStyle(fontSize: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                width: 1,
                                style: BorderStyle.solid,
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        ),
                      ),
                      CustomRadioButton(
                        buttonTextStyle: const ButtonTextStyle(
                            selectedColor: Colors.white,
                            unSelectedColor: Colors.black,
                            textStyle: TextStyle(fontSize: 16)),
                        radioButtonValue: (value) {
                          setState(() {
                            _domain = value;
                          });
                          log(value);
                        },
                        unSelectedColor: Theme.of(context).canvasColor,
                        buttonLables: const ["Cattle", "Aqua"],
                        buttonValues: const ["cf", "af"],
                        spacing: 0,
                        horizontal: false,
                        enableButtonWrap: false,
                        width: 100,
                        absoluteZeroSpacing: false,
                        selectedColor: Theme.of(context).colorScheme.secondary,
                        padding: 10,
                        enableShape: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 50.0, horizontal: 10),
                        child: SizedBox(
                          height: 50,
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isLoading = true;
                              });
                              const apiURL = 'http://66.94.34.21:8090/login';
                              final requestBody = {
                                'mobile': mobileController.text.toString(),
                                'domain': _domain,
                              };

                              http
                                  .post(Uri.parse(apiURL),
                                      headers: {
                                        "Content-Type": "application/json"
                                      },
                                      body: json.encode(requestBody))
                                  .then((response) async {
                                if (response.statusCode == 200) {
                                  final responseData =
                                      json.decode(response.body);
                                  final bool status = responseData['status'];
                                  final String msg = responseData['msg'];
                                  final int otp = responseData['otp'];
                                  final int id = responseData['id'];
                                  final String userType =
                                      responseData['usertype'];
                                  log("===========$msg+++++");
                                  log("===========$status+++++");
                                  log("===========$otp+++++");
                                  log("===========$userType+++++");
                                  if (msg == 'success') {
                                    OneContext().hideCurrentSnackBar();
                                    OneContext().showSnackBar(
                                        builder: (context) => ShowSnackBar()
                                            .customBar(msg.toString(), context!,
                                                true));
                                    Future.delayed(const Duration(seconds: 2),
                                        () async {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                        builder: (context) => OtpPage(
                                          domain: _domain,
                                          mobile:
                                              mobileController.text.toString(),
                                          id: id,
                                          otpp: otp,
                                          userType: userType,
                                        ),
                                      ));
                                       var prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setBool(SplashScreenState.keyLogin,true);
                                    prefs.setInt(SplashScreenState.keyid,id);
                                    prefs.setString(SplashScreenState.keyuserType,userType);
                                    });
                                  } else if (!status &&
                                      msg == 'user not found') {
                                    OneContext().hideCurrentSnackBar();
                                    OneContext().showSnackBar(
                                        builder: (context) => ShowSnackBar()
                                            .customBar(
                                                msg.toString(), context!));
                                  } else {
                                    OneContext().hideCurrentSnackBar();
                                    OneContext().showSnackBar(
                                        builder: (context) => ShowSnackBar()
                                            .customBar(
                                                msg.toString(), context!));
                                  }
                                } else {
                                  OneContext().hideCurrentSnackBar();
                                  OneContext().showSnackBar(
                                      builder: (context) => ShowSnackBar()
                                          .customBar("Something went wrong",
                                              context!));
                                }
                              }).catchError((error) {
                                setState(() {
                                  isLoading = false;
                                });
                                OneContext().hideCurrentSnackBar();
                                OneContext().showSnackBar(
                                    builder: (context) => ShowSnackBar().customBar(
                                        "Status false you are not registered with us",
                                        context!));
                              });
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: const BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                            child: const Text("GET OTP"),
                          ),
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
          padding: const EdgeInsets.only(top: 110.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
                height: 100, width: 150, 'assets/images/dayalgroup.png'),
          ),
        )
      ]),
    );
  }
}
