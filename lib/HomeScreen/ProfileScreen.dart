import 'dart:io';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:folk/HomeScreen/ConnectScreen.dart';
import 'package:folk/HomeScreen/LanguageChange.dart';
import 'package:folk/HomeScreen/Userinfo.dart';
import 'package:folk/Language/Localization/localizations.dart';
import 'package:folk/LoginAuthentication/SplashScreen.dart';
import 'package:folk/SharedWidgets/Constants.dart';
import 'package:folk/SharedWidgets/ProfileListItem.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  var docId;
  var prefs;
  ProfileScreen({this.docId, this.prefs});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future data;
  String update;
  String url;
  File _image;

  Future<String> getVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future getImage(BuildContext context) async {
    var image = await ImagePickerSaver.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      print('Image Path $_image');
    });
    String fileName = basename(_image.path);
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = firebaseStorageRef.putFile(_image);
    TaskSnapshot taskSnapshot =
        await uploadTask.whenComplete(() => setState(() {
              print("Profile Picture uploaded");
            }));
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          actions: <Widget>[
            ThemeSwitcher(
              builder: (context) {
                return AnimatedCrossFade(
                  duration: Duration(milliseconds: 200),
                  crossFadeState:
                      ThemeProvider.of(context).brightness == Brightness.dark
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                  firstChild: GestureDetector(
                    onTap: () => ThemeSwitcher.of(context)
                        .changeTheme(theme: kLightTheme),
                    child: Icon(
                      LineAwesomeIcons.sun,
                      size: 50,
                    ),
                  ),
                  secondChild: GestureDetector(
                    onTap: () => ThemeSwitcher.of(context)
                        .changeTheme(theme: kDarkTheme),
                    child: Icon(
                      LineAwesomeIcons.moon,
                      size: 50,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            SizedBox(height: kSpacingUnit.toDouble() * 2),
            Column(
              children: <Widget>[
                Container(
                  height: kSpacingUnit.toDouble() * 10,
                  width: kSpacingUnit.toDouble() * 10,
                  margin: EdgeInsets.only(top: kSpacingUnit.toDouble() * 1),
                  child: Stack(
                    children: <Widget>[
                      CircleAvatar(
                        radius: kSpacingUnit.toDouble() * 5,
                        backgroundColor: Colors.grey,
                        child: ClipOval(
                          child: new SizedBox(
                            width: 180.0,
                            height: 180.0,
                            child: (_image != null)
                                ? Image.file(
                                    _image,
                                    fit: BoxFit.fill,
                                  )
                                : Image.network(
                                    "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          height: kSpacingUnit.toDouble() * 3,
                          width: kSpacingUnit.toDouble() * 3,
                          decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            heightFactor: kSpacingUnit.toDouble() * 3,
                            widthFactor: kSpacingUnit.toDouble() * 3,
                            child: IconButton(
                              onPressed: () {
                                getImage(context);
                              },
                              icon: Icon(
                                LineAwesomeIcons.pen,
                                color: kDarkPrimaryColor,
                                size: 17,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: kSpacingUnit.toDouble() * 2),
                Text(
                  widget.prefs.getString('name'),
                  style: kTitleTextStyle,
                ),
                SizedBox(height: kSpacingUnit.toDouble() * 0.5),
                Text(
                  widget.prefs.getString('email'),
                  style: kCaptionTextStyle,
                ),
                SizedBox(
                  height: 40,
                )
              ],
            ),
            Expanded(
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  ProfileListItem(
                      icon: LineAwesomeIcons.user_shield,
                      text: AppLocalizations.of(context).OptionA,
                      lol: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Userinfo(
                                      prefs: widget.prefs,
                                      DocId: widget.docId,
                                    )));
                      }),
                  ProfileListItem(
                    icon: LineAwesomeIcons.question_circle,
                    text: AppLocalizations.of(context).OptionB,
                    lol: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ConnectScreen()));
                    },
                  ),
                  ProfileListItem(
                      icon: LineAwesomeIcons.cog,
                      text: AppLocalizations.of(context).OptionC,
                      lol: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LanguageChange()));
                      }),
                  ProfileListItem(
                      icon: Icons.system_update_alt,
                      text: AppLocalizations.of(context).OptionD,
                      lol: () async {
                        PackageInfo packageInfo =
                            await PackageInfo.fromPlatform();
                        var snapShot = await FirebaseFirestore.instance
                            .collection('Folkapp')
                            .doc('version')
                            .get()
                            .then((value) {
                          update = value.data()['android_major_update'];
                          url = value.data()['link'];
                        });
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                    AppLocalizations.of(context).AppUpdate),
                                content: Text(
                                  packageInfo.version == this.update
                                      ? AppLocalizations.of(context).UpdateN
                                      : AppLocalizations.of(context)
                                              .UpdateAvailable +
                                          '${this.update}',
                                ),
                                actions: <Widget>[
                                  packageInfo.version == this.update
                                      ? null
                                      : FlatButton(
                                          onPressed: () async {
                                            if (await canLaunch(this.url)) {
                                              await launch(this.url);
                                            }
                                          },
                                          child: Text(
                                              AppLocalizations.of(context)
                                                  .Update)),
                                  FlatButton(
                                    child: Text(
                                        AppLocalizations.of(context).Close),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                      }),
                  Container(
                    height: kSpacingUnit.toDouble() * 5.5,
                    margin: EdgeInsets.symmetric(
                      horizontal: kSpacingUnit.toDouble() * 4,
                    ).copyWith(
                      bottom: kSpacingUnit.toDouble() * 2,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: kSpacingUnit.toDouble() * 2,
                    ),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(kSpacingUnit.toDouble() * 3),
                      color: Theme.of(context).backgroundColor,
                    ),
                    child: FlatButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setBool('Login', false);
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SplashScreen()));
                      },
                      padding: EdgeInsets.all(0.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            LineAwesomeIcons.alternate_sign_out,
                            size: kSpacingUnit.toDouble() * 2.5,
                          ),
                          SizedBox(width: kSpacingUnit.toDouble() * 1.5),
                          Text(
                            AppLocalizations.of(context).OptionE,
                            style: kTitleTextStyle.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            LineAwesomeIcons.angle_right,
                            size: kSpacingUnit.toDouble() * 2.5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
