import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:login_app/frontend/screens/admin_homepage.dart';
import 'package:login_app/frontend/screens/user_homepage.dart';
import 'package:login_app/frontend/screens/health/visitor_home_health.dart';

import 'package:login_app/frontend/front_end_globals.dart' as globals;

class VisitorHealthCheck extends StatefulWidget {
  static const routeName = "/visitor_health_check";

  @override
  _VisitorHealthCheckState createState() => _VisitorHealthCheckState();
}

class _VisitorHealthCheckState extends State<VisitorHealthCheck> {
  TextEditingController _name = TextEditingController();
  TextEditingController _surname = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _temperature = TextEditingController();
  bool _hasFever = false;
   bool _hasDryCough = false;
   bool _hasShortnessOfBreath = false;
   bool _hadSoreThroat = false;
   bool _hasChills = false;
   bool _hasTasteSmellLoss = false;
   bool _hasHeadMusclePain = false;
   bool _hasNauseaDiarrheaVomiting = false;
   bool _hasComeIntoContact = false;
   bool _hasTestedPositive = false;
   bool _hasTraveled = false;

  final GlobalKey<FormState> _formKey = GlobalKey();

//HealthController services = new HealthController();

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.loggedInUserType == 'Admin') {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
      });
      return Container();
    } else if (globals.loggedInUserType == 'User') {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.of(context).pushReplacementNamed(UserHomePage.routeName);
      });
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
          title: Text('Complete health check'),
          leading: BackButton( //Specify back button
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(VisitorHealth.routeName);
            },
          ),
        ),
        body: Stack(
          children: <Widget>[
            Center(
              child: SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height/(2*globals.getWidgetScaling()),
                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Text('Name:'),
                          TextFormField(
                            textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                            decoration: InputDecoration(
                              labelText: 'Your first name',
                            ),
                            keyboardType: TextInputType.text,
                            controller: _name,
                            validator: (value) {
                              if(value.isEmpty || !value.contains(RegExp(r"^[a-zA-Z ,.'-]+$"))) //Check if valid name format
                                  {
                                return 'please input a valid first name';
                              }
                              return null;
                            },
                          ),
                          SizedBox (
                            height: MediaQuery.of(context).size.height/48,
                            width: MediaQuery.of(context).size.width,
                          ),
                          Text('Surname:'),
                          TextFormField(
                            textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                            decoration: InputDecoration(
                              labelText: 'Your last name',
                            ),
                            keyboardType: TextInputType.text,
                            controller: _surname,
                            validator: (value) {
                              if(value.isEmpty || !value.contains(RegExp(r"^[a-zA-Z ,.'-]+$"))) //Check if valid name format
                                  {
                                return 'please input a valid last name (family name)';
                              }
                              return null;
                            },
                          ),
                          SizedBox (
                            height: MediaQuery.of(context).size.height/48,
                            width: MediaQuery.of(context).size.width,
                          ),
                          Text('Email address:'),
                          TextFormField(
                            textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                            decoration: InputDecoration(
                              labelText: 'Your email address',
                            ),
                            keyboardType: TextInputType.text,
                            controller: _email,
                            validator: (value) {
                              if(value.isEmpty || !value.contains('@'))
                              {
                                return 'invalid email';
                              }
                              return null;
                            },
                          ),
                          SizedBox (
                            height: MediaQuery.of(context).size.height/48,
                            width: MediaQuery.of(context).size.width,
                          ),
                          Text('Please take your temperature before completing the health check-up.'),
                          TextFormField(
                            textInputAction: TextInputAction.done, //The "return" button becomes a "done" button when typing
                            decoration: InputDecoration(
                              labelText: 'Measured temperature (in degrees Celsius)',
                            ),
                            keyboardType: TextInputType.text,
                            controller: _temperature,
                            validator: (value) {
                              if (value.isNotEmpty) {
                                if(!globals.isNumeric(value)) //Check if number
                                  {
                                  return 'Temperature must be a number';
                                  }
                                } else {
                                  return 'Please enter a temperature';
                                }
                                return null;
                              },
                          ),
                          SizedBox (
                            height: MediaQuery.of(context).size.height/48,
                            width: MediaQuery.of(context).size.width,
                          ),
                          Text('Have you experienced any of the following symptoms in the past 14 days?'),
                          CheckboxListTile(
                            //secondary: const Icon(Icons.alarm),
                            title: const Text('1. Fever'),
                            value: this._hasFever,
                            onChanged: (bool value) {
                              setState(() {
                                this._hasFever = value;
                              });
                            },
                          ),
                          CheckboxListTile(
                            //secondary: const Icon(Icons.alarm),
                            title: const Text('2. Dry cough'),
                            value: this._hasDryCough,
                            onChanged: (bool value) {
                              setState(() {
                                this._hasDryCough = value;
                              });
                            },
                          ),
                          CheckboxListTile(
                            //secondary: const Icon(Icons.alarm),
                            title: const Text('3. Shortness of breath'),
                            value: this._hasShortnessOfBreath,
                            onChanged: (bool value) {
                              setState(() {
                                this._hasShortnessOfBreath = value;
                              });
                            },
                          ),
                          CheckboxListTile(
                            //secondary: const Icon(Icons.alarm),
                            title: const Text('4. Sore throat'),
                            value: this._hadSoreThroat,
                            onChanged: (bool value) {
                              setState(() {
                                this._hadSoreThroat = value;
                              });
                            },
                          ),
                          CheckboxListTile(
                            //secondary: const Icon(Icons.alarm),
                            title: const Text('5. Loss of smell or taste'),
                            value: this._hasTasteSmellLoss,
                            onChanged: (bool value) {
                              setState(() {
                                this._hasTasteSmellLoss = value;
                              });
                            },
                          ),
                          CheckboxListTile(
                            //secondary: const Icon(Icons.alarm),
                            title: const Text('6. Chills'),
                            value: this._hasChills,
                            onChanged: (bool value) {
                              setState(() {
                                this._hasChills = value;
                              });
                            },
                          ),
                          CheckboxListTile(
                            //secondary: const Icon(Icons.alarm),
                            title: const Text('7. Head or muscle aches'),
                            value: this._hasHeadMusclePain,
                            onChanged: (bool value) {
                              setState(() {
                                this._hasHeadMusclePain = value;
                              });
                            },
                          ),
                          CheckboxListTile(
                            //secondary: const Icon(Icons.alarm),
                            title: const Text('8. Nausea, diarrhea or vomiting'),
                            value: this._hasNauseaDiarrheaVomiting,
                            onChanged: (bool value) {
                              setState(() {
                                this._hasNauseaDiarrheaVomiting = value;
                              });
                            },
                          ),
                          SizedBox (
                            height: MediaQuery.of(context).size.height/48,
                            width: MediaQuery.of(context).size.width,
                          ),
                          Text('9. Have you come closer than 6 feet (1.83 meters) to someone who has COVID-19 or has displayed symptoms of COVID-19?'),
                          CheckboxListTile(
                            //secondary: const Icon(Icons.alarm),
                            //title: const Text(''),
                            value: this._hasComeIntoContact,
                            onChanged: (bool value) {
                              setState(() {
                                this._hasComeIntoContact = value;
                              });
                            },
                          ),
                          SizedBox (
                            height: MediaQuery.of(context).size.height/48,
                            width: MediaQuery.of(context).size.width,
                          ),
                          Text('10. Have you tested positive for COVID-19 in the past 14 days?'),
                          CheckboxListTile(
                            //secondary: const Icon(Icons.alarm),
                            //title: const Text(''),
                            value: this._hasTestedPositive,
                            onChanged: (bool value) {
                              setState(() {
                                this._hasTestedPositive = value;
                              });
                            },
                          ),
                          SizedBox (
                            height: MediaQuery.of(context).size.height/48,
                            width: MediaQuery.of(context).size.width,
                          ),
                          Text('11. Have you traveled to another province or country the past 14 days?'),
                          CheckboxListTile(
                            //secondary: const Icon(Icons.alarm),
                            //title: const Text(''),
                            value: this._hasTraveled,
                            onChanged: (bool value) {
                              setState(() {
                                this._hasTraveled = value;
                              });
                            },
                          ),
                          SizedBox (
                            height: MediaQuery.of(context).size.height/48,
                            width: MediaQuery.of(context).size.width,
                          ),
                          ElevatedButton(
                            child: Text(
                                'Submit'
                            ),
                            onPressed: () {
                              FormState form = _formKey.currentState;
                              if (form.validate()) {
                                //UserHealthCheckResponse response = services.userCompleteHealthCheckMock(parameters go here);
                                //print(response.getResponse());
                                /*
                                      if (response.getResponse()) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("Health check successfully completed, permission granted")));
                                        Navigator.of(context).pushReplacementNamed(VisitorHealth.routeName);
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("Health check denied, please try again or contact your admin")));
                                      }
                                       */
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Health check successfully completed, permission granted")));
                                Navigator.of(context).pushReplacementNamed(VisitorHealth.routeName);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Please enter required fields")));
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
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}