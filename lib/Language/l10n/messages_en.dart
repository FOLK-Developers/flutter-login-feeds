import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();
final _keepAnalysisHappy = Intl.defaultLocale;
typedef MessageIfAbsent(String message_str, List args);

class MessageLookup extends MessageLookupByLibrary {
  get localeName => 'en';
  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "optionA": MessageLookupByLibrary.simpleMessage("Profile Information"),
        "optionB": MessageLookupByLibrary.simpleMessage("Know more about us"),
        "optionC": MessageLookupByLibrary.simpleMessage("Language Settings"),
        "optionD": MessageLookupByLibrary.simpleMessage("Version Check"),
        "optionE": MessageLookupByLibrary.simpleMessage("Logout"),
        "Name": MessageLookupByLibrary.simpleMessage("Name"),
        "Email": MessageLookupByLibrary.simpleMessage("Email"),
        "Phone Number": MessageLookupByLibrary.simpleMessage("Phone Number"),
        "Update": MessageLookupByLibrary.simpleMessage("Update"),
        "locale": MessageLookupByLibrary.simpleMessage("en"),
        "App_Update": MessageLookupByLibrary.simpleMessage("App update"),
        "Update_Available":
            MessageLookupByLibrary.simpleMessage("Update available to "),
        "Close": MessageLookupByLibrary.simpleMessage("Close"),
        "Home": MessageLookupByLibrary.simpleMessage("Home"),
        "Store": MessageLookupByLibrary.simpleMessage("Store "),
        "Help": MessageLookupByLibrary.simpleMessage("Help"),
        "Verify": MessageLookupByLibrary.simpleMessage("Verify"),
        "Verify2": MessageLookupByLibrary.simpleMessage(
            "Waiting to automatically detect on SMS \nsent to "),
        "Enter Phone":
            MessageLookupByLibrary.simpleMessage("Enter your phone number"),
        "sendSms": MessageLookupByLibrary.simpleMessage(
            "FOLK will send an SMS message to\nverify your phone number."),
        "Language": MessageLookupByLibrary.simpleMessage("Language"),
        "Verify Phone1": MessageLookupByLibrary.simpleMessage(
            "We will be verifying the phone number:"),
        "Verify Phone2": MessageLookupByLibrary.simpleMessage(
            "Is this OK, or would you like to edit the number?"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "edit": MessageLookupByLibrary.simpleMessage('EDIT'),
        "sixDigit": MessageLookupByLibrary.simpleMessage('Enter 6-digit code'),
        "confirm": MessageLookupByLibrary.simpleMessage('Confirm'),
      };
}
