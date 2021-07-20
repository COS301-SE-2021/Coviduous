import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
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
  final pdf = pw.Document();

  //Save PDF on mobile
  Future savePDFMobile() async {
    List<Directory> outputs;

    outputs = await Future.wait([
      DownloadsPathProvider.downloadsDirectory
    ]);
    Directory output = outputs.first;
    print(output.path);

    File file = File("${output.path}/example.pdf");
    await file.writeAsBytes(await pdf.save());
  }

  //Save PDF on web
  Future savePDFWeb() async {
    final bytes = await pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor =
    html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'example.pdf';
    html.document.body.children.add(anchor);
    anchor.click();
    html.document.body.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.type != 'Admin') {
      if (globals.type == 'User') {
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

    //ShiftController services = new ShiftController();
    Widget getList() {
      //List<Shift> shifts = services.getShiftsForRoomNum(globals.currentRoomNumString);
      //List<User> users = shifts.getShift(globals.currentShiftNumString).getUsers();
      //int numOfUsers = users.length;
      int numOfUsers = 1;

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
                              'Name: John Smith',
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
                        pdf.addPage(pw.Page(
                          pageFormat: PdfPageFormat.a4,
                          build: (pw.Context context) {
                            return pw.Center(
                              child: pw.Text("Test output")
                            );
                          }
                        ));

                        //Save PDF
                        if (kIsWeb) {
                          //If PC web browser
                          savePDFWeb();
                        } else {
                          //If mobile device
                          savePDFMobile();
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
