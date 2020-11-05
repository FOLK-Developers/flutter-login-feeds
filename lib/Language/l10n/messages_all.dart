import 'dart:async';

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';
import 'package:intl/src/intl_helpers.dart';

import 'messages_en.dart' as messages_en;
import 'messages_hi.dart' as messages_hi;
import 'messages_tl.dart' as messages_tl;
import 'messages_tm.dart' as messages_tm;

typedef Future<dynamic> LibraryLoader();
Map<String, LibraryLoader> _deferredLibraries = {
  'hi': () => Future.value(null),
  'tl': () => Future.value(null),
  'tm': () => Future.value(null),
  'en': () => Future.value(null),
};
MessageLookupByLibrary _findExact(localeName) {
  switch (localeName) {
    case 'hi':
      return messages_hi.messages;
    case 'en':
      return messages_en.messages;
    case 'tl':
      return messages_tl.messages;
    case 'tm':
      return messages_tm.messages;
    default:
      return messages_en.messages;
  }
}

Future<bool> initializeMessages(String localeName) async {
  var availableLocale = Intl.verifiedLocale(
      localeName, (locale) => _deferredLibraries[locale] != null,
      onFailure: (_) => null);
  if (availableLocale == null) {
    return new Future.value(false);
  }
  var lib = _deferredLibraries[availableLocale];
  await (lib == null ? new Future.value(false) : lib());
  initializeInternalMessageLookup(() => new CompositeMessageLookup());
  messageLookup.addLocale(availableLocale, _findGeneratedMessagesFor);
  return new Future.value(true);
}

bool _messagesExistFor(String locale) {
  try {
    return _findExact(locale) != null;
  } catch (e) {
    return false;
  }
}

MessageLookupByLibrary _findGeneratedMessagesFor(locale) {
  var actualLocale =
      Intl.verifiedLocale(locale, _messagesExistFor, onFailure: (_) => null);
  if (actualLocale == null) return null;
  return _findExact(actualLocale);
}
