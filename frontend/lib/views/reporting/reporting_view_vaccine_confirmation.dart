import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/reporting/reporting_view_single_vaccine_confirmation.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';
import 'package:frontend/views/reporting/reporting_view_recovered_employees.dart';

import 'package:frontend/views/global_widgets.dart' as globalWidgets;
import 'package:frontend/globals.dart' as globals;

class ReportingViewVaccineConfirmation extends StatefulWidget {
  static const routeName = "/reporting_view_vaccine_confirmations";

  @override
  _ReportingViewVaccineConfirmationState createState() => _ReportingViewVaccineConfirmationState();
}

class _ReportingViewVaccineConfirmationState extends State<ReportingViewVaccineConfirmation> {
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
      int numberOfConfirmations = globals.currentVaccineConfirmations.length;
      print(numberOfConfirmations);

      if (numberOfConfirmations == 0) {
        return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / (5 * globals.getWidgetScaling()),
          ),
          globalWidgets.notFoundMessage(context, 'No vaccine confirmations found', 'No confirmations have been uploaded by this user.')
        ]);
      } else {
        //Else create and return a list
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: numberOfConfirmations,
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
                                                Text(globals.currentVaccineConfirmations[index].getTimestamp())
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
                                                globals.currentVaccineConfirmation = globals.currentVaccineConfirmations[index];
                                                Navigator.of(context).pushReplacementNamed(ReportingViewSingleVaccineConfirmation.routeName);
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
                child: (globals.getIfOnPC())
                    ? Container(
                      width: 640,
                      child: getList(),
                )
                    : Container(
                      child: getList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}