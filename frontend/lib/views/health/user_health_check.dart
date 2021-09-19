import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/health/user_home_health.dart';
import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/health/health_helpers.dart' as healthHelpers;
import 'package:frontend/globals.dart' as globals;

class UserHealthCheck extends StatefulWidget {
  static const routeName = "/user_health_check";

  @override
  _UserHealthCheckState createState() => _UserHealthCheckState();
}

class _UserHealthCheckState extends State<UserHealthCheck> {
  TextEditingController _temperature = TextEditingController();
  bool _hasFever = false;
  bool _hasDryCough = false;
  bool _hasShortnessOfBreath = false;
  bool _hasSoreThroat = false;
  bool _hasChills = false;
  bool _hasTasteSmellLoss = false;
  bool _hasHeadMusclePain = false;
  bool _hasNauseaDiarrheaVomiting = false;

  bool _hasComeIntoContact = false;
  bool _hasTestedPositive = false;
  bool _hasTraveled = false;
  bool _isFemale = false;
  bool _is60orOlder = false;

  int currentQuestionNumber = 1;

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(UserHealth.routeName);
    return (await true);
  }

  String getQuestionImage() {
    switch(currentQuestionNumber) {
      case 1: {
        return "assets/images/sick1.jpg";
      }
      break;

      case 2: {
        return "assets/images/sick2.jpg";
      }
      break;

      case 3: {
        return "assets/images/sick3.jpg";
      }
      break;

      case 4: {
        return "assets/images/sick4.jpg";
      }
      break;

      case 5: {
        return "assets/images/sick5.jpg";
      }
      break;

      case 6: {
        return "assets/images/sick6.jpg";
      }
      break;

      case 7: {
        return "assets/images/sick7.jpg";
      }
      break;

      case 8: {
        return "assets/images/sick8.jpg";
      }
      break;

      case 9: {
        return "assets/images/sick9.jpg";
      }
      break;

      case 10: {
        return "assets/images/sick10.jpg";
      }
      break;

      case 11: {
        return "assets/images/sick11.jpg";
      }
      break;

      case 12: {
        return "assets/images/sick12.jpg";
      }
      break;

      case 13: {
        return "assets/images/sick13.jpg";
      }
      break;

      case 14: {
        return "assets/images/sick14.jpg";
      }
      break;

      default: {
        return "assets/images/sick1.jpg";
      }
      break;
    }
  }

  String getQuestion() {
    switch(currentQuestionNumber) {
      case 1: {
        return "Please take your temperature and enter the result below.";
      }
      break;

      case 2: {
        return "Have you had a fever in the past 14 days?";
      }
      break;

      case 3: {
        return "Have you had a dry cough in the past 14 days?";
      }
      break;

      case 4: {
        return "Have you had shortness of breath in the past 14 days?";
      }
      break;

      case 5: {
        return "Have you had a sore throat in the past 14 days?";
      }
      break;

      case 6: {
        return "Have you lost your sense of smell or taste in the past 14 days?";
      }
      break;

      case 7: {
        return "Have you had chills in the past 14 days?";
      }
      break;

      case 8: {
        return "Have you had head or muscle aches in the past 14 days?";
      }
      break;

      case 9: {
        return "Have you suffered from nausea, diarrhea or vomiting in the past 14 days?";
      }
      break;

      case 10: {
        return "Have you come closer than 6 feet (1.83 meters) to someone who has displayed symptoms of COVID-19?";
      }
      break;

      case 11: {
        return "Have you tested positive for COVID-19 in the past 14 days?";
      }
      break;

      case 12: {
        return "Have you traveled to another province or country in the past 14 days?";
      }
      break;

      case 13: {
        return "Are you female?";
      }
      break;

      case 14: {
        return "Are you 60 years old or older?";
      }
      break;

      default: {
        return "";
      }
      break;
    }
  }

  setAnswer(bool answer) {
    switch(currentQuestionNumber) {
      case 2: {
        _hasFever = answer;
      }
      break;

      case 3: {
        _hasDryCough = answer;
      }
      break;

      case 4: {
        _hasShortnessOfBreath = answer;
      }
      break;

      case 5: {
        _hasSoreThroat = answer;
      }
      break;

      case 6: {
        _hasChills = answer;
      }
      break;

      case 7: {
        _hasTasteSmellLoss = answer;
      }
      break;

      case 8: {
        _hasHeadMusclePain = answer;
      }
      break;

      case 9: {
        _hasNauseaDiarrheaVomiting = answer;
      }
      break;

      case 10: {
        _hasComeIntoContact = answer;
      }
      break;

      case 11: {
        _hasTestedPositive = answer;
      }
      break;

      case 12: {
        _hasTraveled = answer;
      }
      break;

      case 13: {
        _isFemale = answer;
      }
      break;

      case 14: {
        _is60orOlder = answer;
      }
      break;

      default: {

      }
      break;
    }
  }

  bool getAnswer() {
    switch(currentQuestionNumber) {
      case 2: {
        return _hasFever;
      }
      break;

      case 3: {
        return _hasDryCough;
      }
      break;

      case 4: {
        return _hasShortnessOfBreath;
      }
      break;

      case 5: {
        return _hasSoreThroat;
      }
      break;

      case 6: {
        return _hasChills;
      }
      break;

      case 7: {
        return _hasTasteSmellLoss;
      }
      break;

      case 8: {
        return _hasHeadMusclePain;
      }
      break;

      case 9: {
        return _hasNauseaDiarrheaVomiting;
      }
      break;

      case 10: {
        return _hasComeIntoContact;
      }
      break;

      case 11: {
        return _hasTestedPositive;
      }
      break;

      case 12: {
        return _hasTraveled;
      }
      break;

      case 13: {
        return _isFemale;
      }
      break;

      case 14: {
        return _is60orOlder;
      }
      break;

      default: {
        return false;
      }
      break;
    }
  }

  Widget getAnswerFormat() {
    switch(currentQuestionNumber) {
      case 1: {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width/(2*globals.getWidgetWidthScaling()),
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  textInputAction: TextInputAction.done, //The "return" button becomes a "done" button when typing
                  decoration: InputDecoration(
                    labelText: 'Temperature (°C)',
                  ),
                  keyboardType: TextInputType.text,
                  controller: _temperature,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height/48,
                ),
                ElevatedButton(
                  child: Text("Proceed"),
                  style: ElevatedButton.styleFrom (
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (currentQuestionNumber < 14) {
                      setState(() {
                        currentQuestionNumber++;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        );
      }
      break;

      default: {
        return Row(
            children:[
              ElevatedButton(
                child: Text("👍", style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 4)),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(24),
                  primary: (getAnswer()) ? globals.focusColor : globals.firstColor,
                ),
                onPressed: () {
                  setAnswer(true);
                  if (currentQuestionNumber < 14) {
                    setState(() {
                      currentQuestionNumber++;
                    });
                  } else if (currentQuestionNumber == 14) {
                    setState(() {});
                    showConfirmation();
                  }
                },
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width/12,
              ),
              ElevatedButton(
                child: Text("👎", style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 4)),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(24),
                  primary: (getAnswer()) ? globals.firstColor : globals.focusColor,
                ),
                onPressed: () {
                  setAnswer(false);
                  if (currentQuestionNumber < 14) {
                    setState(() {
                      currentQuestionNumber++;
                    });
                  } else if (currentQuestionNumber == 14) {
                    setState(() {});
                    showConfirmation();
                  }
                },
              ),
            ]
        );
      }
      break;
    }
  }

  void showConfirmation() {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Warning'),
          content: Text("Are you sure you are done with this health check?"),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: (){
                bool result = completeHealthCheck();
                if (result == false) {
                  Navigator.of(ctx).pop();
                }
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: (){
                Navigator.of(ctx).pop();
              },
            )
          ],
        ));
  }

  bool completeHealthCheck() {
    if (_temperature.text.isNotEmpty && globals.isNumeric(_temperature.text)) {
      healthHelpers.createHealthCheckUser(_temperature.text, _hasFever, _hasDryCough, _hasSoreThroat, _hasChills, _hasHeadMusclePain,
          _hasNauseaDiarrheaVomiting, _hasShortnessOfBreath, _hasTasteSmellLoss, _hasComeIntoContact, _hasTestedPositive, _hasTraveled,
          _hasHeadMusclePain, _isFemale, _is60orOlder).then((result) {
        if (result == true) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Health check successfully completed. You can view your permissions on the view permissions page.")));
          Navigator.of(context).pushReplacementNamed(UserHealth.routeName);
          return true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("There was an error while completing the health check. Please contact the company's admins or try again later.")));
          return false;
        }
      });
      return false;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please complete the questionnaire")));
      return false;
    }
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
            title: Text('Complete health check'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(UserHealth.routeName);
              },
            ),
          ),
          body: Stack(
              children: <Widget>[
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          if (currentQuestionNumber > 1) {
                            setState(() {
                              currentQuestionNumber--;
                            });
                          }
                        },
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height/20
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Column(
                                children: [
                                  Container(
                                    color: globals.firstColor,
                                    width: MediaQuery.of(context).size.width/(2*globals.getWidgetWidthScaling()),
                                    child: Column(
                                      children: [
                                        Text("Question " + currentQuestionNumber.toString() + " of 14",
                                            style: TextStyle(color: Colors.white, fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5),
                                            textAlign: TextAlign.center),
                                        LinearProgressIndicator(
                                          backgroundColor: globals.firstColor,
                                          color: Color(0xffFFBF13),
                                          minHeight: 10,
                                          value: currentQuestionNumber/14,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    color: Colors.white,
                                    width: MediaQuery.of(context).size.width/(2*globals.getWidgetWidthScaling()),
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Image.asset(
                                          getQuestionImage(),
                                          height: 250,
                                        ),
                                        SizedBox(
                                            height: MediaQuery.of(context).size.height/20
                                        ),
                                        Container(
                                            height: MediaQuery.of(context).size.height/10,
                                            child: Column(
                                              children: [
                                                Expanded(child: Text(getQuestion())),
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height/24
                            ),
                            getAnswerFormat(),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        onPressed: () {
                          if (currentQuestionNumber < 14) {
                            setState(() {
                              currentQuestionNumber++;
                            });
                          } else if (currentQuestionNumber == 14) {
                            setState(() {});
                            showConfirmation();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ]
          )
      ),
    );
  }
}