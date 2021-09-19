import 'dart:io';
import 'dart:typed_data';

import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/services.dart' show rootBundle;

import 'package:frontend/globals.dart' as globals;

Future<String> saveImage(String asset, String fileNameWithoutType, String fileType) async {
  ByteData byteData = await rootBundle.load(asset);
  String fileNameWithType = fileNameWithoutType + "." + fileType;

  if (kIsWeb) { //If web browser
    String platform = globals.getOSWeb();
    if (platform == "Android" || platform == "iOS") { //Check if mobile browser
      saveImageMobile(byteData.buffer.asUint8List(), fileNameWithType);
      return "Image saved to downloads folder";
    } else { //Else, PC web browser
      saveImageWeb(byteData.buffer.asUint8List(), fileNameWithType, fileType);
    }
  } else { //Else, mobile app
    saveImageMobile(byteData.buffer.asUint8List(), fileNameWithType);
    return "Image saved to downloads folder";
  }

  return null;
}

Future<String> saveMemoryImage(Uint8List bytes, String fileNameWithoutType, String fileType) async {
  String fileNameWithType = fileNameWithoutType + "." + fileType;

  if (kIsWeb) { //If web browser
    String platform = globals.getOSWeb();
    if (platform == "Android" || platform == "iOS") { //Check if mobile browser
      saveImageMobile(bytes, fileNameWithType);
      return "Image saved to downloads folder";
    } else { //Else, PC web browser
      saveImageWeb(bytes, fileNameWithType, fileType);
    }
  } else { //Else, mobile app
    saveImageMobile(bytes, fileNameWithType);
    return "Image saved to downloads folder";
  }

  return null;
}

Future saveImageMobile(Uint8List bytes, String fileName) async {
  List<Directory> outputs;

  outputs = await Future.wait([
    DownloadsPathProvider.downloadsDirectory
  ]);
  Directory output = outputs.first;
  print(output.path);

  File file = File('${output.path}/' + fileName);
  await file.writeAsBytes(bytes);
}

Future saveImageWeb(Uint8List bytes, String fileName, String fileType) async {
  if (fileType.toLowerCase() == 'png') {
    var blob = html.Blob([bytes], 'image/png');
    var url = html.Url.createObjectUrlFromBlob(blob);
    var anchor =
    html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = fileName;
    html.document.body.children.add(anchor);
    anchor.click();
    html.document.body.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  } else if (fileType.toLowerCase() == 'jpg') {
    var blob = html.Blob([bytes], 'image/jpg');
    var url = html.Url.createObjectUrlFromBlob(blob);
    var anchor =
    html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = fileName;
    html.document.body.children.add(anchor);
    anchor.click();
    html.document.body.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }
}