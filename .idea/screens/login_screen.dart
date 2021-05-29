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