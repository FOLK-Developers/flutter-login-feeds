import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:folk/Services/DynamicLinkService.dart';
import 'package:folk/SharedWidgets/Posts.dart';
import 'package:intl/intl.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FeedMainPage extends StatefulWidget {
  int id;
  String Docid;
  FeedMainPage({this.Docid, this.id});
  @override
  _FeedMainPageState createState() => _FeedMainPageState();
}

class _FeedMainPageState extends State<FeedMainPage> {
  YoutubePlayerController _controller;
  List<DocumentSnapshot> _posts = [];
  bool _loadingPosts = true;
  bool _gettingMorePosts = false;
  bool _morePostsAvailable = true;
  DocumentSnapshot snapshot;
  DynamicLinkService _dls = DynamicLinkService();
  ScrollController _scrollController = ScrollController();
  int _per_page = 12;
  DocumentSnapshot _lastDocument;

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
    super.initState();
    _getPosts();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;
      if (maxScroll - currentScroll <= delta) {
        _getMorePosts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Feeds '),
          backgroundColor: Colors.blue,
        ),
        body: _buildListView(context));
  }

  //BUILDING FEED LIST VIEW
  Widget _buildListView(BuildContext context) {
    return _loadingPosts == true
        ? Container(child: Center(child: CircularProgressIndicator()))
        : Container(
            child: _posts.length == 0
                ? Center(
                    child: Text("No posts to show"),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _posts.length,
                    itemBuilder: (BuildContext context, int index) {
                      int time = _posts[index].data()['creation_date'];
                      final df = new DateFormat('dd-MM-yyyy hh:mm a');
                      String creationDate = df.format(
                          DateTime.fromMillisecondsSinceEpoch(time * 1000));
                      return Posts(
                        Docid: widget.Docid,
                        recordFeed: _posts[index],
                      );
                    }),
          );
  }
}
