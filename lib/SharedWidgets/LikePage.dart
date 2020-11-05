import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:folk/SharedWidgets/RecordFeed.dart';
import 'package:intl/intl.dart';

class LikePage extends StatefulWidget {
  LikePage({@required this.recordFeed});
  final recordFeed;
  @override
  _LikePageState createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Likes'),
        backgroundColor: Color(0xFFF57F17),
      ),
      body: _likeBody(context),
    );
  }

  Widget _likeBody(BuildContext context) {
    final recordFeed = widget.recordFeed;
    var width = MediaQuery.of(context).size.width;
    return Container(
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'This post is liked by',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              Divider(
                thickness: 2.0,
                color: Color(0xFFF57F17),
              ),
              Flexible(
                child: checkIfExists(context),
              ),
            ],
          )),
    );
  }

  //CHECKS IF LIKES EXIST OR NOT
  checkIfExists(BuildContext context) {
    final recordFeed = widget.recordFeed;
    int likeCount = recordFeed.data()['like_count'];

    if (likeCount == 0) {
      return Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('No Likes yet, be the first on to like !'),
        ],
      ));
    } else {
      return _buildLikeBody(context);
    }
  }

  Stream _getStream() {
    var firestore = FirebaseFirestore.instance;
    final recordFeed = widget.recordFeed;
    var docID = recordFeed.documentID;

    var qs = firestore
        .collection('Feeds')
        .doc(docID)
        .collection('Likes')
        .snapshots();

    print(qs);

    return qs;
  }

  Widget _buildLikeBody(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _getStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFFF57F17)))
              ],
            );
          } else {
            return _buildCommentList(context, snapshot.data.docs);
          }
        },
      ),
    );
  }

  Widget _buildCommentList(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    return Container(
      child: ListView(
        children:
            (snapshot.map((data) => _buildListItem(context, data)).toList()),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final recordFeed = RecordFeed.fromSnapshot(data);
    int likeTimestamp = recordFeed.like_feed_timestamp;
    final df = new DateFormat('dd-MM-yyyy hh:mm a');
    String likeTime =
        df.format(DateTime.fromMillisecondsSinceEpoch(likeTimestamp * 1000));

    String name = recordFeed.name;
    return Container(
      child: Column(
        children: [
          ListBody(
            children: [
              Column(
                children: [
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 10, bottom: 0),
                      ),
                      ClipOval(
                        child: Image(
                          image: NetworkImage(
                              'https://www.pngitem.com/pimgs/m/146-1468843_profile-icon-orange-png-transparent-png.png'),
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 19),
                              ),
                              Text(
                                name,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5),
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 5),
                              ),
                              Text(' at ',
                                  style: TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w600)),
                              Text(likeTime,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 0.5,
                    color: Color(0xFFF57F17),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
