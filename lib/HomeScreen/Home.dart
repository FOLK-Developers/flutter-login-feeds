import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:folk/HomeScreen/MainPage.dart';
import 'package:folk/HomeScreen/ProfileScreen.dart';
import 'package:folk/Language/Localization/localizations.dart';
import 'package:folk/SharedWidgets/Loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'FeedDetailedPage.dart';

class Home extends StatefulWidget {
  static const String id = 'Home';
  @override
  var Id;
  String DocId;
  Home({this.Id, this.DocId});
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future temp;
  bool x;
  var click = 1;
  int Index = 0;
  int feedsIndex;
  var data;

  @override
  void initState() {
    super.initState();
    temp = getDataFromFb();
  }

  pushData() async {
    int _index = 0;
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('Feeds')
        .orderBy("creation_date", descending: true)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        if (element.id == widget.Id) {
          _index = value.docs.indexOf(element);
        }
      });
    });
    WidgetsFlutterBinding.ensureInitialized();
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return FeedMainPage(
        Docid: widget.DocId,
        id: _index,
      );
    }));
  }

  Widget build(BuildContext context) {
    List tabContent = [
      MainPage(
        Docid: widget.DocId,
      ),
      Text('')
    ];
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Profile')
          .doc(widget.DocId)
          .snapshots(),
      // ignore: missing_return
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Loading());
        } else {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text('Some Error Occured'));
          } else {
            return DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  elevation: 0.0,
                  title: Text(
                      'Welcome ${snapshot.data.data()['name'].split(' ')[0]}!'),
                  actions: <Widget>[
                    IconButton(
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        print('moving to different screen');
                        WidgetsFlutterBinding.ensureInitialized();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              docId: widget.DocId,
                              prefs: prefs,
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.person),
                    )
                  ],
                ),
                body: Index == 1
                    ? SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: tabContent[Index],
                        ),
                      )
                    : tabContent[Index],
                bottomNavigationBar: BottomNavigationBar(
                  elevation: 0.0,
                  selectedItemColor: Colors.black,
                  currentIndex: Index,
                  type: BottomNavigationBarType.fixed,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      title: Text(AppLocalizations.of(context).Home,
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'NixieOne',
                            color: Colors.black,
                          )),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.group),
                      title: Text(
                        AppLocalizations.of(context).Store,
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NixieOne',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  onTap: (n) {
                    setState(() {
                      Index = n;
                    });
                  },
                ),
              ),
            );
          }
        }
      },
    );
  }

  Future getDataFromFb() async {
    var data = await FirebaseFirestore.instance
        .collection('Profile')
        .doc(widget.DocId)
        .get();
    var user = FirebaseAuth.instance.currentUser;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', data.data()['name']);
    prefs.setString('email', data.data()['email']);
    prefs.setString('phone', user.phoneNumber);
    return data;
  }
}
