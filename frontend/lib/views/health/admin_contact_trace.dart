import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:universal_html/html.dart' as html;
import 'package:pdf/widgets.dart' as pw;

import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';
import 'package:frontend/views/health/admin_contact_trace_shifts.dart';

import 'package:frontend/controllers/health/health_helpers.dart' as healthHelpers;
import 'package:frontend/views/global_widgets.dart' as globalWidgets;
import 'package:frontend/globals.dart' as globals;

class AdminContactTrace extends StatefulWidget {
  static const routeName = "/admin_contact_trace";

  @override
  _AdminContactTraceState createState() => _AdminContactTraceState();
}
class _AdminContactTraceState extends State<AdminContactTrace> {
  var myTheme;
  var pdf;

  int numberOfEmployees = 0;
  List<List<String>> employeeList = [];

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

    File file = File('${output.path}/report_contact_trace_' + globals.currentShift.getShiftId() + '.pdf');
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
      ..download = 'report_contact_trace_' + globals.currentShift.getShiftId() + '.pdf';
    html.document.body.children.add(anchor);
    anchor.click();
    html.document.body.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(AdminContactTraceShifts.routeName);
    return (await true);
  }

  @override
  Widget build(BuildContext context) {
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

    if (globals.selectedUsers != null) {
      numberOfEmployees = globals.selectedUsers.length;
    }

    //Load fonts from assets and initialize PDF
    loadPDFFonts();
    pdf = pw.Document(
      theme: myTheme,
    );

    Widget getList() {
      employeeList.clear();
      employeeList.add(<String>['Employee ID', 'Name', 'Surname', 'Email', 'Date']);
      for (int i = 0; i < globals.selectedUsers.length; i++) {
        List<String> employeeInfo = <String>[
          globals.selectedUsers[i].getUserId(), globals.selectedUsers[i].getFirstName(),
          globals.selectedUsers[i].getLastName(), globals.selectedUsers[i].getEmail(), globals.currentShift.getDate()
        ];
        employeeList.add(employeeInfo);
      }

      if (numberOfEmployees == 0) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / (5 * globals.getWidgetScaling()),
              ),
              globalWidgets.notFoundMessage(context, 'No employees found', 'No other employees were in this shift.'),
            ]
        );
      } else {
        //Else create and return a list
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: numberOfEmployees,
            itemBuilder: (context, index) {
              return ListTile(
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 6,
                            child: Image(
                              image: AssetImage('assets/images/placeholder-employee-image.png'),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('User ' + (index + 1).toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: (MediaQuery
                                            .of(context)
                                            .size
                                            .height * 0.01) * 2.5,
                                      )
                                  ),
                                ],
                              ),
                              Container(
                                color: Colors.white,
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(globals.currentShift.getDate().substring(0, 11) + ' @ ' + globals.currentShift.getDate().substring(11, 19)),
                                              SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Text(globals.selectedUsers[index].getFirstName() + ' ' + globals.selectedUsers[index].getLastName())
                                              ),
                                              SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Text(globals.selectedUsers[index].getUserId())
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ]
                        ),
                      ),
                    ]
                ),
              );
            });
      }
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Contact trace'),
          leading: BackButton( //Specify back button
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(AdminContactTraceShifts.routeName);
            },
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container (
                  height: 50,
                  width: 200,
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom (
                      primary: Color(0xff03305A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Notify employees'),
                    onPressed: (){
                      if (numberOfEmployees == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("No employees found")));
                      } else {
                        showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Warning'),
                              content: Text('Are you sure you want to notify ' + numberOfEmployees.toString() + ' employees?'),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: Text('Yes'),
                                  onPressed: (){
                                    healthHelpers.notifyGroup().then((result) {
                                      if (result == true) {
                                        Navigator.of(ctx).pop();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text(numberOfEmployees.toString() + " employees notified")));
                                      } else {
                                        Navigator.of(ctx).pop();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("An error occurred. Please try again later.")));
                                      }
                                    });
                                  },
                                ),
                                ElevatedButton(
                                  child: Text('No'),
                                  onPressed: (){
                                    Navigator.of(ctx).pop();
                                  },
                                )
                              ],
                            ));
                      }
                    },
                  )
              ),
              Container (
                  height: 50,
                  width: 200,
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom (
                      primary: Color(0xff03305A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Save report as PDF'),
                    onPressed: (){
                      if (numberOfEmployees == 0){
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Cannot save an empty report")));
                        return;
                      }

                      //Create PDF
                      pdf.addPage(pw.MultiPage(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          pageFormat: PdfPageFormat.a4,
                          orientation: pw.PageOrientation.portrait,
                          build: (pw.Context context) => <pw.Widget>[
                            pw.Header(
                              level: 0,
                              title: 'Coviduous - Contact trace',
                              child: pw.Text('Coviduous - Contact trace', textScaleFactor: 2),
                            ),
                            pw.Bullet(
                                text: 'Employee name: ' + globals.selectedUser.getFirstName() + ' ' + globals.selectedUser.getLastName()
                            ),
                            pw.Bullet(
                                text: 'Employee number: ' + globals.selectedUser.getUserId()
                            ),
                            pw.Bullet(
                                text: 'Employee email address: ' + globals.selectedUser.getEmail()
                            ),
                            pw.SizedBox(
                              width: 500,
                              child: pw.Divider(color: PdfColors.grey, thickness: 1.5),
                            ),
                            pw.Bullet(
                                text: 'Date: ' + globals.currentShift.getDate()
                            ),
                            pw.SizedBox(
                              width: 500,
                              child: pw.Divider(color: PdfColors.grey, thickness: 1.5),
                            ),
                            pw.Header(
                                level: 2,
                                text: 'Employees'
                            ),
                            pw.Table.fromTextArray(data: employeeList),
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
                    },
                  )
              ),
            ]
          )
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      color: Color(0xff03305A),
                      width: MediaQuery.of(context).size.width/(1.55 * globals.getWidgetScaling()),
                      child: Text(
                          globals.selectedUser.getFirstName() + ' ' + globals.selectedUser.getLastName() + ' has come into contact with the following employees over the past month:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: (MediaQuery.of(context).size.height * 0.01) * 2,
                          )
                      ),
                      padding: EdgeInsets.all(16),
                    ),
                    getList(),
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