import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:frontend/views/reporting/reporting_health.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';
import 'package:frontend/views/reporting/reporting_view_test_results.dart';
import 'package:frontend/views/reporting/reporting_view_vaccine_confirmation.dart';
import 'package:frontend/models/user/recovered_user.dart';

import 'package:frontend/controllers/pdf_helpers.dart' as pdfHelpers;
import 'package:frontend/globals.dart' as globals;

class ReportingViewRecoveredEmployees extends StatefulWidget {
  static const routeName = "/reporting_view_recovered_employees";

  @override
  _ReportingViewRecoveredEmployeesState createState() => _ReportingViewRecoveredEmployeesState();
}

class _ReportingViewRecoveredEmployeesState extends State<ReportingViewRecoveredEmployees> {
  pw.ThemeData myTheme;
  var pdf;

  int numberOfEmployees = globals.selectedRecoveredUsers.length;
  List<List<String>> employeeList = [];

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(ReportingHealth.routeName);
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
    pdfHelpers.loadPDFFonts().then((result) {
      myTheme = result;
    });
    pdf = pw.Document(
      theme: myTheme,
    );

    Widget getList() {
      List<RecoveredUser> users = globals.selectedRecoveredUsers;

      employeeList.clear();
      employeeList.add(<String>['Employee ID', 'Email', 'Recovered time']);
      for (int i = 0; i < users.length; i++) {
        List<String> employeeInfo = <String>[
          users[i].getUserId(), users[i].getEmail(), users[i].getRecoveredTime()
        ];
        employeeList.add(employeeInfo);
      }

      if (numberOfEmployees == 0) { //If the number of bookings = 0, don't display a list
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                height: MediaQuery.of(context).size.height/(24*globals.getWidgetScaling()),
                color: Theme.of(context).primaryColor,
                child: Text('No employee health status found', style: TextStyle(color: Colors.white,
                    fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
              ),
              Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                  height: MediaQuery.of(context).size.height/(12*globals.getWidgetScaling()),
                  color: Colors.white,
                  padding: EdgeInsets.all(12),
                  child: Text('No health statuses available.', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5))
              )
            ]
        );
      } else { //Else create and return a list
        return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: numberOfEmployees,
            itemBuilder: (context, index) { //Display a list tile FOR EACH booking in bookings[]
              return ListTile(
                title: Column(
                    children:[
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        color: Theme.of(context).primaryColor,
                        child: Text('Employee ' + globals.selectedRecoveredUsers[index].getUserId(), style: TextStyle(color: Colors.white)),
                      ),
                      ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                          children: <Widget>[
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('Email: ' + globals.selectedRecoveredUsers[index].getEmail()),
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('Recovered time: ' + globals.selectedRecoveredUsers[index].getRecoveredTime()),
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom (
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text('View test results'),
                                      onPressed: () {
                                        Navigator.of(context).pushReplacementNamed(ReportingViewTestResults.routeName);
                                      }),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom (
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text('View vaccine confirmation'),
                                      onPressed: () {
                                        Navigator.of(context).pushReplacementNamed(ReportingViewVaccineConfirmation.routeName);
                                      }),
                                ],
                              ),
                            ),
                          ]
                      )
                    ]
                ),
              );
            }
        );
      }
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
          appBar: AppBar(
            title: Text('View recovered employees'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(ReportingHealth.routeName);
              },
            ),
          ),
          bottomNavigationBar: BottomAppBar(
              child: Container(
                alignment: Alignment.bottomCenter,
                height: 50,
                padding: EdgeInsets.all(10),
                child:  ElevatedButton(
                    child: Text('Generate PDF report'),
                    onPressed: () {
                      if (globals.selectedRecoveredUsers.length > 0) {
                        //Create PDF
                        pdf.addPage(pw.MultiPage(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            pageFormat: PdfPageFormat.a4,
                            orientation: pw.PageOrientation.portrait,
                            build: (pw.Context context) => <pw.Widget>[
                              pw.Header(
                                level: 0,
                                title: 'Coviduous - Recovery report',
                                child: pw.Text('Coviduous - Recovery report', textScaleFactor: 2),
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
                            pdfHelpers.savePDFMobile(pdf, 'report_recovered_' + globals.selectedRecoveredUsers[0].getCompanyId() + '.pdf');
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("PDF file saved to downloads folder")));
                          } else { //Else, PC web browser
                            pdfHelpers.savePDFWeb(pdf, 'report_recovered_' + globals.selectedRecoveredUsers[0].getCompanyId() + '.pdf');
                          }
                        } else { //Else, mobile app
                          pdfHelpers.savePDFMobile(pdf, 'report_recovered_' + globals.selectedRecoveredUsers[0].getCompanyId() + '.pdf');
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("PDF file saved to downloads folder")));
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("PDF report cannot be created with an empty list of employees.")));
                      }
                    }),
              )
          ),
          body: Stack(
              children: <Widget>[
                Center(
                   child: getList()
                ),
              ]
          )
      ),
    );
  }
}