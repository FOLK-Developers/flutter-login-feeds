import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:folk/SharedWidgets/Posts.dart';
import 'package:intl/intl.dart';

class FancyAppbarAnimation extends StatefulWidget {
  static final String path = "lib/src/pages/animations/anim3.dart";
  String Docid;
  var Channel;
  String ChannelImage;
  FancyAppbarAnimation({this.Channel, this.Docid, this.ChannelImage});
  @override
  _FancyAppbarAnimationState createState() => _FancyAppbarAnimationState();
}

class _FancyAppbarAnimationState extends State<FancyAppbarAnimation> {
  ScrollController scrollController = ScrollController();
  Color appBarBackground;
  double topPosition;
  var channel;
  DocumentSnapshot snapshot;
  ScrollController _scrollController = ScrollController();
  var a;
  var b;
  var c;
  var d;
  Future temp;

  animateToIndex(i) {
    _scrollController.animateTo(
      100.0 * i,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  Future<DocumentSnapshot> getDataFromFb() async {
    var data = await FirebaseFirestore.instance
        .collection('Channel')
        .doc(widget.Channel)
        .get();
    this.a = data.data()['name'];
    this.b = data.data()['channel_link'];
    this.c = data.data()['created_by'];
    this.d = data.data()['created_on'];
    return data;
  }

  @override
  void initState() {
    temp = getDataFromFb();
    topPosition = -80;
    appBarBackground = Colors.transparent;
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    return time;
  }

  double _getOpacity() {
    double op = (topPosition + 80) / 80;
    return op > 1 || op < 0 ? 1 : op;
  }

  _onScroll() {
    if (_scrollController.offset > 50) {
      if (topPosition < 0)
        setState(() {
          topPosition = -130 + _scrollController.offset;
          if (_scrollController.offset > 130) topPosition = 0;
        });
    } else {
      if (topPosition > -80)
        setState(() {
          topPosition--;
          if (_scrollController.offset <= 0) topPosition = -80;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    /*return Scaffold(
      backgroundColor: Colors.grey[200],
      body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('Channel')
              .doc(widget.Channel)
              .get(),
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
              int time = snapshot.data.data()['created_on'];
              final df = new DateFormat('dd-MM-yyyy hh:mm a');
              String creationDate =
                  df.format(DateTime.fromMillisecondsSinceEpoch(time * 1000));
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Text('Loading.');
                default:
                  return Stack(
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection("Feeds")
                                    .where("channel_ID",
                                        isEqualTo: widget.Channel)
                                    .orderBy("creation_date", descending: true)
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshotx) {
                                  if (snapshotx.hasError)
                                    return new Text(
                                        'Error: ${snapshotx.error}');
                                  switch (snapshotx.connectionState) {
                                    case ConnectionState.waiting:
                                      return Text('Loading...');
                                    default:
                                      return snapshotx.data.docs.isNotEmpty
                                          ? Container(
                                              padding: const EdgeInsets.only(
                                                  top: 0.0, left: 0.0),
                                              child: SizedBox(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                child: ListView(
                                                    controller:
                                                        _scrollController,
                                                    children: <Widget>[
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 16.0,
                                                                right: 50),
                                                        height: 220,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          30.0)),
                                                          color: Colors.white,
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            const SizedBox(
                                                                height: 80),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width -
                                                                      100,
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child:
                                                                        DefaultTextStyle(
                                                                      style:
                                                                          TextStyle(),
                                                                      softWrap:
                                                                          false,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      child:
                                                                          Semantics(
                                                                        child:
                                                                            Text(
                                                                          snapshot
                                                                              .data
                                                                              .data()['name'],
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 24.0,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                ClipOval(
                                                                  child: Image(
                                                                    image: NetworkImage(
                                                                        snapshot
                                                                            .data
                                                                            .data()['channel_link']),
                                                                    width: 80,
                                                                    height: 80,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                                Column(
                                                                  children: <
                                                                      Widget>[
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              20.0),
                                                                      child:
                                                                          Text(
                                                                        "Created by: ${snapshot.data.data()['created_by']}",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize: 18.0),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              20.0),
                                                                      child:
                                                                          Text(
                                                                        "Created on: ${creationDate.split(' ')[0]}",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize: 18.0),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      ...snapshotx.data.docs
                                                          .map((DocumentSnapshot
                                                              document) {
                                                        return Posts(
                                                          Docid: widget.Docid,
                                                          recordFeed: document,
                                                        );
                                                      }),
                                                    ]),
                                              ),
                                            )
                                          : Center(
                                              child: Text("No posts to show"),
                                            );
                                  }
                                }),
                            const SizedBox(height: 10.0),
                          ],
                        ),
                      ),
                      Positioned(
                          top: topPosition,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 80,
                            padding: const EdgeInsets.only(
                                left: 50, top: 25.0, right: 20.0),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(30.0)),
                              color: Colors.white.withOpacity(_getOpacity()),
                            ),
                            child: DefaultTextStyle(
                              style: TextStyle(),
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              child: Semantics(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(1, 20.0, 0, 0),
                                  child: Text(
                                    snapshot.data.data()['name'],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                header: true,
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 80,
                        child: AppBar(
                          iconTheme: IconThemeData(color: Colors.black),
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                        ),
                      )
                    ],
                  );
              }
            }
          }),
    );*/
    return FutureBuilder<DocumentSnapshot>(
        future: temp,
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
            return Scaffold(
              backgroundColor: Colors.grey.shade300,
              body: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(left: 16.0, right: 5),
                          height: 220,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(30.0)),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const SizedBox(height: 80),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 100,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: DefaultTextStyle(
                                        style: TextStyle(),
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        child: Semantics(
                                          child: Text(
                                            snapshot.data.data()['name'],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 24.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  ClipOval(
                                    child: Image(
                                      image: NetworkImage(
                                          snapshot.data.data()['channel_link']),
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Text(
                                          "Created by: ${snapshot.data.data()['created_by']}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Text(
                                          "Created on: ${readTimestamp(snapshot.data.data()['created_on'])}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("Feeds")
                                .where("channel_ID", isEqualTo: widget.Channel)
                                .orderBy("creation_date", descending: true)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshotx) {
                              if (snapshotx.hasError)
                                return new Text('Error: ${snapshotx.error}');
                              switch (snapshotx.connectionState) {
                                case ConnectionState.waiting:
                                  return Text('Loading...');
                                default:
                                  return snapshotx.data.docs.isNotEmpty
                                      ? ListView(
                                          children: <Widget>[
                                            ...snapshotx.data.docs.map(
                                                (DocumentSnapshot document) {
                                              return Posts(
                                                Docid: widget.Docid,
                                                recordFeed: document,
                                              );
                                            }),
                                          ],
                                        )
                                      : Text('no posts');
                              }
                            })
                      ],
                    ),
                  ),
                  Positioned(
                      top: topPosition,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 80,
                        padding: const EdgeInsets.only(
                            left: 50, top: 25.0, right: 20.0),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(30.0)),
                          color: Colors.white.withOpacity(_getOpacity()),
                        ),
                        child: DefaultTextStyle(
                          style: TextStyle(),
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          child: Semantics(
                            child: Text(
                              snapshot.data.data()['name'],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            header: true,
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 80,
                    child: AppBar(
                      iconTheme: IconThemeData(color: Colors.black),
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                    ),
                  )
                ],
              ),
            );
          }
        });
  }
}
