import 'dart:async';

import 'package:dayalbusinesspartner/pages/homepage.dart';
import 'package:dayalbusinesspartner/widgets/color_constant.dart';
// import 'package:dayalbusinesspartner/pages/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _animation;
  static const String keyLogin = "Login";
  static const String keyid = "id";
  static const String keyuserType = "userType";
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
    whereToGo();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.red700,
      body: Center(
        child: AnimatedBuilder(
          
          animation: _animation,
          builder: (BuildContext context, Widget? child) {
            return Opacity(
              opacity: _animation.value,
              child: child,
            );
          },
          child: Image.asset("assets/splash/splash logo.jpeg")),
      ),
    );
  }

  void whereToGo() async {
    var prefs = await SharedPreferences.getInstance();
    var isLoggedIn = prefs.getBool(keyLogin);
    int? userID = prefs.getInt(keyid);
    String userIDType = prefs.getString(keyuserType).toString();

    Timer(const Duration(seconds: 4), () {
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
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomePage(
                        id: 17,
                        userType: "dealer",
                      )));
        }
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const HomePage(
                      id: 17,
                      userType: "dealer",
                    )));
      }
    });
  }
}
