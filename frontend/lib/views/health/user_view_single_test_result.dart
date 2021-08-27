import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/health/user_view_test_results.dart';
import 'package:frontend/views/login_screen.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

import 'package:frontend/globals.dart' as globals;

class UserViewSingleTestResult extends StatefulWidget {
  static const routeName = "/user_view_single_test_result";

  @override
  _UserViewSingleTestResultState createState() => _UserViewSingleTestResultState();
}

class _UserViewSingleTestResultState extends State<UserViewSingleTestResult> {
  final pdfController = PdfController(
    document: PdfDocument.openData(base64Decode(globals.currentTestResult.getBytes())),
  );

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(UserViewTestResults.routeName);
    return (await true);
  }

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.loggedInUserType != 'USER') {
      if (globals.loggedInUserType == 'ADMIN') {
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
                child: Text('No test results found', style: TextStyle(color: Colors.white,
                    fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
              ),
              Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                  height: MediaQuery.of(context).size.height/(12*globals.getWidgetScaling()),
                  color: Colors.white,
                  padding: EdgeInsets.all(12),
                  child: Text('An error occurred while retrieving this test result document. Please try again later.', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5))
              )
            ]
        );
      } else { //Else, return a container showing the test results
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

    return WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
          appBar: AppBar(
            title: Text('View COVID-19 test results'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(UserViewTestResults.routeName);
              },
            ),
          ),
          body: Stack (
              children: <Widget>[
                Center (
                    child: getList()
                ),
              ]
          )
      ),
    );
  }
}