import 'package:flutter/material.dart';


import 'package:provider/provider.dart';

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
          title: Text('An Error Occured'),
          content: Text(msg),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: (){
                Navigator.of(ctx).pop();
              },
            )
          ],
        )
    );
  }