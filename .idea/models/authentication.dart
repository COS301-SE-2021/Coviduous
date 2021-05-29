import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'http_exeption.dart';

class Authentication with ChangeNotifier
{

  Future<void> signUp(String email,String password) async
  {
    const  url= 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAYf69-rLqgS4ryuJc1bYCJObTogVuglpo';
    try {
      final response = await http.post(url, body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }
      ));
