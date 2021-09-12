// Chatbot controller
library controllers;

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:frontend/globals.dart' as globals;
import 'package:frontend/controllers/server_info.dart' as serverInfo;

String chatbotServer = serverInfo.getChatbotServer();

Future<String> sendAndReceive(String message) async {
  String url = chatbotServer;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "question": message
    });
    request.headers.addAll(globals.requestHeaders);

    var response = await request.send();

    print(await response.statusCode);

    if (response.statusCode == 200) {
      var jsonString = (await response.stream.bytesToString());
      var jsonMap = jsonDecode(jsonString);

      print(jsonMap);

      return jsonMap["data"];
    }
  } catch(error) {
    print(error);
  }

  return null;
}