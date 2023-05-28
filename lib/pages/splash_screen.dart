import 'dart:async';

import 'package:dayalbusinesspartner/pages/homepage.dart';
import 'package:dayalbusinesspartner/pages/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
 
  static const String keyLogin = "Login";
  static const String keyid = "id";
  static const String keyuserType = "userType";
  @override
  void initState() {
    super.initState();
    whereToGo();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        // body:
        );
  }

  void whereToGo() async {
    var prefs = await SharedPreferences.getInstance();
    var isLoggedIn = prefs.getBool(keyLogin);
    int? userID = prefs.getInt(keyid);
    String userIDType = prefs.getString(keyuserType).toString();

    Timer(const Duration(seconds: 2), () {
      if (isLoggedIn != null) {
        if (isLoggedIn) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(
                        id: userID!.toInt(),
                        userType: userIDType,
                      )));
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginPage()));
        }
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    });
  }
}
