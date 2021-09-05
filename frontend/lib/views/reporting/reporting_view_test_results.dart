import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:frontend/views/reporting/reporting_view_single_test_result.dart';

import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';
import 'package:frontend/views/reporting/reporting_view_recovered_employees.dart';

import 'package:frontend/globals.dart' as globals;

class ReportingViewTestResults extends StatefulWidget {
  static const routeName = "/reporting_view_test_results";

  @override
  _ReportingViewTestResultsState createState() => _ReportingViewTestResultsState();
}

class _ReportingViewTestResultsState extends State<ReportingViewTestResults> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(ReportingViewRecoveredEmployees.routeName);
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
    Widget getList() {
      int numberOfResults = globals.currentTestResults.length;
      print(numberOfResults);

      if (numberOfResults == 0) {
        return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                  width: MediaQuery.of(context).size.width /
                      (2 * globals.getWidgetScaling()),
                  height: MediaQuery.of(context).size.height /
                      (24 * globals.getWidgetScaling()),
                  color: Theme.of(context).primaryColor,
                  child: Text('No test results found',
                      style: TextStyle(color: Colors.white,
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
                    child: Text('No tests have been uploaded by this user.',
                        style: TextStyle(
                            fontSize:
                            (MediaQuery.of(context).size.height * 0.01) * 2.5
                        )
                    )
                ),
              ],
            ),
          )
        ]);
      } else {
        //Else create and return a list
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: numberOfResults,
            itemBuilder: (context, index) {
              return ListTile(
                title: Container(
                  color: Colors.white,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children:[
                        Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height/6,
                              child: Image(image: AssetImage('assets/images/placeholder-pdf.png')),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
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
                                                Text(globals.currentTestResults[index].getTimestamp())
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            ElevatedButton(
                                              child: Text('View'),
                                              onPressed: () {
                                                globals.currentTestResult = globals.currentTestResults[index];
                                                Navigator.of(context).pushReplacementNamed(ReportingViewSingleTestResult.routeName);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]
                          ),
                        ),
                      ]
                  ),
                ),
              );
            });
      }
    }
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title:
          Text("View COVID-19 test results"),
          leading: BackButton(
            //Specify back button
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(ReportingViewRecoveredEmployees.routeName);
            },
          ),
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Center(
                child: getList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}