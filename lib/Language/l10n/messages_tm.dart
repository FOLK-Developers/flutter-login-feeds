import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();
final _keepAnalysisHappy = Intl.defaultLocale;
typedef MessageIfAbsent(String message_str, List args);

class MessageLookup extends MessageLookupByLibrary {
  get localeName => 'tm';
  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "optionA": MessageLookupByLibrary.simpleMessage("சுயவிவர தகவல்"),
        "optionB": MessageLookupByLibrary.simpleMessage("எங்களை பற்றி"),
        "optionC": MessageLookupByLibrary.simpleMessage("மொழி அமைப்புகள்"),
        "optionD": MessageLookupByLibrary.simpleMessage("பதிப்பு சோதனை"),
        "optionE": MessageLookupByLibrary.simpleMessage("வெளியேறு"),
        "Name": MessageLookupByLibrary.simpleMessage("பெயர்"),
        "Email": MessageLookupByLibrary.simpleMessage("மின்னஞ்சல்"),
        "Phone Number": MessageLookupByLibrary.simpleMessage("தொலைபேசி எண்"),
        "Update": MessageLookupByLibrary.simpleMessage("புதுப்பிப்பு"),
        "locale": MessageLookupByLibrary.simpleMessage("tm"),
        "App_Update":
            MessageLookupByLibrary.simpleMessage("பயன்பாட்டு புதுப்பிப்பு"),
        "Update_Available":
            MessageLookupByLibrary.simpleMessage("புதுப்பிப்பு கிடைக்கிறது "),
        "Close": MessageLookupByLibrary.simpleMessage("நெருக்கமான"),
        "Home": MessageLookupByLibrary.simpleMessage("வீடு"),
        "Store": MessageLookupByLibrary.simpleMessage("கடை "),
        "Help": MessageLookupByLibrary.simpleMessage("உதவி"),
        "Verify": MessageLookupByLibrary.simpleMessage("சரிபார்க்கவும்"),
        "Verify2": MessageLookupByLibrary.simpleMessage(
            "அனுப்பப்பட்ட எஸ்எம்எஸ் தானாகவே\nகண்டறிய காத்திருக்கிறது"),
        "Enter Phone": MessageLookupByLibrary.simpleMessage(
            "உங்கள் தொலைபேசி எண்ணை உள்ளிடவும்"),
        "sendSms": MessageLookupByLibrary.simpleMessage(
            "உங்கள் தொலைபேசி எண்ணை சரிபார்க்க\nFOLK ஒரு SMS செய்தியை அனுப்பும்."),
        "Language": MessageLookupByLibrary.simpleMessage("மொழி"),
        "Verify Phone1": MessageLookupByLibrary.simpleMessage(
            "தொலைபேசி எண்ணை நாங்கள் சரிபார்க்கிறோம்:"),
        "Verify Phone2": MessageLookupByLibrary.simpleMessage(
            "இது சரியா, அல்லது எண்ணைத் திருத்த விரும்புகிறீர்களா?"),
        "ok": MessageLookupByLibrary.simpleMessage("சரி"),
        "edit": MessageLookupByLibrary.simpleMessage('தொகு'),
        "sixDigit": MessageLookupByLibrary.simpleMessage(
            '6 இலக்க குறியீட்டை உள்ளிடவும்'),
        "confirm": MessageLookupByLibrary.simpleMessage('உறுதிப்படுத்தவும்'),
      };
}
