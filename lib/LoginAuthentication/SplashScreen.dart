import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:folk/Language/Localization/localizations.dart';
import 'package:folk/LoginAuthentication/PhoneAuthentication.dart';
import 'package:folk/LoginAuthentication/UserData.dart';
import 'package:folk/Services/DynamicLinkService.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
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
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/SrilaPrabhupada.png'),
              fit: BoxFit.fitHeight)),
    );
  }

  void startTimer() {
    Timer(Duration(seconds: 3), () {
      navigateUser(); //It will redirect  after 3 seconds
    });
  }

  void navigateUser() async {
    var update;
    var url;
    var level;
    final DynamicLinkService _dls = DynamicLinkService();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var check = prefs.getBool('Login');
    var a = await FirebaseAuth.instance.currentUser;
    await _dls.handleDynamicLinks();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var snapShot = await FirebaseFirestore.instance
        .collection('Folkapp')
        .doc('version')
        .get()
        .then((value) {
      update = value.data()['android_major_update'];
      url = value.data()['link'];
      level = value.data()['mandatory'];
    });

    if (packageInfo.version == update) {
      Navigator.of(context).pop();
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context).AppUpdate),
              content: Text(
                level == true
                    ? 'There is a new Update Available to ${update}! PLease update your App to continue'
                    : 'There is a new Update Available! Would you like to update to version ' +
                        '${update}',
              ),
              actions: <Widget>[
                FlatButton(
                    onPressed: () async {
                      if (await canLaunch(url)) {
                        await launch(url);
                      }
                    },
                    child: Text(AppLocalizations.of(context).Update)),
                level == true
                    ? null
                    : FlatButton(
                        child: Text(AppLocalizations.of(context).Close),
                        onPressed: () {
                          if (a == null) {
                            print('user not found');
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PhoneVerification()));
                          } else {
                            if (check == true) {
                              print('user found');
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserData(
                                            user: a,
                                          )));
                            } else {
                              print('user not found');
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PhoneVerification()));
                            }
                          }
                        },
                      )
              ],
            );
          });
    } else {
      if (a == null) {
        print('user not found');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => PhoneVerification()));
      } else {
        if (check == true) {
          print('user found');
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => UserData(
                        user: a,
                      )));
        } else {
          print('user not found');
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => PhoneVerification()));
        }
      }
    }
  }
}
