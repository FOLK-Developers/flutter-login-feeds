import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:folk/Language/Localization/localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class ConnectScreen extends StatefulWidget {
  @override
  _ConnectScreenState createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Opacity(
          opacity: 0.70,
          child: Text(
            AppLocalizations.of(context).OptionB,
            style: TextStyle(
              fontFamily: 'NixieOne',
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Connect').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Text('Loading...');
              default:
                if (snapshot.data.docs.length != 0) {
                  return Column(
                    children: <Widget>[
                      ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children:
                            snapshot.data.docs.map((DocumentSnapshot document) {
                          return Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(),
                                image: DecorationImage(
                                  image: NetworkImage(document.data()[''],
                                      scale: 2),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              height: 300,
                              child: Opacity(
                                opacity: 0.70,
                                child: Card(
                                  semanticContainer: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 5,
                                  margin: EdgeInsets.all(10),
                                  shadowColor: Colors.blue[300],
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5.0, vertical: 7.0),
                                    child: ListTile(
                                      title: Text(
                                        document.data()['Title'],
                                        style: TextStyle(
                                          fontSize: 21.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'NixieOne',
                                        ),
                                      ),
                                      subtitle: Opacity(
                                        opacity: 0.70,
                                        child: Text(
                                          document.data()['Body'],
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'NixieOne',
                                          ),
                                        ),
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(Icons.arrow_forward),
                                        onPressed: () async {
                                          if (await canLaunch(
                                              document.data()['url'])) {
                                            await launch(
                                                document.data()['url']);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  );
                } else {
                  return Center(
                    heightFactor: 10.0,
                    child: Opacity(
                      opacity: 0.50,
                      child: Text(
                        AppLocalizations.of(context).locale == "en"
                            ? 'Nothing yet'
                            : 'अभी तक कुछ नही',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NixieOne',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                }
            }
          },
        ),
      ),
    );
  }
}
