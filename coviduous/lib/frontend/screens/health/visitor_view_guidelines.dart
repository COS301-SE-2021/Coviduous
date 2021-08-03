import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:coviduous/frontend/screens/health/visitor_home_health.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:coviduous/frontend/screens/admin_homepage.dart';
import 'package:coviduous/frontend/screens/user_homepage.dart';

import 'package:coviduous/frontend/front_end_globals.dart' as globals;

class VisitorViewGuidelines extends StatefulWidget {
  static const routeName = "/visitor_view_guidelines";

  @override
  _VisitorViewGuidelinesState createState() => _VisitorViewGuidelinesState();
}

class _VisitorViewGuidelinesState extends State<VisitorViewGuidelines> {
  final pdfController = PdfController(
     document: PdfDocument.openAsset('assets/sample.pdf'),
   );

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.loggedInUserType == 'Admin') {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
      });
      return Container();
    } else if (globals.loggedInUserType == 'User') {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.of(context).pushReplacementNamed(UserHomePage.routeName);
      });
      return Container();
    }

    Widget getList() {
       if (!globals.companyGuidelinesExist) { //If company guidelines have not been uploaded yet
         return Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Container(
                 alignment: Alignment.center,
                 width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                 height: MediaQuery.of(context).size.height/(24*globals.getWidgetScaling()),
                 color: Theme.of(context).primaryColor,
                 child: Text('No company guidelines found', style: TextStyle(color: Colors.white, fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
               ),
               Container(
                   alignment: Alignment.center,
                   width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                   height: MediaQuery.of(context).size.height/(12*globals.getWidgetScaling()),
                   color: Colors.white,
                   padding: EdgeInsets.all(12),
                   child: Text('Your admin has not uploaded company guidelines yet. Please try again later.', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5))
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
            title: Text('Company guidelines'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(VisitorHealth.routeName);
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