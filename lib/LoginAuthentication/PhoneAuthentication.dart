import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:folk/Language/Localization/localizations.dart';
import 'package:folk/LoginAuthentication/UserData.dart';
import 'package:folk/Services/LocaleHelper.dart';
import 'package:folk/SharedWidgets/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhoneVerification extends StatefulWidget {
  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  final Constants constants = new Constants();
  var dropdownValue = 'India';
  final _formKey = GlobalKey<FormState>();
  var languagevalue = 'English';
  TextEditingController prefix = TextEditingController(text: '+91');
  TextEditingController number = new TextEditingController();
  TextEditingController Code = TextEditingController();

  Future<bool> loginUser(BuildContext context) async {
    String phone = prefix.text + number.text;
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          var result = await _auth.signInWithCredential(credential);
          User user = result.user;
          if (user != null) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool('Login', true);
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UserData(
                  user: user,
                ),
              ),
            );
          }
        },
        verificationFailed: (e) {
          print(e);
        },
        codeSent: (String verificationId, [int forceResendToken]) async {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                Widget area = Scaffold(
                  appBar: AppBar(
                    title:
                        Text(AppLocalizations.of(context).Verify + ' $phone'),
                    elevation: 0,
                  ),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 30,
                          ),
                          Center(
                            child: Text(
                              AppLocalizations.of(context).Verify2 +
                                  ' $phone .',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            width: 70,
                            child: TextField(
                              controller: Code,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                fillColor: Colors.blue,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              AppLocalizations.of(context).sixDigit,
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            width: 130,
                            child: FlatButton(
                              child: Text(AppLocalizations.of(context).confirm),
                              textColor: Colors.white,
                              color: Colors.blue,
                              onPressed: () async {
                                final code = Code.text.trim();
                                AuthCredential credential =
                                    PhoneAuthProvider.credential(
                                        verificationId: verificationId,
                                        smsCode: code);
                                var result = await _auth
                                    .signInWithCredential(credential);
                                User user = result.user;
                                if (user != null) {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setBool('Login', true);
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UserData(
                                                user: user,
                                              )));
                                } else {
                                  print("Error");
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
                return area;
              });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
          print('Auto retrival time-out');
        });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            AppLocalizations.of(context).Phone_number,
            style: TextStyle(fontSize: 20, letterSpacing: -1),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: Text(
                AppLocalizations.of(context).send_sms,
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            DropdownButton<String>(
              value: dropdownValue,
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.blue,
              ),
              iconSize: 24,
              elevation: 16,
              underline: Container(
                height: 2,
                color: Colors.blue,
              ),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                  prefix.text =
                      '+' + constants.countryCodes[newValue].toString();
                });
              },
              selectedItemBuilder: (BuildContext context) {
                return constants.country.map<Widget>((String item) {
                  return Container(
                      alignment: Alignment.center,
                      width: 220,
                      child: Text(item, textAlign: TextAlign.center));
                }).toList();
              },
              items: constants.country
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Form(
              key: _formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 70,
                    child: TextFormField(
                      cursorColor: Colors.blue,
                      controller: prefix,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 160,
                    child: TextFormField(
                      controller: number,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context).Phone,
                        fillColor: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 150,
                  child: FlatButton(
                    color: Colors.blue,
                    onPressed: () {
                      return showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              insetPadding:
                                  EdgeInsets.symmetric(horizontal: 20),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              title: Text(
                                AppLocalizations.of(context).verifyPhone1 +
                                    '\n\n ${prefix.text + ' ' + number.text}\n\n' +
                                    AppLocalizations.of(context).verifyPhone2,
                                style: TextStyle(fontSize: 12.0),
                              ),
                              actions: <Widget>[
                                Row(
                                  children: <Widget>[
                                    FlatButton(
                                      child: Text(
                                        AppLocalizations.of(context).edit,
                                        style: TextStyle(fontSize: 10.0),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    FlatButton(
                                      child: Text(
                                        AppLocalizations.of(context).ok,
                                        style: TextStyle(fontSize: 10.0),
                                      ),
                                      onPressed: () {
                                        Code.text = '';
                                        loginUser(context);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            );
                          });
                    },
                    child: Text(
                      AppLocalizations.of(context).Verify,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: RawMaterialButton(
        onPressed: () {
          return showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return AlertDialog(
                  insetPadding: EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  title: Text(
                    AppLocalizations.of(context).OptionC,
                  ),
                  content: DropdownButton<String>(
                    value: languagevalue,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.blue,
                    ),
                    iconSize: 24,
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: Colors.blue,
                    ),
                    onChanged: (String newValue) async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      setState(() {
                        languagevalue = newValue;
                        prefs.setString(
                            'Language', constants.langCode[languagevalue]);
                        helper.onLocaleChanged(
                            Locale(constants.langCode[languagevalue]));
                        Navigator.of(context).pop();
                      });
                    },
                    selectedItemBuilder: (BuildContext context) {
                      return constants.langList.map<Widget>((String item) {
                        return Container(
                            alignment: Alignment.center,
                            width: 220,
                            child: Text(item, textAlign: TextAlign.center));
                      }).toList();
                    },
                    items: constants.langList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  actions: <Widget>[],
                );
              });
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                AppLocalizations.of(context).language,
              ),
              Icon(
                Icons.language,
              )
            ],
          ),
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        constraints: BoxConstraints(minHeight: 50.0, maxWidth: 150.0),
      ),
    );
  }
}
