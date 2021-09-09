import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/health/visitor_home_health.dart';

import 'package:frontend/controllers/health/health_helpers.dart' as healthHelpers;
import 'package:frontend/globals.dart' as globals;

class VisitorHealthCheck extends StatefulWidget {
  static const routeName = "/visitor_health_check";

  @override
  _VisitorHealthCheckState createState() => _VisitorHealthCheckState();
}

class _VisitorHealthCheckState extends State<VisitorHealthCheck> {
  TextEditingController _companyId = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _surname = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
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

  int currentQuestionNumber = 1;

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(VisitorHealth.routeName);
    return (await true);
  }

  String getQuestionImage() {
    switch(currentQuestionNumber) {
      case 2: {
        return "assets/images/sick1.jpg";
      }
      break;

      case 3: {
        return "assets/images/sick2.jpg";
      }
      break;

      case 4: {
        return "assets/images/sick3.jpg";
      }
      break;

      case 5: {
        return "assets/images/sick1.jpg";
      }
      break;

      case 6: {
        return "assets/images/sick2.jpg";
      }
      break;

      case 7: {
        return "assets/images/sick3.jpg";
      }
      break;

      case 8: {
        return "assets/images/sick1.jpg";
      }
      break;

      case 9: {
        return "assets/images/sick2.jpg";
      }
      break;

      case 10: {
        return "assets/images/sick3.jpg";
      }
      break;

      case 11: {
        return "assets/images/sick1.jpg";
      }
      break;

      case 12: {
        return "assets/images/sick2.jpg";
      }
      break;

      case 13: {
        return "assets/images/sick3.jpg";
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
      case 2: {
        return "Please take your temperature and enter the result below.";
      }
      break;

      case 3: {
        return "Have you had a fever in the past 14 days?";
      }
      break;

      case 4: {
        return "Have you had a dry cough in the past 14 days?";
      }
      break;

      case 5: {
        return "Have you had shortness of breath in the past 14 days?";
      }
      break;

      case 6: {
        return "Have you has a sore throat in the past 14 days?";
      }
      break;

      case 7: {
        return "Have you lost your sense of smell or taste in the past 14 days?";
      }
      break;

      case 8: {
        return "Have you had chills in the past 14 days?";
      }
      break;

      case 9: {
        return "Have you had head or muscle aches in the past 14 days?";
      }
      break;

      case 10: {
        return "Have you suffered from nausea, diarrhea or vomiting in the past 14 days?";
      }
      break;

      case 11: {
        return "Have you come closer than 6 feet (1.83 meters) to someone who has displayed symptoms of COVID-19?";
      }
      break;

      case 12: {
        return "Have you tested positive for COVID-19 in the past 14 days?";
      }
      break;

      case 13: {
        return "Have you traveled to another province or country in the past 14 days?";
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
      case 3: {
        _hasFever = answer;
      }
      break;

      case 4: {
        _hasDryCough = answer;
      }
      break;

      case 5: {
        _hasShortnessOfBreath = answer;
      }
      break;

      case 6: {
        _hasSoreThroat = answer;
      }
      break;

      case 7: {
        _hasChills = answer;
      }
      break;

      case 8: {
        _hasTasteSmellLoss = answer;
      }
      break;

      case 9: {
        _hasHeadMusclePain = answer;
      }
      break;

      case 10: {
        _hasNauseaDiarrheaVomiting = answer;
      }
      break;

      case 11: {
        _hasComeIntoContact = answer;
      }
      break;

      case 12: {
        _hasTestedPositive = answer;
      }
      break;

      case 13: {
        _hasTraveled = answer;
      }
      break;

      default: {

      }
      break;
    }
  }

  bool getAnswer() {
    switch(currentQuestionNumber) {
      case 3: {
        return _hasFever;
      }
      break;

      case 4: {
        return _hasDryCough;
      }
      break;

      case 5: {
        return _hasShortnessOfBreath;
      }
      break;

      case 6: {
        return _hasSoreThroat;
      }
      break;

      case 7: {
        return _hasChills;
      }
      break;

      case 8: {
        return _hasTasteSmellLoss;
      }
      break;

      case 9: {
        return _hasHeadMusclePain;
      }
      break;

      case 10: {
        return _hasNauseaDiarrheaVomiting;
      }
      break;

      case 11: {
        return _hasComeIntoContact;
      }
      break;

      case 12: {
        return _hasTestedPositive;
      }
      break;

      case 13: {
        return _hasTraveled;
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
        return Container();
      }
      break;

      case 2: {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width/(2*globals.getWidgetWidthScaling()),
            padding: EdgeInsets.all(16),
            child: TextFormField(
              textInputAction: TextInputAction.done, //The "return" button becomes a "done" button when typing
              decoration: InputDecoration(
                labelText: 'Temperature (°C)',
              ),
              keyboardType: TextInputType.text,
              controller: _temperature,
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
                  setState(() {});
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
                  setState(() {});
                },
              ),
            ]
        );
      }
      break;
    }
  }

  bool validateForm() {
    bool result = true;
    if (_companyId.text.isEmpty) {
      result = false;
    }
    if (_name.text.isEmpty || !_name.text.contains(RegExp(r"^[a-zA-Z ,.'-]+$"))) {
      result = false;
    }
    if (_surname.text.isEmpty || !_surname.text.contains(RegExp(r"^[a-zA-Z ,.'-]+$"))) {
      result = false;
    }
    if (_email.text.isEmpty || !_email.text.contains('@')) {
      result = false;
    }
    if (_phoneNumber.text.isEmpty || !globals.isNumeric(_phoneNumber.text)) {
      result = false;
    }
    return result;
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

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Complete health check'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(VisitorHealth.routeName);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Stack(
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
                        Column(
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
                                        Text("Question " + currentQuestionNumber.toString() + " of 13",
                                            style: TextStyle(color: Colors.white, fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5),
                                            textAlign: TextAlign.center),
                                        LinearProgressIndicator(
                                          backgroundColor: globals.firstColor,
                                          color: Color(0xffFFBF13),
                                          minHeight: 10,
                                          value: currentQuestionNumber/13,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    color: Colors.white,
                                    width: MediaQuery.of(context).size.width/(2*globals.getWidgetWidthScaling()),
                                    padding: EdgeInsets.all(16),
                                    child: (currentQuestionNumber != 1) ? Column(
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
                                    ) : Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Image.asset(
                                          "assets/images/coffee1.jpg",
                                          height: 130,
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context).size.height/48,
                                        ),
                                        TextFormField(
                                          textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                                          decoration: InputDecoration(
                                            labelText: 'Company ID you want to access',
                                          ),
                                          keyboardType: TextInputType.text,
                                          controller: _companyId,
                                        ),
                                        TextFormField(
                                          textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                                          decoration: InputDecoration(
                                            labelText: 'Your first name',
                                          ),
                                          keyboardType: TextInputType.text,
                                          controller: _name,
                                        ),
                                        TextFormField(
                                          textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                                          decoration: InputDecoration(
                                            labelText: 'Your last name',
                                          ),
                                          keyboardType: TextInputType.text,
                                          controller: _surname,
                                        ),
                                        TextFormField(
                                          textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                                          decoration: InputDecoration(
                                            labelText: 'Your email address',
                                          ),
                                          keyboardType: TextInputType.text,
                                          controller: _email,
                                        ),
                                        TextFormField(
                                          textInputAction: TextInputAction.done, //The "return" button becomes a "done" button when typing
                                          decoration: InputDecoration(
                                            labelText: 'Your phone number',
                                          ),
                                          keyboardType: TextInputType.text,
                                          controller: _phoneNumber,
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
                        IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          onPressed: () {
                            if (currentQuestionNumber < 13) {
                              setState(() {
                                currentQuestionNumber++;
                              });
                            } else if (currentQuestionNumber == 13) {
                              if (validateForm()) {
                                healthHelpers.createHealthCheckVisitor(_companyId.text, _name.text, _surname.text, _email.text, _phoneNumber.text,
                                    _temperature.text, _hasFever, _hasDryCough, _hasSoreThroat, _hasChills, _hasHeadMusclePain, _hasNauseaDiarrheaVomiting,
                                    _hasShortnessOfBreath, _hasTasteSmellLoss, _hasComeIntoContact, _hasTestedPositive, _hasTraveled, _hasHeadMusclePain).then((result) {
                                  if (result == true) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Health check successfully completed. You can view your permissions on the view permissions page.")));
                                    Navigator.of(context).pushReplacementNamed(VisitorHealth.routeName);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("There was an error while completing the health check. Please contact the company's admins or try again later.")));
                                  }
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Please complete the questionnaire")));
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ]
            ),
          )
      ),
    );
  }
}