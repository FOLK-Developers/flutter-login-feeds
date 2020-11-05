import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:folk/LoginAuthentication/SplashScreen.dart';

class SplashScreenOpen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenOpenState();
  }
}

class _SplashScreenOpenState extends State<SplashScreenOpen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    return Container(
      padding: EdgeInsets.all(30.0),
      color: Colors.white,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/playstore.png'),
                  fit: BoxFit.fitWidth)),
        ),
      ),
    );
  }

  void startTimer() {
    Timer(Duration(seconds: 3), () {
      navigateUser(); //It will redirect  after 3 seconds
    });
  }

  void navigateUser() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SplashScreen()));
  }
}
