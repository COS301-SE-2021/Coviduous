import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pdf/pdf.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/health/user_home_health.dart';
import 'package:frontend/views/health/user_request_access_shifts.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/pdf_helpers.dart' as pdfHelpers;
import 'package:frontend/controllers/health/health_helpers.dart' as healthHelpers;
import 'package:frontend/globals.dart' as globals;

class UserViewPermissions extends StatefulWidget {
  static const routeName = "/user_view_permissions";

  @override
  _UserViewPermissionsState createState() => _UserViewPermissionsState();
}

class _UserViewPermissionsState extends State<UserViewPermissions> {
  pw.ThemeData myTheme;
  var pdf;

  saveQRCode(String permissionId, Uint8List bytes) {
    pw.MemoryImage QRCodeImage = new pw.MemoryImage(bytes);

    //Create PDF
    pdf.addPage(pw.MultiPage(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        pageFormat: PdfPageFormat.a4,
        orientation: pw.PageOrientation.portrait,
        build: (pw.Context context) => <pw.Widget>[
          pw.Header(
            level: 0,
            title: 'Coviduous - Permission QR code',
            child: pw.Text('Coviduous - Permission QR code', textScaleFactor: 2),
          ),
          pw.Bullet(
            text: 'Company ID: ' + globals.loggedInCompanyId,
          ),
          pw.SizedBox(
            width: 500,
            child: pw.Divider(color: PdfColors.grey, thickness: 1.5),
          ),
          pw.Image(
              QRCodeImage
          ),
        ]
    ));

    //Save PDF
    if (kIsWeb) { //If web browser
      String platform = globals.getOSWeb();
      if (platform == "Android" || platform == "iOS") { //Check if mobile browser
        pdfHelpers.savePDFMobile(pdf, 'qr_code_' + globals.loggedInCompanyId + '.pdf');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("PDF file saved to downloads folder")));
      } else { //Else, PC web browser
        pdfHelpers.savePDFWeb(pdf, 'qr_code_' + permissionId + '.pdf');
      }
    } else { //Else, mobile app
      pdfHelpers.savePDFMobile(pdf, 'qr_code_' + permissionId + '.pdf');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("PDF file saved to downloads folder")));
    }
  }

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

    //Load fonts from assets and initialize PDF
    pdfHelpers.loadPDFFonts().then((result) {
      myTheme = result;
    });
    pdf = pw.Document(
      theme: myTheme,
    );

    Widget getList() {
      int numOfPermissions = 0;
      if (globals.currentPermissions != null) {
        numOfPermissions = globals.currentPermissions.length;
      }
      if (numOfPermissions == 0) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                height: MediaQuery.of(context).size.height/(24*globals.getWidgetScaling()),
                color: Theme.of(context).primaryColor,
                child: Text('No permissions granted', style: TextStyle(color: Colors.white,
                    fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
              ),
              Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                  height: MediaQuery.of(context).size.height/(12*globals.getWidgetScaling()),
                  color: Colors.white,
                  padding: EdgeInsets.all(12),
                  child: Text('No permissions have been granted to you.', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5))
              )
            ]
        );
      } else { //Else create and return a list
        return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: numOfPermissions,
            itemBuilder: (context, index) { //Display a list tile FOR EACH permission in permissions[]
              return ListTile(
                title: Column(
                    children:[
                      (globals.currentPermissions[index].getOfficeAccess() == true) ? Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.green,
                        child: Text('Access granted', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
                      ) : Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.redAccent,
                        child: Text('Access denied', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
                      ),
                      ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                          children: <Widget>[
                            (globals.currentPermissions[index].getOfficeAccess() == true) ? Container(
                              height: 200,
                              color: Colors.white,
                                child: new SingleChildScrollView(
                                  child: new Column(
                                  children: [
                                    Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.greenAccent,
                                      size: 100.0,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom (
                                        primary: Colors.green,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text('Generate QR'),
                                      onPressed: () async {
                                        ByteData byteData = await QrPainter(data: "123456789", version: QrVersions.auto).toImageData(200.0);
                                        saveQRCode(globals.currentPermissions[index].getPermissionId(), byteData.buffer.asUint8List());
                                      }),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom (
                                        primary: Colors.green,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text('View details'),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: Text('Permission information'),
                                              content: Container(
                                                color: Colors.white,
                                                height: 200,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Icon(
                                                      Icons.check_circle_rounded,
                                                      color: Colors.greenAccent,
                                                      size: 100.0,
                                                    ),
                                                    Container(
                                                      alignment: Alignment.center,
                                                      height: 50,
                                                      child: Text('Granted by: ' + globals
                                                          .currentPermissions[index].getGrantedBy(),
                                                          style: TextStyle(color: Colors.black)),
                                                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                                    ),
                                                    Container(
                                                      alignment: Alignment.center,
                                                      height: 50,
                                                      child: Text('Date: ' + globals
                                                          .currentPermissions[index].getTimestamp(),
                                                      style: TextStyle(color: Colors.black)),
                                                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text('Okay'),
                                                  onPressed: (){
                                                    Navigator.of(ctx).pop();
                                                  },
                                                )
                                              ],
                                            )
                                        );
                                      }),
                                ],
                              ),
                                ),
                            ) : Container(),
                            (globals.currentPermissions[index].getOfficeAccess() == false) ? Container(
                              height: 200,
                              color: Colors.white,
                              child: new SingleChildScrollView(
                                child: new Column(
                                children: [
                                  Icon(
                                    Icons.no_accounts_outlined,
                                    color: Colors.redAccent,
                                    size: 100.0,
                                  ),
                                  Container(
                                    height: 50,
                                    color: Colors.white,
                                    child: Text('Date: ' + globals
                                        .currentPermissions[index].getTimestamp()),
                                    padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom (
                                        primary: Colors.redAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text('Request access'),
                                      onPressed: () {
                                        globals.currentPermissionId = globals.currentPermissions[index].getPermissionId();
                                        healthHelpers.viewShifts(globals.loggedInUserEmail).then((result) {
                                          if (result == true) {
                                            Navigator.of(context).pushReplacementNamed(UserRequestAccessShifts.routeName);
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text("An error occurred while submitting the request. Please try again later.")));
                                          }
                                        });
                                      }),
                                ],
                              ),
                              ),
                            ) : Container(),
                          ]
                      )
                    ]
                ),
                //title: floors[index].floor()
              );
            }
        );
      }
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
          appBar: AppBar(
            title: Text('Permissions'),
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
              ]
          )
      ),
    );
  }
}

