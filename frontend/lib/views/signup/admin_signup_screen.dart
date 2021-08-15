import 'package:flutter/material.dart';

import 'package:frontend/auth/auth_provider.dart';
import 'package:frontend/views/signup/home_signup_screen.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/user/user_helpers.dart' as userHelpers;
import 'package:frontend/globals.dart' as globals;

class AdminRegister extends StatefulWidget {
  static const routeName = "/adminRegister";
  @override
  _AdminRegisterState createState() => _AdminRegisterState();
}

class _AdminRegisterState extends State<AdminRegister>{
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _userName = TextEditingController();
  TextEditingController _companyId = TextEditingController();
  TextEditingController _companyName = TextEditingController();
  TextEditingController _companyLocation = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();
  bool isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey();

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(Register.routeName);
    return (await true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        color: globals.secondaryColor,
        child: isLoading == false ? Scaffold(
          appBar: AppBar(
            title: Text('Register'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(Register.routeName);
              },
            ),
          ),
          body: Stack(
            children: <Widget>[
              SingleChildScrollView( //So the element doesn't overflow when you open the keyboard
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height/(2.8*globals.getWidgetScaling()),
                        width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                        padding: EdgeInsets.all(16),
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  //first name
                                  TextFormField(
                                    textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                                    decoration: InputDecoration(labelText: 'First name'),
                                    keyboardType: TextInputType.text,
                                    controller: _firstName,
                                    validator: (value) {
                                      if(value.isEmpty || !value.contains(RegExp(r"^[a-zA-Z ,.'-]+$"))) //Check if valid name format
                                          {
                                        return 'please input a valid first name';
                                      }
                                      return null;
                                    },
                                  ),
                                  //last name
                                  TextFormField(
                                    textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                                    decoration: InputDecoration(labelText: 'Last name'),
                                    keyboardType: TextInputType.text,
                                    controller: _lastName,
                                    validator: (value) {
                                      if(value.isEmpty || !value.contains(RegExp(r"^[a-zA-Z ,.'-]+$"))) //Check if valid name format
                                          {
                                        return 'please input a valid last name (family name)';
                                      }
                                      return null;
                                    },
                                  ),
                                  //email
                                  TextFormField(
                                    textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                                    decoration: InputDecoration(labelText: 'Email'),
                                    keyboardType: TextInputType.emailAddress,
                                    controller: _email,
                                    validator: (value) {
                                      if(value.isEmpty || !value.contains('@'))
                                      {
                                        return 'invalid email';
                                      }
                                      return null;
                                    },
                                  ),
                                  //username
                                  TextFormField(
                                    textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                                    decoration: InputDecoration(labelText: 'Username'),
                                    keyboardType: TextInputType.text,
                                    controller: _userName,
                                    validator: (value) {
                                      if(value.isEmpty)
                                      {
                                        return 'please input a username';
                                      } else if (value.length < 8 || value.length > 20) {
                                        return 'username must be between 8 and 20 characters in length';
                                      } else if (!value.contains(RegExp(r"^(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$"))) {
                                        return 'username must contain only letters, numbers, underscores or periods';
                                      }
                                      return null;
                                    },
                                  ),
                                  //password
                                  TextFormField(
                                    textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                                    decoration: InputDecoration(labelText:'Password'),
                                    obscureText: true,
                                    controller: _password,
                                    validator: (value) {
                                      if(value.isEmpty)
                                      {
                                        return 'please input a password';
                                      } else if (value.length <= 5) {
                                        return 'password must be more than 5 characters long';
                                      }
                                      return null;
                                    },
                                  ),
                                  //confirm password
                                  TextFormField(
                                    textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                                    decoration: InputDecoration(labelText:'Confirm password'),
                                    obscureText: true,
                                    controller: _confirmPassword,
                                    validator: (value) {
                                      if(value.isEmpty)
                                      {
                                        return 'please input a password';
                                      } else if (value != _password.text) {
                                        return 'passwords do not match';
                                      }
                                      return null;
                                    },
                                  ),
                                  //company ID
                                  TextFormField(
                                    textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                                    decoration: InputDecoration(labelText:'Company ID'),
                                    controller: _companyId,
                                    validator: (value) {
                                      if(value.isEmpty || !value.contains(RegExp(r"^[0-9A-Za-z ,.'-]+$"))) //Check if valid name format
                                          {
                                        return 'please input a valid company ID';
                                      }
                                      return null;
                                    },
                                  ),
                                  //company name
                                  TextFormField(
                                    textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                                    decoration: InputDecoration(labelText:'Company name'),
                                    controller: _companyName,
                                    validator: (value) {
                                      if(value.isEmpty || !value.contains(RegExp(r"^[A-Za-z ,.'-]+$"))) //Check if valid name format
                                          {
                                        return 'please input a valid company name';
                                      }
                                      return null;
                                    },
                                  ),
                                  //company address
                                  TextFormField(
                                    textInputAction: TextInputAction.done, //The "return" button becomes a "done" button when typing
                                    decoration: InputDecoration(labelText:'Company address'),
                                    controller: _companyLocation,
                                    validator: (value) {
                                      if(value.isEmpty || !value.contains(RegExp(r"^[0-9A-Za-z ,.'-]+$"))) //Check if valid name format
                                          {
                                        return 'please input a valid company address';
                                      }
                                      return null;
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
                                    onPressed: ()
                                    {
                                      FormState form = _formKey.currentState;
                                      if (form.validate()) {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        AuthClass().createAccount(email: _email.text.trim(),
                                            password: _password.text.trim()).then((value) {
                                          if (value == "Account created") {
                                            setState(() {
                                              isLoading = false;
                                            });

                                            userHelpers.createAdmin(_firstName.text, _lastName.text, _userName.text,
                                                _companyId.text, _companyName.text, _companyLocation.text);
                                            Navigator.pushAndRemoveUntil(context,
                                                MaterialPageRoute(builder: (context) => LoginScreen()), (
                                                    route) => false);
                                          }
                                          else {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text(value)));
                                          }
                                        });
                                      }
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
                    ],
                  ),
                ),
              )
            ],
          ),
        ) : Center( child: CircularProgressIndicator() )
      ),
    );
  }
}
