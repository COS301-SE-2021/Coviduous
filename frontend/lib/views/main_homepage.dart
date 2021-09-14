import 'package:flutter/material.dart';

import 'package:frontend/views/login_screen.dart';
import 'health/visitor_home_health.dart';

import 'package:frontend/controllers/image_helpers.dart' as imageHelpers;
import 'package:frontend/globals.dart' as globals;

class HomePage extends StatefulWidget {
  static const routeName = "/home";
  @override
  _HomePageState createState() => _HomePageState();
}

final _transformationController = TransformationController();
TapDownDetails _doubleTapDetails;

class _HomePageState extends State<HomePage>{
  _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails.localPosition;

      //Zoom 2x
      _transformationController.value = Matrix4.identity()
        ..translate(-position.dx, -position.dy)
        ..scale(2.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, //Prevent the back button from working
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff251F34),
            elevation: 0,
            automaticallyImplyLeading: false, //Back button will not show up in app bar
          ),
          body: Stack(
            children: [
              Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/city-silhouette.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
              ),
              Center(
                child: Column (
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container (
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(20.0),
                        child: Image(
                          alignment: Alignment.center,
                          image: AssetImage('assets/images/logo.png'),
                          color: Colors.white,
                          width: double.maxFinite,
                          height: MediaQuery.of(context).size.height/8,
                        ),
                      ),
                      SizedBox (
                        height: MediaQuery.of(context).size.height/48,
                        width: MediaQuery.of(context).size.width,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width/(1.8*globals.getWidgetWidthScaling()),
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height/16,
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom (
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text('Company member'),
                                  onPressed:() {
                                    Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
                                  }
                              ),
                            ),
                            SizedBox (
                              height: MediaQuery.of(context).size.height/30,
                              width: MediaQuery.of(context).size.width,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height/16,
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom (
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text('Visitor'),
                                  onPressed:() {
                                    Navigator.of(context).pushReplacementNamed(VisitorHealth.routeName);
                                  }
                              ),
                            ),
                            SizedBox (
                              height: MediaQuery.of(context).size.height/30,
                              width: MediaQuery.of(context).size.width,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height/16,
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom (
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text('Help'),
                                  onPressed:() {
                                    showGeneralDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        barrierLabel:
                                        MaterialLocalizations.of(context).modalBarrierDismissLabel,
                                        barrierColor: Colors.black45,
                                        transitionDuration: const Duration(milliseconds: 200),
                                        pageBuilder: (BuildContext ctx, Animation animation,
                                            Animation secondaryAnimation) {
                                          return Center(
                                            child: Container(
                                              height: MediaQuery.of(ctx).size.height - 80,
                                              width: MediaQuery.of(ctx).size.width,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: MediaQuery.of(ctx).size.height - 128,
                                                    width: MediaQuery.of(ctx).size.width,
                                                    child: GestureDetector(
                                                      onDoubleTapDown: _handleDoubleTapDown,
                                                      onDoubleTap: _handleDoubleTap,
                                                      child: InteractiveViewer(
                                                        scaleEnabled: true,
                                                        constrained: false,
                                                        transformationController: _transformationController,
                                                        child: Container(
                                                          color: Colors.white,
                                                          child: Image.asset(
                                                            'assets/images/Coviduous tutorials general - using the app.png',
                                                            width: MediaQuery.of(context).size.width,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      TextButton(
                                                        child: Text('Save'),
                                                        onPressed: (){
                                                          imageHelpers.saveImage('assets/images/Coviduous tutorials general - using the app.png',
                                                              "Coviduous tutorial - using the app", "png").then((result) {
                                                            if (result != null) {
                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                  SnackBar(content: Text("Image saved to downloads folder")));
                                                            }
                                                            Navigator.of(ctx).pop();
                                                          });
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Text('Go back'),
                                                        onPressed: (){
                                                          Navigator.of(ctx).pop();
                                                        },
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  }
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]
                ),
              ),
            ]
          )
      ),
    );
  }
}
