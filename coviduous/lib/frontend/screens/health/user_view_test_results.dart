import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:coviduous/frontend/screens/admin_homepage.dart';
import 'package:coviduous/frontend/screens/health/user_home_health.dart';
import 'package:coviduous/frontend/screens/health/user_upload_test_results.dart';
import 'package:coviduous/frontend/screens/login_screen.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

import 'package:coviduous/frontend/front_end_globals.dart' as globals;

class UserViewTestResults extends StatefulWidget {
  static const routeName = "/user_view_test_results";

  @override
  _UserViewTestResultsState createState() => _UserViewTestResultsState();
}

class _UserViewTestResultsState extends State<UserViewTestResults> {
  final pdfController = PdfController(
    document: PdfDocument.openAsset('assets/sample.pdf'),
  );

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.loggedInUserType != 'User') {
      if (globals.loggedInUserType == 'Admin') {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
        });
      } else {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
        });
      }
      return Container();
    }

    Widget getList() {
      if (!globals.testResultsExist) { //If COVID test results have not been uploaded yet
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                height: MediaQuery.of(context).size.height/(24*globals.getWidgetScaling()),
                color: Theme.of(context).primaryColor,
                child: Text('No test results found', style: TextStyle(color: Colors.white, fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
              ),
              Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                  height: MediaQuery.of(context).size.height/(12*globals.getWidgetScaling()),
                  color: Colors.white,
                  padding: EdgeInsets.all(12),
                  child: Text('Please upload your COVID-19 test results.', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5))
              )
            ]
        );
      } else { //Else, return a container showing the company guidelines
        return Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width/(1.5*globals.getWidgetScaling()),
            height: MediaQuery.of(context).size.height/(1.5*globals.getWidgetScaling()),
            color: Colors.white,
            child: PdfView(
              documentLoader: Center(child: CircularProgressIndicator()),
              pageLoader: Center(child: CircularProgressIndicator()),
              controller: pdfController,
            ),
        );
      }
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: new Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('View COVID-19 test results'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(UserHealth.routeName);
              },
            ),
          ),
          body: Stack (
              children: <Widget>[
                Center (
                    child: getList()
                ),
                Container (
                  alignment: Alignment.bottomRight,
                  child: Container (
                      height: 50,
                      width: 200,
                      padding: EdgeInsets.all(10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom (
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Upload new PDF'),
                        onPressed: (){
                          Navigator.of(context).pushReplacementNamed(UserUploadTestResults.routeName);
                        },
                      )
                  ),
                ),
              ]
          )
      ),
    );
  }
}