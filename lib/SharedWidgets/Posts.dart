import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:folk/Services/DynamicLinkService.dart';
import 'package:folk/SharedWidgets/CommentPage.dart';
import 'package:folk/SharedWidgets/LikePage.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Posts extends StatefulWidget {
  Posts({@required this.recordFeed, @required this.Docid});
  final recordFeed;
  final Docid;
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  DynamicLinkService _dls = DynamicLinkService();
  YoutubePlayerController _controller;

  @override
  Widget build(BuildContext context) {
    int time = widget.recordFeed.data()['creation_date'];
    final df = new DateFormat('dd-MM-yyyy hh:mm a');
    String creationDate =
        df.format(DateTime.fromMillisecondsSinceEpoch(time * 1000));
    return Material(
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 5, bottom: 15),
                  ),
                  ClipOval(
                    child: Image(
                      image: NetworkImage(
                          widget.recordFeed.data()['channel_image_url']),
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    // width: width * 0.05,
                    padding: EdgeInsets.only(left: 0),
                  ),
                  Column(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 5),
                          ),
                          Text(
                            widget.recordFeed.data()['channel_name'],
                            style: /*TextStyle*/ TextStyle(
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
                            padding: EdgeInsets.only(right: 5),
                          ),
                          Text(creationDate,
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w600)),
                          Text(' by ',
                              style: TextStyle(
                                  fontSize: 8, fontWeight: FontWeight.w600)),
                          Text(widget.recordFeed.data()['feed_by'],
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w600)),
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
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Container(child: setContent(widget.recordFeed)),
                      ],
                    ),
                  ),
                ],
              ),
              ifLinkExist(widget.recordFeed),
              Divider(
                thickness: 2.0,
                color: Color(0xFFF57F17),
              ),
            ],
          )),
    );
  }

  onShareButtonPressed(BuildContext context, recordFeed) async {
    if (await Permission.storage.request().isGranted) {
      String temp = recordFeed.id;
      String link = await _dls.createLink(temp);
      print('link : $link');
      var post = recordFeed.data()['feed_image_url'];
      var title = recordFeed.data()['feed_title'];
      var text = recordFeed.data()['feed_text'];
      String feedTitle = recordFeed.data()['feed_title'];
      _onLoading(true);
      print(post);
      // var responce = await http.get(post,);
      // print(responce.statusCode.toString());
      _onLoading(false);

      //Getting the image from network
      var response = await Dio()
          .get(post, options: Options(responseType: ResponseType.bytes));

      //Storing the image on device.
      final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
      );
      print('result : $result');
      String BASE64_IMAGE = result;
      await Share.shareFiles([BASE64_IMAGE.split(':/')[1]],
          subject: title + '\n' + text,
          text: "Join us through the below link \n\n" + link);
    }
  }

  void _onLoading(bool t) {
    if (t) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return SimpleDialog(
              children: <Widget>[
                new CircularProgressIndicator(),
                new Text('Downloading'),
              ],
            );
          });
    } else {
      Navigator.of(context).pop();
    }
  }

  //CHECKS IF THE FEED_LINK EXISTS AND FEED TYPE
  ifLinkExist(recordFeed) {
    String linkCheck = recordFeed.data()['feed_link'];
    int feedType = recordFeed.data()['feed_type'];

    if (feedType == 0) {
      if (linkCheck == 'null') {
        //THIS WILL BE RETURNED WHEN FEED_LINK FOR THE POST WITH TYPE 0 DOES NOT EXIST
        return Container(
            padding: EdgeInsets.only(top: 5),
            child: Column(
              children: [
                //FEED TITLE AND FEED TEXT
                columnForFeedTitleAndFeedText(recordFeed),

                //ROW OF ICONS FOR LIKE SHARE AND COMMENT
                rowOfLikeCommentAndShareIcons(recordFeed),
              ],
            ));
      } else {
        //THIS WILL BE RETURNED WHEN FEED_LINK FOR THE POST WITH TYPE 0 EXIST
        return Container(
            padding: EdgeInsets.only(top: 5),
            child: Column(
              children: [
                //FEED TITLE AND FEED TEXT
                columnForFeedTitleAndFeedText(recordFeed),

                //GOTO LINK BUTTON
                goToLinkButton(recordFeed),

                //ROW OF ICONS FOR LIKE SHARE AND COMMENT
                rowOfLikeCommentAndShareIcons(recordFeed),
              ],
            ));
      }
    } else {
      if (linkCheck == 'null') {
        // var height = MediaQuery.of(context).size.height;
        // var width = MediaQuery.of(context).size.width;

        //THIS WILL BE RETURNED WHEN FEED_LINK FOR THE POST WITH TYPE 1,2 AND 3 DOES NOT EXIST
        return Container(
            padding: EdgeInsets.only(top: 5),
            child: Column(
              children: [
                //ROW OF ICONS FOR LIKE, SHARE AND COMMENT
                rowOfLikeCommentAndShareIcons(recordFeed),
                //FEED TITLE AND FEED TEXT
                columnForFeedTitleAndFeedText(recordFeed),
              ],
            ));
      } else {
        // var height = MediaQuery.of(context).size.height;
        // var width = MediaQuery.of(context).size.width;

        //THIS WILL BE RETURNED WHEN FEED_LINK FOR THE POST WITH TYPE 1,2 AND 3 EXIST
        return Container(
          child: Column(
            children: [
              //GO TO LINK BUTTON
              goToLinkButton(recordFeed),

              //ICONS FOR LIKE, COMMENT AND SHARE
              rowOfLikeCommentAndShareIcons(recordFeed),

              //FEED TITLE AND FEED TEXT
              columnForFeedTitleAndFeedText(recordFeed),
            ],
          ),
        );
      }
    }
  }

  //THIS METHOD RETURNS THE ROW OF LIKE, COMMENT AND SHARE ICON BUTTONS WITH THEIR ACTIONS
  rowOfLikeCommentAndShareIcons(recordFeed) {
    int likes = recordFeed.data()['like_count'];
    String likeCount = likes.toString();
    int comments = recordFeed.data()['comment_count'];
    String commentsCount = comments.toString();
    return FutureBuilder<Object>(
        future: Check(recordFeed),
        builder: (context, snapshot) {
          return Container(
            padding: EdgeInsets.only(top: 5),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                ),
                InkWell(
                  child: IconButton(
                    icon: Icon(
                      Icons.thumb_up,
                      size: 30,
                      color: snapshot.data == 0 ? Colors.black : Colors.blue,
                    ),
                    onPressed: () {
                      addLikeCountAndDocument(recordFeed);
                    },
                  ),
                  onDoubleTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LikePage(
                                  recordFeed: recordFeed,
                                )));
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                ),
                Text(likeCount,
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                ),
                IconButton(
                  icon: Icon(
                    Icons.comment,
                    size: 30,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CommentPage(
                                  recordFeed: recordFeed,
                                )));
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15, top: 10),
                ),
                Text(commentsCount,
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                ),
                IconButton(
                  icon: Icon(
                    Icons.share,
                    size: 30,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    onShareButtonPressed(context, recordFeed);
                    /*return showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                        });*/
                  },
                ),
              ],
            ),
          );
        });
  }

  //THIS METHOD RETURNS FEED TITLE AND FEED TEXT
  columnForFeedTitleAndFeedText(recordFeed) {
    String feedTitle = recordFeed.data()['feed_title'];
    String feedText = recordFeed.data()['feed_text'];

    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    feedTitle,
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
                Text(feedText,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  //check
  Check(recordFeed) async {
    var check = await FirebaseFirestore.instance
        .collection('Profile')
        .doc(widget.Docid)
        .collection('FeedLikes')
        .where('like_feed_documentId', isEqualTo: recordFeed.id)
        .get();
    return check.docs.length;
  }

  //THIS METHOD RETURNS THE GOTO LINK BUTTON TO OPEN FEED LINK
  goToLinkButton(recordFeed) {
    return Container(
      child: InkWell(
        child: Container(
          height: 35,
          decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [Color(0xFFffce45), Color(0xFFffce45)]),
            borderRadius: BorderRadius.circular(0.0),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                //REDIRECTING TO THE METHOD WHICH OPENS FEED LINK
                openFeedLink(recordFeed);
              },
              child: Center(
                  child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 75),
                  ),
                  Center(
                    child: Text("GO TO LINK",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.black,
                  ),
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }

  //ON SINGLE TAP OF LIKE BUTTON, LIKE WILL BE ADDED TO THE DOCUMENT
  Future addLikeCountAndDocument(recordFeed) async {
    // final recordFeedy = RecordFeed.fromSnapshot(recordFeed);
    var docID = recordFeed.id;
    var user = await FirebaseFirestore.instance
        .collection('Profile')
        .doc(widget.Docid)
        .get();
    if (await Check(recordFeed) == 0) {
      await FirebaseFirestore.instance
          .collection('Profile')
          .doc(widget.Docid)
          .collection('FeedLikes')
          .add({
        'like_feed_timestamp': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'like_feed_documentId': docID,
        'user_id': user.data()['author']
      });
      await FirebaseFirestore.instance
          .collection('Feeds')
          .doc(docID)
          .update({'like_count': FieldValue.increment(1)});
    } else {
      print(await Check(recordFeed));
      var temp = await FirebaseFirestore.instance
          .collection('Profile')
          .doc(widget.Docid)
          .collection('FeedLikes')
          .where('like_feed_documentId', isEqualTo: docID)
          .get();
      await FirebaseFirestore.instance
          .collection('Profile')
          .doc(widget.Docid)
          .collection('FeedLikes')
          .doc(temp.docs.first.id)
          .delete();
      await FirebaseFirestore.instance
          .collection('Feeds')
          .doc(docID)
          .update({'like_count': FieldValue.increment(-1)});
    }
  }

  //THIS METHOD LAUNCHES FEED LINK
  openFeedLink(recordFeed) async {
    String url = recordFeed.data['feed_link'];
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Toast.show('Could not launch URL', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  //SETS UP THE URL TO THE FEED ITEMS OF TYPE 1, 2 AND 3
  setContent(recordFeed) {
    // var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;
    String feedUrl = recordFeed.data()['feed_image_url'];
    int feedType = recordFeed.data()['feed_type'];
    String audioURL = feedUrl;
    String kHtml = '''$audioURL ''';

    _controller = YoutubePlayerController(
      initialVideoId: feedUrl,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    switch (feedType) {
      case 0:
        break;
      case 1:
        if (feedUrl != null) {
          return Image(
            image: NetworkImage(feedUrl),
          );
        } else {
          return Container();
        }
        break;
      case 2:
        return Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: HtmlWidget(
              kHtml,
              webView: true,
            ),
          ),
        );
        break;
      case 3:
        return Container(
          child: Column(
            children: <Widget>[
              YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
              ),
            ],
          ),
        );
        break;
    }
  }
}
