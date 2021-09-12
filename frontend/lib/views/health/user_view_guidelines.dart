import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/health/user_home_health.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/globals.dart' as globals;

class UserViewGuidelines extends StatefulWidget {
  static const routeName = "/user_view_guidelines";

  @override
  _UserViewGuidelinesState createState() => _UserViewGuidelinesState();
}

class _UserViewGuidelinesState extends State<UserViewGuidelines> {
  final pdfController = PdfController(
    document: PdfDocument.openAsset('assets/za-covid-guidelines.pdf'),
  );

  int currentPage = 1;

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(UserHealth.routeName);
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
      if (!globals.companyGuidelinesExist) { //If company guidelines have not been uploaded yet
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                height: MediaQuery.of(context).size.height/(24*globals.getWidgetScaling()),
                color: Theme.of(context).primaryColor,
                child: Text('No company guidelines found', style: TextStyle(color: Colors.white,
                    fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
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

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Company guidelines'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(UserHealth.routeName);
              },
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      pdfController.previousPage(duration: Duration(milliseconds: 250), curve: Curves.easeIn);
                      setState(() {
                        if (currentPage > 1) {
                          currentPage--;
                        }
                      });
                    },
                  ),
                  Text(
                    'Page ' + currentPage.toString() + '/' + pdfController.pagesCount.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.01 * 4
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      pdfController.nextPage(duration: Duration(milliseconds: 250), curve: Curves.easeIn);
                      setState(() {
                        if (currentPage < pdfController.pagesCount) {
                          currentPage++;
                        }
                      });
                    },
                  ),
                ]
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