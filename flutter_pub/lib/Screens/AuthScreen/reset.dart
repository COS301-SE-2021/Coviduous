import 'package:flutter/material.dart';
import 'package:flutter_pub/Screens/AuthScreen/login.dart';
import 'package:flutter_pub/Screens/home.dart';
import 'package:flutter_pub/providers/auth_provider.dart';

class ResetPage extends StatefulWidget {
  @override
  _ResetPageState createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
  TextEditingController _email = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
      ),
      body: isLoading == false ? Padding(
        padding: const EdgeInsets.all(8.0),
          child: Column(
              children: [
                TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                      hintText: 'Email'
                  ),
                ),
                const SizedBox(height: 30,),
                
              ],
          ),
        ) : Center(child: CircularProgressIndicator(),
      ),
    );
  }
}