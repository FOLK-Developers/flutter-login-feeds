import 'package:flutter/material.dart';

const kSpacingUnit = 10;

const kDarkPrimaryColor = Color(0xFF212121);

const kDarkSecondaryColor = Color(0xFF373737);

const kLightPrimaryColor = Color(0xFFFFFFFF);

const kLightSecondaryColor = Color(0xFFF3F7FB);

const kAccentColor = Color(0xFFFFC107);

final kTitleTextStyle = TextStyle(
  fontSize: kSpacingUnit * 1.7,
  fontWeight: FontWeight.w600,
);

final kCaptionTextStyle = TextStyle(
  fontSize: kSpacingUnit * 1.3,
  fontWeight: FontWeight.w100,
);

final kButtonTextStyle = TextStyle(
  fontSize: kSpacingUnit * 1.5,
  fontWeight: FontWeight.w400,
  color: kDarkPrimaryColor,
);

final kDarkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'SFProText',
  primaryColor: kDarkPrimaryColor,
  canvasColor: kDarkPrimaryColor,
  backgroundColor: kDarkSecondaryColor,
  accentColor: kAccentColor,
  iconTheme: ThemeData.dark().iconTheme.copyWith(
        color: kLightSecondaryColor,
      ),
  textTheme: ThemeData.dark().textTheme.apply(
        fontFamily: 'SFProText',
        bodyColor: kLightSecondaryColor,
        displayColor: kLightSecondaryColor,
      ),
);

final kLightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'SFProText',
  primaryColor: kLightPrimaryColor,
  canvasColor: kLightPrimaryColor,
  backgroundColor: kLightSecondaryColor,
  accentColor: kAccentColor,
  iconTheme: ThemeData.light().iconTheme.copyWith(
        color: kDarkSecondaryColor,
      ),
  textTheme: ThemeData.light().textTheme.apply(
        fontFamily: 'SFProText',
        bodyColor: kDarkSecondaryColor,
        displayColor: kDarkSecondaryColor,
      ),
);

class Constants {
  List<String> country = [
    'India',
    'United States',
    'United Kingdom',
    'Russia',
    'Japan'
  ];
  var countryCodes = {
    'India': 91,
    'United States': 1,
    'United Kingdom': 44,
    'Russia': 7,
    'Japan': 81
  };
  var langCode = {
    'English': 'en',
    'हिन्दी': 'hi',
    'తెలుగు': 'tl',
    'தமிழ்': 'tm'
  };
  var langList = ['English', 'हिन्दी', 'తెలుగు', 'தமிழ்'];
}
