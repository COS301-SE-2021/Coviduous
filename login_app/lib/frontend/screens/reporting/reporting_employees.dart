import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/services.dart';
import 'package:login_app/subsystems/user_subsystem/user.dart';
import 'package:pdf/pdf.dart';
import 'package:universal_html/html.dart' as html;
import 'package:pdf/widgets.dart' as pw;

import 'package:login_app/frontend/screens/reporting/reporting_shifts.dart';
import 'package:login_app/frontend/screens/user_homepage.dart';
import 'package:login_app/frontend/screens/login_screen.dart';

import 'package:login_app/frontend/front_end_globals.dart' as globals;

class ReportingEmployees extends StatefulWidget {
  static const routeName = "/reporting_employees";
  @override
  ReportingEmployeesState createState() {
    return ReportingEmployeesState();
  }
}

class ReportingEmployeesState extends State<ReportingEmployees> {
  var myTheme;
  var pdf;

  List<List<String>> employeeList = [];

  Future loadPDFFonts() async {
    var fontAssets = await Future.wait([
      rootBundle.load("assets/OpenSans-Regular.ttf"),
      rootBundle.load("assets/OpenSans-Bold.ttf"),
      rootBundle.load("assets/OpenSans-Bold.ttf"),
      rootBundle.load("assets/OpenSans-BoldItalic.ttf")
    ]);
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

    File file = File("${output.path}/report_shift_1234.pdf");
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
      ..download = 'report_shift_1234.pdf';
    html.document.body.children.add(anchor);
    anchor.click();
    html.document.body.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.loggedInUserType != 'Admin') {
      if (globals.loggedInUserType == 'User') {
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

    //ShiftController services = new ShiftController();
    Widget getList() {
      //List<Shift> shifts = services.getShiftsForRoomNum(globals.currentRoomNumString);
      //List<User> users = shifts.getShift(globals.currentShiftNumString).getUsers();
      //int numOfUsers = users.length;
      int numOfUsers = 1;
      List<User> users = [
        new User("User", "John", "Smith", "smithj", "john.smith@email.com", "123456", "1"),
      ];

      employeeList.add(<String>['Employee ID', 'Name', 'Surname', 'Email']);
      for (int i = 0; i < users.length; i++) {
        List<String> employeeInfo = <String>[
          users[i].getId(), users[i].getFirstName(), users[i].getLastName(), users[i].getEmail()
        ];
        employeeList.add(employeeInfo);
      }

      print(numOfUsers);

      if (numOfUsers == 0) {
        return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            height: MediaQuery.of(context).size.height /
                (5 * globals.getWidgetScaling()),
          ),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width /
                (2 * globals.getWidgetScaling()),
            height: MediaQuery.of(context).size.height /
                (24 * globals.getWidgetScaling()),
            color: Theme.of(context).primaryColor,
            child: Text('No employees found',
                style: TextStyle(
                    color: Colors.white,
                    fontSize:
                    (MediaQuery.of(context).size.height * 0.01) * 2.5)),
          ),
          Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width /
                  (2 * globals.getWidgetScaling()),
              height: MediaQuery.of(context).size.height /
                  (12 * globals.getWidgetScaling()),
              color: Colors.white,
              padding: EdgeInsets.all(12),
              child: Text('No employees have been assigned to this shift.',
                  style: TextStyle(
                      fontSize:
                      (MediaQuery.of(context).size.height * 0.01) * 2.5)))
        ]);
      } else {
        //Else create and return a list
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemCount: numOfUsers,
            itemBuilder: (context, index) {
              //Display a list tile FOR EACH user in users[]
              return ListTile(
                title: Column(children: [
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 24,
                    color: Theme.of(context).primaryColor,
                    child: Text('User ' + (index + 1).toString(),
                        style: TextStyle(color: Colors.white)),
                  ),
                  ListView(
                      shrinkWrap: true,
                      physics:
                      NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                      children: <Widget>[
                        Container(
                          height: 50,
                          color: Colors.white,
                          child: Text(
                              'Name: ' + users[index].getFirstName() + ' ' + users[index].getLastName(),
                              style: TextStyle(color: Colors.black)),
                        ),
                        Container(
                          height: 50,
                          color: Colors.white,
                          child: Text(
                              'Email: ' + users[index].getEmail(),
                              style: TextStyle(color: Colors.black)),
                        ),
                      ])
                ]),
              );
            });
      }
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, //To show background image
        appBar: AppBar(
          title:
          Text("View office reports"),
          leading: BackButton(
            //Specify back button
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(ReportingShifts.routeName);
            },
          ),
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: [
                  getList(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 18,
                    width: MediaQuery.of(context).size.width,
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                  height: 50,
                  width: 130,
                  padding: EdgeInsets.all(10),
                  child:  ElevatedButton(
                      child: Text('Create PDF'),
                      onPressed: () {
                        //Create PDF
                        pdf.addPage(pw.MultiPage(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          pageFormat: PdfPageFormat.a4,
                          orientation: pw.PageOrientation.portrait,
                          build: (pw.Context context) => <pw.Widget>[
                            pw.Header(
                              level: 0,
                              title: 'Coviduous - Office report',
                              child: pw.Text('Coviduous - Office report', textScaleFactor: 2),
                            ),
                            pw.Bullet(
                              text: 'Floor plan number: 1'
                            ),
                            pw.Bullet(
                                text: 'Floor number: ' + globals.currentFloorNum
                            ),
                            pw.Bullet(
                                text: 'Room number: ' + globals.currentRoomNum
                            ),
                            pw.SizedBox(
                              width: 500,
                              child: pw.Divider(color: PdfColors.grey, thickness: 1.5),
                            ),
                            pw.Bullet(
                                text: 'Shift number: 1'
                            ),
                            pw.Bullet(
                                text: 'Date: 1 August 2021'
                            ),
                            pw.Bullet(
                                text: 'Time: 3:00 PM to 4:00 PM'
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
                      }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
