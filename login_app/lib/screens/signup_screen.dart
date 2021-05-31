import 'package:flutter/material.dart';
import '../models/authentication.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class Register extends StatefulWidget {
  static const routeName = "/register";
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register>{
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _passwordController = new TextEditingController();

  Map<String, String> _authData ={
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

  Future<void > _submit() async
  {
    if(!_formKey.currentState.validate())
    {
      return;
    }
    _formKey.currentState.save();

    try{
      await Provider.of<Authentication>(context, listen: false).signUp(
          _authData['email'],
          _authData['password']
      );
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);

    } catch(error)
    {
      var errorMessage = 'Authentication Failed. Please try again later.';
      _showErrorDialog(errorMessage);
    }

  }

  @override
  Widget build(BuildContext context) {
    String userType = "User";

    return WillPopScope(
      onWillPop: () async => false, //Prevent the back button from working
      child: Scaffold(
        appBar: AppBar(
          title: Text('Register'),
          backgroundColor: Colors.redAccent,
          actions: <Widget>[
            TextButton(
              child: Row(
                children: <Widget>[
                  Text('Login'),
                  Icon(Icons.person)
                ],
              ),
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
              },
            )
          ],
        ),
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Color(0xff220000),
                        Color(0xff4C1616)
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
                height: 120,
              ),
            ),
            Center(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  height: 300,
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
                                if(value.isEmpty|| !value.contains('@'))
                                {
                                  return 'invalid email';
                                }
                                return null;
                              },
                              onSaved: (value)
                              {
                                _authData['email'] = value;

                              },
                            ),
                            //password
                            TextFormField(
                              decoration: InputDecoration(labelText:'Password'),
                              obscureText: true,
                              controller: _passwordController,
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
                            //confirm Password
                            TextFormField(
                              decoration: InputDecoration(labelText:'Confirm Password'),
                              obscureText: true,
                              validator: (value)
                              {
                                if(value.isEmpty || value != _passwordController.text )
                                {
                                  return 'invalid password';
                                }
                                return null;
                              },
                              onSaved: (value)
                              {

                              },
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text ('Select user type'),
                            DropdownButtonFormField<String>(
                              value: userType,
                              icon: const Icon(Icons.arrow_downward),
                              iconSize: 24,
                              dropdownColor: Colors.lime,
                              onChanged: (String newValue) {
                                setState(() {
                                  userType = newValue;
                                });
                              },
                              items: <String>['Admin', 'User']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            ElevatedButton(
                              child: Text(
                                  'Submit'
                              ),
                              onPressed: ()
                              {
                                _submit();
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                primary: Colors.redAccent
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
