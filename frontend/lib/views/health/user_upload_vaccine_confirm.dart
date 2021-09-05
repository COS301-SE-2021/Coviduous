import 'dart:io';
import 'dart:math';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/health/user_home_health.dart';
import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/health/user_view_vaccine_confirm.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/health/health_helpers.dart' as healthHelpers;
import 'package:frontend/globals.dart' as globals;

class UserUploadVaccineConfirm extends StatefulWidget {
  static const routeName = "/user_upload_vaccine_confirm";

  @override
  _UserUploadVaccineConfirmState createState() => _UserUploadVaccineConfirmState();
}

//Let user pick PDF from their device
class _UserUploadVaccineConfirmState extends State<UserUploadVaccineConfirm> {
  String fileName = "";
  String pickerFileName = "";
  List<int> fileBytes;

  Future getPdf() async {
    var rng = new Random();
    String randomName = "";
    for (var i = 0; i < 20; i++) {
      randomName += rng.nextInt(100).toString();
    }
    await Future.wait([
      FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf'])
    ]).then((results){
      if (kIsWeb) { //If web browser
        String platform = globals.getOSWeb();
        if (platform == "Android" || platform == "iOS") { //Check if mobile browser
          FilePickerResult result = results.first;
          if (result != null) {
            pickerFileName = results.first.names.first;
            File file = File(result.files.single.path);
            String tempFileName = '${randomName}.pdf';
            print(tempFileName);
            fileName = tempFileName;
            fileBytes = file.readAsBytesSync();
          }
        } else { //Else, PC browser
          FilePickerResult result = results.first;
          if (result != null) {
            pickerFileName = results.first.names.first;
            String tempFileName = '${randomName}.pdf';
            print(tempFileName);
            fileName = tempFileName;
            fileBytes = result.files.first.bytes;
          }
        }
      } else { //Else, mobile app
        FilePickerResult result = results.first;
        if (result != null) {
          pickerFileName = results.first.names.first;
          File file = File(result.files.single.path);
          String tempFileName = '${randomName}.pdf';
          print(tempFileName);
          fileName = tempFileName;
          fileBytes = file.readAsBytesSync();
        }
      }
      setState(() {});
    });
  }

  Future savePdf(List<int> asset, String name) async {
    //Upload the PDF to Firestore
    String fileBytes = base64Encode(asset);
    await healthHelpers.uploadVaccineConfirmation(name, fileBytes).then((result) {
      if (result == true) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("PDF successfully uploaded.")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error occurred while uploading PDF. Please try again later.")));
      }
    });
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

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Upload vaccine confirmation'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(UserHealth.routeName);
              },
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text(
                      'View uploaded files'
                  ),
                  onPressed: () {
                    healthHelpers.getVaccineConfirmations().then((result) {
                      if (result == true) {
                        Navigator.of(context).pushReplacementNamed(UserViewVaccineConfirm.routeName);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('An error occurred while retrieving your confirmation documents. Please try again later.')));
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Stack(
              children: <Widget>[
                Center(
                  child: SingleChildScrollView( //So the element doesn't overflow when you open the keyboard
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            color: globals.focusColor,
                            width: MediaQuery.of(context).size.width / (2 * globals.getWidgetScaling()),
                            padding: EdgeInsets.all(20),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Icon(Icons.cloud_upload,
                                        size: 100,
                                        color: Colors.white
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height / (36 * globals.getWidgetScaling()),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(
                                      'Selected file: ' + pickerFileName,
                                      style: TextStyle(color: Colors.white, fontSize:18),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height / (36 * globals.getWidgetScaling()),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                    crossAxisAlignment: CrossAxisAlignment.center, //Center row contents vertically
                                    children: <Widget>[
                                      ElevatedButton(
                                        child: Text(
                                            'Select a file'
                                        ),
                                        onPressed: () {
                                          getPdf();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        child: Text(
                                            'Submit'
                                        ),
                                        onPressed: () {
                                          if (fileBytes != null && fileBytes != "") {
                                            savePdf(fileBytes, fileName).then((result) {
                                              healthHelpers.getVaccineConfirmations().then((result) {
                                                Navigator.of(context).pushReplacementNamed(UserViewVaccineConfirm.routeName);
                                              });
                                            });
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text("Please upload a PDF.")));
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]
          )
      ),
    );
  }
}