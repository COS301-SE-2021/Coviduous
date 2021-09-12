import 'dart:typed_data';
import 'dart:ui' as dart_ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:frontend/views/reporting/home_reporting.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/pdf_helpers.dart' as pdfHelpers;
import 'package:frontend/controllers/reporting/reporting_helpers.dart' as reportingHelpers;
import 'package:frontend/globals.dart' as globals;

class ReportingCompany extends StatefulWidget {
  static const routeName = "/reporting_company";
  @override
  ReportingCompanyState createState() {
    return ReportingCompanyState();
  }
}

class ReportingCompanyState extends State<ReportingCompany> {
  pw.ThemeData myTheme;
  var pdf;

  TextEditingController _year = TextEditingController();
  TextEditingController _month = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  final GlobalKey<SfCartesianChartState> _bookingShiftChartKey = GlobalKey();
  final GlobalKey<SfCartesianChartState> _healthChartKey = GlobalKey();
  final GlobalKey<SfCartesianChartState> _permissionChartKey = GlobalKey();
  final GlobalKey<SfCircularChartState> _userChartKey = GlobalKey();

  List<Map<String, int>> companyList = [
    {"Floor plans": globals.currentCompanySummary.getNumberOfFloorPlans()},
    {"Floors": globals.currentCompanySummary.getNumberOfFloors()},
    {"Rooms": globals.currentCompanySummary.getNumberOfRooms()},
  ];

  List<Map<String, int>> bookingShiftList = [
    {"Bookings": globals.currentBookingSummary.getNumBookings()},
    {"Shifts": globals.currentShiftSummary.getNumShifts()},
  ];

  List<Map<String, int>> healthList = [
    {"Recoveries": globals.currentHealthSummary.getReportedRecoveries()},
    {"Infections": globals.currentHealthSummary.getReportedInfections()},
    {"Employee checks": globals.currentHealthSummary.getHealthChecksUsers()},
    {"Visitor checks": globals.currentHealthSummary.getHealthChecksVisitors()},
  ];

  List<Map<String, int>> permissionList = [
    {"Total permissions": globals.currentPermissionSummary.getTotalPermissions()},
    {"Denied employees": globals.currentPermissionSummary.getPermissionsDeniedUsers()},
    {"Denied visitors": globals.currentPermissionSummary.getPermissionsDeniedVisitors()},
    {"Granted employees": globals.currentPermissionSummary.getPermissionsGrantedUsers()},
    {"Granted visitors": globals.currentPermissionSummary.getPermissionsGrantedVisitors()},
  ];

  //The user list is a list of Map<String, List> instead of Map<String, int> because pie charts also require a color attribute for each category
  List<Map<String, List>> userList = [
    {"Employees": [globals.currentCompanySummary.getNumberOfRegisteredUsers(), Color(0xffFAA61A)]},
    {"Admins": [globals.currentCompanySummary.getNumberOfRegisteredAdmins(), Color(0xffCC7A00)]}
  ];

  //Render booking and shift chart
  Future<Uint8List> renderBookingChart() async {
    final dart_ui.Image data = await _bookingShiftChartKey.currentState.toImage(pixelRatio: 3.0);
    final ByteData bytes = await data.toByteData(format: dart_ui.ImageByteFormat.png);
    return bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  }

  //Render health chart
  Future<Uint8List> renderHealthChart() async {
    final dart_ui.Image data = await _healthChartKey.currentState.toImage(pixelRatio:  3.0);
    final ByteData bytes = await data.toByteData(format: dart_ui.ImageByteFormat.png);
    return bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  }

  //Render permission chart
  Future<Uint8List> renderPermissionChart() async {
    final dart_ui.Image data = await _permissionChartKey.currentState.toImage(pixelRatio:  3.0);
    final ByteData bytes = await data.toByteData(format: dart_ui.ImageByteFormat.png);
    return bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  }

