import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:folk/Channels/ChannelPage.dart';

class ChannelList extends StatefulWidget {
  var userid;
  ChannelList({this.userid});
  @override
  _ChannelListState createState() => _ChannelListState();
}

class _ChannelListState extends State<ChannelList> {
  List<DocumentSnapshot> _Channels = [];
  bool _loadingChannels = true;
  DocumentSnapshot snapshot;
  ScrollController _scrollController = ScrollController();
  _getChannels() async {
    Query q = FirebaseFirestore.instance
        .collection("Channel")
        .orderBy("created_on", descending: true);
    setState(() {
      _loadingChannels = true;
    });
    QuerySnapshot querySnapshot = await q.get();
    _Channels = querySnapshot.docs;
    setState(() {
      _loadingChannels = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getChannels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Channel'),
          backgroundColor: Colors.blue,
        ),
        body: _buildChannelView(context));
  }

  Widget _buildChannelView(BuildContext context) {
    return _loadingChannels == true
        ? Container(child: Center(child: CircularProgressIndicator()))
        : Container(
            child: _Channels.length == 0
                ? Center(
                    child: Text("No Channels to show"),
                  )
                : ListView.builder(
                    itemCount: _Channels.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListBody(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 8.0),
                            child: Material(
                              child: RaisedButton(
                                color: Colors.grey[200],
                                elevation: 2.0,
                                onPressed: () {
                                  WidgetsFlutterBinding.ensureInitialized();
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return FancyAppbarAnimation(
                                      Channel: _Channels[index].id,
                                      ChannelImage: _Channels[index]
                                          .data()['channel_link'],
                                      Docid: widget.userid,
                                    );
                                  }));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: 5, bottom: 15),
                                            ),
                                            ClipOval(
                                              child: Image(
                                                image: NetworkImage(
                                                    _Channels[index].data()[
                                                        'channel_link']),
                                                width: 60,
                                                height: 60,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(right: 5),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      140,
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: DefaultTextStyle(
                                                      style: TextStyle(),
                                                      softWrap: false,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      child: Semantics(
                                                        child: Text(
                                                          _Channels[index].data()[
                                                                      'name'] !=
                                                                  null
                                                              ? _Channels[index]
                                                                      .data()[
                                                                  'name']
                                                              : "Name doesn't exist",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }));
  }
}
