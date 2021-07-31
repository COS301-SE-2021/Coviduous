import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
//import 'package:login_app/frontend/screens/health/user_home_health.dart';
import 'package:login_app/frontend/screens/admin_homepage.dart';
import 'package:login_app/frontend/screens/login_screen.dart';
import 'package:login_app/frontend/front_end_globals.dart' as globals;

class VisitorHealthCheck extends StatefulWidget {
  static const routeName = "/user_health_check";

  @override
  _VisitorHealthCheckState createState() => _VisitorHealthCheckState();
}

class _VisitorHealthCheckState extends State<VisitorHealthCheck> {
  TextEditingController _temperature = TextEditingController();
  // bool _hasFever = false;
  // bool _hasDryCough = false;
  // bool _hasShortnessOfBreath = false;
  // bool _hadSoreThroat = false;
  // bool _hasChills = false;
  // bool _hasTasteSmellLoss = false;
  // bool _hasHeadMusclePain = false;
  // bool _hasNauseaDiarrheaVomiting = false;
  // bool _hasComeIntoContact = false;
  // bool _hasTestedPositive = false;
  // bool _hasTraveled = false;

  final GlobalKey<FormState> _formKey = GlobalKey();

//HealthController services = new HealthController();

  @override
  Widget build(BuildContext context) {

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
              // Navigator.of(context).pushReplacementNamed(UserHealth.routeName);
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
                          Text('Please take your temperature before completing the health check-up.'),
                      TextFormField(
                        textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                        decoration: InputDecoration(
                          labelText: 'Measured temperature (in degrees Celsius)',
                        ),
                        keyboardType: TextInputType.text,
                        controller: _temperature,
                        validator: (value) {
                           if (value.isNotEmpty) {
                             print(_temperature);
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