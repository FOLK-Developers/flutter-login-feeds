import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:folk/SharedWidgets/RecordFeed.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class CommentPage extends StatefulWidget {
  CommentPage({@required this.recordFeed});
  final recordFeed;

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    setState(() {
      _getCommentStream();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Comments'),
          backgroundColor: Color(0xFFF57F17),
        ),
        body: _commentBody(context));
  }

  Widget _commentBody(BuildContext context) {
    final recordFeed = widget.recordFeed;
    var width = MediaQuery.of(context).size.width;
    int time = recordFeed.data()['creation_date'];
    final df = new DateFormat('dd-MM-yyyy hh:mm a');
    String creationDate =
        df.format(DateTime.fromMillisecondsSinceEpoch(time * 1000));
    return Container(
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
          child: Column(
            children: [
              Column(
                children: [
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 15, bottom: 15),
                      ),
                      ClipOval(
                        child: Image(
                          image: NetworkImage(
                              recordFeed.data()['channel_image_url']),
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        width: width * 0.05,
                        padding: EdgeInsets.only(left: 20),
                      ),
                      Column(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 15),
                              ),
                              Text(
                                recordFeed.data()['channel_name'],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.start,
                              )
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10),
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 15),
                              ),
                              Text(creationDate,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600)),
                              Text(' by ',
                                  style: TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w600)),
                              Text(recordFeed.data()['feed_by'],
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Text(
                                      recordFeed.data()['feed_title'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  Text(recordFeed.data()['feed_text'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 2.0,
                    color: Color(0xFFF57F17),
                  ),
                ],
              ),
              Flexible(child: checkIfExists(context)),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      new Theme(
                        data: new ThemeData(
                          primaryColor: Color(0xFFF57F17),
                          primaryColorDark: Color(0xFFF57F17),
                        ),
                        child: new TextField(
                          controller: commentController,
                          keyboardType: TextInputType.multiline,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w300),
                          cursorColor: Color(0xFFF57F17),
                          cursorRadius: Radius.elliptical(40, 40),
                          cursorWidth: 5.0,
                          decoration: InputDecoration(
                              hintText: "Write  a comment..",
                              hintStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(0xFFF57F17), width: 0.0),
                              ),
                              border: OutlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: Color(0xFFF57F17), width: 0.0)),
                              labelText: 'Comment',
                              suffixIcon: IconButton(
                                  onPressed: () async {
                                    var firestore = FirebaseFirestore.instance;
                                    RecordFeed recordFeed = widget.recordFeed;
                                    var docID = recordFeed.reference.id;

                                    //THIS STRING NAME CAN BE REPLACED WITH THR CURRENT USER NAME
                                    String name = 'DEFAULT NAME';
                                    String comment = commentController.text;
                                    String finalComment;

                                    if (comment.isEmpty) {
                                      return Toast.show(
                                          'Please enter comment', context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.CENTER);
                                    } else {
                                      finalComment = commentController.text;
                                      recordFeed.reference.update({
                                        'comment_count': FieldValue.increment(1)
                                      });

                                      //HERE YOU CAN ADD THE
                                      //COMMENTATOR_NAME AS PER THE USER NAME
                                      //AND ALSO ADD FEED_ID AND USER DOC ID
                                      //JUST PASS THE DATA AND MENTION IN BELOW QUERY

                                      FirebaseFirestore.instance
                                          .runTransaction((transaction) async {
                                        await transaction.set(
                                            FirebaseFirestore.instance
                                                .collection('Feeds')
                                                .doc(docID)
                                                .collection('Comments')
                                                .doc(),
                                            {
                                              'commentator_name': name,
                                              'comment_timestamp': DateTime
                                                          .now()
                                                      .millisecondsSinceEpoch ~/
                                                  1000,
                                              'comment': finalComment,
                                            });
                                      });

                                      /*firestore
                                          .collection('Feeds')
                                          .document(docID)
                                          .collection('Comments')
                                          .add({
                                        'commentator_name': name,
                                        'comment_timestamp': DateTime.now()
                                                .millisecondsSinceEpoch ~/
                                            1000,
                                        'comment': finalComment,
                                      });*/

                                      Toast.show('Comment Posted', context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.CENTER);
                                      commentController.clear();
                                    }
                                  },
                                  icon: Icon(
                                    Icons.send,
                                    size: 40,
                                    color: Color(0xFFF57F17),
                                  ))),
                        ),
                      ),
                    ],
                  )),
            ],
          )),
    );
  }

  //CHECKS FOR COMMENTS COUNT
  checkIfExists(BuildContext context) {
    final recordFeed = widget.recordFeed;
    int commentCount = recordFeed.data()['comment_count'];

    if (commentCount == 0) {
      return Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('No Comments yet, be the first on to Comment !'),
        ],
      ));
    } else {
      return _buildCommentBody(context);
    }
  }

  Stream _getCommentStream() {
    var firestore = FirebaseFirestore.instance;
    final recordFeed = widget.recordFeed;
    var docID = recordFeed.documentID;

    var qs = firestore
        .collection('Feeds')
        .doc(docID)
        .collection('Comments')
        .snapshots();

    print(qs);

    return qs;
  }

  Widget _buildCommentBody(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _getCommentStream(),
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
    int commentTimestamp = recordFeed.comment_timestamp;

    final df = new DateFormat('dd-MM-yyyy hh:mm a');
    String commentTime =
        df.format(DateTime.fromMillisecondsSinceEpoch(commentTimestamp * 1000));
    String name = recordFeed.commentator_name;
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
                              Text(commentTime,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Column(
                          children: [
                            Text(recordFeed.comment,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ))
                          ],
                        ),
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
