import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/health/visitor_home_health.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/user_homepage.dart';

import 'package:frontend/views/global_widgets.dart' as globalWidgets;
import 'package:frontend/globals.dart' as globals;

class VisitorViewGuidelines extends StatefulWidget {
  static const routeName = "/visitor_view_guidelines";

  @override
  _VisitorViewGuidelinesState createState() => _VisitorViewGuidelinesState();
}

class _VisitorViewGuidelinesState extends State<VisitorViewGuidelines> {
  final pdfController = PdfController(
     document: PdfDocument.openAsset('assets/za-covid-guidelines.pdf'),
   );

  int currentPage = 1;
  int totalPages = 1;

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(VisitorHealth.routeName);
    return (await true);
  }

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.loggedInUserType == 'ADMIN') {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
      });
      return Container();
    } else if (globals.loggedInUserType == 'USER') {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.of(context).pushReplacementNamed(UserHomePage.routeName);
      });
      return Container();
    }

    Widget getList() {
       if (!globals.companyGuidelinesExist) { //If company guidelines have not been uploaded yet
         return globalWidgets.notFoundMessage(context, 'No company guidelines found', 'Company guidelines have not been uploaded yet. Please try again later.');
       } else {
         //Else, return a container showing the company guidelines
         return Container(
           alignment: Alignment.center,
           width: (!globals.getIfOnPC())
               ? MediaQuery.of(context).size.width
               : MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
           color: Colors.white,
           child: PdfView(
             documentLoader: Center(child: CircularProgressIndicator()),
             pageLoader: Center(child: CircularProgressIndicator()),
             onDocumentLoaded: (PdfDocument doc) {
               setState(() {
                 totalPages = doc.pagesCount;
               });
               },
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
                  Navigator.of(context).pushReplacementNamed(VisitorHealth.routeName);
                },
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        pdfController.previousPage(duration: Duration(milliseconds: 250), curve: Curves.easeIn);
                        setState(() {
                          if (currentPage < pdfController.pagesCount) {
                            currentPage--;
                          }
                        });
                        },
                    ),
                    Text(
                      'Page ' + currentPage.toString() + '/' + totalPages.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: (!globals.getIfOnPC())
                              ? MediaQuery.of(context).size.width * 0.01 * 4
                              : MediaQuery.of(context).size.width * 0.01
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