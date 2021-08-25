import 'dart:io';
import 'dart:typed_data';
import 'package:collection/collection.dart' as collection;
import 'dart:ui' as dart_ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:universal_html/html.dart' as html;
import 'package:pdf/widgets.dart' as pw;

import 'package:frontend/views/reporting/home_reporting.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';
import 'package:frontend/models/office/booking.dart';

import 'package:frontend/globals.dart' as globals;

class ReportingCompany extends StatefulWidget {
  static const routeName = "/reporting_company";
  @override
  ReportingCompanyState createState() {
    return ReportingCompanyState();
  }
}

class ReportingCompanyState extends State<ReportingCompany> {
  var myTheme;
  var pdf;
  final GlobalKey<SfCartesianChartState> _bookingChartKey = GlobalKey();

  Future loadPDFFonts() async {
    var fontAssets = await globals.loadPDFFonts();
    myTheme = pw.ThemeData.withFont(
      base: pw.Font.ttf(fontAssets[0]),
      bold: pw.Font.ttf(fontAssets[1]),
      italic: pw.Font.ttf(fontAssets[2]),
      boldItalic: pw.Font.ttf(fontAssets[3]),
    );
  }

  //Save PDF on mobile
  Future savePDFMobile() async {
    List<Directory> outputs;

    outputs = await Future.wait([
      DownloadsPathProvider.downloadsDirectory
    ]);
    Directory output = outputs.first;
    print(output.path);

    File file = File('${output.path}/report_company_' + globals.loggedInCompanyId + '.pdf');
    await file.writeAsBytes(await pdf.save());
  }

  //Save PDF on web
  Future savePDFWeb() async {
    var bytes = await pdf.save();
    var blob = html.Blob([bytes], 'application/pdf');
    var url = html.Url.createObjectUrlFromBlob(blob);
    var anchor =
    html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'report_company_' + globals.loggedInCompanyId + '.pdf';
    html.document.body.children.add(anchor);
    anchor.click();
    html.document.body.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  final List<Booking> bookingData = globals.currentBookings;
  List<List<Booking>> bookingDataSorted = [];
  List<String> bookingDataDates = [];

  //Group a list of bookings by date
  groupBookingsByDate(List<Booking> bookings) {
    final groups = collection.groupBy(bookings, (Booking booking) {
      return booking.getTimestamp().substring(0, 10);
    });

    bookingDataDates = groups.keys.toList().reversed;
    bookingDataSorted = groups.values.toList();
  }

  //Render booking and shift chart
  Future<Uint8List> renderBookingChart() async {
    final dart_ui.Image data = await _bookingChartKey.currentState.toImage(pixelRatio: 3.0);
    final ByteData bytes = await data.toByteData(format: dart_ui.ImageByteFormat.png);
    return bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(Reporting.routeName);
    return (await true);
  }

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.loggedInUserType != 'ADMIN') {
      if (globals.loggedInUserType == 'USER') {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushReplacementNamed(UserHomePage.routeName);
        });
      } else {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
        });
      }
      return Container();
    }

    //Load fonts from assets and initialize PDF
    loadPDFFonts();
    pdf = pw.Document(
      theme: myTheme,
    );

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title:
          Text("Company overview"),
          leading: BackButton(
            //Specify back button
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(Reporting.routeName);
            },
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 50,
              width: 130,
              padding: EdgeInsets.all(10),
              child:  ElevatedButton(
                  child: Text('Create PDF'),
                  onPressed: () async {
                    if (globals.currentBookings != null) {
                      groupBookingsByDate(bookingData);
                    }
                    pw.MemoryImage bookingChart = new pw.MemoryImage(await renderBookingChart());

                    //Create PDF
                    pdf.addPage(pw.MultiPage(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        pageFormat: PdfPageFormat.a4,
                        orientation: pw.PageOrientation.portrait,
                        build: (pw.Context context) => <pw.Widget>[
                          pw.Header(
                            level: 0,
                            title: 'Coviduous - Company report',
                            child: pw.Text('Coviduous - Company report', textScaleFactor: 2),
                          ),
                          pw.Bullet(
                            text: 'Date: ' + DateTime.now().toString(),
                          ),
                          pw.SizedBox(
                            width: 500,
                            child: pw.Divider(color: PdfColors.grey, thickness: 1.5),
                          ),
                          pw.Header(
                            level: 1,
                            title: 'Bookings and shift statistics',
                            child: pw.Text('Booking and shift statistics', textScaleFactor: 1.5),
                          ),
                          pw.Bullet(
                              text: 'Number of bookings for this month: '
                          ),
                          pw.Bullet(
                              text: 'Number of shifts for this month: '
                          ),
                          pw.Bullet(
                              text: 'Average weekly bookings for this month: '
                          ),
                          pw.Bullet(
                              text: 'Average weekly shifts for this month: '
                          ),
                          pw.Image(
                            bookingChart,
                          ),
                          pw.SizedBox(
                            width: 500,
                            child: pw.Divider(color: PdfColors.grey, thickness: 1.5),
                          ),
                        ]
                    ));

                    //Save PDF
                    if (kIsWeb) { //If web browser
                      String platform = globals.getOSWeb();
                      if (platform == "Android" || platform == "iOS") { //Check if mobile browser
                        savePDFMobile();
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("PDF file saved to downloads folder")));
                      } else { //Else, PC web browser
                        savePDFWeb();
                      }
                    } else { //Else, mobile app
                      savePDFMobile();
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("PDF file saved to downloads folder")));
                    }
                  }),
            )
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox (
                      height: MediaQuery.of(context).size.height/6,
                    ),
                    Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width/(1.8*globals.getWidgetScaling()),
                      padding: EdgeInsets.all(16),
                      child: SfCartesianChart(
                        key: _bookingChartKey,
                        primaryXAxis: DateTimeAxis(
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        series: <ChartSeries>[
                          LineSeries<List<Booking>, DateTime>(
                            color: Colors.black,
                            dataSource: bookingDataSorted,
                            xValueMapper: (List<Booking> bookings, _) => DateTime.parse(bookingDataDates.removeLast()),
                            yValueMapper: (List<Booking> bookings, _) => bookings.length
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
