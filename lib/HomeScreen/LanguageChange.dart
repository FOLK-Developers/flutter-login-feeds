import 'package:flutter/material.dart';
import 'package:folk/Language/Localization/localizations.dart';
import 'package:folk/Services/LocaleHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageChange extends StatefulWidget {
  @override
  _LanguageChangeState createState() => _LanguageChangeState();
}

class _LanguageChangeState extends State<LanguageChange> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          AppLocalizations.of(context).OptionC,
          style: TextStyle(fontSize: 20, letterSpacing: -1),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('Language', 'en');
                      helper.onLocaleChanged(Locale('en'));
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[200].withOpacity(0.8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue[200].withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(5),
                      child: SizedBox(
                        height: 100,
                        width: 140,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'English',
                              textScaleFactor: 2.5,
                              style: TextStyle(color: Colors.blue[700]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('Language', 'hi');
                      Navigator.of(context).pop();
                      helper.onLocaleChanged(Locale('hi'));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[100].withOpacity(0.8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue[100].withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(5),
                      child: SizedBox(
                        height: 100,
                        width: 140,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'हिन्दी',
                              textScaleFactor: 2.5,
                              style: TextStyle(color: Colors.blue[700]),
                            ),
                            Text(
                              'Hindi',
                              style: TextStyle(color: Colors.blue[700]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('Language', 'tm');
                      Navigator.of(context).pop();
                      helper.onLocaleChanged(Locale('tm'));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.purple[100].withOpacity(0.8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purple[100].withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(5),
                      child: SizedBox(
                        height: 100,
                        width: 140,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'தமிழ்',
                              textScaleFactor: 2.5,
                              style: TextStyle(color: Colors.purple[700]),
                            ),
                            Text(
                              'Tamil',
                              style: TextStyle(color: Colors.purple[700]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('Language', 'tl');
                      Navigator.of(context).pop();
                      helper.onLocaleChanged(Locale('tl'));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.orange[200].withOpacity(0.8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange[200].withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(5),
                      child: SizedBox(
                        height: 100,
                        width: 140,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'తెలుగు',
                              textScaleFactor: 2.5,
                              style: TextStyle(color: Colors.orange[700]),
                            ),
                            Text(
                              'Telugu',
                              style: TextStyle(color: Colors.orange[700]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),

      /* SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: new Text("English"),
                color: AppLocalizations.of(context).locale != "en"
                    ? Colors.transparent
                    : Colors.blue,
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('Language', 'en');
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SplashScreen()));
                },
              ),
              FlatButton(
                child: Text("हिन्दी"),
                color: AppLocalizations.of(context).locale != "hi"
                    ? Colors.transparent
                    : Colors.blue,
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('Language', "hi");
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SplashScreen()));
                },
              ),
              FlatButton(
                child: Text("తెలుగు"),
                color: AppLocalizations.of(context).locale != "tl"
                    ? Colors.transparent
                    : Colors.blue,
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('Language', "tl");
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SplashScreen()));
                },
              )
            ],
          ),
        ),
      ),*/
    );
  }
}
