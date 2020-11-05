import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:folk/Language/l10n/messages_all.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode == null ? locale.languageCode : locale.toString();

    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;

      return new AppLocalizations();
    });
  }

  String get OptionA {
    return Intl.message('Profile Information', name: 'optionA');
  }

  String get OptionB {
    return Intl.message('Know more about us', name: 'optionB');
  }

  String get OptionC {
    return Intl.message('Language Settings', name: 'optionC');
  }

  String get OptionD {
    return Intl.message('Version Check', name: 'optionD');
  }

  String get OptionE {
    return Intl.message('Logout', name: 'optionE');
  }

  String get Name {
    return Intl.message('Name', name: 'Name');
  }

  String get Email {
    return Intl.message('Email', name: 'Email');
  }

  String get Phone {
    return Intl.message('Phone Number', name: 'Phone Number');
  }

  String get Update {
    return Intl.message('Update', name: 'Update');
  }

  String get locale {
    return Intl.message('en', name: 'locale');
  }

  String get AppUpdate {
    return Intl.message('App update', name: 'App_Update');
  }

  String get UpdateAvailable {
    return Intl.message('Update available to ', name: 'Update_Available');
  }

  String get UpdateN {
    return Intl.message('Your software is up to date', name: 'UpdateN');
  }

  String get Close {
    return Intl.message('Close', name: 'Close');
  }

  String get Home {
    return Intl.message('Home', name: 'Home');
  }

  String get Store {
    return Intl.message('Store', name: 'Store');
  }

  String get Help {
    return Intl.message('Help', name: 'Help');
  }

  String get Verify {
    return Intl.message('Verify', name: 'Verify');
  }

  String get Verify2 {
    return Intl.message('Waiting to automatically detect on SMS \nsent to',
        name: 'Verify2');
  }

  String get Phone_number {
    return Intl.message('Enter your phone number', name: 'Enter Phone');
  }

  String get send_sms {
    return Intl.message(
        'FOLK will send an SMS message to\nverify your phone number.',
        name: 'sendSms');
  }

  String get language {
    return Intl.message('Language', name: 'Language');
  }

  String get verifyPhone1 {
    return Intl.message('We will be verifying the phone number:',
        name: 'Verify Phone1');
  }

  String get verifyPhone2 {
    return Intl.message('Is this OK, or would you like to edit the number?',
        name: 'Verify Phone2');
  }

  String get ok {
    return Intl.message('OK', name: 'ok');
  }

  String get edit {
    return Intl.message('EDIT', name: 'edit');
  }

  String get sixDigit {
    return Intl.message('Enter 6-digit code', name: 'sixDigit');
  }

  String get confirm {
    return Intl.message('Confirm', name: 'confirm');
  }
}

class SpecificLocalizationDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  final Locale overriddenLocale;

  SpecificLocalizationDelegate(this.overriddenLocale);

  @override
  bool isSupported(Locale locale) => overriddenLocale != null;

  @override
  Future<AppLocalizations> load(Locale locale) =>
      AppLocalizations.load(overriddenLocale);

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => true;
}

class FallbackCupertinoLocalisationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'hi', 'tl', 'tm'].contains(locale.languageCode);

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      SynchronousFuture<_DefaultCupertinoLocalizations>(
          _DefaultCupertinoLocalizations(locale));

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}

class _DefaultCupertinoLocalizations extends DefaultCupertinoLocalizations {
  final Locale locale;

  _DefaultCupertinoLocalizations(this.locale);
}
