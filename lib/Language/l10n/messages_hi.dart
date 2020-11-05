import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();
final _keepAnalysisHappy = Intl.defaultLocale;
typedef MessageIfAbsent(String message_str, List args);

class MessageLookup extends MessageLookupByLibrary {
  get localeName => 'hi';
  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "optionA": MessageLookupByLibrary.simpleMessage("प्रोफ़ाइल जानकारी"),
        "optionB": MessageLookupByLibrary.simpleMessage("जानिए हमारे बारे में"),
        "optionC": MessageLookupByLibrary.simpleMessage("भाषा सेटिंग"),
        "optionD": MessageLookupByLibrary.simpleMessage("संस्करण की जाँच करें"),
        "optionE": MessageLookupByLibrary.simpleMessage("लॉग आउट"),
        "Name": MessageLookupByLibrary.simpleMessage("नाम"),
        "Email": MessageLookupByLibrary.simpleMessage("ईमेल"),
        "Phone Number": MessageLookupByLibrary.simpleMessage("फ़ोन नंबर"),
        "Update": MessageLookupByLibrary.simpleMessage("अपडेट करें"),
        "locale": MessageLookupByLibrary.simpleMessage("hi"),
        "App_Update": MessageLookupByLibrary.simpleMessage("ऐप अपडेट"),
        "Update_Available":
            MessageLookupByLibrary.simpleMessage("अद्यतन के लिए उपलब्ध "),
        "Close": MessageLookupByLibrary.simpleMessage("बंद करे"),
        "UpdateN":
            MessageLookupByLibrary.simpleMessage("आपका सॉफ्टवेयर अद्यतन है"),
        "Home": MessageLookupByLibrary.simpleMessage("होम"),
        "Store": MessageLookupByLibrary.simpleMessage("स्टोर"),
        "Help": MessageLookupByLibrary.simpleMessage("मदद"),
        "Verify": MessageLookupByLibrary.simpleMessage("सत्यापित करें"),
        "Verify2": MessageLookupByLibrary.simpleMessage(
            "भेजे गए एसएमएस पर स्वचालित रूप से पता\nलगाने की प्रतीक्षा की जा रही है"),
        "Enter Phone": MessageLookupByLibrary.simpleMessage(
            "अपना दूरभाष क्रमांक दर्ज करें"),
        "sendSms": MessageLookupByLibrary.simpleMessage(
            "FOLK आपके फ़ोन नंबर को सत्यापित करने\nके लिए एक एसएमएस संदेश भेजेगा।"),
        "Language": MessageLookupByLibrary.simpleMessage("भाषा"),
        "Verify Phone1": MessageLookupByLibrary.simpleMessage(
            "हम फ़ोन नंबर की पुष्टि करेंगे:"),
        "Verify Phone2": MessageLookupByLibrary.simpleMessage(
            "क्या यह ठीक है, या आप संख्या को संपादित करना चाहेंगे?"),
        "ok": MessageLookupByLibrary.simpleMessage("ठीक है"),
        "edit": MessageLookupByLibrary.simpleMessage('संपादित करें'),
        "sixDigit":
            MessageLookupByLibrary.simpleMessage('6-अंकीय कोड दर्ज करें'),
        "confirm": MessageLookupByLibrary.simpleMessage('पुष्टि करें'),
      };
}