  //Render permission chart
  Future<Uint8List> renderUserChart() async {
    final dart_ui.Image data = await _userChartKey.currentState.toImage(pixelRatio:  3.0);
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
    pdfHelpers.loadPDFFonts().then((result) {
      myTheme = result;
    });
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
              padding: EdgeInsets.all(10),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    child: Text('Change date'),
                    onPressed: () async {
                      showDialog(context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Enter date to view'),
                              content: Form(
                                key: _formKey,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _year,
                                        decoration: InputDecoration(hintText: 'Enter year', filled: true, fillColor: Colors.white),
                                        obscureText: false,
                                        validator: (value) {
                                          if (value.isEmpty || !globals.isNumeric(value)) {
                                            return 'please input a year';
                                          }
                                          return null;
                                        },
                                        onSaved: (String value) {
                                          _year.text = value;
                                        },
                                      ),
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height/48,
                                      ),
                                      TextFormField(
                                        controller: _month,
                                        decoration: InputDecoration(hintText: 'Enter month (as a number)', filled: true, fillColor: Colors.white),
                                        obscureText: false,
                                        validator: (value) {
                                          if (value.isEmpty || !globals.isNumeric(value)) {
                                            return 'please input a month as a number';
                                          }
                                          return null;
                                        },
                                        onSaved: (String value) {
                                          _month.text = value;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: Text('Submit'),
                                  onPressed: () {
                                    FormState form = _formKey.currentState;

                                    if (form.validate()) {
                                      //The padLeft(2, "0") after the month is to ensure that if the month is a single digit, it should be preceded by a 0
                                      //Double digit months will automatically not have any leading 0s
                                      reportingHelpers.getCompanySummaries(_year.text, _month.text.padLeft(2, "0")).then((result) {
                                        if (result == true) {
                                          print("Booking summary ID: " + globals.currentBookingSummary.getBookingSummaryID());
                                          print("Company summary ID: " + globals.currentCompanySummary.getCompanyId());
                                          print("Health summary ID: " + globals.currentHealthSummary.getHealthSummaryID());
                                          print("Shift summary ID: " + globals.currentShiftSummary.getShiftSummaryID());
                                          print("Permission summary ID: " + globals.currentPermissionSummary.getPermissionSummaryID());
                                          Navigator.pop(context);
                                          setState(() {});
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text("No company information found for the selected year and month. Please choose a different date.")));
                                          Navigator.pop(context);
                                        }
                                      });
                                    }
                                  },
                                ),
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            );
                          });
                    },
                  ),
                  ElevatedButton(
                      child: Text('Generate PDF report'),
                      onPressed: () async {
                        pw.MemoryImage bookingChart = new pw.MemoryImage(await renderBookingChart());
                        pw.MemoryImage healthChart = new pw.MemoryImage(await renderHealthChart());
                        pw.MemoryImage permissionChart = new pw.MemoryImage(await renderPermissionChart());
                        pw.MemoryImage userChart = new pw.MemoryImage(await renderUserChart());

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
                                text: 'Company ID: ' + globals.loggedInCompanyId,
                              ),
                              pw.Bullet(
                                text: 'Date: ' + globals.currentHealthSummary.getTimestamp().substring(0, 10),
                              ),
                              pw.SizedBox(
                                width: 500,
                                child: pw.Divider(color: PdfColors.grey, thickness: 1.5),
                              ),
                              pw.Header(
                                level: 1,
                                title: 'Company overview',
                                child: pw.Text('Company overview', textScaleFactor: 1.5),
                              ),
                              pw.Bullet(
                                text: 'Number of floor plans: ' + globals.currentCompanySummary.getNumberOfFloorPlans().toString(),
                              ),
                              pw.Bullet(
                                text: 'Number of floors: ' + globals.currentCompanySummary.getNumberOfFloors().toString(),
                              ),
                              pw.Bullet(
                                text: 'Number of rooms: ' + globals.currentCompanySummary.getNumberOfRooms().toString(),
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
                                  text: 'Number of bookings for this month: ' + globals.currentBookingSummary.getNumBookings().toString(),
                              ),
                              pw.Bullet(
                                  text: 'Number of shifts for this month: ' + globals.currentShiftSummary.getNumShifts().toString(),
                              ),
                              pw.Bullet(
                                  text: 'Average weekly bookings for this month: ' + (globals.currentBookingSummary.getNumBookings()/4).toString(),
                              ),
                              pw.Bullet(
                                  text: 'Average weekly shifts for this month: ' + (globals.currentShiftSummary.getNumShifts()/4).toString(),
                              ),
                              pw.Image(
                                bookingChart,
                              ),
                              pw.SizedBox(
                                width: 500,
                                child: pw.Divider(color: PdfColors.grey, thickness: 1.5),
                              ),
                              pw.Header(
                                child: pw.Text('Health statistics', textScaleFactor: 1.5),
                              ),
                              pw.Bullet(
                                text: 'Number of reported recoveries this month: ' + globals.currentHealthSummary.getReportedRecoveries().toString(),
                              ),
                              pw.Bullet(
                                text: 'Number of reported infections this month: ' + globals.currentHealthSummary.getReportedInfections().toString(),
                              ),
                              pw.Bullet(
                                text: 'Number of completed employee health checks this month: ' + globals.currentHealthSummary.getHealthChecksUsers().toString(),
                              ),
                              pw.Bullet(
                                text: 'Number of completed visitor health checks this month: ' + globals.currentHealthSummary.getHealthChecksVisitors().toString(),
                              ),
                              pw.Image(
                                healthChart,
                              ),
                              pw.Header(
                                child: pw.Text('Permission statistics', textScaleFactor: 1.5),
                              ),
                              pw.Bullet(
                                text: 'Total number of permissions granted or denied this month: ' + globals.currentPermissionSummary.getTotalPermissions().toString(),
                              ),
                              pw.Bullet(
                                text: 'Number of employee permissions denied: ' + globals.currentPermissionSummary.getPermissionsDeniedUsers().toString(),
                              ),
                              pw.Bullet(
                                text: 'Number of visitor permissions denied: ' + globals.currentPermissionSummary.getPermissionsDeniedVisitors().toString(),
                              ),
                              pw.Bullet(
                                text: 'Number of employee permissions granted: ' + globals.currentPermissionSummary.getPermissionsGrantedUsers().toString(),
                              ),
                              pw.Bullet(
                                text: 'Number of visitor permissions granted: ' + globals.currentPermissionSummary.getPermissionsGrantedVisitors().toString(),
                              ),
                              pw.Image(
                                permissionChart,
                              ),
                              pw.Header(
                                child: pw.Text('User statistics', textScaleFactor: 1.5),
                              ),
                              pw.Bullet(
                                text: 'Total number of registered users: ' + globals.currentCompanySummary.getTotalNumberOfRegistered().toString(),
                              ),
                              pw.Bullet(
                                text: 'Number of admins: ' + globals.currentCompanySummary.getNumberOfRegisteredAdmins().toString(),
                              ),
                              pw.Bullet(
                                text: 'Number of employees: ' + globals.currentCompanySummary.getNumberOfRegisteredUsers().toString(),
                              ),
                              pw.Image(
                                userChart,
                              ),
                            ]
                        ));

                        //Save PDF
                        if (kIsWeb) { //If web browser
                          String platform = globals.getOSWeb();
                          if (platform == "Android" || platform == "iOS") { //Check if mobile browser
                            pdfHelpers.savePDFMobile(pdf, 'report_company_' + globals.loggedInCompanyId + '.pdf');
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("PDF file saved to downloads folder")));
                          } else { //Else, PC web browser
                            pdfHelpers.savePDFWeb(pdf, 'report_company_' + globals.loggedInCompanyId + '.pdf');
                          }
                        } else { //Else, mobile app
                          pdfHelpers.savePDFMobile(pdf, 'report_company_' + globals.loggedInCompanyId + '.pdf');
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("PDF file saved to downloads folder")));
                        }
                      }),
                ],
              ),
            )
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            color: globals.firstColor,
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              "Company overview",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          GridView.count(
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            shrinkWrap: true,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    color: globals.thirdColor,
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      "Number of floor plans",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    color: Color(0xff134D66),
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      globals.currentCompanySummary.getNumberOfFloorPlans().toString(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    color: globals.fourthColor,
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      "Number of floors",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    color: Color(0xff232A4C),
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      globals.currentCompanySummary.getNumberOfFloors().toString(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    color: globals.fifthColor,
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      "Number of rooms",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    color: Color(0xff4C234C),
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      globals.currentCompanySummary.getNumberOfRooms().toString(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Divider(
                            color: globals.lineColor,
                            thickness: 2,
                          ),
                          Container(
                            alignment: Alignment.center,
                            color: globals.thirdColor,
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              "Bookings and shifts",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5
                              ),
                            ),
                          ),
                          Text("Number of bookings: " + globals.currentBookingSummary.getNumBookings().toString(),
                              style: TextStyle(color: Colors.white)),
                          Text("Number of shifts: " + globals.currentShiftSummary.getNumShifts().toString(),
                              style: TextStyle(color: Colors.white)),
                          Text("Average weekly bookings: " + (globals.currentBookingSummary.getNumBookings()/4).toString(),
                              style: TextStyle(color: Colors.white)),
                          Text("Average weekly shifts: " + (globals.currentShiftSummary.getNumShifts()/4).toString(),
                              style: TextStyle(color: Colors.white)),
                          Divider(
                            color: globals.lineColor,
                            thickness: 2,
                          ),
                          SfCartesianChart(
                            key: _bookingShiftChartKey,
                            primaryXAxis: CategoryAxis(
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                )
                            ),
                            primaryYAxis: NumericAxis(
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            series: <ChartSeries>[
                              ColumnSeries<Map<String, int>, String>(
                                color: globals.thirdColor,
                                dataSource: bookingShiftList,
                                xValueMapper: (Map<String, int> data, _) => data.keys.first,
                                yValueMapper: (Map<String, int> data, _) => data.values.first,
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.center,
                            color: globals.fourthColor,
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              "Health",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5
                              ),
                            ),
                          ),
                          Text("Number of reported recoveries: " + globals.currentHealthSummary.getReportedRecoveries().toString(),
                              style: TextStyle(color: Colors.white)),
                          Text("Number of reported infections: " + globals.currentHealthSummary.getReportedInfections().toString(),
                              style: TextStyle(color: Colors.white)),
                          Text("Number of completed employee health checks: " + globals.currentHealthSummary.getHealthChecksUsers().toString(),
                              style: TextStyle(color: Colors.white)),
                          Text("Number of completed visitor health checks: " + globals.currentHealthSummary.getHealthChecksVisitors().toString(),
                              style: TextStyle(color: Colors.white)),
                          Divider(
                            color: globals.lineColor,
                            thickness: 2,
                          ),
                          SfCartesianChart(
                            key: _healthChartKey,
                            primaryXAxis: CategoryAxis(
                              labelRotation: -45,
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                )
                            ),
                            primaryYAxis: NumericAxis(
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            series: <ChartSeries>[
                              ColumnSeries<Map<String, int>, String>(
                                color: globals.fourthColor,
                                dataSource: healthList,
                                xValueMapper: (Map<String, int> data, _) => data.keys.first,
                                yValueMapper: (Map<String, int> data, _) => data.values.first,
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.center,
                            color: globals.fifthColor,
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              "Permissions",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5
                              ),
                            ),
                          ),
                          Text("Total number of permissions granted or denied this month: " + globals.currentPermissionSummary.getTotalPermissions().toString(),
                              style: TextStyle(color: Colors.white)),
                          Text("Number of employee permissions denied: " + globals.currentPermissionSummary.getPermissionsDeniedUsers().toString(),
                              style: TextStyle(color: Colors.white)),
                          Text("Number of visitor permissions denied: " + globals.currentPermissionSummary.getPermissionsDeniedVisitors().toString(),
                              style: TextStyle(color: Colors.white)),
                          Text("Number of employee permissions granted: " + globals.currentPermissionSummary.getPermissionsGrantedUsers().toString(),
                              style: TextStyle(color: Colors.white)),
                          Text("Number of visitor permissions granted: " + globals.currentPermissionSummary.getPermissionsGrantedVisitors().toString(),
                              style: TextStyle(color: Colors.white)),
                          Divider(
                            color: globals.lineColor,
                            thickness: 2,
                          ),
                          SfCartesianChart(
                            key: _permissionChartKey,
                            primaryXAxis: CategoryAxis(
                                labelRotation: -45,
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                )
                            ),
                            primaryYAxis: NumericAxis(
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            series: <ChartSeries>[
                              ColumnSeries<Map<String, int>, String>(
                                color: globals.fifthColor,
                                dataSource: permissionList,
                                xValueMapper: (Map<String, int> data, _) => data.keys.first,
                                yValueMapper: (Map<String, int> data, _) => data.values.first,
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.center,
                            color: Color(0xffCC7A00),
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              "Users",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5
                              ),
                            ),
                          ),
                          Text("Total number of registered users: " + globals.currentCompanySummary.getTotalNumberOfRegistered().toString(),
                              style: TextStyle(color: Colors.white)),
                          Text("Number of registered admins: " + globals.currentCompanySummary.getNumberOfRegisteredAdmins().toString(),
                              style: TextStyle(color: Colors.white)),
                          Text("Number of registered employees: " + globals.currentCompanySummary.getNumberOfRegisteredUsers().toString(),
                              style: TextStyle(color: Colors.white)),
                          Divider(
                            color: globals.lineColor,
                            thickness: 2,
                          ),
                          SfCircularChart(
                            key: _userChartKey,
                            series: <CircularSeries>[
                              PieSeries<Map<String, List>, String>(
                                pointColorMapper: (Map<String, List> data, _) => data.values.first[1],
                                dataLabelMapper: (Map<String, List> data, _) => data.values.first[0].toString(),
                                dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                dataSource: userList,
                                xValueMapper: (Map<String, List> data, _) => data.keys.first,
                                yValueMapper: (Map<String, List> data, _) => data.values.first[0],
                              ),
                            ],
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
