import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:frontend/views/reporting/reporting_health.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';
import 'package:frontend/models/user/sick_user.dart';

import 'package:frontend/controllers/pdf_helpers.dart' as pdfHelpers;
import 'package:frontend/globals.dart' as globals;

class ReportingViewSickEmployees extends StatefulWidget {
  static const routeName = "/reporting_view_sick_employees";

  @override
  _ReportingViewSickEmployeesState createState() => _ReportingViewSickEmployeesState();
}

class _ReportingViewSickEmployeesState extends State<ReportingViewSickEmployees> {
  pw.ThemeData myTheme;
  var pdf;

  int numberOfEmployees = globals.selectedSickUsers.length;
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
      List<SickUser> users = globals.selectedSickUsers;

      employeeList.clear();
      employeeList.add(<String>['Employee ID', 'Email', 'Time of diagnosis']);
      for (int i = 0; i < users.length; i++) {
        List<String> employeeInfo = <String>[
          users[i].getUserId(), users[i].getEmail(), users[i].getTimeOfDiagnosis()
        ];
        employeeList.add(employeeInfo);
      }

      if (numberOfEmployees == 0) { //If the number of bookings = 0, don't display a list
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height /
                    (5 * globals.getWidgetScaling()),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Column(
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
                    ),
                  ],
                ),
              )
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
                              image: AssetImage('assets/images/placeholder-profile-image.png'),
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
                                              Text(globals.selectedSickUsers[index].getTimeOfDiagnosis()),
                                              SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Text(globals.selectedSickUsers[index].getEmail())
                                              ),
                                              SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Text(globals.selectedSickUsers[index].getUserId())
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
      child: new Scaffold(
          appBar: AppBar(
            title: Text('View sick employees'),
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
                      if (globals.selectedSickUsers.length > 0) {
                        //Create PDF
                        pdf.addPage(pw.MultiPage(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            pageFormat: PdfPageFormat.a4,
                            orientation: pw.PageOrientation.portrait,
                            build: (pw.Context context) => <pw.Widget>[
                              pw.Header(
                                level: 0,
                                title: 'Coviduous - Sick report',
                                child: pw.Text('Coviduous - Sick report', textScaleFactor: 2),
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
                            pdfHelpers.savePDFMobile(pdf, 'report_sick_' + globals.selectedSickUsers[0].getCompanyId() + '.pdf');
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("PDF file saved to downloads folder")));
                          } else { //Else, PC web browser
                            pdfHelpers.savePDFWeb(pdf, 'report_sick_' + globals.selectedSickUsers[0].getCompanyId() + '.pdf');
                          }
                        } else { //Else, mobile app
                          pdfHelpers.savePDFMobile(pdf, 'report_sick_' + globals.selectedSickUsers[0].getCompanyId() + '.pdf');
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
                SingleChildScrollView(
                  child: Center(
                      child: getList()
                  ),
                ),
              ]
          )
      ),
    );
  }
}