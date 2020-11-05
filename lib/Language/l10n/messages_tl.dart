import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();
final _keepAnalysisHappy = Intl.defaultLocale;
typedef MessageIfAbsent(String message_str, List args);

class MessageLookup extends MessageLookupByLibrary {
  get localeName => 'tl';
  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "optionA": MessageLookupByLibrary.simpleMessage("ప్రొఫైల్ సమాచారం"),
        "optionB": MessageLookupByLibrary.simpleMessage(
            "మా గురించి మరింత తెలుసుకోండి"),
        "optionC": MessageLookupByLibrary.simpleMessage("భాష సెట్టింగులు"),
        "optionD": MessageLookupByLibrary.simpleMessage("సంస్కరణ తనిఖీ"),
        "optionE": MessageLookupByLibrary.simpleMessage("లాగ్ అవుట్"),
        "Name": MessageLookupByLibrary.simpleMessage("పేరు"),
        "Email": MessageLookupByLibrary.simpleMessage("ఇమెయిల్"),
        "Phone Number": MessageLookupByLibrary.simpleMessage("ఫోను నంబరు"),
        "Update": MessageLookupByLibrary.simpleMessage("నవీకరణ"),
        "locale": MessageLookupByLibrary.simpleMessage("tl"),
        "App_Update": MessageLookupByLibrary.simpleMessage("అనువర్తన నవీకరణ"),
        "Update_Available":
            MessageLookupByLibrary.simpleMessage("నవీకరణ అందుబాటులో ఉంది "),
        "Close": MessageLookupByLibrary.simpleMessage("దగ్గరగా"),
        "UpdateN":
            MessageLookupByLibrary.simpleMessage("మీ సాఫ్ట్‌వేర్ తాజాగా ఉంది"),
        "Home": MessageLookupByLibrary.simpleMessage("హోమ్"),
        "Store": MessageLookupByLibrary.simpleMessage("స్టోర్ "),
        "Help": MessageLookupByLibrary.simpleMessage("సహాయం"),
        "Verify": MessageLookupByLibrary.simpleMessage("ధ్రువీకరించడం"),
        "Verify2": MessageLookupByLibrary.simpleMessage(
            "పంపిన SMS లో స్వయంచాలకంగా గుర్తించడానికి\nవేచి ఉంది "),
        "Enter Phone": MessageLookupByLibrary.simpleMessage(
            "మీ ఫోన్ నెంబర్ ను ఎంటర్ చేయండి"),
        "sendSms": MessageLookupByLibrary.simpleMessage(
            "మీ ఫోన్ నంబర్‌ను ధృవీకరించడానికి FOLK ఒక\nSMS సందేశాన్ని పంపుతుంది."),
        "Language": MessageLookupByLibrary.simpleMessage("భాషా"),
        "Verify Phone1": MessageLookupByLibrary.simpleMessage(
            "మేము ఫోన్ నంబర్‌ను ధృవీకరిస్తాము:"),
        "Verify Phone2": MessageLookupByLibrary.simpleMessage(
            "ఇది సరేనా, లేదా మీరు సంఖ్యను సవరించాలనుకుంటున్నారా?"),
        "ok": MessageLookupByLibrary.simpleMessage("అలాగే"),
        "edit": MessageLookupByLibrary.simpleMessage('మార్చు'),
        "sixDigit": MessageLookupByLibrary.simpleMessage(
            '6-అంకెల కోడ్‌ను నమోదు చేయండి'),
        "confirm": MessageLookupByLibrary.simpleMessage('నిర్ధారించండి'),
      };
}
