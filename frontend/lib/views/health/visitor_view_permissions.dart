import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pdf/pdf.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/health/visitor_home_health.dart';

import 'package:frontend/controllers/pdf_helpers.dart' as pdfHelpers;
import 'package:frontend/views/global_widgets.dart' as globalWidgets;
import 'package:frontend/globals.dart' as globals;

class VisitorViewPermissions extends StatefulWidget {
  static const routeName = "/visitor_view_permissions";

  @override
  _VisitorViewPermissionsState createState() => _VisitorViewPermissionsState();
}

class _VisitorViewPermissionsState extends State<VisitorViewPermissions> {
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

    //Load fonts from assets and initialize PDF
    pdfHelpers.loadPDFFonts().then((result) {
      myTheme = result;
    });
    pdf = pw.Document(
      theme: myTheme,
    );

     Widget getList(){
      int numOfPermissions = 0;
      if (globals.currentPermissions != null) {
        numOfPermissions = globals.currentPermissions.length;
      }

       if(numOfPermissions == 0) {
         return Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               SizedBox(
                 height: MediaQuery.of(context).size.height /
                     (5 * globals.getWidgetScaling()),
               ),
               globalWidgets.notFoundMessage(context, 'No permissions found', 'No permissions have been assigned to you.')
             ]
         );
       } else {
         return ListView.builder(
             padding: const EdgeInsets.all(16),
             shrinkWrap: true,
             itemCount: numOfPermissions,
             itemBuilder: (context, index) { //Display a list tile FOR EACH permission in permissions[]
               return ListTile(
                 title: Column(
                     children:[
                       (globals.currentPermissions[index].getOfficeAccess() == true) ? Container(
                         alignment: Alignment.center,
                         height: 50,
                         width: MediaQuery.of(context).size.width,
                         color: globals.firstColor,
                         child: Text('Office access granted', style: TextStyle(
                           color: Colors.white,
                           fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5),
                         ),
                       ) : Container(
                         alignment: Alignment.center,
                         height: 50,
                         width: MediaQuery.of(context).size.width,
                         color: globals.sixthColor,
                         child: Text('Office access denied', style: TextStyle(
                           color: Colors.white,
                           fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5),
                         ),
                       ),
                       ListView(
                           shrinkWrap: true,
                           physics: NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                           children: <Widget>[
                             (globals.currentPermissions[index].getOfficeAccess() == true) ? Container(
                               height: 220,
                               color: Colors.white,
                               child: SingleChildScrollView(
                                 child: Column(
                                   children: [
                                     Icon(
                                       Icons.check_circle_rounded,
                                       color: globals.firstColor,
                                       size: 100,
                                     ),
                                     ElevatedButton(
                                         style: ElevatedButton.styleFrom (
                                           primary: globals.firstColor,
                                           shape: RoundedRectangleBorder(
                                             borderRadius: BorderRadius.circular(10),
                                           ),
                                         ),
                                         child: Text('Generate QR'),
                                         onPressed: () async {
                                           ByteData byteData = await QrPainter(data: "123456789", version: QrVersions.auto).toImageData(200.0);
                                           showDialog(
                                               context: context,
                                               builder: (ctx) => AlertDialog(
                                                 title: Text('QR access code'),
                                                 content: Container(
                                                   color: Colors.white,
                                                   height: 300,
                                                   child: Column(
                                                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                     children: [
                                                       Image.memory(byteData.buffer.asUint8List()),
                                                       IconButton(
                                                         color: globals.firstColor,
                                                         icon: Icon(Icons.save_alt),
                                                         iconSize: 40,
                                                         onPressed: () {
                                                           saveQRCode(globals.currentPermissions[index].getPermissionId(), byteData.buffer.asUint8List());
                                                           Navigator.of(context).pop();
                                                         },
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
                                     SizedBox(
                                       height: MediaQuery.of(context).size.height/70,
                                     ),
                                     ElevatedButton(
                                         style: ElevatedButton.styleFrom (
                                           primary: globals.firstColor,
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
                                                         color: globals.firstColor,
                                                         size: 100,
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
                                     SizedBox(
                                       height: MediaQuery.of(context).size.height/70,
                                     ),
                                   ],
                                 ),
                               ),
                             ) : Container(),
                             (globals.currentPermissions[index].getOfficeAccess() == false) ? Container(
                               height: 220,
                               color: Colors.white,
                               child: SingleChildScrollView(
                                 child: Column(
                                   children: [
                                     SizedBox(
                                       height: 30,
                                     ),
                                     Icon(
                                       Icons.no_accounts_outlined,
                                       color: globals.sixthColor,
                                       size: 100,
                                     ),
                                     Container(
                                       height: 50,
                                       color: Colors.white,
                                       child: Text('Date: ' + globals
                                           .currentPermissions[index].getTimestamp()),
                                       padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                     ),
                                   ],
                                 ),
                               ),
                             ) : Container(),
                           ]
                       )
                     ]
                 ),
               );
             }
         );
       }

     }
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Permissions'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(VisitorHealth.routeName);
              },
            ),
          ),
          body: Stack (
              children: <Widget>[
                SingleChildScrollView(
                  child: Center (
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
              ]
          )
      ),
    );
  }
}