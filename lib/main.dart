import 'dart:async';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:folk/HomeScreen/Home.dart';
import 'package:folk/LoginAuthentication/SplashScreenOpen.dart';
import 'package:folk/Services/DynamicLinkService.dart';

import 'Language/Localization/localizations.dart';
import 'Services/LocaleHelper.dart';
import 'Services/Locator.dart';
import 'SharedWidgets/Constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runZoned(
      () {
        runApp(Myapp());
      },
    );
  });
}

class Myapp extends StatefulWidget {
  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  SpecificLocalizationDelegate _specificLocalizationDelegate;

  @override
  void initState() {
    super.initState();
    helper.onLocaleChanged = onLocaleChange;
    _specificLocalizationDelegate =
        SpecificLocalizationDelegate(new Locale("en"));
  }

  onLocaleChange(Locale locale) {
    setState(() {
      _specificLocalizationDelegate = new SpecificLocalizationDelegate(locale);
    });
  }

  Widget build(BuildContext context) {
    return ThemeProvider(
      initTheme: kLightTheme,
      child: Builder(
        builder: (context) {
          return MaterialApp(
            theme: ThemeProvider.of(context),
            supportedLocales: [Locale('en'), Locale('hi'), Locale('tl')],
            locale: _specificLocalizationDelegate.overriddenLocale,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              new FallbackCupertinoLocalisationsDelegate(),
              _specificLocalizationDelegate
            ],
            navigatorKey: locator<NavigationService>().navigationKey,
            // ignore: missing_return
            onGenerateRoute: (routeSettings) {
              switch (routeSettings.name) {
                case 'home':
                  return MaterialPageRoute(
                      builder: (context) => Home(Id: routeSettings.arguments));
              }
            },
            home: SplashScreenOpen(),
          );
        },
      ),
    );
  }
}
