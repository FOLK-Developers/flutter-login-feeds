import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:folk/Channels/ChannelList.dart';
import 'package:folk/HomeScreen/FeedDetailedPage.dart';
import 'package:folk/SharedWidgets/HomePageWidgets.dart';

class MainPage extends StatefulWidget {
  var Docid;
  MainPage({this.Docid});
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 15.0, bottom: 0.0),
          child: Text(
            "STORIES",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.blueAccent),
          ),
        ),
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Stories')
                .orderBy('latest_story_approved_time', descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Text('Loading...');
                default:
                  return Container(
                    padding: const EdgeInsets.only(top: 0.0, left: 0.0),
                    child: SizedBox(
                      height: 210.0,
                      child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data.docs
                              .map((DocumentSnapshot document) {
                            return SizedBox(
                              height: 40.0,
                              width: MediaQuery.of(context).size.width * 2 / 5,
                              child: customcard(
                                  document.data()['latest_story_url'],
                                  document
                                      .data()['user_name']
                                      .toString()
                                      .split(' ')[0],
                                  Icons.wc,
                                  document.data()['user_image_url'],
                                  10.0,
                                  30.0,
                                  context),
                            );
                          }).toList()),
                    ),
                  );
              }
            }),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, bottom: 0.0, top: 10.0),
          child: Text(
            "LATEST FEEDS",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.blueAccent),
          ),
        ),
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Feeds')
                .orderBy("creation_date", descending: true)
                .limit(4)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Text('Loading...');
                default:
                  return Container(
                    padding: const EdgeInsets.only(top: 0.0, left: 0.0),
                    child: SizedBox(
                      height: 350.0,
                      child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            ...snapshot.data.docs
                                .map((DocumentSnapshot document) {
                              return SizedBox(
                                height: 55.0,
                                width:
                                    MediaQuery.of(context).size.width * 2 / 3,
                                child: customcard(
                                    document.data()['feed_image_url'],
                                    document.data()['channel_name'],
                                    Icons.wc,
                                    document.data()['feed_image_url'],
                                    10.0,
                                    30.0,
                                    context),
                              );
                            }),
                            Opacity(
                              opacity: 0.6,
                              child: Container(
                                width:
                                    MediaQuery.of(context).size.width * 2 / 5,
                                height: 50.0,
                                padding: EdgeInsets.all(40),
                                child: RawMaterialButton(
                                  shape: CircleBorder(),
                                  fillColor: Colors.blue[200],
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.arrow_forward,
                                        size: 30,
                                      ),
                                      Text(
                                        'more',
                                      )
                                    ],
                                  ),
                                  onPressed: () {
                                    WidgetsFlutterBinding.ensureInitialized();
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return FeedMainPage(Docid: widget.Docid);
                                    }));
                                  },
                                ),
                              ),
                            ),
                          ]),
                    ),
                  );
              }
            }),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, bottom: 0.0, top: 10.0),
          child: Text(
            "TOP CHANNELS",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.blueAccent),
          ),
        ),
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Channel')
                .orderBy("created_on", descending: true)
                .limit(5)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Text('Loading...');
                default:
                  return Column(
                    children: <Widget>[
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              height: 160.0,
                              child: InkWell(
                                child: customcardrighttext(
                                    snapshot.data.docs
                                        .elementAt(0)
                                        .data()['name'],
                                    ">",
                                    Icons.local_hospital,
                                    snapshot.data.docs
                                        .elementAt(0)
                                        .data()['channel_link'],
                                    14.0),
                                onTap: () {
                                  // here navigation of your choise
                                },
                              )),
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              height: 160.0,
                              child: InkWell(
                                child: customcardrighttext(
                                    snapshot.data.docs
                                        .elementAt(1)
                                        .data()['name'],
                                    ">",
                                    Icons.directions_run,
                                    snapshot.data.docs
                                        .elementAt(1)
                                        .data()['channel_link'],
                                    14.0),
                                onTap: () {
                                  // here navigation of your choise
                                },
                              )),
                        ],
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              height: 160.0,
                              child: InkWell(
                                child: customcardrighttext(
                                    snapshot.data.docs
                                        .elementAt(2)
                                        .data()['name'],
                                    ">",
                                    Icons.accessibility_new,
                                    snapshot.data.docs
                                        .elementAt(2)
                                        .data()['channel_link'],
                                    14.0),
                                onTap: () {
                                  // here navigation of your choise
                                },
                              )),
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              height: 160.0,
                              child: InkWell(
                                child: customcardrighttext(
                                    snapshot.data.docs
                                        .elementAt(3)
                                        .data()['name'],
                                    ">",
                                    Icons.local_hospital,
                                    snapshot.data.docs
                                        .elementAt(3)
                                        .data()['channel_link'],
                                    14.0),
                                onTap: () {
                                  // here navigation of your choise
                                },
                              )),
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              height: 160.0,
                              child: InkWell(
                                child: customcardrighttext(
                                    snapshot.data.docs
                                        .elementAt(4)
                                        .data()['name'],
                                    ">",
                                    Icons.local_hospital,
                                    snapshot.data.docs
                                        .elementAt(4)
                                        .data()['channel_link'],
                                    12.0),
                                onTap: () {
                                  // here navigation of your choise
                                },
                              )),
                        ],
                      ),
                    ],
                  );
              }
            }),
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: InkWell(
                onTap: () {
                  WidgetsFlutterBinding.ensureInitialized();
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return ChannelList(
                      userid: widget.Docid,
                    );
                  }));
                },
                child: Text(
                  'See More',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 50,
        )
      ],
    );
  }
}
