import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:folk/Services/DynamicLinkService.dart';
import 'package:folk/SharedWidgets/Posts.dart';
import 'package:intl/intl.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
  YoutubePlayerController _controller;
  List<DocumentSnapshot> _posts = [];
  bool _loadingPosts = true;
  bool _gettingMorePosts = false;
  bool _morePostsAvailable = true;
  DocumentSnapshot snapshot;
  DynamicLinkService _dls = DynamicLinkService();
  ScrollController _scrollController = ScrollController();
  DocumentSnapshot _lastDocument;
  int _per_page = 12;

  _getPosts() async {
    Query q = FirebaseFirestore.instance
        .collection("Feeds")
        .orderBy("creation_date", descending: true)
        .limit(_per_page);
    setState(() {
      _loadingPosts = true;
    });
    QuerySnapshot querySnapshot = await q.get();
    _posts = querySnapshot.docs;
    _lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    setState(() {
      _loadingPosts = false;
    });
  }

  _getMorePosts() async {
    if (_morePostsAvailable == false) {
      print('no more posts');
      return;
    }
    if (_gettingMorePosts == true) {
      return;
    }
    _gettingMorePosts = true;
    Query q = FirebaseFirestore.instance
        .collection("Feeds")
        .orderBy("creation_date", descending: true)
        .startAfter([_lastDocument.data()['creation_date']]).limit(_per_page);
    QuerySnapshot querySnapshot = await q.get();
    if (querySnapshot.docs.length < _per_page) {
      _morePostsAvailable = false;
    }
    _lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    _posts.addAll(querySnapshot.docs);
    setState(() {});
    _gettingMorePosts = false;
  }

  animateToIndex(i) {
    _scrollController.animateTo(
      100.0 * i,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void initState() {
    topPosition = -80;
    appBarBackground = Colors.transparent;
    super.initState();
    _scrollController.addListener(_onScroll);
    _getPosts();
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
    return Scaffold(
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
                  return Text('Loading...');
                default:
                  return Stack(
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 16.0, right: 50),
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
                                            MediaQuery.of(context).size.width -
                                                100,
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                          image: NetworkImage(snapshot.data
                                              .data()['channel_link']),
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
                                              "Created on: ${creationDate.split(' ')[0]}",
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
                            _loadingPosts == true
                                ? Container(
                                    child: Center(child: Text('loading..')))
                                : _posts.length == 0
                                    ? Center(
                                        child: Text("No posts to show"),
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        controller: _scrollController,
                                        itemCount: _posts.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          int time = _posts[index]
                                              .data()['creation_date'];
                                          final df = new DateFormat(
                                              'dd-MM-yyyy hh:mm a');
                                          String creationDate = df.format(
                                              DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      time * 1000));
                                          return Posts(
                                            Docid: widget.Docid,
                                            recordFeed: _posts[index],
                                          );
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
    );
  }
}
