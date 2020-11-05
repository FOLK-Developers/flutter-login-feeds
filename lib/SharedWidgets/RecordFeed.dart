import 'package:cloud_firestore/cloud_firestore.dart';

class RecordFeed {
  String channel_image_url;
  String channel_name;
  int comment_count;
  int creation_date;
  String feed_by;
  String feed_image_url;
  String feed_link;
  String feed_text;
  String feed_title;
  int feed_type;
  int like_count;
  String commentator_name;
  String comment;
  String feed_id;
  int comment_timestamp;
  String name;
  int like_feed_timestamp;
  DocumentReference reference;

  RecordFeed.fromMap(Map<String, dynamic> map, {this.reference}) {
    this.channel_image_url = map['channel_image_url'];
    this.channel_name = map['channel_name'];
    this.comment_count = map['comment_count'];
    this.creation_date = map['creation_date'];
    this.feed_by = map['feed_by'];
    this.feed_image_url = map['feed_image_url'];
    this.feed_link = map['feed_link'];
    this.feed_text = map['feed_text'];
    this.feed_title = map['feed_title'];
    this.feed_type = map['feed_type'];
    this.like_count = map['like_count'];
    this.commentator_name = map['commentator_name'];
    this.comment = map['comment'];
    this.comment_timestamp = map['comment_timestamp'];
    this.name = map['name'];
    this.like_feed_timestamp = map['like_feed_timestamp'];
  }

  RecordFeed.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  RecordFeed(
      {this.channel_image_url,
      this.channel_name,
      this.comment_count,
      this.creation_date,
      this.feed_by,
      this.feed_image_url,
      this.feed_link,
      this.feed_text,
      this.feed_type,
      this.feed_title,
      this.like_count,
      this.commentator_name,
      this.comment,
      this.comment_timestamp,
      this.name,
      this.like_feed_timestamp});
}
