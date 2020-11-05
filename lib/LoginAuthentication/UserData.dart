import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:folk/HomeScreen/Home.dart';
import 'package:folk/Language/Localization/localizations.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData extends StatefulWidget {
  var user;
  UserData({this.user});
  @override
  _UserDataState createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  final _formKey = GlobalKey<FormState>();
  String string;
  TextEditingController nameController = new TextEditingController(text: null);
  TextEditingController emailController = new TextEditingController(text: null);
  String common;
  String error = '';
  bool confirm;
  var uid;
  SharedPreferences prefs;

  Stream<QuerySnapshot> userData() {
    var data = FirebaseFirestore.instance
        .collection('Profile')
        .where('author', isEqualTo: widget.user.uid)
        .snapshots();
    return data;
  }

  getPrefs() async {
    this.prefs = await SharedPreferences.getInstance();
  }

  emailValidation(String str, String user) async {
    var qshot = await FirebaseFirestore.instance.collection('').get();
    if (str.length == 0) {
      this.string = 'Email required!';
    } else if (validator.email(str)) {
      qshot.docs.map((doc) {
        if (doc.data()['author'] != user) {
          if (doc.data()['email'] == str) {
            print('hello');
            this.common = doc.data()['email'];
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
    return StreamBuilder<QuerySnapshot>(
        stream: userData(),
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
            );
          } else {
            if (snapshot.hasError) {
              print(snapshot.error);
              return Scaffold(body: Center(child: Text('Some Error Occured')));
            } else if (snapshot.data.docs.isNotEmpty) {
              print('Data Exists');
              if (snapshot.data.docs.first.data()['name'] != null) {
                print('Name Exists');
                return Home(
                  DocId: snapshot.data.docs.first.id,
                );
              } else {
                print('name does not exist');
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.blue,
                    elevation: 0.4,
                    title: Center(
                      child: Text('Profile info'),
                    ),
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
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
                                      subtitle: TextFormField(
                                        controller: nameController,
                                        validator: (val) {
                                          if (val.length < 1)
                                            return 'Name Required';
                                          else
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
                                      subtitle: TextFormField(
                                        controller: emailController,
                                        validator: (val) {
                                          this.common = null;
                                          emailValidation(
                                              val,
                                              snapshot.data.docs.first
                                                  .data()['author']);
                                          return this.string;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              FlatButton(
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    FirebaseFirestore.instance
                                        .collection('Profile')
                                        .doc(snapshot.data.docs.first.id)
                                        .update({
                                      'name': nameController.text,
                                      'email': emailController.text,
                                    });
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserData(),
                                      ),
                                    );
                                  } else {
                                    setState(() {
                                      error = 'Please check your Credentials';
                                    });
                                  }
                                },
                                color: Colors.blue,
                                child: Text(
                                  'Continue',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            } else {
              print('data does not exist');
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }
        });
  }
}
