import 'package:flutter/material.dart';
import '../models/authentication.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'login.screen.dart';

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
