import 'dart:io';

import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:pdf/widgets.dart' as pw;

import 'package:frontend/globals.dart' as globals;

Future<pw.ThemeData> loadPDFFonts() async {
  var fontAssets;
  pw.ThemeData theme = null;

  await Future.wait([
    globals.loadPDFFonts()
  ]).then((results) {
    fontAssets = results.first;
    theme = pw.ThemeData.withFont(
      base: pw.Font.ttf(fontAssets[0]),
      bold: pw.Font.ttf(fontAssets[1]),
      italic: pw.Font.ttf(fontAssets[2]),
      boldItalic: pw.Font.ttf(fontAssets[3]),
    );
  });

  return theme;
}

//Save PDF on mobile
Future savePDFMobile(pw.Document pdf, String fileName) async {
  List<Directory> outputs;

  outputs = await Future.wait([
    DownloadsPathProvider.downloadsDirectory
  ]);
  Directory output = outputs.first;
  print(output.path);

  File file = File('${output.path}/' + fileName);
  await file.writeAsBytes(await pdf.save());
}

//Save PDF on web
Future savePDFWeb(pw.Document pdf, String fileName) async {
  var bytes = await pdf.save();
  var blob = html.Blob([bytes], 'application/pdf');
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