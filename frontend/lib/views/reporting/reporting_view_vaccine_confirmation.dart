import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';
import 'package:frontend/views/reporting/reporting_view_recovered_employees.dart';

import 'package:frontend/globals.dart' as globals;

class ReportingViewVaccineConfirmation extends StatefulWidget {
  static const routeName = "/reporting_view_vaccine_confirmation";

  @override
  _ReportingViewVaccineConfirmationState createState() => _ReportingViewVaccineConfirmationState();
}

class _ReportingViewVaccineConfirmationState extends State<ReportingViewVaccineConfirmation> {
  int numberOfEmployees = 1;

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
      int numberOfResults = 1;

      print(numberOfResults);

      if (numberOfResults == 0) {
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
            child: Text('No vaccine confirmations found',
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
              child: Text('No vaccine confirmations have been uploaded by this user.',
                  style: TextStyle(
                      fontSize:
                      (MediaQuery.of(context).size.height * 0.01) * 2.5)))
        ]);
      } else {
        //Else create and return a list
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.all(16),
            itemCount: numberOfResults,
            itemBuilder: (context, index) {
              //Display a list tile FOR EACH room in rooms[]
              return ListTile(
                title: Column(children: [
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    color: Theme.of(context).primaryColor,
                    child: Text('Employee ID '),
                  ),
                  ListView(
                      shrinkWrap: true,
                      physics:
                      NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                      children: <Widget>[
                        Container(
                          color: Colors.white,
                          child: Text('Vaccine Confirmation: 1 '),
                        ),
                        Container(
                          height: 50,
                          color: Colors.white,
                          child: Text('DATE: '),
                        ),
                        Container(
                          height: 50,
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  child: Text('View'),
                                  onPressed: () {
                                    ///will show pdf of vaccine confirmations.
                                  }),
                            ],
                          ),
                        ),
                      ])
                ]),
              );
            });
      }
    }
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title:
          Text("View vaccine confirmation"),
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