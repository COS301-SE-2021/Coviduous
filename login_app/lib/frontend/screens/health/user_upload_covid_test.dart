import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:login_app/frontend/screens/health/user_home_health.dart';
import 'package:login_app/frontend/screens/admin_homepage.dart';
import 'package:login_app/frontend/screens/login_screen.dart';

import 'package:login_app/frontend/front_end_globals.dart' as globals;

class UserUploadTestResults extends StatefulWidget {
  static const routeName = "/user_upload_test_results";

  @override
  _UserUploadTestResultsState createState() => _UserUploadTestResultsState();
}

//Let user pick PDF from their device
class _UserUploadTestResultsState extends State<UserUploadTestResults> {
  Future getPdf() async {
    var rng = new Random();
    String randomName = "";
    for (var i = 0; i < 20; i++) {
      print(rng.nextInt(100));
      randomName += rng.nextInt(100).toString();
    }
    List<FilePickerResult> results = await Future.wait([
        FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf'])
    ]);
    FilePickerResult result = results.first;
    if (result != null) {
      File file = File(result.files.single.path);
      String fileName = '${randomName}.pdf';
      print(fileName);
      print('${file.readAsBytesSync()}');
      savePdf(file.readAsBytesSync(), fileName);
    }
  }

  Future savePdf(List<int> asset, String name) async {
    //Upload the PDF to Firebase Cloud Storage
    documentFileUpload("Test URL.pdf");
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
    return;
  }

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.type != 'User') {
      if (globals.type == 'Admin') {
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

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Upload COVID-19 test results'),
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
                    child: Container(
                      color: Colors.white,
                      height: MediaQuery.of(context).size.height/(3*globals.getWidgetScaling()),
                      width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                      padding: EdgeInsets.all(16),
                      child: SingleChildScrollView(
                          child: Row(
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
                                  /*
                                  if (PDF exists) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("PDF successfully uploaded")));
                                    Navigator.of(context).pushReplacementNamed(UserViewTestResults.routeName);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Please upload a PDF")));
                                  }
                                   */

                                  /*
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("PDF successfully uploaded")));
                                  Navigator.of(context).pushReplacementNamed(UserViewTestResults.routeName);
                                   */
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              )
                            ],
                          )
                      ),
                    ),
                  ),
                ),
              ]
          )
      ),
    );
  }
}