// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "enter_same_password":
            MessageLookupByLibrary.simpleMessage("Enter the same password"),
        "import": MessageLookupByLibrary.simpleMessage("Import"),
        "import_hint":
            MessageLookupByLibrary.simpleMessage("Enter secret phrase"),
        "import_sub1":
            MessageLookupByLibrary.simpleMessage("Your secret phrase"),
        "import_sub2": MessageLookupByLibrary.simpleMessage(
            "Create new password to unlock your wallet"),
        "import_wallet": MessageLookupByLibrary.simpleMessage("Import Wallet"),
        "limit_characters": MessageLookupByLibrary.simpleMessage(
            "Password length should contain minimum 6 characters"),
        "new_password1": MessageLookupByLibrary.simpleMessage("New password"),
        "new_password2":
            MessageLookupByLibrary.simpleMessage("Confirm the password"),
        "select_nft": MessageLookupByLibrary.simpleMessage("Select NFT"),
        "select_tip": MessageLookupByLibrary.simpleMessage(
            "You haven’t NFT\non your address"),
        "show": MessageLookupByLibrary.simpleMessage("Show me"),
        "show_tip": MessageLookupByLibrary.simpleMessage(
            "Select my NFT or photoes to show me")
      };
}
