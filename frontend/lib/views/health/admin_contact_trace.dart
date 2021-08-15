import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:universal_html/html.dart' as html;
import 'package:pdf/widgets.dart' as pw;

import 'package:frontend/models/user/user.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';
import 'package:frontend/views/health/admin_contact_trace_shifts.dart';

import 'package:frontend/globals.dart' as globals;


class AdminContactTrace extends StatefulWidget {
  static const routeName = "/admin_contact_trace";

  @override
  _AdminContactTraceState createState() => _AdminContactTraceState();
}
class _AdminContactTraceState extends State<AdminContactTrace> {
  String firstName = "Kanye";
  String lastName = "West";
  String id = '10';
  int numberOfEmployees = 2;
  var myTheme;
  var pdf;

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

    File file = File("${output.path}/report_contact_trace_1234.pdf");
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
      ..download = 'report_contact_trace_1234.pdf';
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

    //Load fonts from assets and initialize PDF
    loadPDFFonts();
    pdf = pw.Document(
      theme: myTheme,
    );

    Widget getList() {
      List<User> users = [
        new User(userId: "User", firstName: "Beyonce", lastName: "Knowles", userName: "knowlesb", email: "b.knowles@email.com", companyId: "CID-1"),
        new User(userId: "User", firstName: "Janet", lastName: "Jackson", userName: "jacksonj", email: "j.jackson@email.com", companyId: "CID-1"),
      ];

      employeeList.add(<String>['Employee ID', 'Name', 'Surname', 'Email', 'Date']);
      for (int i = 0; i < users.length; i++) {
        List<String> employeeInfo = <String>[
          users[i].getUserId(), users[i].getFirstName(), users[i].getLastName(), users[i].getEmail(), "15 July 2021"
        ];
        employeeList.add(employeeInfo);
      }

      if (numberOfEmployees == 0) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height /
                    (5 * globals.getWidgetScaling()),
              ),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                height: MediaQuery.of(context).size.height/(24*globals.getWidgetScaling()),
                color: Theme.of(context).primaryColor,
                child: Text('No employees found', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
              ),
              Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                  height: MediaQuery.of(context).size.height/(12*globals.getWidgetScaling()),
                  color: Colors.white,
                  padding: EdgeInsets.all(12),
                  child: Text('Employee has not been in contact with anyone within the company recently.', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5))
              )
            ]
        );
      } else { //Else create and return a list
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemCount: numberOfEmployees,
            itemBuilder: (context, index) { //Display a list tile FOR EACH permission in permissions[]
              return ListTile(
                title: Column(
                    children:[
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height/24,
                        color: Theme.of(context).primaryColor,
                        child: Text('Employee ID: ' + users[index].userId),
                      ),
                      ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                          children: <Widget>[
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('Employee name: ' + users[index].firstName + ' ' + users[index].lastName, style: TextStyle(color: Colors.black)),
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('Date: 1 August 2021', style: TextStyle(color: Colors.black)),
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            ),
                          ]
                      )
                    ]
                ),
                //title: floors[index].floor()
              );
            }
        );
      }
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Notify employees'),
                    onPressed: (){
                      if (numberOfEmployees == 0){
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("No employees found")));
                      }
                      else {
                        showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Warning'),
                              content: Text('Are you sure you want to notify ' + numberOfEmployees.toString() + ' employees?'),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: Text('Yes'),
                                  onPressed: (){
                                    Navigator.of(ctx).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(numberOfEmployees.toString() + " employees notified")));
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
                                text: 'Employee name: ' + firstName + ' ' + lastName
                            ),
                            pw.Bullet(
                                text: 'Employee number: 1234'
                            ),
                            pw.Bullet(
                                text: 'Employee email address: email@email.com'
                            ),
                            pw.SizedBox(
                              width: 500,
                              child: pw.Divider(color: PdfColors.grey, thickness: 1.5),
                            ),
                            pw.Bullet(
                                text: 'Date: 1 August 2021'
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
              child: Column(
                children: [
                  Container(
                    height: 110,
                    color: Colors.white,
                    child: Text(firstName + ' ' + lastName + ' (ID ' + id + ') has come into contact with the following employees over the past month:', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                  ),
                  getList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}