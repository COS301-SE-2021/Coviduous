import 'package:flutter/foundation.dart';
import 'package:frontend/frontend/front_end_globals.dart' as globals;

String server = null;

// Should return slightly different URLs depending on the platform
getServer() {
  if (kIsWeb) {
    String platform = globals.getOSWeb();
    if (platform == "Android" || platform == "iOS") {
      server = "https://hvofiy7xh6.execute-api.us-east-1.amazonaws.com";
    } else {
      server = "https://agile-bastion-18336.herokuapp.com/https://hvofiy7xh6.execute-api.us-east-1.amazonaws.com";
    }
  } else {
    server = "https://hvofiy7xh6.execute-api.us-east-1.amazonaws.com";
  }
  return server;
}