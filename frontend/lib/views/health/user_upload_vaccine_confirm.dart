import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/health/user_home_health.dart';
import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/health/user_view_vaccine_confirm.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/globals.dart' as globals;

class UserUploadVaccineConfirm extends StatefulWidget {
  static const routeName = "/user_upload_vaccine_confirm";

  @override
  _UserUploadVaccineConfirmState createState() => _UserUploadVaccineConfirmState();
}

//Let user pick PDF from their device
class _UserUploadVaccineConfirmState extends State<UserUploadVaccineConfirm> {
  Future getPdf() async {
    var rng = new Random();
    String randomName = "";
    for (var i = 0; i < 20; i++) {
      print(rng.nextInt(100));
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
            File file = File(result.files.single.path);
            String fileName = '${randomName}.pdf';
            print(fileName);
            print('${file.readAsBytesSync()}');
            savePdf(file.readAsBytesSync(), fileName);
          }
        } else { //Else, PC browser
          //Not sure what to do here
        }
      } else { //Else, mobile app
        FilePickerResult result = results.first;
        if (result != null) {
          File file = File(result.files.single.path);
          String fileName = '${randomName}.pdf';
          print(fileName);
          print('${file.readAsBytesSync()}');
          savePdf(file.readAsBytesSync(), fileName);
        }
      }
    });
  }

  Future savePdf(List<int> asset, String name) async {
    //Upload the PDF to Firebase Cloud Storage
    documentFileUpload("Test URL 2.pdf");
    return;
  }

  //Upload URL of the document to Firestore
  void documentFileUpload(String str) {
    CollectionReference users = FirebaseFirestore.instance.collection('Test Results');
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser.uid.toString();
    users.add({
      'uid': uid,
      'Document path': str,
    });
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(UserHealth.routeName);
    return (await true);
  }

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.loggedInUserType != 'User') {
      if (globals.loggedInUserType == 'Admin') {
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
          body: Stack(
              children: <Widget>[
                Center(
                  child: SingleChildScrollView( //So the element doesn't overflow when you open the keyboard
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width / (2 * globals.getWidgetScaling()),
                          height: MediaQuery.of(context).size.height / (24 * globals.getWidgetScaling()),
                          color: Theme.of(context).primaryColor,
                          child: Text(
                              'Upload your confirmation',
                              style: TextStyle(
                                fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5,
                              )
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width / (2 * globals.getWidgetScaling()),
                          height: MediaQuery.of(context).size.height / (4 * globals.getWidgetScaling()),
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height / (24 * globals.getWidgetScaling()),
                              ),
                              Text(
                                  'Please note that all documents must be uploaded in a PDF format.'
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / (24 * globals.getWidgetScaling()),
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
                                      globals.vaccineConfirmExists = true;
                                      if (globals.vaccineConfirmExists) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("PDF successfully uploaded")));
                                        Navigator.of(context).pushReplacementNamed(UserViewVaccineConfirm.routeName);
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("Please upload a PDF")));
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
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