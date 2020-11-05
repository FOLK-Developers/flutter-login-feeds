import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:folk/Language/Localization/localizations.dart';
import 'package:folk/SharedWidgets/Constants.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class Userinfo extends StatefulWidget {
  var prefs;
  var DocId;
  Userinfo({this.prefs, this.DocId});
  static const String id = 'UserInfo';
  @override
  _UserinfoState createState() => _UserinfoState();
}

class _UserinfoState extends State<Userinfo> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  var error = '';
  Future data;
  String uid;
  String number;
  String name;
  String email;
  String update;
  String url;
  String string;
  String common;
  bool confirm;
  var user;
  QuerySnapshot qshot;

  void initState() {
    super.initState();
    data = getDataFromFb();
  }

  Future<DocumentSnapshot> getDataFromFb() async {
    user = await FirebaseAuth.instance.currentUser;
    this.uid = user.uid;
    this.number = user.phoneNumber;
    var data = await FirebaseFirestore.instance
        .collection('Profile')
        .doc(widget.DocId)
        .get();
    this.name = data.data()['name'];
    this.email = data.data()['email'];
    this.qshot = await FirebaseFirestore.instance.collection('Profile').get();
    return data;
  }

  emailValidation(String str) async {
    if (str.length == 0) {
      this.string = 'Email required!';
    } else if (validator.email(str)) {
      this.qshot.docs.map((doc) {
        if (doc.data()['author'] != this.uid) {
          if (doc.data()['Email'] == str) {
            this.common = doc.data()['Email'];
            this.confirm = false;
            this.string = 'Email already exists';
          }
        }
      }).toList();
      if (this.common == null) {
        this.string = null;
      }
      print(this.string);
    } else {
      this.string = 'Enter a valid email!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).OptionA,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Card(
                  color: Colors.transparent,
                  elevation: 0.0,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(LineAwesomeIcons.user),
                        title: Text(
                          AppLocalizations.of(context).Name,
                          style: TextStyle(fontSize: 14),
                        ),
                        trailing: Icon(LineAwesomeIcons.pen),
                        subtitle: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: widget.prefs.getString('name'),
                            hintStyle: kTitleTextStyle,
                          ),
                          validator: (val) {
                            if (val.length < 1) {
                              if (AppLocalizations.of(context).locale == "en") {
                                return 'Name Required';
                              } else {
                                return 'नाम की आवश्यकता है';
                              }
                            } else
                              return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  color: Colors.transparent,
                  elevation: 0.0,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.mail),
                        title: Text(
                          AppLocalizations.of(context).Email,
                          style: TextStyle(fontSize: 14),
                        ),
                        trailing: Icon(LineAwesomeIcons.pen),
                        subtitle: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: widget.prefs.getString('email'),
                            hintStyle: kTitleTextStyle,
                          ),
                          validator: (val) {
                            this.common = null;
                            emailValidation(val);
                            return this.string;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  color: Colors.transparent,
                  elevation: 0.0,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(LineAwesomeIcons.phone),
                        title: Text(
                          AppLocalizations.of(context).Phone,
                          style: TextStyle(fontSize: 14),
                        ),
                        subtitle: Opacity(
                          opacity: 0.50,
                          child: Text(
                            widget.prefs.getString('phone'),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: kSpacingUnit.toDouble() * 5.5,
                  margin: EdgeInsets.symmetric(
                    horizontal: kSpacingUnit.toDouble() * 10,
                  ).copyWith(
                    bottom: kSpacingUnit.toDouble() * 2,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: kSpacingUnit.toDouble() * 2,
                  ),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(kSpacingUnit.toDouble() * 3),
                    color: Theme.of(context).backgroundColor,
                  ),
                  child: FlatButton(
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      if (_formKey.currentState.validate()) {
                        Timer(Duration(seconds: 3), () {
                          FirebaseFirestore.instance
                              .collection('Profile')
                              .doc(widget.DocId)
                              .update({
                            'name': nameController.text,
                            'email': emailController.text
                          });
                          prefs.setString('Name', nameController.text);
                          prefs.setString('Email', emailController.text);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Home()));
                        });
                      } else {
                        setState(() {
                          if (AppLocalizations.of(context).locale == "en") {
                            error = 'Please check your Credentials';
                          } else {
                            error = 'कृपया अपने क्रेडेंशियल्स की जाँच करें';
                          }
                        });
                      }
                    },
                    padding: EdgeInsets.all(0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context).Update,
                          style: kTitleTextStyle.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  error,
                  style: TextStyle(color: Colors.red),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
