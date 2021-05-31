import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import 'user_homepage.dart';
import 'signup_screen.dart';
import '../models/authentication.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  final GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, String> _authData = {
    'email' : '',
    'password' : ''
  };
  void _showErrorDialog(String msg)
  {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An Error Occurred'),
          content: Text(msg),
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
  }
  Future<void> _submit() async
  {
    /*
    if(!_formKey.currentState.validate())
    {
      return;
    }
    _formKey.currentState.save();
    try
    {
      await Provider.of<Authentication>(context, listen: false).Login(
          _authData['email'],
          _authData['password']
      );
    } catch (error)
    {
        var errorMessage = 'Authentication failed.';
        _showErrorDialog(errorMessage);
        return;
    }
     */
    Navigator.of(context).pushReplacementNamed(UserHomepage.routeName);
  }
@override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false, //Prevent the back button from working
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
          backgroundColor: Colors.blue,
          actions: <Widget>[
          TextButton(
            child: Row(
                children: <Widget>[
                  Text('Register'),
                  Icon(Icons.person_add)
                ],
              ),
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(Register.routeName);
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff0B0C20),
                    Color(0xff193A59),
                  ]
                )
              ),
            ),
            Container (
              alignment: Alignment.topCenter,
              margin: EdgeInsets.all(20.0),
              child: Image(
                alignment: Alignment.bottomCenter,
                image: NetworkImage('https://placeholder.com/wp-content/uploads/2018/10/placeholder.com-logo1.png'),
                color: Colors.white,
                width: double.maxFinite,
                height: 140,
              ),
            ),
            Center(
              child: Card(
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  color: Colors.white,
                  height: 260,
                  width: 300,
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          //email
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Email'),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value)
                            {
                              /*
                              if(value.isEmpty || !value.contains('@'))
                              {
                                return 'invalid email';
                              }
                               */
                              return null;
                            },
                            onSaved: (value){
                              _authData['email'] = value;
                            },
                          ),
                          //password
                          TextFormField(
                            decoration: InputDecoration(labelText:'Password'),
                            obscureText: true,
                            validator: (value)
                                {
                              if(value.isEmpty || value.length<=5)
                                {
                                  return 'invalid password';
                                }
                              return null;
                            },
                            onSaved: (value)
                            {
                              _authData['password'] = value;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Forgot password?',
                              style: new TextStyle(color: Colors.blue),
                              recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                launch(
                                    'https://www.google.com');
                              },
                            )
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          ElevatedButton(
                            child: Text(
                              'Submit'
                            ),
                            onPressed: ()
                            {
                                _submit();
                            },
                            style: ElevatedButton.styleFrom (
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              primary: Colors.blue,
                            ),
                          )
                        ],
                      )
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
